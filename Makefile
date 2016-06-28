SHELL := /bin/bash
NAME = arizonatribe/centosmariadb
VERSION = 1.0.1

docker:
	    @docker build --rm=true -t $(NAME):$(VERSION) ./
		    @docker tag -f $(NAME):$(VERSION) $(NAME):latest

docker-nocache:
	    @docker build --no-cache=true --rm=true -t $(NAME):$(VERSION) ./
		    @docker tag -f $(NAME):$(VERSION) $(NAME):latest

.PHONY: docker
