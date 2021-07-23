use strict;
use warnings;
use Data::Dumper::Concise;

# master_process ---- job ------> worker_process
#          |  +------ job ------> worker_process
#          +--------- job ------> worker_process
#
# master_process <-- result --+-- worker_process
#                             +-- worker_process
#                             +-- worker_process
package JobWorker {
    use IO::Pipe;
    use JSON;
    use Data::Dumper::Concise;
    use Carp 'croak';

    sub new {
        my ($class, %params) = @_;
        my $n = $params{n} or croak '`n` must be required';
        my $job = $params{job} or croak '`job` must be required';
        my $instance = {
            n => $n,
            job => $job,
            pids => undef,
            job_pipes => undef,
            result_pipe => undef,
            target_worker => 0,
            job_count => 0,
            stopped => 0,
        };
        bless $instance, $class;
        return $instance;
    }

    sub start {
        my ($self) = @_;
        $self->{pids} = [];
        $self->{job_pipes} = [];
        $self->{result_pipe} = IO::Pipe->new();
        $self->{job_count} = 0;

        for (my $i = 0; $i < $self->{n}; $i++) {
            my $job_pipe = IO::Pipe->new();

            my $pid = fork;
            if ($pid) {
                $job_pipe->writer();
                $job_pipe->autoflush(1);
                push @{$self->{job_pipes}}, $job_pipe;
                push @{$self->{pids}}, $pid;
                next;
            }
            else {
                $job_pipe->reader();
                $self->{result_pipe}->writer();
                $self->{result_pipe}->autoflush(1);

                my $e = $self->worker($job_pipe, $self->{result_pipe});
                $job_pipe->close();
                $self->{result_pipe}->close();
                exit($e ? 1 : 0);
            }
        }
        $self->{result_pipe}->reader();
    }

    sub enqueue {
        my ($self, $args) = @_;
        my $item = encode_json({ args => $args });
        $self->{target_worker} = ($self->{target_worker} + 1) % $self->{n};
        $self->{job_count} += 1;
        _write_pipe($self->{job_pipes}->[$self->{target_worker}], $item);
    }

    sub get_results {
        my ($self) = @_;
        my ($results, $error) = $self->_get_results();
        if ($error) {
            $self->_stop(0);
            die $error;
        }
        return $results;
    }

    sub _get_results {
        my ($self) = @_;
        my $results = [];
        my $error = undef;

        while ($self->{job_count} > 0) {
            my $result = $self->{result_pipe}->getline();
            $self->{job_count} -= 1;
            $result = decode_json($result);
            if ($result->{error}) {
                $error = $result->{error};
                last;
            }
            push @{$results}, $result;
        } 

        return ($results, $error);
    }

    sub stop {
        my ($self) = @_;
        my $error = $self->_stop(1);
        die $error if $error;
    }

    sub _stop {
        my ($self, $is_check_results) = @_;
        my ($results, $error);
        return if $self->{stopped};

        print "stopping...\n";
        $_->close() for @{$self->{job_pipes}};
        ($results, $error) = $self->_get_results() if $is_check_results;
        $self->{result_pipe}->close();
        waitpid($_, 0) for @{$self->{pids}};
        $self->{stopped} = 1;
        print "stopped\n";

        return $error;
    }

    sub worker {
        my ($self, $job_pipe, $result_pipe) = @_;
        my $worker_id = $$;
        print "worker $worker_id: start\n";

        local $@;
        eval {
            while (my $item = $job_pipe->getline()) {
                last if $item eq "\n";
                $item = decode_json($item);
                my $job_id = int(rand(100000));
                print "worker $worker_id: job $job_id: start ", Data::Dumper::Concise::Dumper($item);
                my $result = $self->{job}->($item->{args});
                print "worker $worker_id: job $job_id: finished\n";

                $result = encode_json({ result => $result });
                _write_pipe($result_pipe, $result);
            }
        };
        my $e = $@;
        if ($e) {
            warn "worker $worker_id: error $e";
            my $result = encode_json({ error => $e });
            _write_pipe($result_pipe, $result);
        };

        print "worker $worker_id: stop\n";
        return $e;
    }

    sub _write_pipe {
        my ($pipe, $value) = @_;
        $pipe->autoflush(1);
        $pipe->print($value . "\n");
    }
}

sub main {
    my $worker = JobWorker->new(n => 10, job => sub {
        my $value = shift;
        sleep 2;
        die 'job_error' if rand() < 0.2;
        return $value;
    });
    my $results;
    $worker->start();
    $worker->enqueue($_) for (0..10);
    $results = $worker->get_results();
    print "results: ", Data::Dumper::Concise::Dumper($results);

    $worker->enqueue($_) for (11..18);
    $results = $worker->get_results();
    print "results: ", Data::Dumper::Concise::Dumper($results);

    $worker->stop();
}

main();
