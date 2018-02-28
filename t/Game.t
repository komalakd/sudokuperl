#!/usr/bin/perl
use Test::More tests => 17;

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

# get_range
is_deeply( $game->get_range( 1 ), [1..3] );
is_deeply( $game->get_range( 3 ), [1..3] );

is_deeply( $game->get_range( 4 ), [4..6] );
is_deeply( $game->get_range( 6 ), [4..6] );

is_deeply( $game->get_range( 7 ), [7..9] );
is_deeply( $game->get_range( 9 ), [7..9] );

# get_square
my $square = $game->get_square(1,1);
is_deeply( $square->[0], [1..3] );
is_deeply( $square->[1], [1..3] );

my $square = $game->get_square(4,4);
is_deeply( $square->[0], [4..6] );
is_deeply( $square->[1], [4..6] );

my $square = $game->get_square(7,7);
is_deeply( $square->[0], [7..9] );
is_deeply( $square->[1], [7..9] );

#evaluate_possibles


#search_possibles


#algorithm_1


done_testing();
