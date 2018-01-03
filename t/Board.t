#!/usr/bin/perl
use Test::More tests => 31;

use strict;
use lib('../');

use JSONParser;

use_ok('Board');
require_ok('Board');

my $parser = JSONParser->new(filename => '000.json');
my $initial_data = $parser->get_data();

# new
my $board = Board->new( initial_data => $initial_data );

is( $board->get_remaining(), 81 );

is_deeply( $board->{initial_data}, $initial_data, 'data structures should be the same');

# get_value
is( $board->get_value(1,1), 1 );
is( $board->get_value(9,9), 0 );

# set_value
$board->set_value(1,1,9);
is( $board->get_value(1,1), 9 );

# update_possibles
$board->update_possibles(1,1,9);

foreach my $ancho (1..9){
    is( $board->is_possible($ancho,1,9), 0 );
}

foreach my $alto (1..9){
    is( $board->is_possible(1,$alto,9), 0 );
}

# update_remaining # FIXME
$board->set_value(1,1,1);
is( $board->get_value(1,1), 1 );
$board->update_remaining();
is( $board->get_remaining(), 80 );

# set_possible
$board->set_possible(5,5,5,0);
is( $board->is_possible(5,5,5), 0 );

$board->set_possible(5,5,5,1);
is( $board->is_possible(5,5,5), 1 );

is( $board->solved(), 0 );
TODO: {
    local $TODO = 'test a solved game';
    is( $board->solved(), 0 );
}

done_testing();