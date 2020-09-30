# @see https://perldoc.jp/docs/perl/5.16.1/perlsub.pod
use utf8;

print "## normal\n";
sub square {
  $_[0] * $_[0];
}
print &square(5); # 25
print "\n";

print "## function reference\n";
my $square2 = \&square;
print $square2->(5); # 25
print "\n";

print "## lambda\n";
my $lambda = sub { print "lambda\n"; };
&$lambda; # lambda
$lambda->(); # lambda
(sub { print "lambda\n"; })->(); # lambda
