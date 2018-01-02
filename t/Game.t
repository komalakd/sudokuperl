#!/usr/bin/perl
use Test::More tests => 5;

use strict;
use lib('../');

use JSONParser;

use_ok('Game');
require_ok('Game');

my $parser = JSONParser->new(filename => '000.json');
my $initial_data = $parser->get_data();

my $game = Game->new( initial_data => $initial_data );

SKIP: {
	local $TODO = 'i need to test this...';
	ok( Game->new( $initial_data ) );
}

is( $game->solve(), 0 );

TODO: {
    local $TODO = 'test a solved game';
    is( $game->solve(), 0 );
}

done_testing();
