package Bless;

use strict;
use warnings;
use utf8;

# @see https://github.com/plack/Plack/blob/master/lib/Plack/Request.pm
package Bless::Clazz {
  use Data::Dumper;

  sub new {
    my ($class, %attr) = @_;
    my $instance = {
      value1 => ($attr{value1} // ''),
      value2 => ($attr{value2} // ''),
    };
    bless $instance, $class;
    return $instance;
  }

  sub value1 { return _wattr($_[0], 'value1', $_[1]); }
  sub value2 { return _rattr($_[0], 'value2'); }

  sub _wattr {
    my ($self, $attr, $val) = @_;
    if (defined($val)) {
      $self->{$attr} = $val;
    }
    return $self->{$attr};
  }

  sub _rattr {
    my ($self, $attr) = @_;
    return $self->{$attr};
  }
};

1;
