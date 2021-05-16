use Cro::HTTP::Test;
use Test;
use Routes;

use Tipsy;
my $tipsy = Tipsy.new;

test-service routes($tipsy), {
    test get('/'),
            status => 200,
            body-text => /zTipsy/;
}

done-testing;
