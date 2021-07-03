use strict;
use warnings;

use threads;
use threads::shared;
use Carp 'croak';
use Data::Dumper;

package Worker {
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
            que => $que,
            tids => shared_clone({ value => [] }),
            job => $params{job} // sub {},
            run_semaphore => Thread::Semaphore->new(),
            fatal_error => shared_clone({ value => undef }),
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
                my $th = threads->create(sub { $self->worker() });
                push @{$self->{tids}->{value}}, $th->tid;
            }
        }
        $self->{run_semaphore}->up();
    }

    sub stop {
        my ($self) = @_;

        $self->{run_semaphore}->down();
        {
            $self->{que}->end();
            threads->object($_)->join() for @{$self->{tids}->{value}};
            $self->{tids}->{value} = shared_clone([]);
        }
        $self->{run_semaphore}->up();
    }

    sub enqueue {
        my ($self, $param) = @_;
        croak $self->fatal_error if $self->fatal_error;
        $self->{que}->enqueue({ param => $param });
    }

    sub fatal_error {
        my ($self) = @_;
        return $self->{fatal_error}->{value};
    }

    sub worker {
        my ($self) = @_;
        my $que = $self->{que};
        my $job = $self->{job};

        while (my $item = $que->dequeue()) {
            return if $self->fatal_error;
            my $job_id = int(rand(100000));
            my $param = $item->{param};

            local $@;
            eval { $job->($self, $job_id, $param) };
            my $e = $@;

            # fatal error
            if ($e) {
                warn $e;
                $self->{fatal_error}->{value} = shared_clone($e);
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
                print "## retry: $retry_count\n";
                croak 'reach max retry count' if $retry_count > $self->{max_retry};
                $sleep *= 2;
                sleep $sleep;
                $self->{on_retry}->();
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
    my $count :shared = 0;
    my $retry :shared = 0;
    my $failed :shared = 0;

    my $worker = Worker->new(n => 3, job => sub {
        my ($worker, $job_id, $param) = @_;
        my $retrier = ExponentialRetrier->new(
            max_retry => 3,
            default_sleep => 1,
            on_retry => sub { $retry++ },
        );
        $retrier->retriable(sub {
            print "job $job_id: item: ", Dumper($param);

            if (rand() < 0.1) {
                $failed++;
                croak "job $job_id: fatal_error";
            }
            if (rand() < 0.5) {
                warn "job $job_id: error";
                $failed++;
                return if $worker->fatal_error;
                $retrier->retry();
            }
            print "job $job_id: ok\n";
            $count++;
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

    if ($e || $worker->fatal_error) {
        warn "## fatal_error: $e";
    }
    print "## count: $count, failed: $failed, retry: $retry\n";
}

main();
