use strict;
use warnings;
use POSIX ":sys_wait_h";
use IO::Pipe;
use JSON;
use Data::Dumper::Concise;
use Parallel::ForkManager;

# parent <--+-- child_1
#           +-- child_2
#           +-- child_3
sub main {
    my $pipe = IO::Pipe->new;
    my @pids = ();

    for my $i (1..10) {
        my $pid = fork;
        if ($pid) {
            push @pids, $pid;
            next;
        }
        else {
            $pipe->writer;
            $pipe->autoflush(1);
            local $@;
            eval {
                sleep int(rand(2));
                die "error (pid: $$)" if rand() < 0.2;
                my $result = encode_json({
                    pid => $$,
                    value => int(rand(100)),
                });
                print $pipe $result, "\n";
            };
            my $e = $@;
            $pipe->close;
            if ($e) {
                warn $e;
                exit 1;
            }
            exit 0;
        }
    }
    $pipe->reader;

    while (my $result = $pipe->getline()) {
        $result = decode_json($result);
        print Data::Dumper::Concise::Dumper($result);
    }
    $pipe->close;

    my @statuses = ();
    for my $pid (@pids) {
        waitpid($pid, 0);
        push @statuses, $?;
    }
    die 'error on children' if scalar(grep { $_ != 0 } @statuses) != 0;
}

main();
