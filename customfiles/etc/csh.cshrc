/etc/rc.d/linux enable
/etc/rc.d/linux start
while true do
	/usr/local/bin/Self -s /Persona/snapshot
	sleep 5
done
