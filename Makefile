DOCKER_IMAGE := penkit/abuild:latest

define ABUILD
	mkdir -p distfiles packages
	docker run --rm -it \
		--volume "$$PWD/config:/home/penkit/.abuild" \
		--volume "$$PWD/distfiles:/var/cache/distfiles" \
		--volume "$$PWD/packages:/home/penkit/packages" \
		--volume "$$PWD/main/$1:/home/penkit/work" \
		$(DOCKER_IMAGE)
endef

docker-build:
	@docker build -t $(DOCKER_IMAGE) .

apk-pull:
	@mkdir -p packages/penkit
	rsync -r core@penkit.io:packages/penkit/main/ packages/penkit/

apk-push:
	@mkdir -p packages/penkit
	rsync -r packages/penkit/ core@penkit.io:packages/penkit/main/

clean:
	@find . -maxdepth 3 -iname src -type d -exec rm -rf "{}" \;

build/%: main/%/APKBUILD
	@$(call ABUILD,$*)
