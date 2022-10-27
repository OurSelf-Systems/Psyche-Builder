
SELF=/usr/local/bin/Self
BASE=../self/objects

boot.snap:
	echo "saveAs: 'boot.snap'. quitNoSave" | $(SELF) -f $(BASE)/worldBuilder.self -b $(BASE) -f2 setup.self -o morphic 

clean:
	rm boot.snap

