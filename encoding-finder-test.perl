#!/usr/bin/perl -w
use strict;

my $software_file = 'encoding-finder.perl';
my $test_failed = 0;

my $iso_1 = `cat text/iso-latin-1_text.txt | perl $software_file`;
if($iso_1 =~ /ISO-Latin-1/i){
  print "Test ISO-Latin-1 passed\n";
}
else{
  print "Test ISO-Latin-1 FAILED!!!\n";
  $test_failed++;
}


my $utf_8 = `cat text/utf-8_text.txt | perl $software_file`;
if($utf_8 =~ /utf-8/i){
  print "Test utf-8 passed\n";
}
else{
  print "Test utf-8 FAILED!!!\n";
  $test_failed++;
}


my $utf_16le = `cat text/utf-16-le_text.txt | perl $software_file`;
if($utf_16le =~ /utf16-le/i){
  print "Test utf-16le passed\n";
}
else{
  print "Test utf-16le FAILED!!!\n";
  $test_failed++;
}


my $utf_16be = `cat text/utf-16-be_text.txt | perl $software_file`;
if($utf_16be =~ /utf16-be/i){
  print "Test utf-16be passed\n";
}
else{
  print "Test utf-16be FAILED!!!\n";
  $test_failed++;
}


  die "ERROR: $test_failed test failure\/s\n" unless($test_failed == 0);

  print "All the test have passed. Great job!\n";

