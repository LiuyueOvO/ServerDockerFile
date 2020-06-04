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

- [x] c++
- [] python
- [] java
- [] rust
- [] typescript
- [] go
- [] c#
- [] swift

## How to use
### install docker
	#rpm or yum install docker
	sudo yum install -y docker
### clone and run
	git clone https://github.com/LiuyueOvO/ServerDockerFile.git ~/
    cd ~/ServerDockerFile
	#cd what you want to use
	cd ./c++
    docker build -t c++_img:latest .
	docker run --name=c++ -it -d [IMAGEID]

## License ##
This software is licensed under the [MIT license][1]. © 2020 蓝芷

[1]: https://github.com/LiuyueOvO/ServerDockerFile/blob/master/LICENSE