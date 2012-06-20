# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Generate page list HTML.';
author 'Michal Jurosz <mj@mj41.cz>';
author 'Michal Špaček <skim@cpan.org>';
license 'perl';
name 'Data-Page-HTML';
requires 'Exporter' => 0;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Data-Page-HTML';
resources 'homepage' => 'https://github.com/tupinek/Data-Page-HTML';
resources 'repository' => 'git://github.com/tupinek/Data-Page-HTML';
test_requires 'Cwd' => 0;
test_requires 'Data::Page' => 0;
test_requires 'English' => 0;
test_requires 'File::Spec' => 0;
test_requires 'FindBin' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.11';

# Run.
WriteAll();
