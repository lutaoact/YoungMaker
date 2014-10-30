#budweiser

cloud3edu cloud based education system

##Client
###Prerequisites:
+ node  
`brew install node`
+ npm 
+ bower  
`npm install bower grunt grunt-cli -g`
+ redis  
`brew install redis`
+ *Font Custom (if you want to build font)  
`brew install fontforge ttfautohint`
`gem install fontcustom`

sudo apt-get install fontforge ttfautohint
wget http://people.mozilla.com/~jkew/woff/woff-code-latest.zip
unzip woff-code-latest.zip -d sfnt2woff && cd sfnt2woff && make && sudo mv sfnt2woff /usr/local/bin/
gem install fontcustom

###Downloand node&bower packages
```
npm install
bower install
```
###Test and build
####build font (optionals)
```
grunt webfont
```
####build
```
grunt build
grunt test
```
###Run
start redis server at localhost:6379, then

`grunt serve`

###Troubleshooting
+ After using `grunt serve` and get [Fatal error: spawn EMFILE](https://github.com/gruntjs/grunt/issues/788)  
Fixed: add `ulimit -S -n 2048` to your `~/.bash_profile`

###Contributing
Sublime is recommended.  
Otherwise, ignore the IDE related files. E.g. `.idea`  
Install [EditorConfig](http://editorconfig.org/)  
Install Coffee/Less  
[Package Control](https://sublime.wbond.net/installation#st2)  
[Editor Config for Sublime](https://github.com/sindresorhus/editorconfig-sublime)  
[Coffee Syntax for Sublime](https://github.com/jashkenas/coffee-script-tmbundle)  
HTML/CSS Coding Style: follow [Github Coding Sytle](https://github.com/styleguide/css)  
JS/Coffee Coding Sytle: follow [node-style-guide](https://github.com/felixge/node-style-guide)


