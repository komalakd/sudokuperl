#!/usr/bin/perl
use strict;
use Data::Dumper;
use Game;
use JSONParser;

my $parser = JSONParser->new(filename => '001.json');
my $initial_data = $parser->get_data();

my $game = Game->new( initial_data => $initial_data, debug_log => 1, debug => 1 );
my $solved = $game->solve();
