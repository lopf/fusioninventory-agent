package FusionInventory::Test::Inventory;

use strict;
use warnings;
use base qw(FusionInventory::Agent::Inventory);

use FusionInventory::Agent::Logger;

sub new {
    my ($class, %params) = @_;

    my $logger  = FusionInventory::Agent::Logger->new(
        backends  => [ 'fatal' ],
        verbosity => 'debug'
    );

    return $class->SUPER::new(logger => $logger);
}

1;
