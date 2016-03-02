# NAME

Digest::Bcrypt [![Build Status](https://travis-ci.org/genio/digest-bcrypt.svg?branch=master)](https://travis-ci.org/genio/digest-bcrypt)

# SYNOPSIS

Provides an interface to the bcrypt digest algorithm.

This module subclasses [Digest::base](https://metacpan.org/module/Digest::base) and can be used either directly
or through the Digest meta-module. Using the latter is recommended.

It is mostly a wrapper around [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/module/Crypt::Eksblowfish::Bcrypt).

# USAGE

    # via the Digest module (recommended)
    use Digest;

    my $bcrypt = Digest->new('Bcrypt');

    # $cost is an integer between 1 and 31
    $bcrypt->cost($cost);

    # $salt must be exactly 16 octets long
    $bcrypt->salt($salt);

    $bcrypt->add($data);

    $digest = $bcrypt->digest;
    $digest = $bcrypt->hexdigest;
    $digest = $bcrypt->b64digest;

    # bcrypt's own non-standard base64 dictionary
    $digest = $bcrypt->bcrypt_b64digest;

    # [...]

    # Using the module directly (same interface as above)

    use Digest::Bcrypt;

    my $bcrypt = Digest::Bcrypt->new();

# METHODS

The object-oriented interface to `Digest::Bcrypt` is mostly
identical to that of [Digest](https://metacpan.org/module/Digest), with a few additions.

Notably you __must__ set a `salt` exactly 16 octets in length,
and you __must__ provide a `cost` in the range `'1'..'31'`.

## new

    my $bcrypt = Digest->new('Bcrypt');

Creates a new `Digest::Bcrypt` object.

You can also use this module directly

    my $bcrypt = Digest::Bcrypt->new();

## add

    $bcrypt->add("a"); $bcrypt->add("b"); $bcrypt->add("c");
    $bcrypt->add("a")->add("b")->add("c");
    $bcrypt->add("a", "b", "c");
    $bcrypt->add("abc");

Adds data to the message we are calculating the digest for.

All the above examples have the same effect

## salt

    $bcrypt->salt($salt);

Sets the value to be used as a salt. Bcrypt requires __exactly__ 16 octets of salt

It is recommenced that you use a module like [Data::Entropy::Algorithms](https://metacpan.org/module/Data::Entropy::Algorithms) to
provide a truly randomised salt.

When called with no arguments, will return the whatever is the current salt

## cost

    $bcrypt->cost($cost);

An integer in the range `'1'..'31'`, this is required.

See [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/module/Crypt::Eksblowfish::Bcrypt) for a detailed description of `cost`
in the context of the bcrypt algorithm.

When called with no arguments, will return the current cost

## digest

    $bcrypt->digest;

Return the binary digest for the message.

The returned string will be 23 bytes long.

## hexdigest

    $bcrypt->hexdigest;

Same as ["digest"](#digest), but will return the digest in hexadecimal form.

The `length` of the returned string will be 46 and will only contain
characters from the ranges `'0'..'9'` and `'a'..'f'`.

## b64digest

    $bcrypt->b64digest;

Same as ["digest"](#digest), but will return the digest base64 encoded.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'/'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

## bcrypt_b64digest

    $bcrypt->bcrypt_b64digest;

Same as ["digest"](#digest), but will return the digest base64 encoded using the alphabet
that is commonly used with bcrypt.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'.'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

_Note:_ This is bcrypt's own non-standard base64 alphabet, It is __not__
compatible with the standard MIME base64 encoding.

## clone

    my $bcrypt->clone;

Creates a clone of the `Digest::Bcrypt` object, and returns it.

## reset

    $bcrypt->reset;

Resets the object to the same internal state it was in when it was constructed.

# SEE ALSO

[Digest](https://metacpan.org/module/Digest), [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/module/Crypt::Eksblowfish::Bcrypt), [Data::Entropy::Algorithms](https://metacpan.org/module/Data::Entropy::Algorithms)



# AUTHOR

James Aitken <jaitken@cpan.org>



# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
