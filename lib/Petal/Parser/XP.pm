# ------------------------------------------------------------------
# Petal::Parser::XP - Fires Petal::Canonicalizer events
# ------------------------------------------------------------------
# A Wrapper class for XML::Parser which plugs into Petal backend
# for complete parsing backwards compatibility with Petal < 1.10.
# ------------------------------------------------------------------
package Petal::Parser::XP;
use strict;
use warnings;
use Petal;
use XML::Parser;

use vars qw /$Canonicalizer @NameSpaces @XI_NameSpaces/;

$Petal::INPUTS->{'XML'} = 'Petal::Parser::XP';

our $VERSION = '1.00';


sub new
{
    my $class = shift;
    $class = ref $class || $class;
    return bless { @_ }, $class;
}


sub process
{
    my $self = shift;
    local $Canonicalizer = shift;
    local @NameSpaces = ();
    
    my $data_ref = shift;
    $data_ref = (ref $data_ref) ? $data_ref : \$data_ref;
    my $parser = new XML::Parser (
	Style    => 'Stream',
	Pkg      => ref $self,
       );
    
    $parser->parse ($$data_ref);
}


sub StartTag
{
    # process the Petal namespace...
    my $ns = (scalar @NameSpaces) ? $NameSpaces[$#NameSpaces] : $Petal::NS;
    foreach my $key (keys %_)
    {
	my $value = $_{$key};
	if ($value eq $Petal::NS_URI)
	{
	    next unless ($key =~ /^xmlns\:/);
	    delete $_{$key};
	    $ns = $key;
	    $ns =~ s/^xmlns\://;
	}
    }
    
    push @NameSpaces, $ns;
    local ($Petal::NS) = $ns;
    
    # process the XInclude namespace
    my $xi_ns = (scalar @XI_NameSpaces) ? $XI_NameSpaces[$#XI_NameSpaces] : $Petal::XI_NS;
    foreach my $key (keys %_)
    {
	my $value = $_{$key};
	if ($value eq $Petal::XI_NS_URI)
	{
	    next unless ($key =~ /^xmlns\:/);
	    delete $_{$key};
	    $xi_ns = $key;
	    $xi_ns =~ s/^xmlns\://;
	}
    }
    
    push @XI_NameSpaces, $xi_ns;
    local ($Petal::XI_NS) = $xi_ns;
    
    $Canonicalizer->StartTag();
}


sub EndTag
{
    local ($Petal::NS) = pop (@NameSpaces);
    local ($Petal::XI_NS) = pop (@XI_NameSpaces);
    $Canonicalizer->EndTag()
}


sub Text
{
    local ($Petal::NS) = $NameSpaces[$#NameSpaces];
    local ($Petal::XI_NS) = $XI_NameSpaces[$#XI_NameSpaces];
    s/\&/\&amp;/g;
    s/\</\&lt\;/g;
    $Canonicalizer->Text();
}


1;


__END__


=head1 NAME

Petal::Parser::XP - XML::Parser backend for Petal parsing


=head1 SYNOPSIS

  use Petal;
  use Petal::Parser::XP;


=head1 SUMMARY

Petal used to depend on both XML::Parser and HTML::TreeBuilder for HTML
parsing. This has been changed to MKDoc::XML. If you want the XML parsing
exactly as it was before though, you can use this module with Petal > 1.10.

Using this module will change $Petal::INPUTS->{XML} to 'Petal::Parser::XP'.
This will result in using the same code as in Petal < 1.10 for XML Parsing.


=head1 EXPORTS

None.


=head1 KNOWN BUGS

XML::Parser is deprecated and should be replaced by SAX handlers at some point.

Because XML::Parser is used in Stream mode, your comments will be always stripped.


=head1 AUTHOR

Copyright 2003 - MKDoc Holdings Ltd.

Authors: Jean-Michel Hiver <jhiver@mkdoc.com>.

This module free software and is distributed under the same license as Perl
itself. Use it at your own risk.


=head1 SEE ALSO

  L<Petal>


Join the Petal mailing list:

  http://lists.webarch.co.uk/mailman/listinfo/petal


Mailing list archives:

  http://lists.webarch.co.uk/pipermail/petal


Any extra questions? jhiver@mkdoc.com.

=cut
