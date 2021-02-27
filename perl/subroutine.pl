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


print "## with code block\n";

sub with_code_block(&@) {
  my $code = shift;
  my $value = $_[0];
  {
    local $_ = $value;
    $code->();
  }
}

print "res: ", (with_code_block { $_ * 2 } 3), "\n";
