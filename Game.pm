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
    
    if ( $self->get_value($ancho_,$alto_) != 0 ){
        map { $self->set_possible($ancho_,$alto_,$_,0) } 1..9;
        return; 
    }
    
    # Recorro la columna
    $self->check_column( $ancho_ );
    
    # Recorro la fila
    $self->check_row( $alto_ );   

    # Recorro la zona
    $self->check_square( $ancho_, $alto_ );

}

sub check_column {
    my $self = shift;
    my ($alto_) = @_;

    foreach my $alto (1..9){
        my $valor = $self->get_value($ancho_,$alto);
        if( $self->{debug_log} ){
            print "$ancho_-$alto_: evaluando columna en celda ($ancho_,$alto) valor: $valor".$/; # Debug
        }
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
        if( $self->{debug_log} ){
            print "$ancho_-$alto_: evaluando fila    en celda ($ancho,$alto_) valor: $valor".$/; # Debug
        }
        if ( $valor != 0 ){
            $self->set_possible($ancho_,$alto_,$valor,0);
        }
    }
}

sub check_square {
    my $self = shift;
    my ($ancho_,$alto_) = @_;

    my $rangos = $self->get_square( $ancho_, $alto_ );
    my $imposibles = {};
    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            $imposibles->{ $self->get_value($ancho,$alto) } = 1;
        }
    }

    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            foreach my $valor (1..9) {
                $self->set_possible($ancho,$alto,$valor,0) if exists $imposibles->{$valor};
            }
        }
    }
}

sub get_square {
    my $self = shift;
    my ($ancho_,$alto_) = @_;
    return [ $self->get_range($ancho_), $self->get_range($alto_) ];
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
    
    my @possibles = ();
    for $number (1..9){
        if( $self->is_possible($ancho,$alto,$number) ){
            push @possibles, $number;
        }
    }

    # Si hay un solo valor posible lo seteo en la celda
    if ( scalar @possibles == 1 ){
        my $possible = $possibles[0];
        $self->set_value( $ancho,$alto,$possible);
        $self->update_possibles( $ancho,$alto,$possible);
        $self->update_remaining();
    }
} 

sub get_initial_data {
    my $self = shift;
    return $self->{initial_data};
}

1;
