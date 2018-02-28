#!/usr/bin/perl
use Test::More tests => 17;

use strict;
use lib('../');

use JSONParser;
use TestObjectFactory;

use_ok('Game');
require_ok('Game');

my $factory = TestObjectFactory->new( test_object => get_object() );

my $game = $factory->get_object();


SKIP: {
    local $TODO = 'i need to test this...';
    ok( $game );
}

is( $game->solve(), 0 );

TODO: {
    local $TODO = 'test a solved game';
    is( $game->solve(), 0 );
}

my $game = $factory->get_object();

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
my $game = $factory->get_object();


#search_possibles
my $game = $factory->get_object();



#algorithm_1
my $game = $factory->get_object();



done_testing();

sub get_object {
    my $parser = JSONParser->new(filename => '000.json');
    my $initial_data = $parser->get_data();

    my $game = Game->new( initial_data => $initial_data );
    return $game;
}