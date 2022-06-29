# Usage:
#   cd perllib/ClassBuilder/
#   perl benchmark.pl
use utf8;
use strict;
use warnings;

use Cwd 'abs_path';
use File::Basename qw/dirname/;
use lib abs_path(dirname(__FILE__));

use Benchmark qw/timethese cmpthese/;
use Data::Dumper;

package BenchmarkClassBuilder {
    use ClassBuilder qw/has/;

    sub new {
        my ($class, $hashref) = @_;
        return bless $hashref, $class;
    }

    has value_01 => ( is => 'rw', isa => 'Str' );
    has value_02 => ( is => 'rw', isa => 'Str' );
    has value_03 => ( is => 'rw', isa => 'Str' );
    has value_04 => ( is => 'rw', isa => 'Str' );
    has value_05 => ( is => 'rw', isa => 'Str' );
    has value_06 => ( is => 'rw', isa => 'Str' );
    has value_07 => ( is => 'rw', isa => 'Str' );
    has value_08 => ( is => 'rw', isa => 'Str' );
    has value_09 => ( is => 'rw', isa => 'Str' );
    has value_10 => ( is => 'rw', isa => 'Str' );
    has value_11 => ( is => 'rw', isa => 'Str' );
    has value_12 => ( is => 'rw', isa => 'Str' );
    has value_13 => ( is => 'rw', isa => 'Str' );
    has value_14 => ( is => 'rw', isa => 'Str' );
    has value_15 => ( is => 'rw', isa => 'Str' );
    has value_16 => ( is => 'rw', isa => 'Str' );
    has value_17 => ( is => 'rw', isa => 'Str' );
    has value_18 => ( is => 'rw', isa => 'Str' );
    has value_19 => ( is => 'rw', isa => 'Str' );
    has value_20 => ( is => 'rw', isa => 'Str' );
}

package BenchmarkClassBuilderCheckAttr {
    use ClassBuilder qw/has/;

    sub new {
        my ($class, $hashref) = @_;
        my $instance = bless $hashref, $class;
        ClassBuilder::check_attributes($instance);
        return $instance;
    }

    has value_01 => ( is => 'rw', isa => 'Str' );
    has value_02 => ( is => 'rw', isa => 'Str' );
    has value_03 => ( is => 'rw', isa => 'Str' );
    has value_04 => ( is => 'rw', isa => 'Str' );
    has value_05 => ( is => 'rw', isa => 'Str' );
    has value_06 => ( is => 'rw', isa => 'Str' );
    has value_07 => ( is => 'rw', isa => 'Str' );
    has value_08 => ( is => 'rw', isa => 'Str' );
    has value_09 => ( is => 'rw', isa => 'Str' );
    has value_10 => ( is => 'rw', isa => 'Str' );
    has value_11 => ( is => 'rw', isa => 'Str' );
    has value_12 => ( is => 'rw', isa => 'Str' );
    has value_13 => ( is => 'rw', isa => 'Str' );
    has value_14 => ( is => 'rw', isa => 'Str' );
    has value_15 => ( is => 'rw', isa => 'Str' );
    has value_16 => ( is => 'rw', isa => 'Str' );
    has value_17 => ( is => 'rw', isa => 'Str' );
    has value_18 => ( is => 'rw', isa => 'Str' );
    has value_19 => ( is => 'rw', isa => 'Str' );
    has value_20 => ( is => 'rw', isa => 'Str' );
}

