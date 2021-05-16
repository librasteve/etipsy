use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

sub routes() is export {
    route {
        get -> {
            content 'text/html', "<h1> etipsy </h1>";
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