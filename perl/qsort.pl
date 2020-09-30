use utf8;

sub qsort(&@) {
  my $code = shift;
  my @array = @_;
  if ($#array <= 0) { return @array; }

  my $pivot = shift(@array);
  my @left = ();
  my @right = ();
  foreach (@array) {
    local $a = $_;
    local $b = $pivot;
    if ($code->() == -1) { push @left, $_; }
    else { push @right, $_; }
  }

  my @result = ();
  push(@result, &qsort($code, @left));
  push(@result, $pivot);
  push(@result, &qsort($code, @right));
  return @result;
}

my @array = (1, 10, 2, 5, -23);
my @sorted1 = qsort { $a <=> $b } @array;
my @sorted2 = sort { $a <=> $b } @array;
my @sorted3 = qsort { $b <=> $a } @array;
my @sorted4 = sort { $b <=> $a } @array;

print "array: ", join(',', @array), "\n";
print "sorted1: ", join(',', @sorted1), "\n";
print "sorted2: ", join(',', @sorted2), "\n";
print "sorted3: ", join(',', @sorted3), "\n";
print "sorted4: ", join(',', @sorted4), "\n";
