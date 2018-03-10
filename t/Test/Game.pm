package Test::Game;
use base qw(Test::Class);

use Test::More;
use Test::MockModule;

use strict;
use lib('../');

use Game;
use JSONParser;
use TestObjectFactory;



#RunTestCase();
#done_testing();

sub make_fixture : Test(setup) {
    my $self = shift;
    my $factory = TestObjectFactory->new( test_object => GetTestObject() );
    $self->{factory} = $factory;
}

sub get_test_instance {
    my $self = shift;
    return $self->{factory}->get_object();
}

sub TestUseOk : Test {
    use_ok('Game');
}

sub TestNotSolvedGame : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->solve(), 0 );
}

sub TestSolvedGame : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    
#    TODO: {
#        local $TODO = 'test a solved game';
#        is( $game->solve(), 0 );
#    }
}

sub TestRanges : Test( 6 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

    # get_range
    is_deeply( $game->get_range( 1 ), [1..3] );
    is_deeply( $game->get_range( 3 ), [1..3] );

    is_deeply( $game->get_range( 4 ), [4..6] );
    is_deeply( $game->get_range( 6 ), [4..6] );

    is_deeply( $game->get_range( 7 ), [7..9] );
    is_deeply( $game->get_range( 9 ), [7..9] );
}

sub TestSquares : Test( 6 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

    # get_square
    my $square = $game->get_square(1,1);
    is_deeply( $square->{ancho}, [1..3] );
    is_deeply( $square->{alto} , [1..3] );

    my $square = $game->get_square(4,4);
    is_deeply( $square->{ancho}, [4..6] );
    is_deeply( $square->{alto} , [4..6] );

    my $square = $game->get_square(7,7);
    is_deeply( $square->{ancho}, [7..9] );
    is_deeply( $square->{alto} , [7..9] );
}

sub TestEvaluatePossibles : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    $game->evaluate_possibles();
}

sub TestGetPossiblesCell : Test( 3 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

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

sub TestSearchPossibles : Test( 3 ) {
    my $self = shift;

    {
        my $game = $self->get_test_instance();
        my $module = Test::MockModule->new('Game');
        $module->mock('get_possibles_cell', sub { return []; });

        is( $game->search_possibles, 0, 'ok: no possibles' );
    }

    {
        my $game = $self->get_test_instance();
        my $module = Test::MockModule->new('Game');
        $module->mock('get_possibles_cell', sub { return [1]; });

        is( $game->search_possibles, 1, 'ok: one possible' );
    }

    {
        my $game = $self->get_test_instance();
        my $module = Test::MockModule->new('Game');
        $module->mock('get_possibles_cell', sub { return [1,2]; });

        is( $game->search_possibles, 0, 'ok: two possibles' );
    }

}

sub TestSetDefaultPossibles : Test( 2 ) {
    my $self = shift;

    {
        my $game = $self->get_test_instance();
        my $module = Test::MockModule->new('Game');
        $module->mock('get_value', sub { return 0; });

        is( $game->set_default_possibles(), 0, 'ok: do not update possibles' );
    }

    {
        my $game = $self->get_test_instance();
        my $module = Test::MockModule->new('Game');
        $module->mock('get_value', sub { return 1; });

        is( $game->set_default_possibles(), 1, 'ok: update possibles' );
    }
}
    

sub TestAlgorithm1 : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->algorithm_1(), '' ); # FIXME
}

sub TestCheckColumn : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->check_column(), '' ); # FIXME
}

sub TestCheckRow : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->check_row(), '' ); # FIXME
}

sub TestCheckSquare : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->check_square(), '' ); # FIXME
}

sub TestRemaining : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is( $game->get_remaining(), 81 );
}

sub TestInitialData : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    is_deeply( $game->get_initial_data(), get_initial_data(), 'data structures should be the same');
}

sub TestProcessInitialData : Test {
    my $self = shift;
    my $game = $self->get_test_instance();
    
#    TODO: {
#        local $TODO = 'process_initial_data';
#        is( $game->process_initial_data(), '' );
#    }
}

sub TestGetValue : Test( 2 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

    # get_value
    is( $game->get_value(1,1), 1 );
    is( $game->get_value(9,9), 0 );
}

sub TestSetValue : Test {
    my $self = shift;
    my $game = $self->get_test_instance();

    # set_value
    $game->set_value(1,1,9);
    is( $game->get_value(1,1), 9 );
}

sub TestUpdatePossibles : Test( 18 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

    # update_possibles
    $game->update_possibles(1,1,9);

    foreach my $ancho (1..9){
        is( $game->is_possible($ancho,1,9), 0 );
    }

    foreach my $alto (1..9){
        is( $game->is_possible(1,$alto,9), 0 );
    }
}

sub TestUpdateRemaining : Test( 2 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

    # update_remaining # FIXME
    $game->set_value(1,1,1);
    is( $game->get_value(1,1), 1 );
    $game->update_remaining();
    is( $game->get_remaining(), 80 );
}

sub TestSetPossible : Test( 2 ) {
    my $self = shift;
    my $game = $self->get_test_instance();

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

1;