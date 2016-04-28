package Empyrion::Base;
# ABSTRACT: Base class for distribution packages

use MooX ();

sub import { MooX->import::into(scalar caller, qw( +Carp +Path::Tiny +bytes )) }

1;