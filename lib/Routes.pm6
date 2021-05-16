use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;
use Tipsy;

sub routes(Tipsy $tipsy) is export {
    route {
        get -> {
            #content 'text/html', "<h1> etipsy </h1>";
            static 'static/index.html'
        }
        get -> 'js', *@path {
            static 'static/js', @path
        }

        my $chat = Supplier.new;
        get -> 'chat' {
            web-socket -> $incoming {
                supply {
                    whenever $incoming -> $message {
                        $chat.emit(await $message.body-text);
                    }
                    whenever $chat -> $text {
                        emit $text;
                    }
                }
            }
        }

        get -> 'greet', $name {
            template 'templates/greet.crotmp', { :$name }
        }
    }
}