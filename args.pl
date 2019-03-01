#! /usr/bin/env perl

use strict;
use warnings;

use App::Vit::Util;

our ( $audit, $titlebar, $cli_args, $version );

sub parse_args {
  my $args = App::Vit::Util::parse_args();

  usage()   if $args->{help};
  version() if $args->{version};
  $audit    = $args->{audit};
  $titlebar = $args->{titlebar};
  $cli_args = join ' ', @{ $args->{passthrough} };

  if ( $audit ) {
    # TODO move the audit writing/opening code
    open(AUDIT, ">", "vit_audit.log") or die "$!"; ## no critic
    open STDERR, '>', '&AUDIT';

    # flush AUDIT after printing to it
    my $ofh = select AUDIT;
    $| = 1;
    select $ofh;

    print AUDIT "$$ INIT $0 " . join(' ',@ARGV), "\r\n";
  }
}

#------------------------------------------------------------------

sub usage {
  my $usage = App::Vit::Util::usage_string( $version );
  print $usage;
  exit 0;
}

sub version {
  print "$version\n";
  exit 0;
}

return 1;

=head1 COPYRIGHT

See LICENCE file

=cut

