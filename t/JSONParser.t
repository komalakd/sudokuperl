#!/usr/bin/perl
use Test::More tests => 8;
use Test::Exception;
use Data::Dumper;

use strict;
use lib('../');

use_ok('JSONParser');
require_ok('JSONParser');

my $parser = JSONParser->new(filename => 'nofile.json');
dies_ok { $parser->get_data() } 'ok: no file.';

my $parser = JSONParser->new(filename => 'nojson.json');
dies_ok { $parser->get_data() } 'ok: no json file.';

my $parser = JSONParser->new(filename => '000.json');
my $initial_data;
lives_ok { $initial_data = $parser->get_data() } 'ok: json file.';

is( $initial_data->[0][0], 1, 'ok: non-empty square' );
is( $initial_data->[8][8], 0, 'ok: empty square' );
is( $initial_data->[9][9], undef, 'ok: out of range' );

done_testing();
