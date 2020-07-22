release:
	swift build --configuration release
	cp -f .build/release/progress /usr/local/bin/progress
	
	