package BenchmarkClassBuilderClone {
    use ClassBuilder qw/has/;

    sub new {
        my ($class, $hashref) = @_;
        return bless {
            value_01 => $hashref->{value_01},
            value_02 => $hashref->{value_02},
            value_03 => $hashref->{value_03},
            value_04 => $hashref->{value_04},
            value_05 => $hashref->{value_05},
            value_06 => $hashref->{value_06},
            value_07 => $hashref->{value_07},
            value_08 => $hashref->{value_08},
            value_09 => $hashref->{value_09},
            value_10 => $hashref->{value_10},
            value_11 => $hashref->{value_11},
            value_12 => $hashref->{value_12},
            value_13 => $hashref->{value_13},
            value_14 => $hashref->{value_14},
            value_15 => $hashref->{value_15},
            value_16 => $hashref->{value_16},
            value_17 => $hashref->{value_17},
            value_18 => $hashref->{value_18},
            value_19 => $hashref->{value_19},
            value_20 => $hashref->{value_20},
        }, $class;
    }

    has value_01 => ( is => 'rw', isa => 'Str' );
    has value_02 => ( is => 'rw', isa => 'Str' );
    has value_03 => ( is => 'rw', isa => 'Str' );
    has value_04 => ( is => 'rw', isa => 'Str' );
    has value_05 => ( is => 'rw', isa => 'Str' );
    has value_06 => ( is => 'rw', isa => 'Str' );
    has value_07 => ( is => 'rw', isa => 'Str' );
    has value_08 => ( is => 'rw', isa => 'Str' );
    has value_09 => ( is => 'rw', isa => 'Str' );
    has value_10 => ( is => 'rw', isa => 'Str' );
    has value_11 => ( is => 'rw', isa => 'Str' );
    has value_12 => ( is => 'rw', isa => 'Str' );
    has value_13 => ( is => 'rw', isa => 'Str' );
    has value_14 => ( is => 'rw', isa => 'Str' );
    has value_15 => ( is => 'rw', isa => 'Str' );
    has value_16 => ( is => 'rw', isa => 'Str' );
    has value_17 => ( is => 'rw', isa => 'Str' );
    has value_18 => ( is => 'rw', isa => 'Str' );
    has value_19 => ( is => 'rw', isa => 'Str' );
    has value_20 => ( is => 'rw', isa => 'Str' );
}

package BenchmarkMouse {
    use Mouse;

    has value_01 => ( is => 'rw', isa => 'Str' );
    has value_02 => ( is => 'rw', isa => 'Str' );
    has value_03 => ( is => 'rw', isa => 'Str' );
    has value_04 => ( is => 'rw', isa => 'Str' );
    has value_05 => ( is => 'rw', isa => 'Str' );
    has value_06 => ( is => 'rw', isa => 'Str' );
    has value_07 => ( is => 'rw', isa => 'Str' );
    has value_08 => ( is => 'rw', isa => 'Str' );
    has value_09 => ( is => 'rw', isa => 'Str' );
    has value_10 => ( is => 'rw', isa => 'Str' );
    has value_11 => ( is => 'rw', isa => 'Str' );
    has value_12 => ( is => 'rw', isa => 'Str' );
    has value_13 => ( is => 'rw', isa => 'Str' );
    has value_14 => ( is => 'rw', isa => 'Str' );
    has value_15 => ( is => 'rw', isa => 'Str' );
    has value_16 => ( is => 'rw', isa => 'Str' );
    has value_17 => ( is => 'rw', isa => 'Str' );
    has value_18 => ( is => 'rw', isa => 'Str' );
    has value_19 => ( is => 'rw', isa => 'Str' );
    has value_20 => ( is => 'rw', isa => 'Str' );

    __PACKAGE__->meta->make_immutable;
    no Mouse;
}

sub benchmark_new {
    my $n = 1_000_000;

    print "\n### Benchmark new\n\n";

    timethese($n, {
        class_builder_new => sub {
            BenchmarkClassBuilder->new({
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            });
        },
        class_builder_check_attr_new => sub {
            BenchmarkClassBuilderCheckAttr->new({
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            });
        },
        class_builder_clone_new => sub {
            BenchmarkClassBuilder->new({
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            });
        },
        mouse_new => sub {
            BenchmarkMouse->new({
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            });
        },
        mouse_bless_new => sub {
            bless {
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            }, 'BenchmarkMouse';
        },
        hashref_new => sub {
            {
                value_01 => "Value 01",
                value_02 => "Value 02",
                value_03 => "Value 03",
                value_04 => "Value 04",
                value_05 => "Value 05",
                value_06 => "Value 06",
                value_07 => "Value 07",
                value_08 => "Value 08",
                value_09 => "Value 09",
                value_10 => "Value 10",
                value_11 => "Value 11",
                value_12 => "Value 12",
                value_13 => "Value 13",
                value_14 => "Value 14",
                value_15 => "Value 15",
                value_16 => "Value 16",
                value_17 => "Value 17",
                value_18 => "Value 18",
                value_19 => "Value 19",
                value_20 => "Value 20",
            };
        },
    });
}

