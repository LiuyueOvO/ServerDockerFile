# Docker - Fast Build

The development environment(c++,python,rust and so on) quickly set up

## Why should I use it 

### support develop environment
	$ quickly build develop-env by using docker
	$ wont contaminate linux environment
	$ Deploy multiple applications simultaneously
### Docker
	$ you can make images and download it anywhere you want
	$ you can easily stop and run, reduce system resources
## some planes   

- [x] ReadMe
- 
- iOS 显示小黑点 
- Mac
- Win32

## How To Create New Samples  3部分

### 1、init environment

	$ python download-engine.py

	$ cd libs/cocos2d-x

	$ python setup.py

### 2、create new sample

	$ cd samples

	$ cocos new ProjectName -l [cpp or js or lua] 

**attension: only create projectName in samples dir, it will be compiled correctly** 跟4级标题差不多