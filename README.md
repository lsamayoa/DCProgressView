# DCProgressView #

Custom ProgressView inspired by twitter bootstrap.

# Examples #

	DCProgressView *progressBar = [[DCProgressView alloc] initWithFrame:CGRectMake(10,10,100,20)];
	progressBar.tintColor = [UIColor redColor];
	[self.view addSubView:progressBar];

# Install #

The recommended approach for installing DCProgressView is via the CocoaPods package manager, as it provides flexible dependency management and dead simple installation.

via CocoaPods

Install CocoaPods if not already available:

	$ [sudo] gem install cocoapods
	$ pod setup
Change to the directory of your Xcode project, and Create and Edit your Podfile and add RestKit:

	$ cd /path/to/MyProject
	$ touch Podfile
	$ edit Podfile
	platform :ios, '5.0' 
	pod 'DCProgressView'

Install into your project:

	$ pod install
	
Open your project in Xcode from the .xcworkspace file (not the usual project file)

# License #

DCProgressView is license under the Apache License.

# Contact #

### Dalton Cherry ###
* https://github.com/daltoniam
* http://twitter.com/daltoniam