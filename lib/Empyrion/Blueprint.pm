package Empyrion::Blueprint;
# ABSTRACT: Class representing an Empyrion blueprint

use Empyrion::Base;

has bytes => (
  is => 'ro',
  required => 1,
);

around BUILDARGS => sub {
  my ( $orig, $class, @args ) = @_;
 
  if (scalar @args % 2) {
    my $filename = shift @args;
    my $bytes = path($filename)->slurp_raw;
    push @args, bytes => $bytes;
  }

  return $class->$orig(@args);
};

has data => (
  is => 'lazy',
  clearer => 'reset_data',
);

sub _build_data {
  my ( $self ) = @_;
  my %data;
  my @ba = map { ord($_) } split(//, $self->bytes);
  $data{type} = $ba[0x08];
  $data{height} = $ba[0x0D];
  $data{width} = $ba[0x09];
  $data{depth} = $ba[0x11];
  $data{remove_terrain} = $ba[0x21];
  $data{spawn_group_length} = $ba[0x64];
  $data{spawn_group} = join('',map { chr($_) } @ba[0x65 .. (0x64+$data{spawn_group_length})]) if $data{spawn_group_length};
  $data{z_position} = unpack("l",pack("C*",@ba[0x2B .. 0x2E]));
  return \%data;
}

sub type { shift->data->{type} }
sub height { shift->data->{height} }
sub width { shift->data->{width} }
sub depth { shift->data->{depth} }
sub remove_terrain { shift->data->{remove_terrain} }
sub spawn_group_length { shift->data->{spawn_group_length} }
sub spawn_group { shift->data->{spawn_group} }
sub z_position { shift->data->{z_position} }

sub type_name {
  my ( $self ) = @_;
  return $self->type == 16 ? 'Hover Vessel'
    : $self->type == 8 ? 'Capital Vessel'
    : $self->type == 4 ? 'Small Vessel'
    : $self->type == 2 ? 'Base'
    : 'Unknown Type '.$self->type;
}

sub _replace {
  my ( $self, $from, $length, $new ) = @_;
  substr($self->bytes,$from,$length,$new);
  $self->reset_data;
  return $self;  
}

sub set_spawn_group {
  my ( $self, $name ) = @_;
  $name = "" unless defined $name;
  return $self->_replace(0x64,$self->spawn_group_length+1,chr(length($name)).$name);
}

sub set_remove_terrain {
  my ( $self, $remove_terrain ) = @_;
  return $self->_replace(0x21,1,chr($remove_terrain ? 1 : 0));
}

sub set_z_position {
  my ( $self, $z_position ) = @_;
  return $self->_replace(0x2B,4,pack("l",$z_position));
}

sub save {
  my ( $self, $filename ) = @_;
  my $path = path($filename);
  $path->spew_raw($self->bytes);
  return $path;
}

1;
