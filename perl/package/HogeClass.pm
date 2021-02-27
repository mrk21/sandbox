package HogeClass;

use utf8;

# base class
use Object::Simple -base;

# accsessors
has x => 0;

sub static_method1 {
  print "static_method1\n";
}

# instance method
sub square {
  my $self = shift; # first variable is recever
  $self->x * $self->x;
}

1;