sub benchmark_get {
    my $n = 80_000_000;

    my $hashref = {
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    };
    my $class_builder = BenchmarkClassBuilder->new({
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    });
    my $mouse = BenchmarkMouse->new({
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    });
    my $mouse_bless = bless {
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    }, 'BenchmarkMouse';

    print "\n### Benchmark get\n\n";

    timethese($n, {
        class_builder_get => sub {
            $class_builder->value_01();
        },
        mouse_get => sub {
            $mouse->value_01();
        },
        mouse_bless_get => sub {
            $mouse_bless->value_01();
        },
        hashref_get => sub {
            $hashref->{value_01};
        },
    });
}

sub benchmark_set {
    my $n = 20_000_000;

    my $hashref = {
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    };
    my $class_builder = BenchmarkClassBuilder->new({
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    });
    my $mouse = BenchmarkMouse->new({
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    });
    my $mouse_bless = bless {
        value_01 => "Value 01",
        value_02 => "Value 02",
        value_03 => "Value 03",
        value_04 => "Value 04",
        value_05 => "Value 05",
        value_06 => "Value 06",
        value_07 => "Value 07",
        value_08 => "Value 08",
        value_09 => "Value 09",
        value_10 => "Value 10",
        value_11 => "Value 11",
        value_12 => "Value 12",
        value_13 => "Value 13",
        value_14 => "Value 14",
        value_15 => "Value 15",
        value_16 => "Value 16",
        value_17 => "Value 17",
        value_18 => "Value 18",
        value_19 => "Value 19",
        value_20 => "Value 20",
    }, 'BenchmarkMouse';

    print "\n### Benchmark set\n\n";

    timethese($n, {
        class_builder_set => sub {
            $class_builder->value_01("New Value 01");
        },
        mouse_set => sub {
            $mouse->value_01("New Value 01");
        },
        mouse_bless_set => sub {
            $mouse_bless->value_01("New Value 01");
        },
        hashref_set => sub {
            $hashref->{value_01} = "New Value 01";
        },
    });
}

