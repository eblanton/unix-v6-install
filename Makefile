CC = gcc
CFLAGS = -std=c89

PRISTINERKDISKS = images/pristine_root.rk05 images/pristine_src.rk05 images/pristine_doc.rk05

all: rlrk

include urls.inc

pristine-rk: pristine-rk.stamp

pristine-rk.stamp: dist.tap $(PRISTINERKDISKS) scripts/pristine-rk configs/pristine-rk.ini
	scripts/pristine-rk quiet && touch $@

rlrk: rlrk.stamp

rlrk.stamp: images/rlrk_root.rk05 images/shoppa_unix_v6.rl02 configs/rlrk.ini
	scripts/rlrk quiet && touch $@

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

images/shoppa_unix_v6.rl02: unix_v6.rl02.gz
	gzip -d < $< > $@

unix_v6.rl02.gz:
	curl -OSs "$(SHOPPA)"

images/rlrk_root.rk05: pristine-rk.stamp
	cp images/pristine_root.rk05 images/rlrk_root.rk05

%.rk05:
	dd if=/dev/zero of=$@ bs=1024 count=2436 2>/dev/null

%.rl02:
	dd if=/dev/zero of=$@ bs=1024 count=10240 2>/dev/null

clean:
	rm -f tools/enblock dist.tap *.stamp
	rm -rf tools/v6enb

realclean: clean
	rm -f $(PRISTINERKDISKS) images/rlrk_root.rk05 images/shoppa_unix_v6.rl02

.PHONY: all pristine-rk rlrk clean

.PRECIOUS: dist.tap v6.tape.gz v6enb.tar.gz tools/enblock
.PRECIOUS: unix_v6.rl02.gz
.PRECIOUS: $(PRISTINERKDISKS) images/rlrk_root.rk05
