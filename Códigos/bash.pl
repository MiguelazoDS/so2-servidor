#!/usr/bin/env perl

my $data;
use File::Slurp;
BEGIN {
    $data = read_file('bash.h');
}

use Inline (Config =>
            DIRECTORY => '.Inline',
           );

use Inline C => $data;

$buffer = $ENV{'QUERY_STRING'};
if($buffer =~ /\w=(.+)/){
  $buffer=$1;
}

#Llamada a bash.h

print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<link rel=\"stylesheet\" href=\"style.css\"";
print "</head>";
print "<body>";
print "<a href=$buffer>DOWNLOAD FILE</a>";
print "</body>";
print "</html>";
1;
