/etc/rc.d/linux enable
/etc/rc.d/linux start
/usr/local/bin/startXvnc.sh
sleep 2
/usr/local/bin/startRatpoison.sh
cd /self 
setenv DISPLAY :1
/usr/local/bin/Self -s snapshot --resetXDisplays --psycheBootRoutine
