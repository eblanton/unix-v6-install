CC = gcc
CFLAGS = -std=c89

all: pristine

include urls.inc

pristine: dist.tap

dist.tap: v6.tape tools/enblock
	tools/enblock < v6.tape > dist.tap

v6.tape:
	curl -O "$(V6TAPE)"
	gzip < v6.tape.gz > v6.tape

tools/enblock: tools/v6enb/enblock.c
	# Compile with -w because this code is old enough to make gcc
	# very sad
	$(CC) -w -o tools/enblock $<

tools/v6enb/enblock.c: v6enb.tar.gz
	cd tools && tar xzf ../v6enb.tar.gz
	# Prevent continual fetches due to enblock.c remaining unchanged
	# since 2001
	touch $@

v6enb.tar.gz:
	curl -OL "$(ENBLOCK)"

clean:
	rm -r tools/v6enb tools/enblock dist.tap

.PHONY: all pristine clean

.PRECIOUS: dist.tap v6.tape.gz v6enb.tar.gz tools/enblock
