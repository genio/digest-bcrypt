# NAME

Digest::Bcrypt - Perl interface to the bcrypt digest algorithm

# SYNOPSIS

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Digest;   # via the Digest module (recommended)

my $bcrypt = Digest->new('Bcrypt', cost => 12, salt => 'abcdefgh♥stuff');
# You can forego the cost and salt in favor of settings strings:
my $bcrypt = Digest->new('Bcrypt', settings => '$2a$20$GA.eY03tb02ea0DqbA.eG.');

# $cost is an integer between 5 and 31
$bcrypt->cost(12);

# $type is a selection between 2a, 2b, 2x, and 2y
$bcrypt->type('2b');

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

# Now, let's create a password hash and check it later:
use Data::Entropy::Algorithms qw(rand_bits);
my $bcrypt = Digest->new('Bcrypt', type => '2b', cost => 20, salt => rand_bits(16*8));
my $settings = $bcrypt->settings(); # save for later checks.
my $pass_hash = $bcrypt->add('Some secret password')->digest;

# much later, we can check a password against our hash via:
my $bcrypt = Digest->new('Bcrypt', settings => $settings);
if ($bcrypt->add($value_from_user)->digest eq $known_pass_hash) {
    say "Your password matched";
}
else {
    say "Try again!";
}

# Now that you've seen how cumbersome/silly that is,
# please use Crypt::Bcrypt instead of this module.
```

# NOTICE

While maintenance for [Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) will continue, there's no reason to use
[Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) when [Crypt::Bcrypt](https://metacpan.org/pod/Crypt%3A%3ABcrypt) already exists.  We strongly suggest
that you use [Crypt::Bcrypt](https://metacpan.org/pod/Crypt%3A%3ABcrypt) instead.

This `Digest::Bcrypt` interface is crufty and laborious to use when compared
to that of [Crypt::Bcrypt](https://metacpan.org/pod/Crypt%3A%3ABcrypt).

# DESCRIPTION

[Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) provides a [Digest](https://metacpan.org/pod/Digest)-based interface to the
[Crypt::Bcrypt](https://metacpan.org/pod/Crypt%3A%3ABcrypt) library.

Please note that you **must** set a `salt` of exactly 16 octets in length,
and you **must** provide a `cost` in the range `1..31`.

# ATTRIBUTES

[Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) implements the following attributes.

## cost

```perl
$bcrypt = $bcrypt->cost(20); # allows for method chaining
my $cost = $bcrypt->cost();
```

An integer in the range `5..31`, this is required.

See [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt%3A%3AEksblowfish%3A%3ABcrypt) for a detailed description of `cost`
in the context of the bcrypt algorithm.

When called with no arguments, it will return the current cost.

## salt

```perl
$bcrypt = $bcrypt->salt('abcdefgh♥stuff'); # allows for method chaining
my $salt = $bcrypt->salt();

# OR, for good, random salts:
use Data::Entropy::Algorithms qw(rand_bits);
$bcrypt->salt(rand_bits(16*8)); # 16 octets
```

Sets the value to be used as a salt. Bcrypt requires **exactly** 16 octets of salt.

It is recommenced that you use a module like [Data::Entropy::Algorithms](https://metacpan.org/pod/Data%3A%3AEntropy%3A%3AAlgorithms) to
provide a truly randomized salt.

When called with no arguments, it will return the current salt.

## settings

```perl
$bcrypt = $bcrypt->settings('$2a$20$GA.eY03tb02ea0DqbA.eG.'); # allows for method chaining
my $settings = $bcrypt->settings();
```

A `settings` string can be used to set the ["salt" in Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt#salt) and
["cost" in Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt#cost) automatically. Setting the `settings` will override any
current values in your `cost` and `salt` attributes.

For details on the `settings` string requirements, please see [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt%3A%3AEksblowfish%3A%3ABcrypt).

When called with no arguments, it will return the current settings string.

## type

```
$bcrypt = $bcrypt->type('2b');
# method chaining on mutations
say $bcrypt->type(); # 2b
```

This sets the subtype of bcrypt used. These subtypes are as defined in [Crypt::Bcrypt](https://metacpan.org/pod/Crypt%3A%3ABcrypt).
The available types are:
`2b` which is the current standard,
`2a` which is older; it's the one used in [Crypt::Eksblowfish](https://metacpan.org/pod/Crypt%3A%3AEksblowfish),
`2y` which is considered equivalent to `2b` and used in PHP.
`2x` which is very broken and only needed to work with ancient PHP versions.

# METHODS

[Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) inherits all methods from [Digest::base](https://metacpan.org/pod/Digest%3A%3Abase) and implements/overrides
the following methods as well.

## new

```perl
my $bcrypt = Digest->new('Bcrypt', %params);
my $bcrypt = Digest::Bcrypt->new(%params);
my $bcrypt = Digest->new('Bcrypt', \%params);
my $bcrypt = Digest::Bcrypt->new(\%params);
```

Creates a new `Digest::Bcrypt` object. It is recommended that you use the [Digest](https://metacpan.org/pod/Digest)
module in the first example rather than using [Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt) directly.

Any of the ["ATTRIBUTES" in Digest::Bcrypt](https://metacpan.org/pod/Digest%3A%3ABcrypt#ATTRIBUTES) above can be passed in as a parameter.

## add

```
$bcrypt->add("a"); $bcrypt->add("b"); $bcrypt->add("c");
$bcrypt->add("a")->add("b")->add("c");
$bcrypt->add("a", "b", "c");
$bcrypt->add("abc");
```

Adds data to the message we are calculating the digest for. All the above
examples have the same effect.

## b64digest

```perl
my $digest = $bcrypt->b64digest;
```

Same as ["digest"](#digest), but will return the digest base64 encoded.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'/'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

## bcrypt\_b64digest

```perl
my $digest = $bcrypt->bcrypt_b64digest;
```

Same as ["digest"](#digest), but will return the digest base64 encoded using the alphabet
that is commonly used with bcrypt.

The `length` of the returned string will be 31 and will only contain characters
from the ranges `'0'..'9'`, `'A'..'Z'`, `'a'..'z'`, `'+'`, and `'.'`

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

_Note:_ This is bcrypt's own non-standard base64 alphabet, It is **not**
compatible with the standard MIME base64 encoding.

## clone

```perl
my $clone = $bcrypt->clone;
```

Creates a clone of the `Digest::Bcrypt` object, and returns it.

## digest

```perl
my $digest = $bcrypt->digest;
```

Returns the binary digest for the message. The returned string will be 23 bytes long.

## hexdigest

```perl
my $digest = $bcrypt->hexdigest;
```

Same as ["digest"](#digest), but will return the digest in hexadecimal form.

The `length` of the returned string will be 46 and will only contain
characters from the ranges `'0'..'9'` and `'a'..'f'`.

## reset

```
$bcrypt->reset;
```

Resets the object to the same internal state it was in when it was constructed.

# SEE ALSO

[Digest](https://metacpan.org/pod/Digest), [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt%3A%3AEksblowfish%3A%3ABcrypt), [Data::Entropy::Algorithms](https://metacpan.org/pod/Data%3A%3AEntropy%3A%3AAlgorithms)

# AUTHOR

James Aitken `jaitken@cpan.org`

# CONTRIBUTORS

- Chase Whitener `capoeira@cpan.org`

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
