#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use FusionInventory::Agent::Task::Inventory::Input::Linux::Drives;

my %hal_tests = (
    'dell-xt2' => [
        {
            VOLUME => '/dev/',
            TOTAL  => 44814
        },
        {
            VOLUME     => '/dev/sda7',
            TOTAL      => 44814,
            SERIAL     => 'f75b1fa9-1109-46b4-abde-541af44ed8cd',
            FILESYSTEM => 'crypto_LUKS'
        },
        {
            VOLUME     => '/dev/sda6',
            TOTAL      => 3993,
            SERIAL     => '3aebfe11-8dba-4c61-87b1-10f391dba4fc',
            LABEL      => 'swap',
            FILESYSTEM => 'swap'
        },
        {
            VOLUME => '/dev/sda4',
            TOTAL  => 0
        },
        {
            VOLUME     => '/dev/sda5',
            TOTAL      => 12300,
            SERIAL     => '7a20e641-ec5f-41ff-8c7b-2056b18cae80',
            LABEL      => 'root',
            FILESYSTEM => 'ext4'
        },
        {
            VOLUME     => '/dev/sda3',
            TOTAL      => 60003,
            SERIAL     => '5A60194E6019326D',
            LABEL      => 'OS',
            FILESYSTEM => 'ntfs-3g'
        },
        {
            VOLUME     => '/dev/sda2',
            TOTAL      => 750,
            SERIAL     => 'CCE616B2E6169CB0',
            LABEL      => 'RECOVERY',
            FILESYSTEM => 'ntfs-3g'
        },
        {
            VOLUME     => '/dev/sda1',
            TOTAL      => 243,
            SERIAL     => '07DA-0305',
            LABEL      => 'DellUtility',
            FILESYSTEM => 'vfat'
        }
    ],
    'rh4-kvm' => [
        {
            VOLUME     => '/dev/hda1',
            TOTAL      => 102,
            LABEL      => '/boot',
            SERIAL     => 'a946b73c-79a1-4498-a5f4-ae241426954f',
            FILESYSTEM => 'ext3'
        },
        {
            VOLUME     => '/dev/hda2',
            TOTAL      => 10135,
            FILESYSTEM => 'LVM2_member'
        },
    ]
);

plan tests => scalar keys %hal_tests;

foreach my $test (keys %hal_tests) {
    my $file = "resources/linux/hal/$test";
    my $results = FusionInventory::Agent::Task::Inventory::Input::Linux::Drives::_parseLshal(file => $file);
    is_deeply($results, $hal_tests{$test}, $test);
}
