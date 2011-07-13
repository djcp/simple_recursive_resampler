#!/usr/bin/perl

use strict;
use Ogg::Vorbis::Header;

my $o = Ogg::Vorbis::Header->new($ARGV[0]);

print '--ta "'. clean_string($o->comment('artist')) . '" --tt "' . clean_string($o->comment('title')). '" --tl "'. clean_string($o->comment('album')). '" --ty "'. clean_string($o->comment('year')) .'" --tn "' . clean_string($o->comment('tracknumber')). '"';

sub clean_string{
	my $string = shift;
	$string =~ s/"//gi;
	return $string;
}
