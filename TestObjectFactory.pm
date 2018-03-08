package TestObjectFactory;

use Data::Dumper;

sub new {
    my $class = shift;
    my %args = @_;

    die unless ref $args{test_object};

    my $self = bless {
        test_object => $args{test_object},
    }, $class;

    return $self;
}

sub get_object {
    my $self = shift;

    my $object = $self->{test_object};
    my $copy;

    if( ref $object eq 'ARRAY' ){
        $copy = [ @$object ];
    }elsif( ref $object eq 'HASH' ){
        $copy = { %$object };
    }else{ # hopefully a blessed ref
        $copy = bless { %$object }, ref $object;
    }

    return $copy;
}

1;
