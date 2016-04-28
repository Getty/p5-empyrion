#!perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use Empyrion::Blueprint;
use Path::Tiny;

my %byte;

path($ARGV[0] || ".")->visit( sub {
  my ($path, $state) = @_;
  return if $path->is_dir;
  return unless $path =~ /\.epb$/;
  my $bp = Empyrion::Blueprint->new($path);
  my $ninenine = substr($bp->bytes,0,99);
  my @bytes = split(//,$ninenine);
  for (0..(scalar @bytes)-1) {
    if (ord($bytes[$_]) != 0) {
      $byte{$_} = {} unless defined $byte{$_};
      $byte{$_}->{$bp->spawn_group ? $bp->spawn_group.': '.$path->basename : $path->basename} = ord($bytes[$_]);
    }
  }
}, { recurse => 1 });

for my $curr (sort { $a <=> $b }keys %byte) {
  my $bs = $byte{$curr};
  print $curr.": AlienBA ".( $bs->{'AlienBaseSave.epb'} || 0 )." StarterBA ".( $bs->{'BaseStarter.epb'} || 0 )." OutpostBA ".( $bs->{'MyOutpost.epb'} || 0 )." FalconSV ".( $bs->{'Falcon-MKI.epb'} || 0 )."\n";
  for my $o (sort { $bs->{$a} <=> $bs->{$b}  } keys %{$bs}) {
    if ($o =~ /: /) {
      print "      ".sprintf('%4d',$bs->{$o})." ".$o."\n";
    }
  }
}
