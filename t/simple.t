use Test::More;

BEGIN { use_ok( 'Wight::Chart::Google' ); }

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

done_testing;
