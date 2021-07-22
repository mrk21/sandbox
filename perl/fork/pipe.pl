use strict;
use warnings;
use IO::Pipe;
use JSON;
use Data::Dumper::Concise;

sub main {
    my $pipe = IO::Pipe->new;

    print "parent process: fork\n";
    my $pid = fork // die 'fork failed';
    if ($pid) {
        $pipe->reader;

        print "parent process: wait child process $pid...\n";
        while (my $result = <$pipe>) {
            $result = decode_json($result);
            print "parent process: child process result: ", Data::Dumper::Concise::Dumper($result);
        }
        waitpid($pid, 0);
        print "parent process: child process $pid finished\n";
    }
    else {
        $pipe->writer;

        print "child process $$: start\n";
        sleep 3;
        my $result = encode_json({
            pid => $$,
            value => int(rand(100)),
        });
        print $pipe $result;
        $pipe->close;
        print "child process $$: finished\n";
        exit 0;
    }
}

main();
