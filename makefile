release:
	# Build with release configuration
	swift build -c release

	# Copy the executable into /usr/local/bin/ with should be in the PATH
	cp -f .build/release/progress /usr/local/bin/progress

	# Copy the libSwiftToolsSupport dynamic library into our shared dylib folder
	cp -f .build/release/libSwiftToolsSupport.dylib /usr/local/lib/

	# Update the executable's @rpath to check the shared folder
	install_name_tool -change "@rpath/libSwiftToolsSupport.dylib" "/usr/local/lib/libSwiftToolsSupport.dylib" "/usr/local/bin/progress"
	
	
