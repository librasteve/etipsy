use Cro::HTTP::Test;
use Test;
use etipsy::Routes;

test-service routes, {
    test get('/'),
            status => 200,
            body-text => '<h1> etipsy </h1>';
}

done-testing;
