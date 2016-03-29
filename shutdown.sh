#!/usr/bin/expect

set timeout 5
set hostname localhost
set port 8081
set password muumi123

spawn telnet $hostname $port

expect "Please enter password:"
send "$password\r";
send "shutdown\r";
send "exit\r";
