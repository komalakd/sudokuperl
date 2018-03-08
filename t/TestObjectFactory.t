#!/usr/bin/perl
use strict;
use lib('../');

use Test::More tests => 11;
use Test::Exception;
use Data::Dumper;

use TestObjectFactory;
use JSONParser;

RunTestCases();
done_testing();

sub RunTestCases {
	TestUseOk();
	TestNewNoRef();
	TestNewArrayref();
	TestNewHashref();
	TestNewBlessedref();
}

sub TestUseOk {
	use_ok('TestObjectFactory');
}

sub TestNewNoRef {
	dies_ok { TestObjectFactory->new( test_object => undef ) } 'Dies ok: no reference.';
}

sub TestNewArrayref {
	my $arrayref = [qw/a b c/];
	my $factory = TestObjectFactory->new( test_object => $arrayref );

	is( ref $factory->get_object(), 'ARRAY', 'Test Object is an arrayref' );
	isnt( $factory->get_object(), $arrayref, 'Arrayref is not the same' );
	is_deeply( $arrayref, $factory->get_object(), 'Refs deeply identicals' );
}

sub TestNewHashref {
	my $hashref = { a => 1, b => 2 };
	my $factory = TestObjectFactory->new( test_object => $hashref );

	is( ref $factory->get_object(), 'HASH', 'Test Object is an arrayref' );
	isnt( $factory->get_object(), $hashref, 'Hashref is not the same' );
	is_deeply( $hashref, $factory->get_object(), 'Refs deeply identicals' );
}

sub TestNewBlessedref {
	my $hashref = { a => 1, b => 2 };
	my $bless_name = 'Sarasa';
	my $blessedref = bless $hashref, $bless_name;
	my $factory = TestObjectFactory->new( test_object => $blessedref );

	is( ref $factory->get_object(), $bless_name, 'Test Object is a blessedref' );
	isnt( $factory->get_object(), $blessedref, 'Blessedref is not the same' );
	is_deeply( $blessedref, $factory->get_object(), 'Refs deeply identicals' );
}