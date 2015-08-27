use strict;
use warnings;
use Test::More;

use Import::Compiling;

BEGIN {
  package MyExporter;
  $INC{'MyExporter.pm'} = __FILE__;
  use Carp;

  sub import {
    shift->export;
  }
  sub export {
    Carp->import::compiling(qw(carp));
  }
}

BEGIN {
  package MyImporter;
  use MyExporter;
}

ok +MyImporter->can('carp'), 'import::compiling exports to correct location';

done_testing;
