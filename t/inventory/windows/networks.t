#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use lib 't';

use English qw(-no_match_vars);
use Test::More;
use Test::MockModule;

use FusionInventory::Test::Utils;

BEGIN {
    # use mock modules for non-available ones
    push @INC, 't/fake/windows' if $OSNAME ne 'MSWin32';
}

use FusionInventory::Agent::Task::Inventory::Input::Win32::Networks;

my %tests = (
    7 => [
        {
            'dns'       => '192.168.0.254',
            IPMASK6     => [ '64' ],
            IPMASK      => [ '255.255.255.0' ],
            IPGATEWAY   => '192.168.0.254',
            MACADDR     => 'F4:6D:04:97:2D:3E',
            STATUS      => 'Up',
            IPADDRESS6  => [ 'fe80::311a:2127:dded:6618' ],
            IPDHCP      => '192.168.0.254',
            IPSUBNET    => [ '192.168.0.0' ],
            MTU         => undef,
            IPSUBNET6   => [],
            DESCRIPTION => 'Realtek PCIe GBE Family Controller',
            IPADDRESS   => [ '192.168.0.1' ],
            VIRTUALDEV  => 0,
            SPEED       => 100000000,
            PNPDEVICEID => 'PCI\VEN_10EC&DEV_8168&SUBSYS_84321043&REV_06\4&87D54EE&0&00E5',
            TYPE        => 'Ethernet'
        },
        {
            MTU         => undef,
            MACADDR     => '00:26:83:12:FB:0B',
            STATUS      => 'Up',
            DESCRIPTION => "Périphérique Bluetooth (réseau personnel)",
            IPDHCP      => undef,
            VIRTUALDEV  => 0,
            PNPDEVICEID => 'BTH\MS_BTHPAN\7&42D85A8&0&2',
            TYPE        => 'Ethernet',
            SPEED       => 0
        },
    ],
    xp => [
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\MS_PPTPMINIPORT\\0000',
            MACADDR     => '50:50:54:50:30:30',
            STATUS      => 'Up',
            TYPE        => "Red de \x{e1}rea extensa (WAN)",
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Minipuerto WAN (PPTP)'
        },
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\MS_PPPOEMINIPORT\\0000',
            MACADDR     => '33:50:6F:45:30:30',
            STATUS      => 'Up',
            TYPE        => "Red de \x{e1}rea extensa (WAN)",
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Minipuerto WAN (PPPOE)'
        },
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\MS_PSCHEDMP\\0000',
            MACADDR     => '26:0F:20:52:41:53',
            STATUS      => 'Up',
            TYPE        => 'Ethernet',
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Minipuerto del administrador de paquetes'
        },
        {
            dns         => '10.36.6.200',
            IPMASK      => [ '255.255.254.0' ],
            IPGATEWAY   => '10.36.6.1',
            MACADDR     => '00:14:C2:0D:B0:FB',
            STATUS      => 'Up',
            IPDHCP      => '10.36.6.200',
            IPSUBNET    => [ '10.36.6.0' ],
            MTU         => undef,
            DESCRIPTION => 'Broadcom NetXtreme Gigabit Ethernet - Teefer2 Miniport',
            'IPADDRESS' => [ '10.36.6.30' ]
        },
        {
            dns         => '10.36.6.100',
            IPMASK      => [ '255.255.254.0' ],
            IPGATEWAY   => '10.36.6.1',
            VIRTUALDEV  => 0,
            PNPDEVICEID => 'PCI\\VEN_14E4&DEV_1677&SUBSYS_3006103C&REV_01\\4&1886B119&0&00E1',
            MACADDR     => '00:14:C2:0D:B0:FB',
            STATUS      => 'Up',
            TYPE        => 'Ethernet',
            SPEED       => undef,
            IPDHCP      => '10.36.6.100',
            IPSUBNET    => [ '10.36.6.0' ],
            MTU         => undef,
            DESCRIPTION => 'Broadcom NetXtreme Gigabit Ethernet - Teefer2 Miniport',
            'IPADDRESS' => [ '10.36.6.30' ]
        },
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\MS_PSCHEDMP\\0002',
            MACADDR     => '00:14:C2:0D:B0:FB',
            STATUS      => 'Up',
            TYPE        => 'Ethernet',
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Minipuerto del administrador de paquetes'
        },
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\SYMC_TEEFER2MP\\0000',
            MACADDR     => '00:14:C2:0D:B0:FB',
            STATUS      => 'Up',
            TYPE        => 'Ethernet',
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Teefer2 Miniport'
        },
        {
            VIRTUALDEV  => 1,
            PNPDEVICEID => 'ROOT\\SYMC_TEEFER2MP\\0002',
            MACADDR     => '26:0F:20:52:41:53',
            STATUS      => 'Up',
            TYPE        => 'Ethernet',
            SPEED       => undef,
            IPDHCP      => undef,
            MTU         => undef,
            DESCRIPTION => 'Teefer2 Miniport'
        }
    ]
);

plan tests => scalar keys %tests;

my $module = Test::MockModule->new(
    'FusionInventory::Agent::Task::Inventory::Input::Win32::Networks'
);

foreach my $test (keys %tests) {
    $module->mock(
        'getWmiObjects',
        mockGetWmiObjects($test)
    );

    my @interfaces = FusionInventory::Agent::Task::Inventory::Input::Win32::Networks::_getInterfaces();
    is_deeply(
        \@interfaces,
        $tests{$test},
        "$test sample"
    );
}