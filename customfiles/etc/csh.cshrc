# Development Option

# Do this only once
if (! -e /FIRSTRUN) then
touch /FIRSTRUN
   

	echo "About to Boot Self"

	# need bash read for timeout
	bash -c 'read -t 10 -p  "Press Enter for emergency shell or wait 10 seconds to continue..."'

	# remember we are in csh
	if  ( $? < 128 )  then
		echo "Entering bash shell. 'exit' will return to Self boot path."
		bash
		exit 0
	endif

	# Main boot path
	cd /objects
	setenv DISPLAY :1
	/vm/Self -s snapshot --resetXDisplays

	# For development images
	if (-e /RESTART_REQUESTED) then
	  echo "** RESTARTING INTO DEVELOPMENT MODE **"
	  set SNAP = `cat /RESTART_REQUESTED`
	  set ACTION = "/vm/Self -s "$SNAP"/snapshot --resetXDisplays"
	  sleep 10
	  tmux new-session -s console "$ACTION"
	endif


endif

