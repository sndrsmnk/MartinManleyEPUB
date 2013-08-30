#!/usr/bin/perl -w
use strict;
binmode STDIN, ':encoding(UTF-8)'; binmode STDOUT, ':encoding(UTF-8)';
my $counter = 1;
while (<>) {
    if (/navPoint id="[^"]+" playOrder="(\d+)"/) {
        $_ =~ s#playOrder="\d+"#playOrder="$counter"#;
        $counter++;
    }

    if (/page href.+?name="[X\d]+"/) {
        $_ =~ s#name="[X\d]+"#name="$counter"#;
        $counter++;
    }
    print;
}
__END__