sub mouse_bless_test {
    my $mouse_bless;
    if (1) {
        $mouse_bless = bless {
            value_01 => "Value 01",
            value_02 => "Value 02",
            value_03 => "Value 03",
            value_04 => "Value 04",
            value_05 => "Value 05",
            value_06 => "Value 06",
            value_07 => "Value 07",
            value_08 => "Value 08",
            value_09 => "Value 09",
            value_10 => "Value 10",
            value_11 => "Value 11",
            value_12 => "Value 12",
            value_13 => "Value 13",
            value_14 => "Value 14",
            value_15 => "Value 15",
            value_16 => "Value 16",
            value_17 => "Value 17",
            value_18 => "Value 18",
            value_19 => "Value 19",
            value_20 => "Value 20",
        }, 'BenchmarkMouse';
    } else {
        $mouse_bless = BenchmarkMouse->new({
            value_01 => "Value 01",
            value_02 => "Value 02",
            value_03 => "Value 03",
            value_04 => "Value 04",
            value_05 => "Value 05",
            value_06 => "Value 06",
            value_07 => "Value 07",
            value_08 => "Value 08",
            value_09 => "Value 09",
            value_10 => "Value 10",
            value_11 => "Value 11",
            value_12 => "Value 12",
            value_13 => "Value 13",
            value_14 => "Value 14",
            value_15 => "Value 15",
            value_16 => "Value 16",
            value_17 => "Value 17",
            value_18 => "Value 18",
            value_19 => "Value 19",
            value_20 => "Value 20",
        });
    }

    print "\n### Mouse bless test\n\n";

    print "- value_01 ", $mouse_bless->value_01, "\n";
    print "- value_02 ", $mouse_bless->value_02, "\n";
    print "- value_03 ", $mouse_bless->value_03, "\n";
    print "- value_04 ", $mouse_bless->value_04, "\n";
    print "- value_05 ", $mouse_bless->value_05, "\n";
    print "- value_06 ", $mouse_bless->value_06, "\n";
    print "- value_07 ", $mouse_bless->value_07, "\n";
    print "- value_08 ", $mouse_bless->value_08, "\n";
    print "- value_09 ", $mouse_bless->value_09, "\n";
    print "- value_10 ", $mouse_bless->value_10, "\n";
    print "- value_11 ", $mouse_bless->value_11, "\n";
    print "- value_12 ", $mouse_bless->value_12, "\n";
    print "- value_13 ", $mouse_bless->value_13, "\n";
    print "- value_14 ", $mouse_bless->value_14, "\n";
    print "- value_15 ", $mouse_bless->value_15, "\n";
    print "- value_16 ", $mouse_bless->value_16, "\n";
    print "- value_17 ", $mouse_bless->value_17, "\n";
    print "- value_18 ", $mouse_bless->value_18, "\n";
    print "- value_19 ", $mouse_bless->value_19, "\n";
    print "- value_20 ", $mouse_bless->value_20, "\n";
    print "\n";

    print "\nset new value\n";
    $mouse_bless->value_01("New Value 01");
    print "- value_01 ", $mouse_bless->value_01, "\n";
    print "- value_02 ", $mouse_bless->value_02, "\n";
    print "- value_03 ", $mouse_bless->value_03, "\n";
    print "- value_04 ", $mouse_bless->value_04, "\n";
    print "- value_05 ", $mouse_bless->value_05, "\n";
    print "- value_06 ", $mouse_bless->value_06, "\n";
    print "- value_07 ", $mouse_bless->value_07, "\n";
    print "- value_08 ", $mouse_bless->value_08, "\n";
    print "- value_09 ", $mouse_bless->value_09, "\n";
    print "- value_10 ", $mouse_bless->value_10, "\n";
    print "- value_11 ", $mouse_bless->value_11, "\n";
    print "- value_12 ", $mouse_bless->value_12, "\n";
    print "- value_13 ", $mouse_bless->value_13, "\n";
    print "- value_14 ", $mouse_bless->value_14, "\n";
    print "- value_15 ", $mouse_bless->value_15, "\n";
    print "- value_16 ", $mouse_bless->value_16, "\n";
    print "- value_17 ", $mouse_bless->value_17, "\n";
    print "- value_18 ", $mouse_bless->value_18, "\n";
    print "- value_19 ", $mouse_bless->value_19, "\n";
    print "- value_20 ", $mouse_bless->value_20, "\n";
    print "\n";

    print "\nset wrong value\n";
    eval { $mouse_bless->value_01({ a=> 1}) };
    my $e = $@;
    print "error: ", $e;
    print "- value_01 ", $mouse_bless->value_01, "\n";
    print "- value_02 ", $mouse_bless->value_02, "\n";
    print "- value_03 ", $mouse_bless->value_03, "\n";
    print "- value_04 ", $mouse_bless->value_04, "\n";
    print "- value_05 ", $mouse_bless->value_05, "\n";
    print "- value_06 ", $mouse_bless->value_06, "\n";
    print "- value_07 ", $mouse_bless->value_07, "\n";
    print "- value_08 ", $mouse_bless->value_08, "\n";
    print "- value_09 ", $mouse_bless->value_09, "\n";
    print "- value_10 ", $mouse_bless->value_10, "\n";
    print "- value_11 ", $mouse_bless->value_11, "\n";
    print "- value_12 ", $mouse_bless->value_12, "\n";
    print "- value_13 ", $mouse_bless->value_13, "\n";
    print "- value_14 ", $mouse_bless->value_14, "\n";
    print "- value_15 ", $mouse_bless->value_15, "\n";
    print "- value_16 ", $mouse_bless->value_16, "\n";
    print "- value_17 ", $mouse_bless->value_17, "\n";
    print "- value_18 ", $mouse_bless->value_18, "\n";
    print "- value_19 ", $mouse_bless->value_19, "\n";
    print "- value_20 ", $mouse_bless->value_20, "\n";
    print "\n";
}

mouse_bless_test();
benchmark_new();
benchmark_get();
benchmark_set();
