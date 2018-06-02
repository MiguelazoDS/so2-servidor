#!/usr/bin/env perl

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
