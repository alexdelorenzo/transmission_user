# transmission_user
Change the user of the `transmission-daemon` in Debian/Ubuntu.
Debian based distrobutions run `transmission-daemon` with the user `debian-transmission`.

```
   user@host:~$ ps aux | grep transmission
   user     26298  3.7  1.9 118704 40368 ?        Ssl  May23 181:40 /usr/bin/transmission-daemon 
```

## Usage
`./transmission_user.sh USER GROUP`
