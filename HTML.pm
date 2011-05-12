package Data::Page::HTML;

use base qw(Exporter);
use strict;
use warnings;
our $VERSION = '0.11';

our @EXPORT_OK = qw/get_pager_html/;

=head1 NAME

Data::Page::HTML

=head1 SYNOPSIS

  use Data::Page::HTML qw/get_pager_html/;

  my $pager = ... ; # Data::Page object, $rs->pager or something
  my $page_uri_prefix = 'show-page-';
  my $near_links_num = 3;
  my $pager_html = get_pager_html( $pager, $page_uri_prefix, $near_links_num );

=head1 DESCRIPTION

Generate page list HTML.

=head1 SUBROUTINES

=over 8

=item C<default_rs_uri_for_page($page_uri_prefix)>

TODO

=cut

sub default_rs_uri_for_page {
    my $page_uri_prefix = shift;
    $page_uri_prefix = '' unless defined $page_uri_prefix;

    return sub {
        my ( $page_num, $text, $class_name ) = @_;
        return
            '<a href="' . $page_uri_prefix . $page_num . '"'
            . ( $class_name ? (' class="'.$class_name.'"' ) : '' )
            . '>' . $text . '</a>'
        ;
    };
}

=item C<get_pager_html($pager, $uri_param, $near_links_num)>

TODO

=cut

sub get_pager_html {
    my ( $pager, $uri_param, $near_links_num ) = @_;

    my $rs_uri_for_page;
    if ( ref $uri_param eq 'SUB' ) {
        $rs_uri_for_page = $uri_param;
    } elsif ( ref $uri_param eq 'HASH' ) {
        $rs_uri_for_page = default_rs_uri_for_page( $uri_param->{prefix});
    } else {
        $uri_param = 'page-' unless $uri_param;
        $rs_uri_for_page = default_rs_uri_for_page( $uri_param, '' );
    }

    $near_links_num = 3 unless defined $near_links_num;

    my $current = $pager->current_page;
    my $last = $pager->last_page;
    return '' if $last <= 1;

    my $ot = '';
    $ot .= '<div class=pages>';
    $ot .= '<span class=text>' . 'Page' . ' ' . $current . '/' . $last . '</span>';

    if ( $current > 1 ) {
        $ot .= $rs_uri_for_page->( $current-1, '&laquo;', 'arrow' );
    } else {
        $ot .= '<span class="a-arrow disabled">' . '&laquo;' . '</span>';
    }

    my $from = $current - $near_links_num;
    $from = 1 if $from < 1;
    my $to = $current + $near_links_num;
    $to = $last if $to > $last;

    if ( $current > $near_links_num+1 ) {
        $ot .= $rs_uri_for_page->( 1, 1 );
        if ( $current > $near_links_num+2 ) {
            $ot .= '...';
        }
    }

    for ( my $i=$from; $i<=$to; $i++ ) {
        if ( $i == $current ) {
            $ot .= '<span class="a selected">' . $i . '</span>';
        } else {
            $ot .= $rs_uri_for_page->( $i, $i );
        }
    }

    if ( $current < $last-$near_links_num ) {
        if ( $current < ($last-$near_links_num-1) ) {
            $ot .= '...';
        }
        $ot .= $rs_uri_for_page->( $last, $last );
    }

    if ( $current < $last ) {
        $ot .= $rs_uri_for_page->( $current+1, '&raquo;', 'arrow' ) . ' ';
    } else {
        $ot .= '<span class="a-arrow disabled">' . '&raquo;' . '</span>' . ' ';
    }
    $ot .=  "</div>";
    return $ot;
}

=back

=head1 SEE ALSO

L<Data::Page>, L<CatalystX::Controller::TableBrowser>

=head1 AUTHOR

Michal Jurosz <mj@mj41.cz>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
