package JSONParser;
use JSON;
use Data::Dumper;

sub new {
    my $class = shift;
    my %args = @_;

    my $self = bless {
        filename => $args{filename},
    }, $class;

    return $self;
}

sub get_data {
    my $self = shift;

    my $filename = $self->{filename};

    my $json_text = do {
       open(my $json_fh, "<:encoding(UTF-8)", $filename)
          or die("Can't open \$filename\": $!\n");
       local $/;
       <$json_fh>
    };

    my $json = JSON->new;
    my $data = $json->decode($json_text);

    return $data;
}

1;
