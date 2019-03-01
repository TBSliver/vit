use Test2::V0;

use App::Vit::Util;

# Util should export nothing by default
not_imported_ok('&parse_args');

my %basic_expected = (
  audit       => 0,
  help        => undef,
  passthrough => [],
  titlebar    => 0,
  version     => 0,
);

# Available options: help version titlebar audit
my @tests = (
  {
    name     => 'no args',
    in       => [],
    expected => { %basic_expected },
  },
  {
    name     => 'help',
    in       => [ qw/ --help / ],
    expected => {
      %basic_expected,
      help => 1,
    },
  },
  {
    name     => 'titlebar',
    in       => [ qw/ --titlebar / ],
    expected => {
      %basic_expected,
      titlebar => 1,
    },
  },
  {
    name     => 'audit',
    in       => [ qw/ --audit / ],
    expected => {
      %basic_expected,
      audit => 1,
    },
  },
  {
    name     => 'version',
    in       => [ qw/ --version / ],
    expected => {
      %basic_expected,
      version => 1,
    },
  },
  {
    name     => 'titlebar audit',
    in       => [ qw/ --audit --titlebar / ],
    expected => {
      %basic_expected,
      audit => 1,
      titlebar => 1,
    },
  },
  {
    name     => 'passthrough',
    in       => [ qw/ --anything something more stuff args / ],
    expected => {
      %basic_expected,
      passthrough => [ qw/  --anything something more stuff args / ],
    },
  },
  {
    name     => 'passthrough with audit',
    in       => [ qw/ --audit --anything something more stuff args / ],
    expected => {
      %basic_expected,
      audit => 1,
      passthrough => [ qw/  --anything something more stuff args / ],
    },
  },
  {
    name     => 'passthrough with titlebar',
    in       => [ qw/ --titlebar --anything something more stuff args / ],
    expected => {
      %basic_expected,
      titlebar => 1,
      passthrough => [ qw/  --anything something more stuff args / ],
    },
  },
);

for my $test ( @tests ) {
  subtest $test->{name} => sub {
    is
      App::Vit::Util::parse_args( $test->{in} ),
      $test->{expected},
      'Got expected';
  }
}

done_testing;
