use strict;
use warnings;

use Digest::Bcrypt ();
use Try::Tiny qw(try catch);

use Test::More tests => 8;

my $secret = "Super Secret Squirrel";
my $salt   = "   known salt   ";

my $ctx = try { return Digest::Bcrypt->new(); } catch { return "Couldn't create object: $!"; };
isa_ok($ctx,'Digest::Bcrypt', 'new: got a proper object');

SKIP: { # test cost
    skip "Couldn't get a Digest::Bcrypt object", 4 unless $ctx;
    my $res;
    $ctx->add($secret);
    $res = try {
        $ctx->cost('foobar');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must be an integer between 1 and 31/i, 'cost: dies on non-numeric';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(32);
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must be an integer between 1 and 31/i, 'cost: dies when greater than 31';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(0);
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must be an integer between 1 and 31/i, 'cost: dies when less than 1';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must be an integer between 1 and 31/i, 'cost: dies when none specified';
}

SKIP: {
    skip "Couldn't get a Digest::Bcrypt object", 3 unless $ctx;
    my $res;
    $ctx->add($secret);
    $res = try {
        $ctx->cost(1);
        $ctx->salt('too small');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must be exactly 16 octets long/i, 'salt: dies on too small of a salt';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(1);
        $ctx->salt();
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must be exactly 16 octets long/i, 'salt: dies without salt';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(1);
        $ctx->salt('This is a mighty big salt cannon we have here!');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must be exactly 16 octets long/i, 'salt: dies when salt too large';
}
