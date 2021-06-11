use strict;
use warnings;

use Data::Dumper;
use Benchmark qw/timethese cmpthese/;

# @see [InsideOutクラスのクラスビルダーの紹介 - Mobile Factory Tech Blog](https://tech.mobilefactory.jp/entry/2018/12/09/074155)
# @see https://github.com/plack/Plack/blob/master/lib/Plack/Request.pm
package BlessClass {
  sub new {
    my ($class, %attr) = @_;
    my $instance = {
      value1 => ($attr{value1} // ''),
      value2 => ($attr{value2} // ''),
    };
    bless $instance, $class;
    return $instance;
  }

  sub value1 { $_[0]->{value1}; }
  sub value2 { $_[0]->{value2}; }

  sub set_value1 { $_[0]->{value1} = $_[1]; }
  sub set_value2 { $_[0]->{value2} = $_[1]; }

  sub instance_method {
    my ($self) = @_;
    print "## ", __PACKAGE__ ,"#instance_method: ", $self->value1, "\n";
  }
}

package ClassStruct {
  use Class::Struct __PACKAGE__, {
    value1 => '$',
    value2 => '$',
  };

  sub instance_method {
    my ($self) = @_;
    print "## ", __PACKAGE__ ,"#instance_method: ", $self->value1, "\n";
  }
}

package MooseClass {
  use Moose;

  has 'value1' => (
      is  => 'rw',
      isa => 'Int',
  );

  has 'value2' => (
      is  => 'rw',
      isa => 'Int',
  );

  sub instance_method {
    my ($self) = @_;
    print "## ", __PACKAGE__ ,"#instance_method: ", $self->value1, "\n";
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}

package MouseClass {
  use Mouse;

  has 'value1' => (
      is  => 'rw',
      isa => 'Int',
  );

  has 'value2' => (
      is  => 'rw',
      isa => 'Int',
  );

  sub instance_method {
    my ($self) = @_;
    print "## ", __PACKAGE__ ,"#instance_method: ", $self->value1, "\n";
  }

  no Mouse;
  __PACKAGE__->meta->make_immutable;
}

sub call_instance_method {
    my $class_struct = ClassStruct->new(value1 => 1, value2 => 2);
    my $bless_class = BlessClass->new(value1 => 1, value2 => 2);
    my $mouse_class = MouseClass->new(value1 => 1, value2 => 2);
    my $moose_class = MooseClass->new(value1 => 1, value2 => 2);

    $class_struct->instance_method();
    $bless_class->instance_method();
    $mouse_class->instance_method();
    $moose_class->instance_method();
}

sub instance_bench {
  print "## instance_bench\n";
  my $n = 100 * 10000;
  my $result = timethese(3, {
    class_struct => sub {
      my $a = ClassStruct->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        my $instance = ClassStruct->new(value1 => 1, value2 => 2);
      }
    },
    mouse_class => sub {
      for (my $i = 0; $i < $n; $i++){
        my $instance = MouseClass->new(value1 => 1, value2 => 2);
      }
    },
    moose_class => sub {
      for (my $i = 0; $i < $n; $i++){
        my $instance = MooseClass->new(value1 => 1, value2 => 2);
      }
    },
    bless_class => sub {
      for (my $i = 0; $i < $n; $i++){
        my $instance = BlessClass->new(value1 => 1, value2 => 2);
      }
    },
    hashref => sub {
      for (my $i = 0; $i < $n; $i++){
        my $instance = +{ value1 => 1, value2 => 2 };
      }
    },
  });
  print "\n";
}

sub get_bench {
  print "## get_bench\n";
  my $n = 100 * 10000;
  my $result = timethese(3, {
    class_struct => sub {
      my $instance = ClassStruct->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        my $value = $instance->value1();
      }
    },
    mouse_class => sub {
      my $instance = MouseClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->value1();
      }
    },
    moose_class => sub {
      my $instance = MooseClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->value1();
      }
    },
    bless_class => sub {
      my $instance = BlessClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        my $value = $instance->value1();
      }
    },
    hashref => sub {
      my $instance = +{ value1 => 1, value2 => 2 };
      for (my $i = 0; $i < $n; $i++){
        my $value = $instance->{value1};
      }
    },
  });
  print "\n";
}

sub set_bench {
  print "## set_bench\n";
  my $n = 100 * 10000;
  my $result = timethese(3, {
    class_struct => sub {
      my $instance = ClassStruct->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->value1(1);
      }
    },
    mouse_class => sub {
      my $instance = MouseClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->value1(1);
      }
    },
    moose_class => sub {
      my $instance = MooseClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->value1(1);
      }
    },
    bless_class => sub {
      my $instance = BlessClass->new(value1 => 1, value2 => 2);
      for (my $i = 0; $i < $n; $i++){
        $instance->set_value1(1);
      }
    },
    hashref => sub {
      my $instance = +{ value1 => 1, value2 => 2 };
      for (my $i = 0; $i < $n; $i++){
        $instance->{value1} = 1;
      }
    },
  });
  print "\n";
}

call_instance_method();
instance_bench();
get_bench();
set_bench();
