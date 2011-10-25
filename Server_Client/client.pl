#! /usr/bin/perl
#
use IO::Socket::INET;
use threads;
use strict;


if(($ARGV[0] eq "")||($ARGV[0] eq "0")||($ARGV[0] =~ /\s/)||($ARGV[0] eq "-h")||$ARGV[0] eq "--help"){
  system("clear");
  print "\nUsage: ./client <ADDRESS_SERVER> <TIME_MAC> <ADAPTER_NAME>\n\n\n";
  print "Options:\n\n";
  print "<ADDRESS_SERVER>\t\tSet the address of the server.\n\n";
  print "<TIME_MAC>\t\t\tSet the range time that the script \"octomorph\" will run.\n\n";
  print "<ADAPTER_NAME>\t\t\tSet the adapter\n\n\n";
  print "e.g.: ./client 127.0.0.1 10 wlan0\n\n";

  exit;
}

INICIO:
my$thread = threads->new(\&runScript);
my$resp_thread = $thread->join;

#system("sleep 5");

if($resp_thread eq "free\n"){

my$thr = threads->new(\&sendSignal);
#system("sleep 10");
system("perl octomorph.pl -l ../../MACList.lst -f 1 -s 1 $ARGV[2]");
sleep($ARGV[1]);
#system("ping uol.com.br");

goto INICIO;
}

sub runScript{
  my$status="free";

  my$resp;
  my$msg_server;
   
  my $pid;
  my$nomeProcesso="octomorph.pl";
  #my $nomeProcesso="octomorph.pl";

  my $cliente_socket = IO::Socket::INET->new(
  'PeerAddr' => $ARGV[0],
  'PeerPort' => '2008',
  'Proto' => 'tcp'
  ) or die "Não foi possível criar o socket. ($!)\n";

  while (1)
  { 
    
    $pid = `ps -ef | grep \"$nomeProcesso\" | grep -v grep | tr -s ' ' '#' | cut -d"#" -f3`;
    if($pid){
      $msg_server = "busy\n";
      print $cliente_socket "$msg_server";
      $resp = <$cliente_socket>;
    }
    else {
      $msg_server = "free\n";
      print $cliente_socket "$msg_server";
      $resp = <$cliente_socket>;
      close($cliente_socket);
      return $resp;
    }
  }
}

sub sendSignal{
  my $msg_server;
  my $cliente_socket = IO::Socket::INET->new(
  'PeerAddr' => $ARGV[0],
  'PeerPort' => '2008',
  'Proto' => 'tcp'
  ) or die "Não foi possível criar o socket. ($!)\n";

  $msg_server = "busy\n";
  print $cliente_socket "$msg_server";
  close($cliente_socket);
}

exit;
