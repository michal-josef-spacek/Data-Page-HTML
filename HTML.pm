package Data::Page::HTML;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(default_rs_uri_for_page get_pager_html);
Readonly::Scalar my $DOTS => q{…};
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = '0.11';

=head1 NAME

Data::Page::HTML

=head1 SYNOPSIS

  use Data::Page::HTML qw(get_pager_html);
  my $sub_uri = default_rs_uri_for_page('http://www.example.com/list.pl?number=');
  my $pager_html = get_pager_html($data_page, 'show-page-', 3);

=head1 DESCRIPTION

Generate page list HTML.

=head1 SUBROUTINES

=over 8

=item C<default_rs_uri_for_page($page_uri_prefix)>

 $page_uri_prefix - Main URI for link.

 Return reference to subroutine with arguments:
 $page_num - Number of page.
 $text - Main data in anchor element.
 $class_name - CSS class name.
 Subroutine return HTML code for anchor.

=cut

sub default_rs_uri_for_page {
	my $page_uri_prefix = shift;
	if (! defined $page_uri_prefix) {
		$page_uri_prefix = $EMPTY_STR;
	}
	return sub {
		my ($page_num, $text, $class_name) = @_;
		return '<a href="'.$page_uri_prefix.$page_num.'"'
			.($class_name ? ' class="'.$class_name.'"'
			: $EMPTY_STR)
			.'>'.$text.'</a>';
	};
}

=item C<get_pager_html($pager, $uri_param, $near_links_num)>

 $pager - Data::Page object, $rs->pager or something.
 $uri_param - Reference to subroutine as default_rs_uri_for_page(), hash with 'prefix' URI, main URI for link or default 'page-'.
 $near_links_num - Near links number.

 Returns HTML code.

=cut

sub get_pager_html {
	my ($pager, $uri_param, $near_links_num) = @_;

	# Anchor subroutine.
	my $rs_uri_for_page;
	if (ref $uri_param eq 'CODE') {
		$rs_uri_for_page = $uri_param;
	} elsif (ref $uri_param eq 'HASH') {
		$rs_uri_for_page = default_rs_uri_for_page(
			$uri_param->{'prefix'});
	} else {
		if (! $uri_param) {
			$uri_param = 'page-';
		}
		$rs_uri_for_page = default_rs_uri_for_page($uri_param);
	}

	# Near links number.
	if (! defined $near_links_num) {
		$near_links_num = 3;
	}

	# Main paging.
	my $current = $pager->current_page;
	my $last = $pager->last_page;
	if ($last <= 1) {
		return $EMPTY_STR;
	}
	my $ot = '<div class="pages">'.
		'<span class="text">Page '.$current.'/'.$last.'</span>';
	if ($current > 1) {
		$ot .= $rs_uri_for_page->($current - 1, '&laquo;', 'arrow');
	} else {
		$ot .= '<span class="a-arrow disabled">&laquo;</span>';
	}
	my $from = $current - $near_links_num;
	if ($from < 1) {
		$from = 1;
	}
	my $to = $current + $near_links_num;
	if ($to > $last) {
		$to = $last;
	}
	if ($current > $near_links_num + 1) {
	        $ot .= $rs_uri_for_page->(1, 1);
		if ($current > $near_links_num + 2) {
			$ot .= $DOTS;
		}
	}
	for (my $i = $from; $i <= $to; $i++) {
		if ($i == $current) {
			$ot .= '<span class="a selected">'.$i.'</span>';
		} else {
			$ot .= $rs_uri_for_page->($i, $i);
		}
	}
	if ($current < $last-$near_links_num) {
		if ($current < ($last - $near_links_num - 1)) {
			$ot .= $DOTS;
		}
		$ot .= $rs_uri_for_page->($last, $last);
	}
	if ($current < $last) {
		$ot .= $rs_uri_for_page->($current + 1, '&raquo;', 'arrow').
			$SPACE;
	} else {
		$ot .= '<span class="a-arrow disabled">&raquo;</span>'.$SPACE;
	}
	$ot .=  '</div>';

	# Result.
	return $ot;
}

=back

=head1 ERRORS

 None.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Data::Page::HTML qw(default_rs_uri_for_page);

 # Get subroutine.
 my $a_sub = default_rs_uri_for_page('http://www.example.com/list.pl?number=');

 # Print out.
 print $a_sub->('_NUMBER_', '_TEXT_', '_CLASS_');

 # Output:
 # <a href="http://www.example.com/list.pl?number=_NUMBER_" class="_CLASS_">_TEXT_</a>

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Data::Page;
 use Data::Page::HTML qw(get_pager_html);

 # Data::Page object.
 my $pager = Data::Page->new;
 $pager->total_entries(100);
 $pager->entries_per_page(10);
 $pager->current_page(3);

 # Get HTML code.
 my $pager_html = get_pager_html($pager, 'show-page-', 3);

 # Print out.
 print $pager_html."\n";

 # Output (non indented):
 # <div class="pages">
 #   <span class="text">Page 3/10</span>
 #   <a href="show-page-2" class="arrow">&laquo;</a>
 #   <a href="show-page-1">1</a>
 #   <a href="show-page-2">2</a>
 #   <span class="a selected">3</span>
 #   <a href="show-page-4">4</a>
 #   <a href="show-page-5">5</a>
 #   <a href="show-page-6">6</a>
 #   …
 #   <a href="show-page-10">10</a>
 #   <a href="show-page-4" class="arrow">&raquo;</a>
 # </div>

=head1 SEE ALSO

L<Data::Page(3pm)>,
L<CatalystX::Controller::TableBrowser(3pm)>.

=head1 AUTHOR

Michal Jurosz <mj@mj41.cz>,
Michal Špaček <skim@cpan.org>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
