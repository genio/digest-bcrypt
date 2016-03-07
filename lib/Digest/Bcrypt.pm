package Digest::Bcrypt;
use parent 'Digest::base';

use strict;
use warnings;
use bytes ();
use Carp ();
use Crypt::Eksblowfish::Bcrypt ();
use 5.008001;
use utf8;

our $VERSION = '1.202';
$VERSION = eval $VERSION;

sub add {
    my $self = shift;
    $self->{_buffer} .= join('', @_);
    return $self;
}

sub bcrypt_b64digest { return Crypt::Eksblowfish::Bcrypt::en_base64(shift->digest); }

sub clone {
    my $self = shift;

    return bless {
        cost    => $self->cost,
        salt    => $self->salt,
        _buffer => $self->{_buffer},
    }, ref($self);
}

sub cost {
    my $self = shift;
    return $self->{cost} unless @_;

    my $cost = shift;
    # allow and undefined value to clear it
    unless (defined $cost) {
        delete $self->{cost};
        return $self;
    }
    $self->_check_cost($cost);
    # bcrypt requires 2 digit costs, it dies if it's a single digit.
    $self->{cost} = sprintf("%02d", $cost);
    return $self;
}

sub digest {
    my $self = shift;
    $self->_check_cost;
    $self->_check_salt;

    my $hash = Crypt::Eksblowfish::Bcrypt::bcrypt_hash({
        key_nul => 1,
        cost    => $self->cost,
        salt    => $self->salt,
    }, $self->{_buffer});
    $self->reset;
    return $hash;
}

sub new {
    my $class = shift;
    my $self = bless {
        _buffer => '',
    }, ref $class || $class;
    return $self unless @_;
    my $params = @_ > 1 ? {@_} : {%{$_[0]}};
    $self->cost($params->{cost}) if $params->{cost};
    $self->salt($params->{salt}) if $params->{salt};
    return $self;
}

sub reset {
    my $self = shift;
    $self->{_buffer} = '';
    delete $self->{cost};
    delete $self->{salt};
    return $self;
}

sub salt {
    my $self = shift;
    return $self->{salt} unless @_;

    my $salt = shift;
    # allow and undefined value to clear it
    unless ( defined $salt ) {
        delete $self->{salt};
        return $self;
    }
    # all other values go through the check
    $self->_check_salt($salt);
    $self->{salt} = $salt;
    return $self;
}

# Checks that the cost is an integer in the range 1-31. Croaks if it isn't
sub _check_cost {
    my ($self, $cost) = @_;
    $cost = defined $cost ? $cost : $self->cost;
    if (!defined $cost || $cost !~ /^\d+$/ || ($cost < 1 || $cost > 31)) {
        Carp::croak "Cost must be an integer between 1 and 31";
    }
}

# Checks that the salt exactly 16 octets long. Croaks if it isn't
sub _check_salt {
    my ($self, $salt) = @_;
    $salt = defined $salt ? $salt : $self->salt;
    if (!defined $salt || bytes::length $salt != 16) {
        Carp::croak "Salt must be exactly 16 octets long";
    }
}

1;

=encoding utf8

=head1 NAME

Digest::Bcrypt - Perl interface to the bcrypt digest algorithm

=head1 SYNOPSIS

    #!/usr/bin/env perl
    use strict;
    use warnings;
    use utf8;
    use Digest;   # via the Digest module (recommended)

    my $bcrypt = Digest->new('Bcrypt', cost => 12, salt => 'abcdefgh♥stuff');

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

=head1 NOTICE

While maintenance for L<Digest::Bcrypt> will continue, there's no reason to use
L<Digest::Bcrypt> when L<Crypt::Eksblowfish::Bcrypt> already exists.  We suggest
that you use L<Crypt::Eksblowfish::Bcrypt> instead.

=head1 DESCRIPTION

L<Digest::Bcrypt> provides a L<Digest>-based interface to the
L<Crypt::Eksblowfish::Bcrypt> library.

