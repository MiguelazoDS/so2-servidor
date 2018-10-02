#!/usr/bin/env perl

use CGI;
use Cwd;
$q = CGI->new;
print 	$q->header( -charset=>'utf-8'),
     	  $q->start_html( -title=>'pc_info',
                        -style=>{-src=>'style.css'}),
     	  $q->end_html;

#Directorio donde está el script bash.pl y donde se guardará el archivo pwd.
$base=getcwd."/";

#Guardo el directorio donde está el ejecutable bash.
$bash=$base."Bash/Bash";

#Nombre del archivo.
$pwd = "pwd";

#Path donde guardo el archivo pwd.
$pwd_path = $base.$pwd;

#Verifico si existe el archivo.
if(-e $pwd){
  #Existe guardo lo del archivo en una variable.
  $pwd_c = `cat pwd`;
  #Cambio el directorio actual con lo que se leyó del archivo.
  chdir($pwd_c);
}
else{
  #No existe. Guardo en un archivo el directorio actual
  open($file, ">", "pwd");
  print $file getcwd;
  close($file);
}

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

#Separo la cadena por espacios y utilizo el primer valor (comando).
@comando=split " ", $buffer;

#Si el comando es "cd", y no da error, guardo el cambio de directorio en el archivo.
if($comando[0] eq "cd"){
  $correcto = chdir($comando[1]);
  if($correcto == 1){
    print "El directorio actual es: ", getcwd;
    open($file, ">", "$pwd_path");
    print $file getcwd;
    close($file);
  }
  #Si da error guarda el mensaje en un archivo de nombre "output"
  else{
    open($file, ">", "output");
    print $file "El directorio no existe";
    close($file);
}
#Si es otro comando llamo a bash
else{
  system("$bash $buffer");
}

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

#Borro el archivo.
unlink("output");
