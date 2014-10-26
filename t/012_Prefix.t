#!/usr/bin/perl
use warnings;
use strict;
use lib ('lib');
use Test::More 'no_plan';
use Petal;
use Petal::Parser::XP;
$Petal::INPUT = 'XML';

$Petal::BASE_DIR = './t/data/';
$Petal::DISK_CACHE = 0;
$Petal::MEMORY_CACHE = 0;
$Petal::TAINT = 1;

my $template = new Petal ('prefix.xml');
my $string = $template->process;
like ($string, qr/<some:stuff>/);
like ($string, qr/<\/some:stuff>/);
