#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  Empyrion
  Empyrion::Blueprint
  App::EmpyrionBlueprint
)) {
  use_ok($_);
}

done_testing;

