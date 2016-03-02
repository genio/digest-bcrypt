# NAME

Digest::Bcrypt [![Build Status](https://travis-ci.org/genio/digest-bcrypt.svg?branch=master)](https://travis-ci.org/genio/digest-bcrypt)

## SYNOPSIS

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Digest;   # via the Digest module (recommended)

my $bcrypt = Digest->new('Bcrypt');

# $cost is an integer between 1 and 31
$bcrypt->cost(12);

# $salt must be exactly 16 octets long
$bcrypt->salt('abcdefgh♥stuff');

$bcrypt->add('some stuff', 'here and', 'here');

my $digest = $bcrypt->digest;
$digest = $bcrypt->hexdigest;
$digest = $bcrypt->b64digest;

# bcrypt's own non-standard base64 dictionary
$digest = $bcrypt->bcrypt_b64digest;
```

## DESCRIPTION

[Digest::Bcrypt](https://github.com/genio/digest-bcrypt/) provides a [Digest](https://metacpan.org/pod/Digest)-based interface to the
[Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) library.

Please note that you ``must`` set a [salt](#salt) of exactly 16 octets in length,
and you ``must`` provide a [cost](#cost) in the range ```[1,31]```.

## METHODS

[Digest::Bcrypt](https://github.com/genio/digest-bcrypt/) inherits all methods
from [Digest::base](https://metacpan.org/pod/Digest::base) and implements/overrides
the following methods as well.

### new

```perl
my $bcrypt = Digest->new('Bcrypt');
my $bcrypt = Digest::Bcrypt->new();
```

Creates a new [Digest::Bcrypt](https://github.com/genio/digest-bcrypt/) object.
It is recommended that you use the [Digest](https://metacpan.org/pod/Digest)
module in the first example rather than using
[Digest::Bcrypt](https://github.com/genio/digest-bcrypt/) directly.

### add

```perl
    $bcrypt->add("a"); $bcrypt->add("b"); $bcrypt->add("c");
    $bcrypt->add("a")->add("b")->add("c");
    $bcrypt->add("a", "b", "c");
    $bcrypt->add("abc");
```

Adds data to the message we are calculating the digest for. All the above
examples have the same effect.

### b64digest

```perl
my $digest = $bcrypt->b64digest;
```

Same as [digest](#digest), but will return the digest base64 encoded.

The ```length``` of the returned string will be 31 and will only contain characters
from the ranges ```[0,9]```, ```[A,Z]```, ```[a,z]```, ```+```, and ```/```.

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

### bcrypt_b64digest

```perl
my $digest = $bcrypt->bcrypt_b64digest;
```

Same as [digest](#digest), but will return the digest base64 encoded using the alphabet
that is commonly used with bcrypt.

The ```length``` of the returned string will be 31 and will only contain characters
from the ranges ```[0,9]```, ```[A,Z]```, ```[a,z]```, ```+```, and ```.```.

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

_Note:_ This is bcrypt's own non-standard base64 alphabet, It is __not__
compatible with the standard [MIME::base64](https://metacpan.org/pod/MIME::Base64) encoding.

### clone

```perl
my $clone = $bcrypt->clone;
```

Creates a clone of the [Digest::Bcrypt](https://github.com/genio/digest-bcrypt/)
object and returns it.

### cost

```perl
$bcrypt->cost($cost);
my $cost = $bcrypt->cost();
```

An integer in the range ```[1,31]```, this is required.

See [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/module/Crypt::Eksblowfish::Bcrypt) for a
detailed description of [cost](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt#cost)
in the context of the [bcrypt algorithm](http://usenix.org/legacy/publications/library/proceedings/usenix99/full_papers/provos/provos_html/node5.html).

When called with no arguments, it will return the current cost.

### digest

```perl
my $digest = $bcrypt->digest;
```

Returns the binary digest for the message. The returned string will be 23 bytes long.

### hexdigest

```perl
my $digest = $bcrypt->hexdigest;
```

Same as [digest](#digest), but will return the digest in hexadecimal form.

The `length` of the returned string will be 46 and will only contain
characters in ```[0-9a-f]```.

### reset

```perl
$bcrypt->reset;
```

Resets the object to the same internal state it was in when it was constructed.

### salt

```perl
$bcrypt->salt($salt);
my $salt = $bcrypt->salt();
```

Sets the value to be used as a salt. Bcrypt requires __exactly__ 16 octets of salt

It is recommenced that you use a module like [Data::Entropy::Algorithms](https://metacpan.org/module/Data::Entropy::Algorithms) to
provide a truly randomized salt.

When called with no arguments, it will return whatever is the current salt.

## SEE ALSO

[Digest](https://metacpan.org/module/Digest), [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/module/Crypt::Eksblowfish::Bcrypt), [Data::Entropy::Algorithms](https://metacpan.org/module/Data::Entropy::Algorithms)

## AUTHORS

Chase Whitener - cwhitener@gmail.com - Current maintainer

James Aitken - jaitken@cpan.org - Original author

## COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
