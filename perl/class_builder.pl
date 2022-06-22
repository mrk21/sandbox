use strict;
use warnings;

use Cwd 'abs_path';
use File::Basename qw/dirname/;
use lib abs_path(dirname(__FILE__));

use Data::Dumper;

package Foo {
    use ClassBuilder qw(attr);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    attr 'a', type => 'Int';
    attr 'b', type => 'Int';
}

package Bar {
    use ClassBuilder qw(attr);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    attr 'c', type => 'Int';
}

package Buzz {
    use ClassBuilder qw(attr);

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    attr 'value', type => 'Int';
    attr 'foo', type => 'Foo';
}

my $buzz = Buzz->new({ value => 1, foo => Foo->new({ a => 1, b => 2 }) });

print Dumper(Buzz->meta->attr_names);

print Dumper($buzz->value);
# $buzz->value('a'); #=> Error
$buzz->value(2);     #=> OK
print Dumper($buzz->value);

print Dumper($buzz->foo);
# $buzz->foo(1);                          #=> Error
# $buzz->foo(Bar->new({ c => 13 }));      #=> Error
$buzz->foo(Foo->new({ a => 3, b => 4 })); #=> OK
print Dumper($buzz->foo);
