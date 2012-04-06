use Test::More tests => 4;

use strict;
use warnings;

use Digest;

my $secret = "Super Secret Squirrel";
my $salt   = "   known salt   ";
my $cost   = 1;

# Object is reset after each hash is generated
my $ctx = Digest->new('Bcrypt');


$ctx->add($secret);
$ctx->salt($salt);
$ctx->cost($cost);

ok($ctx->digest, "Creates Binary Digest");


$ctx->add($secret);
$ctx->salt($salt);
$ctx->cost($cost);

ok($ctx->hexdigest eq '7ca73fd67f694324bcad7b0910093ff8ef9e8c564e2297', "Creates Hex Digest");


$ctx->add($secret);
$ctx->salt($salt);
$ctx->cost($cost);

ok($ctx->b64digest eq 'fKc/1n9pQyS8rXsJEAk/+O+ejFZOIpc', "Creates Base 64 Digest");


$ctx->add($secret);
$ctx->salt($salt);
$ctx->cost($cost);

ok($ctx->bcrypt_b64digest eq 'dIa9zl7nOwQ6pVqHC.i98M8chDXMGna', "Creates Bcrypt Base 64 Digest");
