package Import::Compiling;
use strict;
use warnings;
use Devel::CompileLevel qw(compile_caller);
use Carp qw(carp);

sub _gensub {
  my ($module, $method) = @_;
  if (!$module->can($method)) {
    (my $file = "$module.pm") =~ s{::}{/}g;
    if (!$INC{$file}) {
      carp "Can't find $method method in $module.  Did you forget to load it?";
    }
  }
  my ($package, $file, $line) = compile_caller;
  my $code = <<"END_CODE";
package $package;
#line $line "$file"
sub { \$module->$method(\@_) }
END_CODE
  return(eval $code or die $@);
}

sub import::compiling {
  my $module = shift;
  _gensub($module, 'import')->(@_);
}

sub unimport::compiling {
  my $module = shift;
  _gensub($module, 'unimport')->(@_);
}

1;
__END__

=head1 NAME

Import::Compiling - Import a module at the compiling code

=head1 SYNOPSIS

  package MyExporter;
  use Import::Compiling;
  use OtherExporter ();

  sub import {
    OtherExporter->import::compiling('arg1');
  }

=head1 DESCRIPTION

Like L<Import::Into>, but always exports to the level where code is being
compiled.

=head1 METHODS

=head2 import::compiling

Exp
