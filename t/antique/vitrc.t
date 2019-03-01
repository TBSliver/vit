use Test2::V0;
use Test::Trap; # gives trap and $trap

use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use lib "$Bin/../..";

# Module under test
require 'vitrc.pl'; ## no critic (Modules::RequireBarewordIncludes)

done_testing;
