#!/usr/bin/perl6

constant $searchTextus = True;

my $vowel = / :m <[aeiouə]> /;
my $consonant = /
                  <!before <$vowel>>
                  <!before <[ʔwy]>>
                  <:L>
                /;

my $reg = /
         $
         /;

use Colorize;

class Text {
  has Str $.corpus;
  has Str $.title;
  has Str $.number;
  has Str @.textus;
  has Str @.versio;
}

my @dirs = 
  '/home/evb/MAILRU/Linguae/Maalula/_CORPUS'
        .IO.dir.grep( ! (* ~~ /TRANS | git/))
        .grep(*.d).sort; 
       # this can be changed to include all the corpus


my Text @text;

for @dirs -> $dirText {
  my $dirTrans = $dirText ~ " TRANS";
  for dir($dirText).grep(*.f).sort -> $file {
    my $title = ~ $file.basename;
    my $number = ~ ( $title ~~ / ^ \d+ / );
    my @textus = $file.lines;
    my $transfile = ($dirTrans ~ '/' ~ $title).IO;
    my @versio = $transfile.f ?? $transfile.lines !! "";
    my $currentText =
       Text.new(
         corpus => $dirText.IO.basename,
         title => $title,
         number => $number,
         textus => @textus,
         versio => @versio
       );
    @text.push: $currentText;
  }
}

for @text -> $currentText {
  my $corpus = $currentText.corpus;
  my @textus = $currentText.textus;
  my @versio = $currentText.versio;
  my $title = $currentText.title;
  my $titleColor = ($corpus, $title).join(": ");
  for @textus.kv -> $k, $v {
    color( / \N+ /, $under, $filled, $magenta, $titleColor );
    my $textusLine = $v;
    my $versioLine = @versio[$k] // "";
    ($textusLine, $versioLine) .= reverse
         unless $searchTextus;
    if $textusLine ~~ $reg {
      color( $reg, $bold, $filled, $red, $textusLine );
      color( / \N+ /, $normal, $filled, $blue, $versioLine );
      put $titleColor;
      put $textusLine;
      put $versioLine;
      put "";
    }
  }
}
