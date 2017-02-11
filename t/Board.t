#!/usr/bin/perl
use Test::More qw/no_plan/;

use strict;
use lib('../');

use_ok('Board');
require_ok('Board');

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

my $board = Board->new( initial_data => $initial_data );
TODO: {
	local $TODO = 'fixme remaining';
	is( $board->{remaining}, 89 );
}
is_deeply( $board->{initial_data}, $initial_data, 'data structures should be the same');

is( $board->get_value(1,1), 1 );
is( $board->get_value(9,9), 0 );
is( $board->get_value(9,9), 0 );

$board->set_value(1,1,9);
is( $board->get_value(1,1), 9 );
$board->set_value(1,1,1);



# done_testing();