#!/usr/bin/expect -f

## FIXME: This is still broken, as 7DTD is catching the CTRL-C (or some other signal)

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
expect "World saved\r"

send "shutdown\r"
#send "exit\r"
expect eof
