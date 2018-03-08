package MockFactory;

use base Test::DeepMock;

our $PATH_TO_MOCKS; # FIXME

our $CONFIG = {
    'Game' => {
        source => '
package Game;
1;'
    },
    'Board' => {
        source => '
package Board;
sub new { return bless {}, "Board"; } 
sub get_value { return 0; } 
sub set_value { return 0; } 
sub is_possible { return 0; } 
sub debug { return 0; } 
sub solved { return 0; } 
1;'
    },
#    'My::Another::Package' => {
#        file_handle => $FH
#    },
#    'My::Package::From::File' => {
#        path => '/some/path/to/mock'
#    },
#    default => sub {
#        my ($class, $package_name) = @_;
#        #returns scalar with source of package or file handle
#        #return undef to interrupt mocking
#    },
};