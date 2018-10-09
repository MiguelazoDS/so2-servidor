#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'instalar módulo',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

#Instala el módulo.
$instalar=system("sudo /sbin/insmod /tmp/hello_world.ko");
#Guarda la última línea de dmesg.
$info=`dmesg | tail -n 1`;
#Si se pudo instalar envía el mensaje.
if($instalar==0){
print $q->h2($info);
        $q->end_html;
}
#Si no se pudo instalar manda un mensaje de error.
else{
  print $q->h2("No se pudo instalar el módulo");
        $q->end_html;
}
