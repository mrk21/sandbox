# @see https://perldoc.jp/func/package
use strict;
use warnings;
use utf8;

use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin";

use HogeClass;
{
  print "## HogeClass\n";
  print "### instance\n";
  my $hoge = HogeClass->new();
  $hoge->x(5);
  print $hoge->square(); # 25
  print "\n";

  print "### static method\n";
  HogeClass::static_method1();
  print "\n";
}

use Bless;
{
  print "## Bless\n";
  my $v = Bless::Clazz->new(value1 => 'v1', value2 => 'v2');
  print "### v->value1: ", $v->value1, "\n";
  print "### v->value2: ", $v->value2, "\n";

  $v->value1('vv1');
  print "### v->value1: ", $v->value1, "\n";
  print "### v->value2: ", $v->value2, "\n";
  print "\n";
}

use ClassStruct;
{
  print "## ClassStruct\n";
  my $v = ClassStruct::Clazz->new(value1 => 'v1', value2 => 'v2');
  print "### v->value1: ", $v->value1, "\n";
  print "### v->value2: ", $v->value2, "\n";

  $v->value1('vv1');
  print "### v->value1: ", $v->value1, "\n";
  print "### v->value2: ", $v->value2, "\n";
  print "\n";
}
