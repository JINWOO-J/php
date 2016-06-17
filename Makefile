REPO = dr.ytlabs.co.kr
NAME = php
VERSION = 5.6.22
include ENVAR

.PHONY: all build push test tag_latest release ssh

all: build

build:
	docker build --no-cache --rm=true --build-arg PHP_VERSION=$(VERSION) -t $(NAME):$(VERSION) .

push:
	docker tag -f $(NAME):$(VERSION) $(REPO)/$(NAME):$(VERSION)
	docker push $(REPO)/$(NAME):$(VERSION)

tag_latest:
	docker tag -f $(REPO)/$(NAME):$(VERSION) $(REPO)/$(NAME):latest
	docker push $(REPO)/$(NAME):latest

push_hub:
	echo "TRIGGER_KEY" ${TRIGGERKEY}
	curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "$(VERSION)"}' -X POST https://registry.hub.docker.com/u/jinwoo/nginx/trigger/${TRIGGERKEY}/
	cat .Dockerfile | sed  "s/__PHP_VERSION__/$(VERSION)/g"   > Dockerfile
	git add .
	git commit -m "$(NAME):$(VERSION) by Makefile"
	git push
	git tag -a "$(VERSION)" -m "$(VERSION) by Makefile"
	git push origin --tags
	curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "$(VERSION)"}' -X POST https://registry.hub.docker.com/u/jinwoo/nginx/trigger/${TRIGGERKEY}/


init:
	git init
	git add .
	git commit -m "first commit"
	git remote add origin git@github.com:JINWOO-J/$(NAME).git
	git push -u origin master
	
	