
docker_base_tag=roidocampo/arch
root_date=2016-08-28

IMAGES = base tex 

base_SRCS = Dockerfile
base_ARGS = --build-arg root_date=$(root_date)
base_USEROOT = yes

tex_FROM = base
tex_SRCS = Dockerfile

AURPACKAGES = frobby scscp singular-factory macaulay2

# macaulay2_DEPS = frobby scscp singular-factory

EXTRAIMAGES = rootbuilder aurbuilder

rootbuilder_SRCS = Dockerfile mkimage_src/aux_mkimage.sh \
		   mkimage_src/mkimage-arch-pacman.conf \
		   mkimage_src/mkimage.sh \
		   mkimage_src/mkimage/mkimage-arch.sh

aurbuilder_SRCS = Dockerfile aur_build.sh

################################################################################

default:
	@echo Make what? 
	@echo Available images: $(IMAGES)

current_root_filename = archlinux-$(root_date).tar.xz
current_root_dir = roots
current_root = $(current_root_dir)/$(current_root_filename)
$(current_root): .phonydir/rootbuilder_image
	@echo
	@echo Building root: $@
	@echo ==================================================================
	@echo
	mkdir -p roots
	docker run --rm \
	    --privileged \
	    -v ${PWD}/roots:/root/build \
	    $(docker_base_tag)-rootbuilder \
	    /bin/bash aux_mkimage.sh \
	    $(current_root_filename) \
	    $(subst -,/,$(root_date))

define IMAGE_template
$(1): .phonydir/$(1)_image
.PHONY: $(1)
ifdef $(1)_FROM
.phonydir/$(1)_image: .phonydir/$$($(1)_FROM)_image 
endif
ifdef $(1)_SRCS
.phonydir/$(1)_image: $$(addprefix images/$(1)/,$$($(1)_SRCS))
endif
ifdef $(1)_USEROOT
.phonydir/$(1)_image: $(current_root)
endif
.phonydir/$(1)_image:
	@echo
	@echo Building docker image: $(docker_base_tag)-$(1)
	@echo ==================================================================
	@echo
ifdef $(1)_USEROOT
	mkdir -p "images/$(1)/roots"
	cp "$(current_root)" "images/$(1)/roots/$(current_root_filename)"
endif
	cd images/$(1); \
	    docker build $$($(1)_ARGS) \
	    	-t $(docker_base_tag)-$(1) .
ifdef $(1)_USEROOT
	rm "images/$(1)/roots/$(current_root_filename)"
	rmdir "images/$(1)/roots"
endif
	mkdir -p .phonydir
	touch .phonydir/$(1)_image

endef

ALLIMAGES = $(IMAGES) $(EXTRAIMAGES)
$(foreach image,$(ALLIMAGES),$(eval $(call IMAGE_template,$(image))))

.PHONY: aur

aur_docker_cmd = docker run --rm \
		 -v ${PWD}/aur:/home/aurbuilder/aur \
		 $(docker_base_tag)-aurbuilder \
		 /bin/bash aur_build.sh

define AUR_template
aur: aur-$(1)
aur-$(1): aur/build/$(1).pkg.tar.xz
.PHONY: aur-$(1)
ifdef $(1)_DEPS
aur/build/$(1).pkg.tar.xz: $$(foreach dep,$$($(1)_DEPS),aur/build/$$(dep).pkg.tar.xz)
endif
aur/build/$(1).pkg.tar.xz: .phonydir/aurbuilder_image
aur/build/$(1).pkg.tar.xz: aur/src/$(1).tar.gz
aur/build/$(1).pkg.tar.xz:
	@echo
	@echo Building AUR package: $@
	@echo ==================================================================
	@echo
	mkdir -p aur/build
ifdef $(1)_DEPS
	$(aur_docker_cmd) $(1) --deps $$($(1)_DEPS)
else
	$(aur_docker_cmd) $(1)
endif
endef

$(foreach pac,$(AURPACKAGES),$(eval $(call AUR_template,$(pac))))

# image_name=roidocampo/base
# $(eval $(call RULE_TEMPLATE, hola))

# DEFINE_RULE=$(eval $(call RULE_TEMPLATE, def-$(1)))
# $(call DEFINE_RULE, hola)
# $(eval $(call RULE_TEMPLATE, hola))

# default: 
# 	@echo Make what? $(hola)
# 	@echo
# 	@echo $(call dir_dep, image_base)
# 	@echo =====================
# 	@$(RULE_TEMPLATE)
# 	@echo =====================
# 	@$(call RULE_TEMPLATE, hola)

# base_image: .phonydir/base_image
# .phonydir/base_image: $(current_root)
# 	@echo
# 	@echo Building docker image: $(base_image_name)
# 	@echo ==================================================================
# 	@echo
# 	cd image_base; \
# 	    docker build \
# 	    	--build-arg root_date=$(root_date) \
# 	    	-t $(base_image_name) .
# 	touch .phonydir/base_image

# tex_image: base_image
# 	@echo
# 	@echo Building docker image: $(tex_image_name)
# 	@echo ==================================================================
# 	@echo
# 	cd image_tex; \
# 	    docker build \
# 	    	-t $(tex_image_name) .

################################################################################

# image: run_image.sh

# docker_image: $(current_root)
# 	@echo
# 	@echo Building docker image: $(image_name)
# 	@echo ==================================================================
# 	@echo
# 	cd base; \
# 	    docker build \
# 	    	--build-arg root_date=$(root_date) \
# 	    	-t $(image_name) .


# $(current_root):
# 	@echo
# 	@echo Building root: $@
# 	@echo ==================================================================
# 	@echo
# 	mkdir -p base/roots
# 	cd root_builder; docker build -t tmp/arch_builder .
# 	docker run --rm \
# 	    --privileged \
# 	    -v ${PWD}/base/roots:/root/build \
# 	    tmp/arch_builder \
# 	    /bin/bash aux_mkimage.sh \
# 	    $(subst -,/,$(root_date))

# run_image.sh: docker_image
# 	@echo
# 	@echo Building runner: $@
# 	@echo ==================================================================
# 	@echo
# 	echo "#!/bin/bash" > "$@"
# 	echo "exec docker run --rm -it -p 8888:8888 $(image_name)" >> "$@"
# 	chmod +x "$@"
