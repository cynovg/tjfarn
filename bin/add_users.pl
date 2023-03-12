#!/usr/bin/env perl
use utf8;
use v5.30;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/../lib/";

use TJFARN::Process qw(add_user);

sub main {
	my (@ARGV) = @_;

	add_user($_) for qw/any beny raba/;
}

main(@ARGV);