use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Petal-Parser-XP',
    'VERSION_FROM'	=> 'lib/Petal/Parser/XP.pm', # finds $VERSION
    'PREREQ_PM'		=> {
	'Petal'             => '1.10',
        'XML::Parser'       => '2.31',
	'Test::Harness'	    => '2.00',
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Petal/Parser/XP.pm', # retrieve abstract from module
       AUTHOR     => 'Jean-Michel Hiver <jhiver@mkdoc.com>') : ()),
);


1;


package MY;


sub postamble {
    return <<EOF;
cover ::
	\$(RM_RF) cover_db
	PERL5OPT=-MDevel::Cover \$(MAKE) test || true
	cover -report html cover_db > /dev/null

EOF

}


1;
