use strict;
use warnings;
use Data::Dumper;

# Mouse like class builder
#
# @see https://github.com/xslate/p5-Mouse/blob/963c3a248fd786f1d38f297d7a79705a29833ebc/lib/Mouse.pm
# @see https://github.com/xslate/p5-Mouse/blob/963c3a248fd786f1d38f297d7a79705a29833ebc/lib/Mouse/Role.pm#L36
# @see https://github.com/maokt/class-accessor-pm/blob/master/lib/Class/Accessor.pm
# @see https://metacpan.org/pod/Moose::Meta::TypeConstraint
package ClassBuilder {
    use Mouse::Util::TypeConstraints qw(find_type_constraint type where);
    use Data::Dumper;

    my %META; # All classes meta. `Hash[ClassBuilder::Meta]` class_name => meta

    sub has {
        no strict 'refs'; # This requires at `*{hoge} = sub { ... }`
        my $class = caller; # `caller` is a package that called this subroutine.
        my ($name, %spec) = @_;

        my $is = $spec{is};
        my $isa = $spec{isa};
        $isa = find_type_constraint($isa) // type $isa => where { ref $_ eq $isa };

        my $accessor;
        if ($is eq 'rw') {
            $accessor = sub {
                my $self = shift;

                if (@_) {
                    my $value = shift;
                    $isa->assert_valid($value);
                    $self->{$name} = $value;
                } else {
                    return $self->{$name};
                }
            };
        }
        elsif ($is eq 'r') {
            $accessor = sub {
                my $self = shift;
                return $self->{$name};
            };
        }

        *{"${class}::${name}"} = $accessor; # Dynamic definition of a subrutine of the package.
        $class->meta->add_attribute($name => %spec);
    }

    # `import` subroutine is called on `use ClassBuilder`.
    sub import {
        no strict 'refs';
        my $class = shift;
        my @uses = @_;
        my $target_class = caller;

        $META{$target_class} //= ClassBuilder::Meta->new($target_class);

        *{"${target_class}::$_"} = \&{"${class}::$_"} for @uses;
        *{"${target_class}::meta"} = sub { $META{$target_class} };
    }
}

package ClassBuilder::Meta {
    sub new {
        my ($class, $target) = @_;
        return bless {
            target => $target,
            attributes => [],
        }, $class;
    }

    sub add_attribute {
        my ($self, $name, %spec) = @_;
        my $attr = ClassBuilder::Meta::Attribute->new($name, %spec);
        push @{$self->{attributes}}, $attr;
    }

    sub get_all_attributes {
        my ($self) = @_;
        return $self->{attributes};
    }

    sub get_attribute_list {
        my ($self) = @_;
        return [ map { $_->name } @{$self->{attributes}} ];
    }
}

package ClassBuilder::Meta::Attribute {
    sub new {
        my ($class, $name, %spec) = @_;
        return bless {
            name => $name,
            is => $spec{is},
            isa => $spec{isa},
            accessor => $spec{accessor},
        }, $class;
    }

    sub name { shift->{name} }
    sub is { shift->{is} }
    sub isa { shift->{isa} }
    sub accessor { shift->{accessor} }
}

1;
