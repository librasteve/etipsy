use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;

use Tipsy;

my $tipsy = Tipsy.new;
my $application = routes($tipsy);

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<ETIPSY_HOST> ||
        die("Missing ETIPSY_HOST in environment"),
    port => %*ENV<ETIPSY_PORT> ||
        die("Missing ETIPSY_PORT in environment"),
    :$application,
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<ETIPSY_HOST>:%*ENV<ETIPSY_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
