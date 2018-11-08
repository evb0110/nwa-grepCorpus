my $all = "all.txt".IO.slurp;

my @all = $all.split( / \n \s* \n / );

for @all.grep(/ \S /) -> $one {
  my @lines = $one.lines;
  my $number1 = @lines[1] ~~ / ^ \d+ /;
  my $number2 = @lines[2] ~~ / ^ \d+ /;
  put "$one\n===\n" unless $number1 == $number2;
}
