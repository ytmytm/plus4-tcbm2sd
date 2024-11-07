
DIRS := giana_sisters

.PHONY: all clean $(DIRS)

all: $(DIRS)

$(DIRS):
	$(MAKE) -C $@

clean:
	@for dir in $(DIRS); do \
	    $(MAKE) -C $$dir clean; \
	done
