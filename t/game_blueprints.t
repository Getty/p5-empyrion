#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin '$Bin';

use Empyrion::Blueprint;

my %starters = (
  BA_Starter_Tier1 => [2,8,13,14,0,0],
  BA_XenuRareSupplyStation => [2,9,19,20,1,-3],
  CV_Starter_Tier1 => [8,7,13,23,0,0],
  HV_Starter_Tier1 => [16,6,9,13,0,0],
  SV_Starter_Tier1 => [4,5,11,14,0,0],
);

for my $key (sort { $a cmp $b } keys %starters) {
  my $starter = $starters{$key};
  my $bp = Empyrion::Blueprint->new($Bin.'/game_blueprints/'.$key.'.epb');
  is($bp->type,$starter->[0],'Type of '.$key.' is '.$starter->[0]);
  is($bp->height,$starter->[1],'Height of '.$key.' is '.$starter->[1]);
  is($bp->width,$starter->[2],'Width of '.$key.' is '.$starter->[2]);
  is($bp->depth,$starter->[3],'Depth of '.$key.' is '.$starter->[3]);
  is($bp->remove_terrain ? 1 : 0,$starter->[4],'Remove terrain of '.$key.' is '.($starter->[4] ? 'on' : 'off' ));
  is($bp->z_position,$starter->[5],'Z-position of '.$key.' is '.$starter->[5]);
}

done_testing;

