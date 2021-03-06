
use Test::More;
use JSONParser;

use strict;
use Data::Dumper;

my $tablero = {};
my $parser = JSONParser->new(filename => '001.json');
my $datos_iniciales = $parser->get_data();

foreach my $ancho (1..9){
    foreach my $alto (1..9){
        $tablero->{$ancho}{$alto}{numero} = $datos_iniciales->[$ancho-1][$alto-1];
        $tablero->{$ancho}{$alto}{posibles} = posibles_default();
    }   
}
for(1..100){
    algoritmo1();
}

print debug_tablero();

# print Dumper $tablero;

exit 0;


sub posibles_default {
    my $hash = {};
    foreach my $key (1..9){
        $hash->{$key} = 1;
    }
    return $hash;

    my %hash = map { { $_ => 1 } } 1..9;
    return \%hash;

}


sub algoritmo1 {
    foreach my $ancho (1..9){
        foreach my $alto (1..9){
            calcular_posibles( $ancho, $alto );
        }
    }
    foreach my $ancho (1..9){
        foreach my $alto (1..9){
            busco_posibles( $ancho, $alto );
        }
    }
}


sub calcular_posibles {
    my ($ancho_,$alto_) = @_;
    if ( $tablero->{$ancho_}{$alto_}{numero} != 0 ){
        map { $tablero->{$ancho_}{$alto_}{posibles}{$_} = 0 } 1..9;
        return; 
    }
    # Recorro la columna
    foreach my $alto (1..9){
        my $valor = $tablero->{$ancho_}{$alto}{numero};
        # print "$ancho_-$alto_: evaluando columna en celda ($ancho_,$alto) valor: $valor".$/; # Debug
        if ( $valor != 0 ){
            $tablero->{$ancho_}{$alto_}{posibles}{$valor} = 0;
        }
    }
    # Recorro la fila
    foreach my $ancho (1..9){
        my $valor = $tablero->{$ancho}{$alto_}{numero};
        # print "$ancho_-$alto_: evaluando fila    en celda ($ancho,$alto_) valor: $valor".$/; # Debug
        if ( $valor != 0 ){
            $tablero->{$ancho_}{$alto_}{posibles}{$valor} = 0;
        }
    }

    # Recorro la zona
    my $rangos = get_square( $ancho_, $alto_ );
    my $imposibles = {};
    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            $imposibles->{ $tablero->{$ancho}{$alto}{numero} } = 1;
        }
    }

    foreach my $ancho ( @{$rangos->[0]} ) {
        foreach my $alto ( @{$rangos->[1]} ) {
            foreach my $valor (1..9) {
                $tablero->{$ancho}{$alto}{posibles}{$valor} = 0 if exists $imposibles->{$valor};
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

sub busco_posibles{ 
    my ($ancho,$alto) = @_;
    # Busco posibles de una celda
    my @posibles = grep { $tablero->{$ancho}{$alto}{posibles}{$_} == 1 } keys %{ $tablero->{$ancho}{$alto}{posibles} };
    # Si hay un solo valor posible lo seteo en la celda
    if ( scalar @posibles == 1 ){
    my $posible = $posibles[0];
        print Dumper( "$ancho-$alto: posibleee: $posible" );
        setear_valor( $ancho,$alto,$posibles[0] );
    }
}   

sub setear_valor {
    my ($ancho,$alto,$valor) = @_;
    $tablero->{$ancho}{$alto}{numero} = $valor;
    # Eliminar posibles de la fila
    foreach my $alto_ (1..9){
        $tablero->{$ancho}{$alto_}{posibles}{$valor} = 0;
    }
    # Eliminar posibles de la columna
    foreach my $ancho_ (1..9){
        $tablero->{$ancho_}{$alto}{posibles}{$valor} = 0;
    }
}


sub debug_tablero {
    
    foreach my $alto (1..9){
        
        print $/ if ( ($alto-1) % 3 == 0 );
        print $/;

        foreach my $ancho (1..9){
            print ' ' if ( ($ancho-1) % 3 == 0 );
            print $tablero->{$ancho}{$alto}{numero} . ' ';
        }
    
    }
    print "\n\n\n\n\n\n";
}