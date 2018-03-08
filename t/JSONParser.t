#!/usr/bin/perl
use strict;
use lib('../');

use Test::More tests => 7;
use Test::Exception;
use Data::Dumper;

use TestObjectFactory;
use JSONParser;

my $factory = TestObjectFactory->new( test_object => GetTestObject() );

RunTestCases();
done_testing();

sub RunTestCases {
	TestUseOk();
	TestNoFile();
	TestNoJsonFile();
	TestJsonFile();
	TestNonEmptySquare();
	TestEmptySquare();
	TestOutOfRange();	
}

sub TestUseOk {
	use_ok('JSONParser');
}

sub TestNoFile {
	my $parser = JSONParser->new(filename => 'nofile.json');
	dies_ok { $parser->get_data() } 'ok: no file.';
}

sub TestNoJsonFile {
	my $parser = JSONParser->new(filename => 'nojson.json');
	dies_ok { $parser->get_data() } 'ok: no json file.';
}

sub TestJsonFile {
	my $parser = JSONParser->new(filename => '000.json');
	my $initial_data;
	lives_ok { $initial_data = $parser->get_data() } 'ok: json file.';
}

sub TestNonEmptySquare {
	my $initial_data = $factory->get_object();
	is( $initial_data->[0][0], 1, 'ok: non-empty square' );
}

sub TestEmptySquare {
	my $initial_data = $factory->get_object();
	is( $initial_data->[8][8], 0, 'ok: empty square' );
}

sub TestOutOfRange {
	my $initial_data = $factory->get_object();
	is( $initial_data->[9][9], undef, 'ok: out of range' );
}

sub GetTestObject {
	my $parser = JSONParser->new(filename => '000.json');
	return $parser->get_data();	
}
