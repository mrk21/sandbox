use strict;
use warnings;

use threads;
use threads::shared;
use Carp 'croak';
use Data::Dumper;

sub gen_id {
    return sprintf('%010d', int(rand(10000000000 - 1)));
}

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

        my $n = $params{n} // 1; croak '`n` must be greater than or equal to 1' if $n < 1;
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
            is_killed => 0,
            kill_semaphore => Thread::Semaphore->new(),
        };
        bless $instance, $class;
        return $instance;
    }

    sub start {
        my ($self) = @_;
        print "worker: starting...\n";

        $self->{run_semaphore}->down();
        {
            my $n = $self->{n};
            for my $i ((0..$n-1)) {
                my $th = threads->create(sub { $self->executor(::gen_id()) });
                push @{$self->{executor_tids}->{value}}, $th->tid;
            }
        }
        $self->{run_semaphore}->up();
        print "worker: started\n";
    }

    sub stop {
        my ($self) = @_;
        print "worker: stopping...\n";

        $self->{run_semaphore}->down();
        {
            $self->{que}->end();
            my @tids = @{$self->{executor_tids}->{value}};
            my @tids_without_self = grep { $_ != threads->tid } @tids;
            my @threads = map { threads->object($_) } @tids_without_self;
            my @running_threads = grep { defined($_) and $_->running } @threads;
            $_->join for @running_threads;
            $self->{executer_tids}->{value} = shared_clone([]);
        }
        $self->{run_semaphore}->up();
        print "worker: stopped\n";
    }

    sub enqueue {
        my ($self, $param) = @_;
        croak $self->error if $self->error;
        $self->{que}->enqueue({ param => $param, job_id => ::gen_id() });
    }

    sub error {
        my ($self, $e) = @_;
        return $self->{error}->{value} unless $e;
        $self->{error_semaphore}->down();
        {
            $self->{error}->{value} //= shared_clone($e);
            $self->kill();
        }
        $self->{error_semaphore}->up();
        return $self->{error}->{value};
    }

    sub kill {
        my ($self) = @_;
        return if $self->{is_killed};
        $self->{kill_semaphore}->down();
        {
            return if $self->{is_killed};
            $self->{is_killed} = 1;
            print "worker: kill\n";

            my $size = $self->{que}->pending();
            $self->{que}->end();
            $self->{que}->dequeue_nb($size) if $size;
        }
        $self->{kill_semaphore}->up();
    }

    sub executor {
        my ($self, $executor_id) = @_;
        my $que = $self->{que};
        my $job = $self->{job};
        print "executor $executor_id: start\n";

        while (my $item = $que->dequeue()) {
            last if $self->error;
            my $job_id = $item->{job_id};
            my $param = $item->{param};

            local $@;
            eval { $job->($self, $job_id, $param) };
            my $e = $@;

            # fatal error
            if ($e) {
                warn $e;
                $self->error($e);
                last;
            }
        }
        print "executor $executor_id: stop\n";
    }
}

package ExponentialRetrier {
    use Carp 'croak';
    use Data::Dumper;

    sub new {
        my $class = shift;
        my %params = @_;

        my $instance = {
            id => ::gen_id(),
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
        print "job $job_id: start\n";

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
                print "job $job_id: retrying...\n";
                $retrier->retry();
            }
            print "job $job_id: ok\n";
            $increment_count->('ok');
        });
        print "job $job_id: finish\n";
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
