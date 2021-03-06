package Game;
use Data::Dumper;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless {
        initial_data => $args{initial_data},
        board        => {},
        remaining    => 9 * 9,
        debug        => $args{debug},
        debug_log    => $args{debug_log},
    }, $class;

    $self->process_initial_data();

    return $self;
}

sub process_initial_data {
    my $self = shift;

    my %possibles = map { $_, 1 } 1..9;

    foreach my $ancho (1..9){
        foreach my $alto (1..9){
            my $number = $self->{initial_data}->[$ancho-1][$alto-1];
            
            $self->set_value( $ancho,$alto,$number );
            $self->{board}->{$ancho}{$alto}{possibles} = { %possibles };
        }   
    }
}

sub set_value {
    my $self = shift;
    my ($ancho,$alto,$number) = @_;

    $self->{board}->{$ancho}{$alto}{number} = $number;
}

sub get_remaining {
    my $self = shift;
    return $self->{remaining};
}

sub update_remaining {
    my $self = shift;
    $self->{remaining} = $self->{remaining} - 1;
}

sub update_possibles {
    my $self = shift;
    my ($ancho,$alto,$number) = @_;

    # Eliminar posibles de la fila
    foreach my $alto_ (1..9){
        $self->set_possible($ancho,$alto_,$number,0);
    }

    # Eliminar posibles de la columna
    foreach my $ancho_ (1..9){
        $self->set_possible($ancho_,$alto,$number,0);
    }
}

sub set_possible {
    my $self = shift;
    my ($ancho,$alto,$number,$valor) = @_;

    $self->{board}->{$ancho}{$alto}{possibles}{$number} = $valor;
}

sub get_possibles {
    my $self = shift;
    my ($ancho,$alto) = @_;

    return $self->{board}->{$ancho}{$alto}{possibles};
}

sub is_possible {
    my $self = shift;
    my ($ancho,$alto,$number) = @_;

    return $self->{board}->{$ancho}{$alto}{possibles}{$number};
}

sub get_value {
    my $self = shift;
    my ($ancho,$alto) = @_;

    return $self->{board}{$ancho}{$alto}{number};
}

sub debug {
    my $self = shift;
    
    return unless $self->{debug};

    foreach my $alto (1..9){
        
        print $/ if ( ($alto-1) % 3 == 0 );
        print $/;

        foreach my $ancho (1..9){
            print ' ' if ( ($ancho-1) % 3 == 0 );
            print $self->{board}->{$ancho}{$alto}{number} . ' ';
        }
    
    }
    print "\n\n\n\n\n\n";
}

sub solved {
    my $self = shift;
    return $self->{remaining} == 0 ? 1 : 0;
}

sub solve {
    my $self = shift;

    $self->algorithm_1();

    $self->debug();

    return $self->solved();
}

sub algorithm_1 {
    my $self = shift;
    
    foreach my $ancho (1..9){
        foreach my $alto (1..9){
            $self->evaluate_possibles( $ancho, $alto );
        }
    }
    foreach my $ancho (1..9){
        foreach my $alto (1..9){
            $self->search_possibles( $ancho, $alto );
        }
    }   
}

sub evaluate_possibles {
    my $self = shift;
    my ($ancho_,$alto_) = @_;
    
    $self->set_default_possibles( $ancho_, $alto_ );
    
    # Recorro la columna
    $self->check_column( $ancho_ );
    
    # Recorro la fila
    $self->check_row( $alto_ );   

    # Recorro la zona
    $self->check_square( $ancho_, $alto_ );

    return;
}

sub set_default_possibles {
    my $self = shift;
    my ($ancho_,$alto_) = @_;
    
    if ( $self->get_value($ancho_,$alto_) != 0 ){
        map { $self->set_possible($ancho_,$alto_,$_,0) } 1..9;
        return 1;
    }

    return 0;
}

sub check_column {
    my $self = shift;
    my ($ancho_) = @_;

    foreach my $alto (1..9){
        my $valor = $self->get_value($ancho_,$alto);
        
        $self->debug_check( $ancho_, $alto, $valor );
        
        if ( $valor != 0 ){
            $self->set_possible($ancho_,$alto_,$valor,0);
        }
    }
}

sub check_row {
    my $self = shift;
    my ($alto_) = @_;

    foreach my $ancho (1..9){
        my $valor = $self->get_value($ancho,$alto_);
        
        $self->debug_check( $ancho, $alto_, $valor );

        if ( $valor != 0 ){
            $self->set_possible($ancho_,$alto_,$valor,0);
        }
    }
}

sub debug_check {
    my $self = shift;
    my ($ancho, $alto, $valor, $type) = @_;

    return unless $self->{debug_log};

    if( $type eq 'column' ){
        print "Evaluando columna en celda ($ancho,$alto) valor: $valor".$/; # Debug
    }

    if( $type eq 'row' ){
        print "Evaluando fila    en celda ($ancho,$alto) valor: $valor".$/; # Debug
    }

}

sub check_square {
    my $self = shift;
    my ($ancho_,$alto_) = @_;

    my $rangos = $self->get_square( $ancho_, $alto_ );
    my $rango_ancho = $rangos->{ancho};
    my $rango_alto  = $rangos->{alto};

    my $imposibles = $self->get_imposibles( $rango_ancho, $rango_alto );

    $self->set_imposibles( $rango_ancho, $rango_alto, $imposibles );
}

sub get_imposibles {
    my $self = shift;
    my ($rango_ancho, $rango_alto) = @_;

    my $imposibles = [];
    foreach my $ancho ( @$rango_ancho ) {
        foreach my $alto ( @$rango_alto ) {
            my $valor = $self->get_value( $ancho, $alto);
            push @$imposibles, $valor if $valor != 0;
        }
    }

    return $imposibles;
}

sub set_imposibles {
    my $self = shift;
    my ($rango_ancho, $rango_alto, $imposibles) = @_;

    return unless @$imposibles;

    foreach my $ancho ( @$rango_ancho ) {
        foreach my $alto ( @$rango_alto ) {
            foreach my $valor ( @$imposibles ) {
                $self->set_possible($ ancho, $alto, $valor, 0);
            }
        }
    }
}

sub get_square {
    my $self = shift;
    my ($ancho_,$alto_) = @_;
    
    return {
        ancho => $self->get_range($ancho_),
        alto  => $self->get_range($alto_),
    };

}

sub get_range {
    my $self = shift;
    my $value = shift;
    if($value < 4){
        return [1..3];
    }elsif($value < 7){
        return [4..6];
    }else{
        return [7..9];
    }
}

sub search_possibles { 
    my $self = shift;

    my ($ancho, $alto) = @_;
    
    my $possibles = $self->get_possibles_cell( $ancho, $alto );
    
    # Si hay un solo valor posible lo seteo en la celda
    if ( scalar @$possibles == 1 ){
        my $possible = $possibles->[0];
        $self->set_value( $ancho,$alto,$possible);
        $self->update_possibles( $ancho,$alto,$possible);
        $self->update_remaining();

        return 1;
    }

    return 0;
}

sub get_possibles_cell {
    my $self = shift;
    my ($ancho, $alto) = @_;

    my $possibles = [];
    for $number (1..9){
        if( $self->is_possible($ancho,$alto,$number) ){
            push @$possibles, $number;
        }
    }

    return $possibles;
}

sub get_initial_data {
    my $self = shift;
    return $self->{initial_data};
}

1;
