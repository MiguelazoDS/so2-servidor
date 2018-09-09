#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'instalar módulo',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

#Remueve el módulo.
$desinstalar=system("sudo /usr/bin/rmmod hello_world");
#Guarda la última línea de dmesg.
$info=`dmesg | tail -n 1`;
#Si se pudo remover envía el mensaje.
if($desinstalar==0){
print $q->h2($info);
        $q->end_html;
}
#Si no se pudo remover manda un mensaje de error.
else{
  print $q->h2("No se pudo desinstalar el módulo");
        $q->end_html;
}
