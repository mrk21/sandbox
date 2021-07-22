use strict;
use warnings;

sub main {
    print "parent process: fork\n";
    my $pid = fork // die 'fork failed';
    if ($pid) {
        print "parent process: wait child process $pid...\n";
        my $wait_pid = waitpid($pid, 0);
        print "parent process: child process $pid finished\n";
    }
    else {
        print "child process $$: start\n";
        sleep 3;
        print "child process $$: finished\n";
    }
}

main();
