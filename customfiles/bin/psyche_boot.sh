#!/bin/sh

# Do this only once
if ! [ -f /FIRSTRUN ]; then

	touch /FIRSTRUN

	# Green bar go away
	tmux set status off   

	# Main boot path
	cd /objects
	export DISPLAY=:1
	/vm/Self -s snapshot --resetXDisplays

	# For development images
	if [ -f /RESTART_REQUESTED ]; then
	  echo "** RESTARTING INTO DEVELOPMENT MODE **"
	  SNAP=$(cat /RESTART_REQUESTED)
	  /vm/Self -s $SNAP/snapshot --resetXDisplays
	fi

fi
