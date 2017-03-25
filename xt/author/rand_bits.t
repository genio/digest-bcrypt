use strict;
use warnings;

use Data::Entropy::Algorithms qw(rand_bits);
use Digest::Bcrypt;
use Test::More;
use Try::Tiny qw(try catch);

my $ctx = try { return Digest::Bcrypt->new(); } catch { return "Couldn't create object: $!"; };
isa_ok($ctx, 'Digest::Bcrypt', 'new: got a proper object');

my $secret = "Super Secret Squirrel";
my $bits = rand_bits(128); # 16 octets
is(length($bits), 16, 'rand_bits: 16 octets');

subtest "salt tests", sub {
    plan(skip_all=> "Couldn't get a Digest::Bcrypt object") unless $ctx;
    my $res;
    my $err;
    $ctx->add($secret);
    try {
        $ctx->cost(1);
        $ctx->salt($bits);
        $res = $ctx->digest;
    }
    catch {
        $err = $_;
    };
    is($err, undef, 'rand_bits salt: no error');
    ok($res, 'rand_bits salt: got a proper digest');
};

done_testing();
