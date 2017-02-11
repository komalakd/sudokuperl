#!/usr/bin/perl
use Test::More qw/no_plan/;

use strict;
use lib('../');

use_ok('Game');
require_ok('Game');

#use Game;

# my $initial_data = [];
# isnt( Game->new( $initial_data ), 1 );

my $initial_data = [
    [1,2,3,4,5,6,7,8,0],
    [2,0,0,0,0,0,0,0,0],
    [3,0,0,0,0,0,0,0,0],
    [4,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [6,0,0,0,0,0,0,0,0],
    [7,0,0,0,0,0,0,0,0],
    [8,0,0,0,0,0,0,0,0],
    [9,0,0,0,0,0,0,0,0],
];
my $game = Game->new( initial_data => $initial_data );
#isnt( $game, undef );

is( $game->solve(), 1 );

SKIP: {
	local $TODO = 'i need to test this...';
	ok( Game->new( $initial_data ) );
}

 #done_testing();