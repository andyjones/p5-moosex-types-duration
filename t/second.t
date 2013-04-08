use Test::Most;
use Scalar::Util;

{
  package Class;
  use Moose;
  use MooseX::Types::Duration qw(Seconds);

  has 'in_secs' => ( is => 'ro', isa => Seconds, coerce => 1 );
};

my %tests = (
  50          => 50,
  '50s'       => 50,
  '1m'        => 60,
  '1 min'     => 60,
  '1 minute'  => 60,
  '2 minutes' => 2*60,
  '1m 1s'     => 61,
  '1h'        => 60*60,
  '2h'        => 2*60*60,
  '1d'        => 24*60*60,
  '1 minute 0 second' => 60,
);

plan tests => scalar(keys %tests);

while ( my ($input, $expected) = each %tests ) {
  my $label = Scalar::Util::looks_like_number($input) ? "$input (Number)" : $input;
  is( Class->new( in_secs => $input )->in_secs, $expected, $label);
}
