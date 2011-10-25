#! /usr/bin/perl

use IO::Socket::INET;
use strict;

system("clear");

my $server_socket = IO::Socket::INET->new(
'LocalPort' => '2008',
'Proto' => 'tcp',
'Reuse' => 1,
'Listen' => SOMAXCONN,
) or die "Não foi possível criar o socket. ($!)\t\t[\x034OFF\x030]\n";

print ("Server started.\t\t\t\t\t\t\t\t[ON]\n\n");

my$msg_ant_free=0;
my$msg_ant_busy=0;
my$ipClient;

while (my ($cliente, $client_addr)	 = $server_socket->accept()){
  my ($port, $ip) = sockaddr_in $client_addr;
	my $ipnum       = inet_ntoa   $ip;
  my$ip_ant = 0;
 while (<$cliente>) {
  if($_ eq "free\n"){
    if($msg_ant_free == 0 || $ip_ant == 0){
      print("Client [$ipnum] connection\t\t\t\t\t\t[UP]\n");
      $msg_ant_free = 1;
      $msg_ant_busy = 0;
      $ip_ant = 1;
    }
  }
  else{
    if($msg_ant_busy == 0 || $ip_ant == 0){
      print("Client [$ipnum] connection\t\t\t\t\t\t[BUSY]\n");
      $msg_ant_free = 0;
      $msg_ant_busy = 1;
      $ip_ant = 1;
    }
   }
    print $cliente "$_";
 }
} 
