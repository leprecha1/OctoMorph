#!/usr/bin/perl -w

use strict;

#sleep(6); #teste
#exit; #teste

my$UltimoEl = $#ARGV;

if(($ARGV[0] eq "-h") || ($ARGV[0] =~ /\s/) || ($ARGV[0] eq "--help") || ($ARGV[0] eq '')){
  system("clear");
  print "\nUsage: ./octomorph.pl (-m | -l -f -s) (<MAC_Destiny> | <MACList>) <Adapter_Name>\n\n\n";
  print "Options:\n\n";
  print "-m\t\t\tSet only one MAC adress, use with <MAC_Destiny>\n\t\t\te.g.: ./octomorph.pl -m <MAC_Destiny> eth0\n\n";
  print "-l or --list\t\tSet a MAC List\n\n";
  print "-f or --frequency\tSet a frequency or how many times script will run\n\n";
  print "-s or --sec\t\tSet the range time that de script will run\n\n\n";
  print "PS: This two last options should be used together:\n\n# ./octomorph.pl -l <MACList> -f 10 -s 5 wlan0\n\n";
}

elsif($ARGV[0] eq "-m"){
  system("sudo ifconfig $ARGV[$UltimoEl] down");
  
  system("sudo ifconfig $ARGV[$UltimoEl] hw ether $ARGV[1]"); #present in all UNIX-LIKE 
  print"New Faked MAC: $ARGV[1]\n";
  
  system("sudo ifconfig $ARGV[$UltimoEl] up");
}

elsif($ARGV[0] eq "-l"){
  my@list;
  unless(open(FILE,"<$ARGV[1]")){
    die "Erro ao abrir arquivo para leitura!";
  }

  while(<FILE>){
    $_ =~ s/\n//g;
    push(@list,$_);
  }

  srand(time^$$);
  my$MACFake = $list[rand($#list)]; 

  system("sudo ifconfig $ARGV[$UltimoEl] down"); 

  system("sudo ifconfig $ARGV[$UltimoEl] hw ether $MACFake"); #present in all UNIX-like
  print "New Faked MAC: $MACFake\n";  

  print "\n"; 
  system("sudo ifconfig $ARGV[$UltimoEl] up");
  
  if(($ARGV[2] eq "-f") || ($ARGV[2] eq "--frequency")){
    for(my$x=0; $x<= ($ARGV[3]-2); $x++){
      if(($ARGV[4] eq "-s") || ($ARGV[4] eq "--sec")){
        sleep($ARGV[5]);
      }
      else{
        sleep(1);
      }
      system"perl octomorph.pl -l $ARGV[1] $ARGV[$UltimoEl]";
    }
  }
}


__END__
