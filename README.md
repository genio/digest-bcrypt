# NAME

Digest::Bcrypt - Perl interface to the bcrypt digest algorithm

# SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;
    use utf8;
    use Digest;   # via the Digest module (recommended)

    my $bcrypt = Digest->new('Bcrypt', cost => 12, salt => 'abcdefgh♥stuff');
    # You can forego the cost and salt in favor of settings strings:
    my $bcrypt = Digest->new('Bcrypt', settings => '$2a$20$GA.eY03tb02ea0DqbA.eG.');

    # $cost is an integer between 1 and 31
    $bcrypt->cost(12);

    # $salt must be exactly 16 octets long
    $bcrypt->salt('abcdefgh♥stuff');
    # OR, for good, random salts:
    use Data::Entropy::Algorithms qw(rand_bits);
    $bcrypt->salt(rand_bits(16*8)); # 16 octets

    # You can forego the cost and salt in favor of settings strings:
    $bcrypt->settings('$2a$20$GA.eY03tb02ea0DqbA.eG.');

    # add some strings we want to make a secret of
    $bcrypt->add('some stuff', 'here and', 'here');

    my $digest = $bcrypt->digest;
    $digest = $bcrypt->hexdigest;
    $digest = $bcrypt->b64digest;

    # bcrypt's own non-standard base64 dictionary
    $digest = $bcrypt->bcrypt_b64digest;

# NOTICE

While maintenance for [Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) will continue, there's no reason to use
[Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) when [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) already exists.  We suggest
that you use [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) instead.

# DESCRIPTION

[Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) provides a [Digest](https://metacpan.org/pod/Digest)-based interface to the
[Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) library.

Please note that you **must** set a `salt` of exactly 16 octets in length,
and you **must** provide a `cost` in the range `1..31`.

# ATTRIBUTES

[Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) implements the following attributes.

## cost

    $bcrypt = $bcrypt->cost(20); # allows for method chaining
    my $cost = $bcrypt->cost();

An integer in the range `1..31`, this is required.

See [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) for a detailed description of `cost`
in the context of the bcrypt algorithm.

When called with no arguments, it will return the current cost.

## salt

    $bcrypt = $bcrypt->salt('abcdefgh♥stuff'); # allows for method chaining
    my $salt = $bcrypt->salt();

    # OR, for good, random salts:
    use Data::Entropy::Algorithms qw(rand_bits);
    $bcrypt->salt(rand_bits(16*8)); # 16 octets

Sets the value to be used as a salt. Bcrypt requires **exactly** 16 octets of salt.

It is recommenced that you use a module like [Data::Entropy::Algorithms](https://metacpan.org/pod/Data::Entropy::Algorithms) to
provide a truly randomized salt.

When called with no arguments, it will return the current salt.

## settings

    $bcrypt = $bcrypt->settings('$2a$20$GA.eY03tb02ea0DqbA.eG.'); # allows for method chaining
    my $settings = $bcrypt->settings();

A `settings` string can be used to set the ["salt" in Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt#salt) and
["cost" in Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt#cost) automatically. Setting the `settings` will override any
current values in your `cost` and `salt` attributes.

For details on the `settings` string requirements, please see [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt).

When called with no arguments, it will return the current settings string.

# METHODS

[Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) inherits all methods from [Digest::base](https://metacpan.org/pod/Digest::base) and implements/overrides
the following methods as well.

## new

    my $bcrypt = Digest->new('Bcrypt', %params);
    my $bcrypt = Digest::Bcrypt->new(%params);
    my $bcrypt = Digest->new('Bcrypt', \%params);
    my $bcrypt = Digest::Bcrypt->new(\%params);

Creates a new `Digest::Bcrypt` object. It is recommended that you use the [Digest](https://metacpan.org/pod/Digest)
module in the first example rather than using [Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt) directly.

Any of the ["METHODS" in Digest::Bcrypt](https://metacpan.org/pod/Digest::Bcrypt#METHODS) above can be passed in as a parameter.

## add

    $bcrypt->add("a"); $bcrypt->add("b"); $bcrypt->add("c");
    $bcrypt->add("a")->add("b")->add("c");
    $bcrypt->add("a", "b", "c");
    $bcrypt->add("abc");

Adds data to the message we are calculating the digest for. All the above
examples have the same effect.

## b64digest

    my $digest = $bcrypt->b64digest;

Same as ["digest"](#digest), but will return the digest base64 encoded.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'/'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

## bcrypt\_b64digest

    my $digest = $bcrypt->bcrypt_b64digest;

Same as ["digest"](#digest), but will return the digest base64 encoded using the alphabet
that is commonly used with bcrypt.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'.'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

_Note:_ This is bcrypt's own non-standard base64 alphabet, It is **not**
compatible with the standard MIME base64 encoding.

## clone

    my $clone = $bcrypt->clone;

Creates a clone of the `Digest::Bcrypt` object, and returns it.

## digest

    my $digest = $bcrypt->digest;

Returns the binary digest for the message. The returned string will be 23 bytes long.

## hexdigest

    my $digest = $bcrypt->hexdigest;

Same as ["digest"](#digest), but will return the digest in hexadecimal form.

The `length` of the returned string will be 46 and will only contain
characters from the ranges `'0'..'9'` and `'a'..'f'`.

## reset

    $bcrypt->reset;

Resets the object to the same internal state it was in when it was constructed.

# SEE ALSO

[Digest](https://metacpan.org/pod/Digest), [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt), [Data::Entropy::Algorithms](https://metacpan.org/pod/Data::Entropy::Algorithms)

# AUTHOR

James Aitken `jaitken@cpan.org`

# CONTRIBUTORS

- Chase Whitener `capoeira@cpan.org`

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
