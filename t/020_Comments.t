#!/usr/bin/perl
use warnings;
use strict;
use lib ('lib');
use Test::More 'no_plan';
use Petal;
use Petal::Parser::XP;
$Petal::INPUT = 'XML';

my $template_file = 'comments.xml';
$Petal::DISK_CACHE = 0;
$Petal::MEMORY_CACHE = 0;
$Petal::TAINT = 1;
$Petal::BASE_DIR = 't/data';

my $template = new Petal ($template_file);
unlike ($template->process() => qr/^\<\!/);
