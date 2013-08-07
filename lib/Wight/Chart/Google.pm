package Wight::Chart::Google;

#ABSTRACT: Save google charts to images using phantomjs

our $VERSION = '0.001'; # VERSION
#
# 

use strictures 1;
use Moo;
use Template::Tiny;
use Wight;
use File::Share qw/dist_file/;
use Cwd;
use JSON::XS;

#TODO: import roles for each type for more options
my $types = {
  line => "LineChart",
  area => "AreaChart",
  bar => "BarChart",
  spark => 'ImageSparkLine',
};

has 'type' => ( is => 'rw', required => 1, isa => sub { $types->{$_[0]} } );
has 'output' => ( is => 'rw', default => sub { 'chart.png'} );
has 'rows' => ( is => 'rw' );
has 'options' => ( is => 'rw', default => sub { {} } );
has 'columns' => ( is => 'rw' );
has 'wight' => ( is => 'lazy' );
has 'width' => ( is => 'rw', default => 900 );
has 'height' => ( is => 'rw', default => 500 );

sub _build_wight {
  my $self = shift;
  my $wight = Wight->new();
  #really?
  my $file = -e 'share/chart.html' ?
    getcwd . '/share/chart.html'
    :
    dist_file('Wight-Chart-Google', 'chart.html');


  $wight->resize($self->width + 20, $self->height + 20);
  $wight->visit("file:///$file");
  $wight;
}

sub render {
  my ($self) = @_;
  my $w = $self->wight;
  my $options = {
    chartArea => {
      width => $self->width - 100,
      height => $self->height - 100,
    },
    %{$self->options}
  };

  my $args = encode_json({
    options => $options,
    type => $types->{$self->type},
    rows => $self->rows,
    columns => $self->columns,
  });
  #warn $args;
  $w->evaluate("drawChart($args)");
  $w->render($self->output);
}


1;

__END__

=pod

=encoding utf-8

=head1 NAME

Wight::Chart::Google - Save google charts to images using phantomjs

=head1 VERSION

version 0.001

=head1 SYNOPSIS

  use Wight::Chart::Google;

  my $chart = Wight::Chart::Google->new(
    type => "area",
    width => 900,
    height => 500,
    options => {
      backgroundColor => 'transparent',
      hAxis => { gridlines => { color => "#fff" } },
      vAxis => { gridlines => { color => "#fff" } },
      legend => { position => 'none' },
    }
  );
  $chart->columns([
    { name => 'Day', type => 'string' },
    { name => 'Amount', type => 'number' },
  ]);
  $chart->rows([['1st',100], ['2nd',150], ['3rd',50], ['4th',70]]);
  $chart->render();

=head1 NAME

Wight::Chart::Google - Generate static google charts

This is pre-release software, everything could change and there are definitely bugs.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/papercreatures/wight-chart-google/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/papercreatures/wight-chart-google>

  git clone git://github.com/papercreatures/wight-chart-google.git

=head1 AUTHOR

Simon Elliott <simon@papercreatures.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Simon Elliott.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
