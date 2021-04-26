include ../files.mk

ALL_IMAGE := $(ALL_IMAGE:%=../docs/%)
ALL := $(ALL_MARKDOWN) $(ALL_IMAGE)

.DELETE_ON_ERROR:
default:

jekyll-build jekyll-serve: assets
	bundle exec jekyll $(@:jekyll-%=%)

assets: $(ALL)
	chown -R --reference=Makefile .

../docs/%.png: ../img/%.png
	cp $< $@

%.md: ../%.md
	ln -fs $@ $<

../%.md:
	make -C .. $(<:../%=%)
