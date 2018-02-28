package TestObjectFactory;
use Data::Dumper;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless {
        test_object => $args{test_object},
    }, $class;

    return $self;
}

sub get_object {
    my $self = shift;

    my $object = $self->{test_object};

    my $copy = bless { %$object }, ref $object;

    return $copy;
}

1;
