use Test::More;
use Plack::Test;
use HTTP::Request::Common; # install separately
 
use myhomepage;
 
my $app  = myhomepage->to_app;
my $test = Plack::Test->create($app);
 
my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr/hero/, '[GET /] Correct content' );
 
done_testing;
