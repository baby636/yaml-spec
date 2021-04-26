SHELL := bash
ROOT := $(shell pwd)

SPEC := spec-1.2

include files.mk

ALL_IMG_IMAGE := $(ALL_IMAGE:%=img/%)

ALL := $(ALL_MARKDOWN) $(ALL_IMG_IMAGE)

DOCKER_IMAGE := yamlio/yaml-spec-to-markdown

.DELETE_ON_ERROR:
default:

build: run-build

build-all: $(ALL)

clean:
	rm -f $(ALL)

realclean: clean
	rm -fr $(SPEC)

docker-build:
	docker build --tag=$(DOCKER_IMAGE) .

run-build: docker-build $(SPEC)
	$(call docker-run,make build-all)

shell: docker-build
	$(call docker-run,tmux)

serve: docker-build
	$(call docker-run,make -C jekyll jekyll-serve)

docker-push: docker-build
	docker push $(DOCKER_IMAGE)

index.md: $(SPEC)/spec.html
	./html-to-markdown $< > $@ 2>error
	chown --reference=Makefile $@

$(SPEC)/spec.html: $(SPEC)
	make -C $< spec.html

$(SPEC):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

img/%.png: $(SPEC)/%.png
	cp $< $@
	chown --reference=Makefile $@

define docker-run
	docker run -it --rm \
	    -p 4000:4000 \
	    -v $(PWD):/host \
	    -w /host \
	    $(DOCKER_IMAGE) \
	    $1
endef
