#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'pc_info',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

#Obtiene el comando ingresado por el cuadro de diálogo.
$buffer = $ENV{'QUERY_STRING'};
if($buffer =~ /\w=(.+)/){
  $buffer=$1;
}

#Crea un arreglo de "+".
@c = ($buffer =~ /\+/g);
#Cuenta cuantos hay.
$i = scalar @c;

#Cambia todos los "+" por espacios.
while($i > 0){
  $ind = index $buffer, "+";
  if($ind != -1){
    substr $buffer, $ind, 1, " ";
  }
  $i--;
}

$barra = "%2F";
#Crea un arreglo de "%2F".
@c = ($buffer =~ /$barra/g);
#Cuenta cuantos hay.
$i = scalar @c;

#Cambia todos los "%2F" por una barra (/).
while($i > 0){
  $ind = index $buffer, "%2F";
  if($ind != -1){
    substr $buffer, $ind, 3, "/";
  }
  $i--;
}

#Ejecuta el bash con el comando obtenido.
system("Bash/Bash $buffer");

#Función que abre y lee un archivo.
sub get_info{
	@h= split "\n", `cat $_[0]`;
	foreach $a(@h){
  	print $q->p($a),
       	$q->end_html;
	}
}

#Guarda el nombre del archivo en $out y llama la función get_info().
$out="output";
print $q->h3("SALIDA BASH");
get_info($out);
