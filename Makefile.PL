# Pragmas.
use strict;
use warnings;

# Modules.
use ExtUtils::MakeMaker;

# Definition.
WriteMakefile(
	'AUTHOR' => 'Michal Jurosz <mj@mj41.cz>',
	'BUILD_REQUIRES' => {
		'Cwd' => 0,
		'Data::Page' => 0,
		'English' => 0,
		'File::Spec' => 0,
		'FindBin' => 0,
		'Test::More' => 0,
		'Test::Pod' => 0,
		'Test::Pod::Coverage' => 0,
	},
	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker' => 0,
	},
	'NAME' => 'Data::Page::HTML',
	'VERSION' => 0.11,
	'PREREQ_PM' => {
		'Exporter' => 0,
		'Readonly' => 0,
	},
	'test' => {
		'TESTS' => 't/Data::Page::HTML/*.t',
	},
);