Please note that you B<must> set a C<salt> of exactly 16 octets in length,
and you B<must> provide a C<cost> in the range C<'1'..'31'>.

=head1 ATTRIBUTES

L<Digest::Bcrypt> implements the following attributes.

=head2 cost

    $bcrypt = $bcrypt->cost(20); # allows for method chaining
    my $cost = $bcrypt->cost();

An integer in the range C<'1'..'31'>, this is required.

See L<Crypt::Eksblowfish::Bcrypt> for a detailed description of C<cost>
in the context of the bcrypt algorithm.

When called with no arguments, it will return the current cost.

=head2 salt

    $bcrypt = $bcrypt->salt('abcdefgh♥stuff'); # allows for method chaining
    my $salt = $bcrypt->salt();

Sets the value to be used as a salt. Bcrypt requires B<exactly> 16 octets of salt.

It is recommenced that you use a module like L<Data::Entropy::Algorithms> to
provide a truly randomized salt.

When called with no arguments, it will return whatever is the current salt.

=head1 METHODS

L<Digest::Bcrypt> inherits all methods from L<Digest::base> and implements/overrides
the following methods as well.

=head2 new

    my $bcrypt = Digest->new('Bcrypt', %params);
    my $bcrypt = Digest::Bcrypt->new(%params);
    my $bcrypt = Digest->new('Bcrypt', \%params);
    my $bcrypt = Digest::Bcrypt->new(\%params);

Creates a new C<Digest::Bcrypt> object. It is recommended that you use the L<Digest>
module in the first example rather than using L<Digest::Bcrypt> directly.

Possible parameters are:

=over

=item cost

An integer value between 1 and 31.

=item salt

A string of exactly 16 octets in length.

=back

=head2 add

    $bcrypt->add("a"); $bcrypt->add("b"); $bcrypt->add("c");
    $bcrypt->add("a")->add("b")->add("c");
    $bcrypt->add("a", "b", "c");
    $bcrypt->add("abc");

Adds data to the message we are calculating the digest for. All the above
examples have the same effect.

=head2 b64digest

    my $digest = $bcrypt->b64digest;

Same as L</"digest">, but will return the digest base64 encoded.

The C<length> of the returned string will be 31 and will only contain characters
from the ranges C<'0'..'9'>, C<'A'..'Z'>, C<'a'..'z'>, C<'+'>, and C<'/'>

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

=head2 bcrypt_b64digest

    my $digest = $bcrypt->bcrypt_b64digest;

Same as L</"digest">, but will return the digest base64 encoded using the alphabet
that is commonly used with bcrypt.

The C<length> of the returned string will be 31 and will only contain characters
from the ranges C<'0'..'9'>, C<'A'..'Z'>, C<'a'..'z'>, C<'+'>, and C<'.'>

The base64 encoded string returned is not padded to be a multiple of 4 bytes long.

I<Note:> This is bcrypt's own non-standard base64 alphabet, It is B<not>
compatible with the standard MIME base64 encoding.

=head2 clone

    my $clone = $bcrypt->clone;

Creates a clone of the C<Digest::Bcrypt> object, and returns it.

=head2 digest

    my $digest = $bcrypt->digest;

Returns the binary digest for the message. The returned string will be 23 bytes long.

=head2 hexdigest

    my $digest = $bcrypt->hexdigest;

Same as L</"digest">, but will return the digest in hexadecimal form.

The C<length> of the returned string will be 46 and will only contain
characters from the ranges C<'0'..'9'> and C<'a'..'f'>.

=head2 reset

    $bcrypt->reset;

Resets the object to the same internal state it was in when it was constructed.

=head1 SEE ALSO

L<Digest>, L<Crypt::Eksblowfish::Bcrypt>, L<Data::Entropy::Algorithms>

=head1 AUTHORS

Chase Whitener <cwhitener@gmail.com> - Current maintainer

James Aitken <jaitken@cpan.org> - Original author

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by James Aitken.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
