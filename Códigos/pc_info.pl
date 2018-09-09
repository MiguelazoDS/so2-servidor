#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'pc_info',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

#Función que abre e imprime lo que contiene un archivo del "proc".
sub get_info{
	@h= split "\n", `cat /proc/$_[0]`;
	foreach $a(@h){
  	print $q->p($a),
       	$q->end_html;
	}
}

#Archivos del "proc".
$mem="meminfo";
$cpu="cpuinfo";
$time="uptime";
print $q->h2("INFORMACION DE HARDWARE");
print $q->h3("INFORMACION DE MEMORIA");
get_info($mem);
print $q->h3("INFORMACION DE PROCESADOR");
get_info($cpu);
print $q->h3("UPTIME");
@a=split"\n", `uptime`;
foreach $a(@a){
  print $q->p($a),
        $q->end_html;
}print $q->h3("FECHA Y HORA");
@a=split"\n", `date`;
foreach $a(@a){
  print $q->p($a),
        $q->end_html;
}
