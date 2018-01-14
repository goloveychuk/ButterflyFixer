swift build -c release

cp ./config.plist /usr/local/etc/butterfly_fixer.plist


cp ./.build/release/butterfly_fixer /usr/local/bin


sudo cp ./butterfly_fixer.plist /Library/LaunchDaemons


sudo launchctl unload /Library/LaunchDaemons/butterfly_fixer.plist 2>/dev/null

sudo launchctl load -w -F /Library/LaunchDaemons/butterfly_fixer.plist