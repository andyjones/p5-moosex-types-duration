package MooseX::Types::Duration;
use strict;
use warnings;

# ABSTRACT: Duration types for Moose classes

use MooseX::Types -declare => ['Seconds'];
use MooseX::Types::Moose qw(Int Str HashRef);

# Type representing a time in seconds
# allow more readable '1 day' style strings
subtype Seconds,
  as Int;

coerce Seconds,
  from Str, via { _hashref_to_secs(_parse_secs_str($_)) };

coerce Seconds,
  from HashRef, via { _hashref_to_secs($_) };

my %UNITS = (
  day => {
    unit => qr/d(?:ays?)?\b/i,
    to_secs => 24*60*60,
  },
  hour => {
    unit => qr/h(?:ours?)?\b/i,
    to_secs => 60*60,
  },
  minute => {
    unit => qr/m(?:in(?:ute)?s?)?\b/i,
    to_secs => 60,
  },
  second => {
    unit => qr/s(?:ec(?:ond)?s?)?\b/i,
    to_secs => 1,
  },
);

sub _parse_secs_str {
  my $str = shift;

  my %parsed;
  while ( my ($unit, $defn) = each %UNITS ) {
    $parsed{$unit} = $1 if $str =~ m/\b(\d+) ?$defn->{unit}/;
  }

  return \%parsed;
}

sub _hashref_to_secs {
  my $time_ref = shift or return 0;

  my $total_secs = 0;
  while (my ($unit, $defn) = each %UNITS ) {
    if ( exists($time_ref->{$unit}) && $time_ref->{$unit} ) {
      $total_secs += $time_ref->{$unit} * $defn->{to_secs};
    }
  }

  return $total_secs;
}
1;

__END__

=head1 SYNOPSIS

  package Class;
  use Moose;
  use MooseX::Types::Duration qw(Second);

  has 'expire_after' => ( is => 'ro', isa => Second );

  package main;
  Class->new( expire_after => '10m' );

=head1 DESCRIPTION

  This module lets you ....

=head1 EXPORT

None by default, you usually want to request C<Second> explicitly
