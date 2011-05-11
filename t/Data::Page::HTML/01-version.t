# Pragmas.
use strict;
use warnings;

# Modules.
use Data::Page::HTML;
use Test::More 'tests' => 1;

# Test.
is($Data::Page::HTML::VERSION, '0.11', 'Version.');
