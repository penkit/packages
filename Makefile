DOCKER_IMAGE := penkit/abuild:latest

define ABUILD
	docker run --rm -it --volume "$$PWD/$1:/home/penkit/work" $(DOCKER_IMAGE)
endef

docker-build:
	docker build -t $(DOCKER_IMAGE) .

clean:
	@find . -maxdepth 3 -iname src -type d -exec rm -rf "{}" \;

build/%: %/APKBUILD
	$(call ABUILD,$*)
