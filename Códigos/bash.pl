#!/usr/bin/env perl

=pod
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
=cut

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'pc_info',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

$buffer = $ENV{'QUERY_STRING'};
if($buffer =~ /\w=(.+)/){
  $buffer=$1;
}
$buffer="df -h";
system("Bash/Bash $buffer");

sub get_info{
	@h= split "\n", `cat $_[0]`;
	foreach $a(@h){
  	print $q->p($a),
       	$q->end_html;
	}
}

$out="output";
print $q->h3("SALIDA BASH");
get_info($out);
