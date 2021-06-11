use strict;
use warnings;

package BaseClass {
  sub new {
    my ($class) = @_;
    my $instance = {
      value1 => 1,
    };
    bless $instance, $class;
    return $instance;
  }

  sub hoge {
    my ($self) = @_;
    print "## hoge: ", __PACKAGE__, ", ", $self->{value1}, "\n";
  }

  sub foo {
    my ($self) = @_;
    print "## foo: ", __PACKAGE__, ", ", $self->{value1}, "\n";
  }
}

package DerivedClass {
  use base qw(BaseClass);

  sub new {
    my ($class) = @_;
    my $instance = $class->SUPER::new(@_);
    $instance->{value2} = 2;
    bless $instance, $class;
    return $instance;
  }

  sub fuga {
    my ($self) = @_;
    print "## fuga: ", __PACKAGE__, ", ", $self->{value2}, "\n";
  }

  sub foo {
    my ($self) = @_;
    print "## foo(overrided): ", __PACKAGE__, ", ", $self->{value2}, "\n";
  }
}

sub main {
  my $base = BaseClass->new();
  my $derived = DerivedClass->new();

  $base->hoge();    ## hoge: BaseClass, 1
  $base->foo();     ## foo: BaseClass, 1
  $derived->fuga(); ## fuga: DerivedClass, 2
  $derived->hoge(); ## hoge: BaseClass, 1
  $derived->foo();  ## foo(overrided): DerivedClass, 2
}

main();
