#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'instalar módulo',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

$instalar=system("sudo /usr/bin/rmmod hello_world");
$info=`dmesg | tail -n 1`;
if($instalar==0){
print $q->h2($info);
        $q->end_html;
}
else{
  print $q->h2("No se pudo desinstalar el módulo");
        $q->end_html;
}
