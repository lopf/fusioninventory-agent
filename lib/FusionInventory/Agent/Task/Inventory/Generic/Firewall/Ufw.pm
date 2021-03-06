package FusionInventory::Agent::Task::Inventory::Generic::Firewall::Ufw;

use strict;
use warnings;

use parent 'FusionInventory::Agent::Task::Inventory::Module';

use FusionInventory::Agent::Tools::Constants;
use FusionInventory::Agent::Tools;

sub isEnabled {
    my (%params) = @_;
    return
        # Ubuntu
        canRun('ufw');
}

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    my $firewallStatus = _getFirewallStatus(
        logger => $logger
    );
    $inventory->addEntry(
        section => 'FIREWALL',
        entry   => {
            STATUS => $firewallStatus
        }
    );

}

sub _getFirewallStatus {
    my (%params) = @_;

    my $status = getFirstMatch(
        command => 'ufw status',
        pattern => qr/^Status:\s*(\w+)$/,
        %params
    );
    if ($status && $status eq 'active') {
        $status = STATUS_ON;
    } else {
        $status = STATUS_OFF;
    }

    return $status;
}

1;
