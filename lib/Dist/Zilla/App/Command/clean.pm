use strict;
use warnings;
package Dist::Zilla::App::Command::clean;
# ABSTRACT: clean up after build, test, or install
use Dist::Zilla::App -command;

use File::Find::Rule;

=head1 SYNOPSIS

Removes some files that are created during build, test, and install.

    dzil clean

=head1 REMOVED FILES

    ^.build
    ^<distribution-name>-*

ie:

    removing .build
    removing Foo-Bar-1.09010
    removing Foo-Bar-1.09010.tar.gz

=cut

sub abstract { 'clean up after build, test, or install' }

sub execute {
  my ($self, $opt, $arg) = @_;

  require File::Path;
  for my $x (grep { -e } '.build', glob($self->zilla->name . '-*')) {
    $self->log("clean: removing $x");
    File::Path::rmtree($x);
  };

  # removing leftovers
  my @temps =
    File::Find::Rule
    ->file
    ->name( qr/~$/ )
    ->in('.');
  unlink @temps;
}

1;
