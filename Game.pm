package Game;
use Board;
use Data::Dumper;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless {
        initial_data => $args{initial_data},
        board        => Board->new( initial_data => $args{initial_data} ),
        debug        => $args{debug},
        debug_log   => $args{debug_log},
    }, $class;

    return $self;
}

sub board {
    my $self = shift;
    return $self->{board};
}

sub solve {
    my $self = shift;

    $self->algorithm_1();

    $self->board()->debug();

    return $self->board()->solved();
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
    
    if ( $self->board()->get_value($ancho_,$alto_) != 0 ){
        map { $self->board()->{board}->{$ancho_}{$alto_}{possibles}{$_} = 0 } 1..9;
        return; 
    }
    # Recorro la columna
    foreach my $alto (1..9){
        my $valor = $self->board()->get_value($ancho_,$alto);
        if( $self->{debug_log} ){
            print "$ancho_-$alto_: evaluando columna en celda ($ancho_,$alto) valor: $valor".$/; # Debug
        }
        if ( $valor != 0 ){
            $self->board()->{board}->{$ancho_}{$alto_}{possibles}{$valor} = 0;
        }
    }
    # Recorro la fila
    foreach my $ancho (1..9){
        my $valor = $self->board()->get_value($ancho,$alto_);
        if( $self->{debug_log} ){
            print "$ancho_-$alto_: evaluando fila    en celda ($ancho,$alto_) valor: $valor".$/; # Debug
        }
        if ( $valor != 0 ){
            $self->board()->{board}->{$ancho_}{$alto_}{possibles}{$valor} = 0;
        }
    }

    # Recorro la zona
    my $rangos = get_square( $ancho_, $alto_ );
    my $imposibles = {};
    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            $imposibles->{ $self->board()->get_value($ancho,$alto) } = 1;
        }
    }

    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            foreach my $valor (1..9) {
                $self->board()->{board}->{$ancho}{$alto}{possibles}{$valor} = 0 if exists $imposibles->{$valor};
            }
        }
    }

}

sub get_square {
    my ($ancho_,$alto_) = @_;
    return [ get_range($ancho_), get_range($alto_) ];
}

sub get_range {
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
        if( $self->board()->{board}->{$ancho}{$alto}{possibles}{$number} == 1 ){
            push @possibles, $number;
        }
    }

    # Si hay un solo valor posible lo seteo en la celda
    if ( scalar @possibles == 1 ){
        my $possible = $possibles[0];
        $self->board()->set_value( $ancho,$alto,$possible);
        $self->board()->update_possibles( $ancho,$alto,$possible);
        $self->board()->update_remaining();
    }
}

sub debug {
    my $self = shift;
    $self->board()->debug();
} 

1;