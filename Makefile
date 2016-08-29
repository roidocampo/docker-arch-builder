
image_name=roidocampo/base

root_date=2016-08-28

################################################################################

current_root=base/roots/archlinux-$(root_date).tar.xz

.PHONY: default image

default: 
	@echo Make what?
	
image: $(current_root) 
	@echo
	@echo Building docker image: $(image_name)
	@echo ==================================================================
	@echo
	cd base; \
	    docker build \
	    	--build-arg root_date=$(root_date) \
	    	-t $(image_name) .


$(current_root):
	@echo
	@echo Building root: $@
	@echo ==================================================================
	@echo
	mkdir -p base/roots
	cd root_builder; docker build -t tmp/arch_builder .
	docker run --rm \
	    --privileged \
	    -v ${PWD}/base/roots:/root/build \
	    tmp/arch_builder \
	    /bin/bash aux_mkimage.sh \
	    $(subst -,/,$(root_date))

