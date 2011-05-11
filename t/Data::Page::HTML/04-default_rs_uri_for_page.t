# Pragmas.
use strict;
use warnings;

# Modules.
use Data::Page::HTML;
use Test::More 'tests' => 5;

# Test.
my $sub = Data::Page::HTML::default_rs_uri_for_page();
is(ref $sub, 'CODE', 'default_rs_uri_for_page() returns code reference.');

# Test.
my $ret = $sub->(1, 'text');
is($ret, '<a href="1">text</a>');

# Test.
$ret = $sub->(1, 'text', 'class');
is($ret, '<a href="1" class="class">text</a>');

# Test.
$sub = Data::Page::HTML::default_rs_uri_for_page('prefix');
is(ref $sub, 'CODE', 'default_rs_uri_for_page() returns code reference.');

# Test.
$ret = $sub->(1, 'text', 'class');
is($ret, '<a href="prefix1" class="class">text</a>');
