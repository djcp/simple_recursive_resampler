#!/usr/bin/perl

use strict;
use Audio::FLAC::Header;

my $o = Audio::FLAC::Header->new($ARGV[0]);

my $tags = $o->tags();

print '--ta "'. clean_string($tags->{'ARTIST'}) . '" --tt "' . clean_string($tags->{'TITLE'}). '" --tl "'. clean_string($tags->{'ALBUM'}). '" --ty "'. clean_string($tags->{'DATE'}) .'" --tn "' . clean_string($tags->{'TRACKNUMBER'}). '"';

sub clean_string{
	my $string = shift;
	$string =~ s/"//gi;
	return $string;
}
