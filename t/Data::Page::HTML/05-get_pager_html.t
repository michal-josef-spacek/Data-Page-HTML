# Pragmas.
use strict;
use warnings;

# Modules.
use Data::Page;
use Data::Page::HTML qw(get_pager_html);
use Test::More 'tests' => 11;

# Test.
my $data_page = Data::Page->new;
$data_page->total_entries(30);
$data_page->entries_per_page(10);
$data_page->current_page(1);
my $ret = get_pager_html($data_page);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 1/3</span>'.
		'<span class="a-arrow disabled">&laquo;</span>'.
		'<span class="a selected">1</span>'.
		'<a href="page-2">2</a>'.
		'<a href="page-3">3</a>'.
		'<a href="page-2" class="arrow">&raquo;</a>'.
		' </div>',
	'Three pages, actual is first page.',
);

# Test.
$data_page->current_page(2);
$ret = get_pager_html($data_page);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 2/3</span>'.
		'<a href="page-1" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'<span class="a selected">2</span>'.
		'<a href="page-3">3</a>'.
		'<a href="page-3" class="arrow">&raquo;</a>'.
		' </div>',
	'Three pages, actual is second page.',
);

# Test.
$data_page->current_page(3);
$ret = get_pager_html($data_page);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 3/3</span>'.
		'<a href="page-2" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'<a href="page-2">2</a>'.
		'<span class="a selected">3</span>'.
		'<span class="a-arrow disabled">&raquo;</span>'.
		' </div>',
	'Three pages, actual is last page.',
);

# Test.
$data_page->current_page(1);
$ret = get_pager_html($data_page, 'xxx-');
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 1/3</span>'.
		'<span class="a-arrow disabled">&laquo;</span>'.
		'<span class="a selected">1</span>'.
		'<a href="xxx-2">2</a>'.
		'<a href="xxx-3">3</a>'.
		'<a href="xxx-2" class="arrow">&raquo;</a>'.
		' </div>',
	'Three pages, actual is first page. Set URI parameter name.',
);

# Test.
$ret = get_pager_html($data_page, { 'prefix' => 'xxx-' });
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 1/3</span>'.
		'<span class="a-arrow disabled">&laquo;</span>'.
		'<span class="a selected">1</span>'.
		'<a href="xxx-2">2</a>'.
		'<a href="xxx-3">3</a>'.
		'<a href="xxx-2" class="arrow">&raquo;</a>'.
		' </div>',
	'Three pages, actual is first page. Set URI parameter name in hash.',
);

# Test.
$ret = get_pager_html($data_page, sub {
        my ( $page_num, $text, $class_name ) = @_;
        return
            '<a href="xxx-' . $page_num . '"'
            . ( $class_name ? (' class="'.$class_name.'"' ) : '' )
            . '>' . $text . '</a>'
        ;
});
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 1/3</span>'.
		'<span class="a-arrow disabled">&laquo;</span>'.
		'<span class="a selected">1</span>'.
		'<a href="xxx-2">2</a>'.
		'<a href="xxx-3">3</a>'.
		'<a href="xxx-2" class="arrow">&raquo;</a>'.
		' </div>',
	'Three pages, actual is first page. Set links as subroutine.',
);

# Test.
$data_page = Data::Page->new;
$data_page->total_entries(100);
$data_page->entries_per_page(10);
$data_page->current_page(3);
$ret = get_pager_html($data_page, undef, 1);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 3/10</span>'.
		'<a href="page-2" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'<a href="page-2">2</a>'.
		'<span class="a selected">3</span>'.
		'<a href="page-4">4</a>'.
		'...'.
		'<a href="page-10">10</a>'.
		'<a href="page-4" class="arrow">&raquo;</a>'.
		' </div>',
	'Ten pages, actual is fourth page. Set number of near links to one.',
);

# Test.
$data_page->current_page(5);
$ret = get_pager_html($data_page, undef, 1);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 5/10</span>'.
		'<a href="page-4" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'...'.
		'<a href="page-4">4</a>'.
		'<span class="a selected">5</span>'.
		'<a href="page-6">6</a>'.
		'...'.
		'<a href="page-10">10</a>'.
		'<a href="page-6" class="arrow">&raquo;</a>'.
		' </div>',
	'Ten pages, actual is fifth page. Set number of near links to one.',
);
# Test.
$data_page->current_page(5);
$ret = get_pager_html($data_page, undef, 1);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 5/10</span>'.
		'<a href="page-4" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'...'.
		'<a href="page-4">4</a>'.
		'<span class="a selected">5</span>'.
		'<a href="page-6">6</a>'.
		'...'.
		'<a href="page-10">10</a>'.
		'<a href="page-6" class="arrow">&raquo;</a>'.
		' </div>',
	'Ten pages, actual is fifth page. Set number of near links to one.',
);

# Test.
$data_page = Data::Page->new;
$data_page->total_entries(100);
$data_page->entries_per_page(10);
$data_page->current_page(8);
$ret = get_pager_html($data_page, undef, 1);
is(
	$ret,
	'<div class=pages>'.
		'<span class=text>Page 8/10</span>'.
		'<a href="page-7" class="arrow">&laquo;</a>'.
		'<a href="page-1">1</a>'.
		'...'.
		'<a href="page-7">7</a>'.
		'<span class="a selected">8</span>'.
		'<a href="page-9">9</a>'.
		'<a href="page-10">10</a>'.
		'<a href="page-9" class="arrow">&raquo;</a>'.
		' </div>',
	'Ten pages, actual is eight page. Set number of near links to one.',
);

# Test.
$data_page = Data::Page->new;
$data_page->total_entries(10);
$data_page->entries_per_page(10);
$data_page->current_page(1);
$ret = get_pager_html($data_page);
is($ret, '', 'Only one page.');
