DOCKER_IMAGE := penkit/abuild:latest
PACKAGES := $(subst main/,,$(subst /APKBUILD,,$(shell find main -iname APKBUILD)))

define ABUILD
	mkdir -p distfiles packages
	docker run --rm \
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

build/%: main/%/APKBUILD
	@$(call ABUILD,$*)

check: $(addprefix check/,$(PACKAGES)) ;
check/%: main/%/APKBUILD
	@echo Check: $*
	@$(call ABUILD,$*) abuild sanitycheck

clean:
	@find . -maxdepth 3 -iname src -type d -exec rm -rf "{}" \;

verify: $(addprefix verify/,$(PACKAGES)) ;
verify/%: main/%/APKBUILD
	@echo Verify: $*
	@$(call ABUILD,$*) abuild verify
