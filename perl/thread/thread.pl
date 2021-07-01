# @see https://perldoc.jp/docs/modules/threads-shared-1.29/threads/shared.pod
use strict;
use warnings;

package Client {
  use Time::HiRes 'usleep';

  sub new {
    my ($class) = @_;
    my $instance = {};
    bless $instance, $class;
    return $instance;
  }

  sub request {
    my ($self, $request_no) = @_;
    usleep int(rand(50 * 1000));
    my $response = "response: $request_no\n";
    return $response;
  }
}

package Requester {
  use Time::HiRes 'usleep';
  use threads;
  use threads::shared;
  use Thread::Semaphore;

  sub new {
    my ($class) = @_;
    my $instance = {
      client => Client->new(),
      worker_num => 0,
      semaphore => Thread::Semaphore->new(),
    };
    bless $instance, $class;
    return shared_clone($instance);
  }

  sub run {
    my $self = shift;
    my @threads = ();
    print "start\n";

    for (my $i = 0; $i < 10; $i++) {
      push @threads, threads->create($self->create_worker($i));
      usleep int(rand(10 * 1000));
    }
    $_->join for @threads;

    print "end\n";
  }

  sub create_worker {
    my ($self, $i) = @_;

    return sub {
      my $n = $self->increment_worker_num(1);
      print "thread $i: start\n";
      print "thread $i: worker_num: $n\n";
      my $response = $self->{client}->request($i);
      print "thread $i: $response";
      print "thread $i: end\n";
      $self->increment_worker_num(-1);
    };
  }

  sub increment_worker_num {
    my ($self, $n) = @_;
    $self->{semaphore}->down();
    $self->{worker_num} += $n;
    my $result = $self->{worker_num};
    $self->{semaphore}->up();
    return $result;
  }
}

sub main {
  my $requester = Requester->new();
  $requester->run();
}

main();
