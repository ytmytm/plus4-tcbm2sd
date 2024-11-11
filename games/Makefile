
DIRS := \
	alpharay \
	giana_sisters \
	lemmings \
	petsrescue \
	prince_of_persia \
	turbo_outrun \


.PHONY: all clean $(DIRS)

all: $(DIRS)

$(DIRS):
	$(MAKE) -C $@

clean:
	@for dir in $(DIRS); do \
	    $(MAKE) -C $$dir clean; \
	done
