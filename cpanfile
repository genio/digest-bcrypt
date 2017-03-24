on 'runtime' => sub {
    requires 'perl' => '5.008001';
    requires 'strict';
    requires 'warnings';
    requires 'parent';
    requires 'utf8';
    requires 'Carp';
    requires 'Crypt::Eksblowfish::Bcrypt';
    requires 'Digest';
    requires 'Encode';
};

on 'test' => sub {
    requires 'Scalar::Util' => '0.88';
    requires 'Test::More' => '0.88';
    requires 'Try::Tiny'  => '0.24';
};

on 'develop' => sub {
    requires 'Test::CheckManifest' => '1.29';
    requires 'Test::CPAN::Changes' => '0.4';
    requires 'Test::Kwalitee'      => '1.22';
    requires 'Test::Pod::Spelling::CommonMistakes' => '1.000';
};
