#!/usr/bin/perl
use Test::More tests => 50;
use Test::MockModule;

use strict;
use lib('../');

use Game;
use JSONParser;
use TestObjectFactory;

my $factory = TestObjectFactory->new( test_object => GetTestObject() );

RunTestCase();
done_testing();

sub RunTestCase {
    TestUseOk();
    TestNotSolvedGame();
    TestSolvedGame();
    TestRanges();
    TestSquares();
    TestCheckColumn();
    TestCheckRow();
    TestRemaining();
    TestEvaluatePossibles();
    TestGetPossiblesCell();
    TestSearchPossibles();
    TestAlgorithm1();
    TestRemaining();
    TestInitialData();
    TestProcessInitialData();
    TestGetValue();
    TestSetValue();
    TestUpdatePossibles();
    TestUpdateRemaining();
    TestSetPossible();
}

sub TestUseOk {
    use_ok('Game');
}

sub TestNotSolvedGame {
    my $game = $factory->get_object();
    is( $game->solve(), 0 );
}

sub TestSolvedGame {
    my $game = $factory->get_object();
    
    TODO: {
        local $TODO = 'test a solved game';
        is( $game->solve(), 0 );
    }
}

sub TestRanges {
    my $game = $factory->get_object();

    # get_range
    is_deeply( $game->get_range( 1 ), [1..3] );
    is_deeply( $game->get_range( 3 ), [1..3] );

    is_deeply( $game->get_range( 4 ), [4..6] );
    is_deeply( $game->get_range( 6 ), [4..6] );

    is_deeply( $game->get_range( 7 ), [7..9] );
    is_deeply( $game->get_range( 9 ), [7..9] );
}

sub TestSquares {
    my $game = $factory->get_object();

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
}

sub TestEvaluatePossibles {
    my $game = $factory->get_object();
    $game->evaluate_possibles();
}

sub TestGetPossiblesCell {
    my $game = $factory->get_object();

    {
        my $module = Test::MockModule->new('Game');
        $module->mock('is_possible', sub { 
            my ($self, $ancho, $alto, $number) = @_;
            return 0;
        });

        is_deeply( $game->get_possibles_cell(1,1), [], 'ok: no possibles' );
    }

    {
        my $module = Test::MockModule->new('Game');
        $module->mock('is_possible', sub { 
            my ($self, $ancho, $alto, $number) = @_;
            return $number == 1 ? 1 : 0;
        });

        is_deeply( $game->get_possibles_cell(1,1), [1], 'ok: one possible' );
    }

    {
        my $module = Test::MockModule->new('Game');
        $module->mock('is_possible', sub { 
            my ($self, $ancho, $alto, $number) = @_;
            return $number < 3 ? 1 : 0;
        });

        is_deeply( $game->get_possibles_cell(1,1), [1,2], 'ok: two possibles' );   
    }

}

sub TestSearchPossibles {
    my $game = $factory->get_object();
}

sub TestAlgorithm1 {
    my $game = $factory->get_object();
    is( $game->algorithm_1(), '' ); # FIXME
}

sub TestCheckColumn {
    my $game = $factory->get_object();
    is( $game->check_column(), '' ); # FIXME
}

sub TestCheckRow {
    my $game = $factory->get_object();
    is( $game->check_row(), '' ); # FIXME
}

sub TestRemaining {
    my $game = $factory->get_object();
    is( $game->get_remaining(), 81 );
}

sub TestInitialData {
    my $game = $factory->get_object();
    is_deeply( $game->get_initial_data(), get_initial_data(), 'data structures should be the same');
}

sub TestProcessInitialData {
    my $game = $factory->get_object();
    # process_initial_data
    TODO: {
        local $TODO = 'process_initial_data';
        is( $game->process_initial_data(), '' );
    }
}

sub TestGetValue {
    my $game = $factory->get_object();

    # get_value
    is( $game->get_value(1,1), 1 );
    is( $game->get_value(9,9), 0 );
}

sub TestSetValue {
    my $game = $factory->get_object();

    # set_value
    $game->set_value(1,1,9);
    is( $game->get_value(1,1), 9 );
}

sub TestUpdatePossibles {
    my $game = $factory->get_object();

    # update_possibles
    $game->update_possibles(1,1,9);

    foreach my $ancho (1..9){
        is( $game->is_possible($ancho,1,9), 0 );
    }

    foreach my $alto (1..9){
        is( $game->is_possible(1,$alto,9), 0 );
    }
}

sub TestUpdateRemaining {
    my $game = $factory->get_object();

    # update_remaining # FIXME
    $game->set_value(1,1,1);
    is( $game->get_value(1,1), 1 );
    $game->update_remaining();
    is( $game->get_remaining(), 80 );
}

sub TestSetPossible {
    my $game = $factory->get_object();

    # set_possible
    $game->set_possible(5,5,5,0);
    is( $game->is_possible(5,5,5), 0 );

    $game->set_possible(5,5,5,1);
    is( $game->is_possible(5,5,5), 1 );
}

# auxiliar functions
sub GetTestObject {
    my $initial_data = get_initial_data();
    my $game = Game->new( initial_data => $initial_data );
    return $game;
}

sub get_initial_data {
    my $parser = JSONParser->new(filename => '000.json');
    return $parser->get_data();
}
