#!/usr/bin/perl

use CGI qw(:standard);
#use CGI::Para imprimir mensajes de error en el navegador
use CGI::Carp qw(fatalsToBrowser);

#Carpeta donde se guardará el archivo (módulo) subido
my $upload_dir = "/tmp";

#Crea el formulario.
print header(-charset=>'utf-8'),
     start_html(-title=>'Subir módulo',
                -background=>"/imagen.png",
                -bgcolor=>"lightblue",
                -align=>"center",
              ),
#Formulario multipartes (subida de archivos), utiliza por defecto el método POST
     start_multipart_form,
     'Archivo .ko: ',p ,filefield('input_file'), p,
     submit(-name=>'Subir'),
     end_form;

#Si el botón de nombre "Subir" se presionó.
if ( param('Subir') )
{
   #'upload' devuelve un manejador de archivo.
   my $fh = upload('input_file');
   die "Can't upload file: $!" . cgi_error() . "\n" if ( ! defined($fh) );

   #Guarda el nombre del archivo seleccionado en la variable.
   my $filename = param('input_file');

   #Guarda el archivo en la carpeta seleccionada con su nombre original.
   open FILE, ">$upload_dir/$filename" or die "Can't create upload file: $!\n";
   while ( <$fh> )
   {
     print FILE;
   }
   close FILE;
   #Comprueba mediante expresiones regulares que el archivo sea del tipo módulo e imprime
   #un mensaje de acuerdo a los obtenido.
   if($filename =~ /\w.ko/){
     print "El archivo $filename se subió con éxito.";
   }
   else{
     print "El archivo se subió con éxito, pero no es un tipo válido.";
   }
}
