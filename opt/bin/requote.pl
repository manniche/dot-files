#!/usr/bin/perl -w -i.slet

use strict;

# find linier med '> ' og ombryd

my $linebreak = 77;
my $pre = '> ';

sub requote($){
  my $rest = shift;
  chomp $rest;

  my $res;

  # do line break  
  while ($rest =~ /^(.{$linebreak})(.*)/o) {
    my $line = $1;
    $rest = $2;
    
    # try to break at space
    if ($line =~ /^(.* )(.*)$/) {
      $line = $1;
      $rest = $2.$rest;      
    }
    $res .= $pre . $line . "\n";
  }	
  $res .= $pre . $rest . "\n";

  return $res;
}

while (<>){
  my $line = $_;
  if ($line =~ /^> (.*)/){
    $line = requote($1);
  }
  print $line;
}
