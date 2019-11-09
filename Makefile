CC = gcc
CFLAGS = -std=c89

PRISTINEDISKS = images/pristine_root.rk05 images/pristine_src.rk05 images/pristine_doc.rk05

all: pristine

include urls.inc

pristine: dist.tap $(PRISTINEDISKS) scripts/pristine
	scripts/pristine quiet

dist.tap: v6.tape tools/enblock
	tools/enblock < v6.tape > dist.tap

v6.tape:
	curl -OSs "$(V6TAPE)"
	gzip -d < v6.tape.gz > v6.tape

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
	curl -OLSs "$(ENBLOCK)"

%.rk05:
	dd if=/dev/zero of=$@ bs=1024 count=2436 2>/dev/null

%.rl02:
	dd if=/dev/zero of=$@ bs=1024 count=10240 2>/dev/null

clean:
	rm -r tools/v6enb tools/enblock dist.tap

realclean: clean
	rm -f $(PRISTINEDISKS)

.PHONY: all pristine clean

.PRECIOUS: dist.tap v6.tape.gz v6enb.tar.gz tools/enblock
.PRECIOUS: $(PRISTINEDISKS)
