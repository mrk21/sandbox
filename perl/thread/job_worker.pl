use strict;
use warnings;

use threads;
use threads::shared;
use Carp 'croak';
use Data::Dumper;

package JobWorker {
    use threads;
    use threads::shared;
    use Thread::Semaphore;
    use Thread::Queue;
    use Carp 'croak';
    use Data::Dumper;

    sub new {
        my $class = shift;
        my %params = @_;

        my $n = $params{n} // 1;
        my $que = Thread::Queue->new();
        $que->limit = $n;

        my $instance = {
            n => $n,
            job => $params{job} // sub {},
            que => $que,
            executor_tids => shared_clone({ value => [] }),
            run_semaphore => Thread::Semaphore->new(),
            error => shared_clone({ value => undef }),
            error_semaphore => Thread::Semaphore->new(),
        };
        bless $instance, $class;
        return $instance;
    }

    sub start {
        my ($self) = @_;

        $self->{run_semaphore}->down();
        {
            my $n = $self->{n};
            for my $i ((0..$n-1)) {
                my $th = threads->create(sub { $self->executor() });
                push @{$self->{executor_tids}->{value}}, $th->tid;
            }
        }
        $self->{run_semaphore}->up();
    }

    sub stop {
        my ($self) = @_;

        $self->{run_semaphore}->down();
        {
            $self->{que}->end();
            threads->object($_)->join for @{$self->{executor_tids}->{value}};
            $self->{executer_tids}->{value} = shared_clone([]);
        }
        $self->{run_semaphore}->up();
    }

    sub enqueue {
        my ($self, $param) = @_;
        croak $self->error if $self->error;
        $self->{que}->enqueue({ param => $param, job_id => int(rand(100000)) });
    }

    sub error {
        my ($self, $e) = @_;
        return $self->{error}->{value} unless $e;
        $self->{error_semaphore}->down();
        {
            $self->{error}->{value} //= shared_clone($e);
            $self->destruct_que();
        }
        $self->{error_semaphore}->up();
        return $self->{error}->{value};
    }

    sub destruct_que {
        my ($self) = @_;
        my $size = $self->{que}->pending();
        $self->{que}->end();
        $self->{que}->dequeue_nb($size) if $size;
    }

    sub executor {
        my ($self) = @_;
        my $que = $self->{que};
        my $job = $self->{job};

        while (my $item = $que->dequeue()) {
            return if $self->error;
            my $job_id = $item->{job_id};
            my $param = $item->{param};

            local $@;
            eval { $job->($self, $job_id, $param) };
            my $e = $@;

            # fatal error
            if ($e) {
                warn $e;
                $self->error($e);
                return;
            }
        }
    }
}

package ExponentialRetrier {
    use Carp 'croak';
    use Data::Dumper;

    sub new {
        my $class = shift;
        my %params = @_;

        my $instance = {
            id => int(rand(10000)),
            max_retry => $params{max_retry} // 3,
            default_sleep => $params{default_sleep} // 1,
            on_retry => $params{on_retry} // sub {},
        };
        bless $instance, $class;
        return $instance;
    }

    sub retriable {
        my ($self, $callback) = @_;
        my $retry_count = 0;
        my $sleep = $self->{default_sleep};

        while (1) {
            local $@;
            eval { $callback->() };
            my $e = $@;

            if ($e) {
                die $e unless $e =~ $self->retry_error;
                $retry_count++;
                croak 'reach max retry count' if $retry_count > $self->{max_retry};
                $sleep *= 2;
                sleep $sleep;
                $self->{on_retry}->($retry_count);
                next;
            }
            last;
        }
    }

    sub retry {
        my ($self) = @_;
        die $self->retry_error;
    }

    sub retry_error {
        my ($self) = @_;
        my $class = __PACKAGE__;
        my $id = $self->{id};
        return "$class#$id: retry_error";
    }
}

sub main {
    my $count = shared_clone({
        ok => 0,
        retry => 0,
        failed => 0,
    });
    my $count_semaphore = Thread::Semaphore->new();
    my $increment_count = sub {
        my $type = shift;
        $count_semaphore->down();
        $count->{$type}++;
        $count_semaphore->up();
    };

    my $worker = JobWorker->new(n => 3, job => sub {
        my ($worker, $job_id, $param) = @_;
        my $retrier = ExponentialRetrier->new(
            max_retry => 3,
            default_sleep => 1,
            on_retry => sub {
                my $retry_count = shift;
                print "job $job_id: retry: $retry_count\n";
                $increment_count->('retry');
            },
        );
        $retrier->retriable(sub {
            return if $worker->error;

            print "job $job_id: item: ", Dumper($param);
            sleep 1;

            if (rand() < 0.1) {
                $increment_count->('failed');
                croak "job $job_id: fatal_error";
            }
            if (rand() < 0.4) {
                warn "job $job_id: error";
                $increment_count->('failed');
                return if $worker->error;
                $retrier->retry();
            }
            print "job $job_id: ok\n";
            $increment_count->('ok');
        });
    });

    $worker->start();
    local $@;
    eval {
        for (my $i = 0; $i < 10; $i++) {
            $worker->enqueue($i);
        }
    };
    my $e = $@;
    $worker->stop();
    $e ||= $worker->error;

    warn "## fatal_error: $e" if $e;
    print "## ok: ". $count->{ok} .", failed: ". $count->{failed} .", retry: ". $count->{retry} ."\n";
}

main();
