package App::EmpyrionBlueprint;

use Empyrion::Base;
use MooX::Options;
use Empyrion::Blueprint;

option 'spawn_group' => (
  is => 'ro',
  format => 's',
  predicate => 1,
  doc => 'set a new spawn group to the blueprint',
);

option 'no_spawn_group' => (
  is => 'ro',
  negativable => 0,
  doc => 'unset existing spawn group',
);

option 'z_position' => (
  is => 'ro',
  format => 's',
  predicate => 1,
  doc => 'set new z position for the blueprint',
);

option 'remove_terrain' => (
  is => 'ro',
  negativable => 1,
  predicate => 1,
  doc => 'remove terrain around base on random spawn',
);

option 'from' => (
  is => 'ro',
  format => 's',
  required => 1,
  doc => 'filename to open (required)',
);

option 'to' => (
  is => 'ro',
  format => 's',
  predicate => 1,
  doc => 'save changed blueprint here',
);

sub run {
  my ( $self ) = @_;
  my $bp = Empyrion::Blueprint->new($self->from);
  $bp->set_spawn_group($self->spawn_group) if $self->has_spawn_group;
  $bp->set_spawn_group(undef) if $self->no_spawn_group;
  $bp->set_spawn_group($self->spawn_group) if $self->has_spawn_group;
  $bp->set_z_position($self->z_position) if $self->has_z_position;
  $bp->set_remove_terrain($self->remove_terrain) if $self->has_remove_terrain;
  print "\n";
  if ($self->has_to) {
    my $path = $bp->save($self->to);
    print "Saved new blueprint to: ".$path->absolute->stringify."\n";
  } else {
    print "Type:           ".$bp->type_name."\n";
    print "Dimensions:     ".$bp->width."/".$bp->height."/".$bp->depth." (w/h/d)\n";
    print "Remove Terrain: ".($bp->remove_terrain ? 'Yes' : 'No')."\n";
    if ($bp->spawn_group_length) {
      print "Spawn Group:    ".$bp->spawn_group."\n";
    }
    print "Z-position:     ".$bp->z_position."\n";
  }
  print "\n";
  return 0;
}

1;
