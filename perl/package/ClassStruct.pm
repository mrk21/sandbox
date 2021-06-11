package ClassStruct;

use strict;
use warnings;
use utf8;

package ClassStruct::Clazz {
  use Class::Struct __PACKAGE__, {
    value1 => '$',
    value2 => '$',
  };

  sub other_method {
    print "### other_func\n";
  }
};

1;
