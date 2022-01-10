use strict;
use warnings;

use Digest::Bcrypt ();
use Try::Tiny qw(try catch);

use Test::More;

my $secret = "Super Secret Squirrel";
my $salt   = "   known salt   ";

my $ctx = try { return Digest::Bcrypt->new(); } catch { return "Couldn't create object: $!"; };
isa_ok($ctx,'Digest::Bcrypt', 'new: got a proper object');

subtest 'settings tests', sub {
    plan(skip_all => 'No valid Digest::Bcrypt object') unless $ctx;
    my $res;
    $ctx->add($secret);
    $res = try {
        $ctx->settings('$2a$20$GA.eY');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/bad bcrypt settings/, 'settings: dies on invalid setup';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->settings('$2a$40$GA.eY03tb02ea0DqbA.eG.');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must/i, 'settings: dies with bad cost';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->settings('$2a$20$GA.eY03tb02eZFOeGA.');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/bad bcrypt settings/i, 'settings: dies with bad salt part';
};

subtest "cost tests", sub {
    plan(skip_all=> "Couldn't get a Digest::Bcrypt object") unless $ctx;
    my $res;
    $ctx->add($secret);
    $res = try {
        $ctx->cost('foobar');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must/i, 'cost: dies on non-numeric';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(32);
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must/i, 'cost: dies when greater than 31';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(0);
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must/i, 'cost: dies when less than 5';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Cost must/i, 'cost: dies when none specified';
};

subtest "salt tests", sub {
    plan(skip_all=> "Couldn't get a Digest::Bcrypt object") unless $ctx;
    my $res;
    $ctx->add($secret);
    $res = try {
        $ctx->cost(5);
        $ctx->salt('too small');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must/i, 'salt: dies on too small of a salt';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(5);
        $ctx->salt();
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must/i, 'salt: dies without salt';

    $ctx->reset; $ctx->add($secret);
    $res = try {
        $ctx->cost(5);
        $ctx->salt('This is a mighty big salt cannon we have here!');
        $ctx->digest;
    } catch { $_ };
    like $res, qr/Salt must/i, 'salt: dies when salt too large';
};

done_testing();
