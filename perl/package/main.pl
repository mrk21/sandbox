# @see https://perldoc.jp/func/package
use utf8;
require './HogeClass.pm';

print "## instance\n";
my $hoge = HogeClass->new();
$hoge->x(5);
print $hoge->square(); # 25
print "\n";

print "## static method\n";
HogeClass::static_method1();
