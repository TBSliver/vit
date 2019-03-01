package App::Vit::Util;

use strict;
use warnings;

use Getopt::Long qw/ GetOptionsFromArray /;

use base 'Exporter';
our @EXPORT_OK = ( qw/
  parse_args
  usage_string
/ );

sub parse_args {
  my $args = shift;

  $args //= \@ARGV;

  my $titlebar = 0;
  my $audit    = 0;
  my $version  = 0;
  my $help;

  Getopt::Long::Configure( 'pass_through' );
  GetOptionsFromArray( $args,
    'titlebar|t' => \$titlebar,
    'audit|a'    => \$audit,
    'version|v'  => \$version,
    'help|h'     => \$help,
  );

  return {
    titlebar    => $titlebar,
    audit       => $audit,
    version     => $version,
    help        => $help,
    passthrough => $args,
  };
}

sub usage_string {
  my $version = shift;

  $version //= "NO VERSION SET";

  return <<USAGE;
usage: vit [switches] [task_args]
  --audit    -a print task commands to vit_audit.log
  --titlebar -t sets the xterm titlebar to $version
  --version  -v prints the version
  task_args     any set of task commandline args that print an "ID" column
USAGE
}

1;
