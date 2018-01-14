# ButterflyFixer
Workaround for macbook pro 2016+ double key pressing problem

This is a NOT FIX. Problem is within keyboard itself (hardware). 
This is a WORKAROUND. 

How it works. It detects if interval between pressing SAME button is very small (100ms by default) and canceling second keypress.

Why 100ms? 
1) The fastest button pressing I tried - near 150ms, so app won't block valid user input. 
2) All double pressing I catched are under 100ms. 

You could increase inverval if app don't block some keypresses.

How to setup:

1) Open `config.plist` file. 
2) Think good about timeout, edit if needed
3) Write key codes of buttons you want to filter. 

Where get codes:
1) install https://itunes.apple.com/tr/app/key-codes/id414568915?l=tr&mt=12 , press button and look at `Key Code`. E.g. for enter it's 36.
2) https://stackoverflow.com/questions/3202629/where-can-i-find-a-list-of-mac-virtual-key-codes  Find and convert HEX to dec.

How to install:

1) clone or download this repo
2) open terminal and go to this directory (cd ~/Downloads/ButterflyFixer)
3) run `bash install.bash`
4) install developer tools if needed (you will be prompted)
5) enter admin password
6) ready. You can check status and logs by `bash status.bash` and `bash logs.bash`

Why you prompted to enter sudo password? `Quartz Event` api requires admin privileges, so no way to avoid this.

Should I worry about privacy and security? No. Any binaries are downloaded, app is building from sources. So everything is transparent.

How to remove:

`bash remove.bash`


PS. For developers who know Cocoa and have developer certificate. You can help with writing Perf pane and privileged helper tool. (which requires signing)
