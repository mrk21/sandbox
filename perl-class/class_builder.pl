use strict;
use warnings;

use Cwd 'abs_path';
use File::Basename qw/dirname/;
use lib abs_path(dirname(__FILE__));

use Data::Dumper;

package Foo {
    use ClassBuilder qw(has);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    has a => ( is => 'rw', isa => 'Int' );
    has b => ( is => 'rw', isa => 'Int' );
}

package Bar {
    use ClassBuilder qw(has);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    has c => ( is => 'rw', isa => 'Int' );
}

package Buzz {
    use ClassBuilder qw(has);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    has value => ( is => 'rw', isa => 'Int' );
    has foo   => ( is => 'rw', isa => 'Foo' );
}

my $buzz = Buzz->new({ value => 1, foo => Foo->new({ a => 1, b => 2 }) });

print Dumper(Buzz->meta->get_attribute_list);

print Dumper($buzz->value);
# $buzz->value('a'); #=> Error
$buzz->value(2);     #=> OK
print Dumper($buzz->value);

print Dumper($buzz->foo);
# $buzz->foo(1);                          #=> Error
# $buzz->foo(Bar->new({ c => 13 }));      #=> Error
$buzz->foo(Foo->new({ a => 3, b => 4 })); #=> OK
print Dumper($buzz->foo);
