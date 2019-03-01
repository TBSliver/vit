use Test2::V0;
use Test::Trap; # gives trap and $trap

use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use lib "$Bin/../..";

# Module under test
require 'args.pl'; ## no critic (Modules::RequireBarewordIncludes)

imported_ok( '&parse_args' );

# requires a global package variable
our ( $cli_args, $audit, $titlebar, $version );

subtest 'ARGV empty' => sub {
  local @ARGV = ();
  local ( $cli_args, $audit, $titlebar )
      = ( '',        0,      0         );

  trap { parse_args() };

  # it actually ends up appending a space
  is $cli_args,      '',    'cli_args correct';
  is $audit,         0,     'audit correct';
  is $titlebar,      0,     'titlebar correct';
  is $trap->stdout,  '',    'stdout empty';
  is $trap->exit,    undef, 'no exit';
  is \@ARGV,         [],    'ARGV empty';
};

subtest 'ARGV help' => sub {
  for my $arg ( qw/ --help -help -h / ) {
    subtest $arg => sub {
      local @ARGV = ( $arg );
      local ( $cli_args, $audit, $titlebar )
          = ( '',        0,      0         );

      trap { parse_args() };

      # it actually ends up appending a space
      is   $cli_args,      '',             'cli_args correct';
      is   $audit,         0,              'audit correct';
      is   $titlebar,      0,              'titlebar correct';
      like $trap->stdout,  qr/usage: vit/, 'stdout contains usage';
      is   $trap->exit,    0,              'exit 0';
    };
  }
};

subtest 'ARGV version' => sub {
  for my $arg ( qw/ --version -version -v / ) {
    subtest $arg => sub {
      local @ARGV = ( $arg );
      local ( $cli_args, $audit, $titlebar, $version )
          = ( '',        0,      0        , 'testing' );

      trap { parse_args() };

      # it actually ends up appending a space
      is $cli_args,      '',          'cli_args correct';
      is $audit,         0,           'audit correct';
      is $titlebar,      0,           'titlebar correct';
      is $trap->stdout,  "testing\n", 'stdout correct';
      is $trap->exit,    0,           'exit 0';
    };
  }
};

subtest 'ARGV titlebar' => sub {
  for my $arg ( qw/ --titlebar -titlebar -t / ) {
    subtest $arg => sub {
      local @ARGV = ( $arg );
      local ( $cli_args, $audit, $titlebar, $version )
          = ( '',        0,      0        , undef );

      trap { parse_args() };

      # it actually ends up appending a space
      is $cli_args,      '',    'cli_args correct';
      is $audit,         0,     'audit correct';
      is $titlebar,      1,     'titlebar correct';
      is $trap->stdout,  "",    'stdout correct';
      is $trap->exit,    undef, 'exit 0';
      is \@ARGV,         [],    'ARGV empty';
    };
  }
};

subtest 'ARGV ignored items' => sub {
  local @ARGV = ( '--titlebar', 'ignored', '--someotheropt', 'more ignored' );
  local ( $cli_args, $audit, $titlebar, $version )
      = ( '',        0,      0        , undef );

  trap { parse_args() };

  # it actually ends up appending a space
  # Maybe remove trailing spaces - updated version will mangle that
  $cli_args =~ s/\s+$//;
  is $cli_args,      'ignored --someotheropt more ignored', 'cli_args correct';
  is $audit,         0,     'audit correct';
  is $titlebar,      1,     'titlebar correct';
  is $trap->stdout,  "",    'stdout correct';
  is $trap->exit,    undef, 'no exit';
  is \@ARGV,         [],    'ARGV empty';
};

# testing --audit requires wrapping the file open

done_testing;
