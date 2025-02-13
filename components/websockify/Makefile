bin/websockify:
	doas pkg install -y py311-pyinstaller
	mkdir -p src && cd src && (git clone https://github.com/novnc/websockify.git || (cd websockify && git pull))
	pyinstaller --onefile src/websockify/websockify/__main__.py
	cp dist/__main__ websockify

clean:
	rm -rf src
	rm -rf build
	rm -rf dist
	rm  -f *.spec
