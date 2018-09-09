#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'módulos instalados',
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

#Archivo del "proc".
$modulos="modules";
print $q->h2("MODULOS INSTALADOS");
get_info($modulos);
