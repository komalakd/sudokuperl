package Board;

sub new {
	my $class = shift;
	my %args = @_;

	my $self = bless {
		initial_data => $args{initial_data},
		board        => {},
		remaining    => 9 * 9,       
	
	}, $class;

	$self->process_initial_data();

	return $self;
}

sub process_initial_data {
	my $self = shift;

	foreach my $ancho (1..9){
	    foreach my $alto (1..9){
	    	my $number = $self->{initial_data}->[$ancho-1][$alto-1];
	    	
	    	$self->set_value( $ancho,$alto,$number );
	        $self->{board}->{$ancho}{$alto}{possibles} = process_possible_values(); # FIXME!
	    }   
	}
}

# FIXME delete method
sub process_possible_values {
	my $class = shift;

	my $possibles = {};
    foreach my $number (1..9){
        $possibles->{$number} = 1;
    }
    
    return $possibles;
}

sub set_value {
    my $self = shift;
    my ($ancho,$alto,$valor) = @_;

    $self->{board}->{$ancho}{$alto}{number} = $valor;
    
    # Eliminar posibles de la fila
    foreach my $alto_ (1..9){
        $self->set_possible($ancho,$alto_,$valor,0);
    }
    
    # Eliminar posibles de la columna
    foreach my $ancho_ (1..9){
        $self->set_possible($ancho_,$alto,$valor,0);
    }

    $self->{remaining} = $self->{remaining} - 1; # FIXME: refactor
}

sub set_possible {
    my $self = shift;
    my ($ancho,$alto,$number,$valor) = @_;

    $self->{board}->{$ancho_}{$alto}{possibles}{$number} = $valor;
}

sub get_value {
    my $self = shift;
    my ($ancho,$alto) = @_;

    return $self->{board}{$ancho}{$alto}{number};
}

sub debug {
	my $self = shift;
    
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

1;