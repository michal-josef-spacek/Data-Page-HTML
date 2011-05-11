# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Jurosz <mj@mj41.cz>',
	'NAME' => 'Data::Page::HTML',
	'VERSION' => 0.11,
	'test' => {
		'TESTS' => 't/Data::Page::HTML/*.t',
	},
);
