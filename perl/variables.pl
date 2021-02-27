# funny characters
# - `$` => scalar
# - `@` => array
# - `%` => hash
# - `&` => subroutine
# - `*` => type glob
#
# variable types
# - `our` => package variables(global variables), managed by symbol table(can use type glob)
# - `local` => daynamic scoped package variables, managed by symbol table(can use type glob)
# - `has` => instance scoped package variables
# - `my` => lexcal scoped variables
use utf8;


print "## scalar\n";
my $scalar = 1;
print $scalar; print "\n";


print "## array\n";
my @array = (1,3,5);
print $array[0]; print ", ";
print $array[1]; print ", ";
print $array[2]; print "\n";


print "## hash\n";
my %hash = (
  key1 => 'value1',
  key2 => 'value2'
);
print $hash{'key1'}; print ", ";
print $hash{'key2'}; print "\n";


print "## type glob\n";
# > |-------------|
# > | *typedglob  |--|
# > |-------------|  |
# >                  |      |-----------------|
# >                  |----->| ${ *typedglob } |
# >                  |      |-----------------|
# >                  |----->| @{ *typedglob } |
# >                  |      |-----------------|
# >                  |----->| %{ *typedglob } |
# >                  |      |-----------------|
# >                  |----->| &{ *typedglob } |
# >                         |-----------------|
# >
# > https://tutorial.perlzemi.com/blog/20080614121342.html
our $value1 = 1;
our @value1 = (1,2,3);
our %value1 = (k1 => 'v1', k2 => 'v2');

print "### get entry of symbol table \n";
print *value1, "\n";

print "### get values \n";
print ${*value1}, "\n";
print @{*value1}, "\n";
print %{*value1}, "\n";

print "### get references each type \n";
print *value1{SCALAR}, "\n";
print *value1{ARRAY}, "\n";
print *value1{HASH}, "\n";

print "### alias all types specified by the type glob \n";
*value2 = *value1;
print ${*value2}, "\n";
print @{*value2}, "\n";
print %{*value2}, "\n";


print "## scope\n";
sub method1 {
  print $var1;
  print "\n";
}
our $var1 = 10; # package variables(close to global variables)
&method1; # 10

{
  print "### my\n";
  my $var1 = 11; # lexcal scope(hide the this variable on this scope if defined same name variable)
  print $var1; # 10
  print "\n";
  &method1; # 10;
} 
&method1; # 10;

{
  print "### local\n";
  local $var1 = 12; # dynamic scope(update the global variable temporarily on this scope)
  print $var1; # 12
  print "\n";
  &method1; # 12
}
&method1; # 10;
