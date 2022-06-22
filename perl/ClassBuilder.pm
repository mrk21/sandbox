use strict;
use warnings;
use Data::Dumper;

# @see https://github.com/xslate/p5-Mouse/blob/963c3a248fd786f1d38f297d7a79705a29833ebc/lib/Mouse.pm
# @see https://github.com/xslate/p5-Mouse/blob/963c3a248fd786f1d38f297d7a79705a29833ebc/lib/Mouse/Role.pm#L36
# @see https://github.com/maokt/class-accessor-pm/blob/master/lib/Class/Accessor.pm
# @see https://metacpan.org/pod/Moose::Meta::TypeConstraint
package ClassBuilder {
    use Mouse::Util::TypeConstraints qw(find_type_constraint type where);
    use Data::Dumper;

    my %meta; # All classes meta. `Hash[ClassBuilder::Meta]` class_name => meta

    sub attr {
        no strict 'refs'; # This requires at `*{hoge} = sub { ... }`
        my $class = caller; # `caller` is a package that called this subroutine.
        my ($name, %spec) = @_;
        my $type = $spec{type};
        $type = find_type_constraint($type) // type $type => where { ref $_ eq $type };

        my $accessor = sub {
            my $self = shift;

            if (@_) {
                my $value = shift;
                $type->assert_valid($value);
                $self->{$name} = $value;
            } else {
                return $self->{$name};
            }
        };
        *{"${class}::${name}"} = $accessor; # Dynamic definition of a subrutine of the package.
        $class->meta->add_attr($name, type => $type, accessor => $accessor);
    }

    # `import` subroutine is called on `use ClassBuilder`.
    sub import {
        no strict 'refs';
        my $class = shift;
        my @uses = @_;
        my $target_class = caller;

        $meta{$target_class} //= ClassBuilder::Meta->new($target_class);

        *{"${target_class}::$_"} = \&{"${class}::$_"} for @uses;
        *{"${target_class}::meta"} = sub { $meta{$target_class} };
    }
}

package ClassBuilder::Meta {
    sub new {
        my ($class, $target) = @_;
        return bless {
            target => $target,
            attrs => [],
        }, $class;
    }

    sub add_attr {
        my ($self, $name, %spec) = @_;
        my $attr = ClassBuilder::Meta::Attribute->new($name, %spec);
        push @{$self->{attrs}}, $attr;
    }

    sub attrs {
        my ($self) = @_;
        return $self->{attrs};
    }

    sub attr_names {
        my ($self) = @_;
        return [ map { $_->name } @{$self->{attrs}} ];
    }
}

package ClassBuilder::Meta::Attribute {
    sub new {
        my ($class, $name, %spec) = @_;
        return bless {
            name => $name,
            type => $spec{type},
            accessor => $spec{accessor},
        }, $class;
    }

    sub name { shift->{name} }
    sub type { shift->{type} }
    sub accessor { shift->{accessor} }
}

1;
