#使用 generator-angular-fullstack创建angular+express脚手架
##Info
这个[工具](https://github.com/DaftMonk/generator-angular-fullstack)生成的脚手架可以选择使用coffee，less，jade，自动生成gruntfile构建脚本。  
提供了一些列命令可以后续添加api，view，或者进行test， e2etest  
使用[mongodb](http://docs.mongodb.org/manual/tutorial/)  

##Install
使用这个生成器之前，必须确保系统已经安装过[yeoman](http://yeoman.io)  
```
npm install -g yeoman
npm install -g generator-angular-fullstack
```

##Client
###Problem may met during installation:  
+ common.gypi not found
解决方法(http://jsplus.sinaapp.com/common-gypi-not-found.html)
+ grunt build 的时候报错
```
Warning: Loading "less.js" tasks...ERROR
    >> Error: Cannot find module 'async'
    Warning: Task "less" failed. Use --force to continue.
```
解决方法：
  + grunt依赖的package没有装上
    ```
    cd node_modules/
    npm install
    ```
  + 缺啥module装啥  
  `npm install xxx -save`
###About html5 mode
You will find that the ugly angular hash in url is gone.  
It is configed by this line of `$locationProvider.html5Mode true`.  
[HTML5Mode](https://docs.angularjs.org/guide/$location) may have compatibility issues, so later we may need to changes this.  

