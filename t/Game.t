#!/usr/bin/perl
use Test::More tests => 46;

use strict;
use lib('../');

use MockFactory qw(
    Board
);

use JSONParser;
use TestObjectFactory;

use_ok('Game');
require_ok('Game');


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











my $game = $factory->get_object();

is( $game->get_remaining(), 81 );

is_deeply( $game->get_initial_data(), get_initial_data(), 'data structures should be the same');

# process_initial_data
TODO: {
    local $TODO = 'process_initial_data';
    is( $game->process_initial_data(), '???' );
}


my $game = $factory->get_object();

# get_value
is( $game->get_value(1,1), 1 );
is( $game->get_value(9,9), 0 );


my $game = $factory->get_object();

# set_value
$game->set_value(1,1,9);
is( $game->get_value(1,1), 9 );

my $game = $factory->get_object();

# update_possibles
$game->update_possibles(1,1,9);

foreach my $ancho (1..9){
    is( $game->is_possible($ancho,1,9), 0 );
}

foreach my $alto (1..9){
    is( $game->is_possible(1,$alto,9), 0 );
}

my $game = $factory->get_object();

# update_remaining # FIXME
$game->set_value(1,1,1);
is( $game->get_value(1,1), 1 );
$game->update_remaining();
is( $game->get_remaining(), 80 );

my $game = $factory->get_object();

# set_possible
$game->set_possible(5,5,5,0);
is( $game->is_possible(5,5,5), 0 );

$game->set_possible(5,5,5,1);
is( $game->is_possible(5,5,5), 1 );

my $game = $factory->get_object();

is( $game->solved(), 0 );





done_testing();

sub get_object {
    my $parser = JSONParser->new(filename => '000.json');
    my $initial_data = $parser->get_data();

    my $game = Game->new( initial_data => $initial_data );
    return $game;
}

sub get_initial_data {
    my $parser = JSONParser->new(filename => '000.json');
    return $parser->get_data();
}