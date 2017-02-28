DOCKER_IMAGE := penkit/abuild:latest

define ABUILD
	mkdir -p distfiles packages
	docker run --rm -it \
		--volume "$$PWD/distfiles:/var/cache/distfiles" \
		--volume "$$PWD/packages:/home/penkit/packages" \
		--volume "$$PWD/$1:/home/penkit/work" \
		$(DOCKER_IMAGE) sh
endef

docker-build:
	@docker build -t $(DOCKER_IMAGE) .

clean:
	@find . -maxdepth 3 -iname src -type d -exec rm -rf "{}" \;

build/%: %/APKBUILD
	@$(call ABUILD,$*)
