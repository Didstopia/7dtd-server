#!/usr/bin/expect -f

## FIXME: Forceful shutdown doesn't work for some reason?

set timeout 5
set hostname localhost
set port $::env(SEVEN_DAYS_TO_DIE_TELNET_PORT)
set password $::env(SEVEN_DAYS_TO_DIE_TELNET_PASSWORD)

spawn telnet $hostname $port

expect {
  "Please enter password:" {
    send "$password\r"
  }
}

send "saveworld\r"
send "shutdown\r"
send "exit\r"

expect eof