#!/usr/bin/perl
use strict;
use Data::Dumper;
use Game;

# Ojo! El tablero esta inverso en esta representacion.
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
my $solved = $game->solve();
