.PHONY: build
build: build/xkb/rules/evdev-local build/xkb/rules/evdev-local.lst build/xkb/symbols/iaenrtsh

build/xkb/rules:
	mkdir -p $@

build/xkb/rules/evdev-local.lst: build/xkb/rules
	printf "! layout\n  iaenrtsh English" > $@

build/xkb/rules/evdev-local: build/xkb/rules
	cp /usr/share/X11/xkb/rules/evdev $@

build/xkb/symbols:
	mkdir -p $@

build/xkb/symbols/iaenrtsh: build/xkb/symbols
	cp xkb/symbols/iaenrtsh $@

.PHONY: backup
backup:
	mkdir backup
	setxkbmap -print > backup/old-mapping.xkb

.PHONY: set_layout
set_layout: build backup
	setxkbmap -Ibuild/xkb -rules evdev-local -layout "iaenrtsh" -option -print | xkbcomp -Ibuild/xkb - $$DISPLAY

.PHONY: set_layout_l
set_layout_l: build backup
	setxkbmap -Ibuild/xkb -rules evdev-local -layout "iaenrtsh(iaenrtsh-l)" -option -print | xkbcomp -Ibuild/xkb - $$DISPLAY

.PHONY: set_layout_l_bkspc
set_layout_l_bkspc: build backup
	setxkbmap -Ibuild/xkb -rules evdev-local -layout "iaenrtsh(iaenrtsh-l-bkspc)" -option -print | xkbcomp -Ibuild/xkb - $$DISPLAY

.PHONY: set_layout_l_bkspc_w
set_layout_l_bkspc_w: build backup
	setxkbmap -Ibuild/xkb -rules evdev-local -layout "iaenrtsh(iaenrtsh-l-bkspc-w)" -option -print | xkbcomp -Ibuild/xkb - $$DISPLAY

.PHONY: revert_layout
revert_layout:
	xkbcomp backup/old-mapping.xkb $$DISPLAY

.PHONY: clean
clean:
	rm -rf build/

.PHONY: clean_backup
clean_backup:
	rm -rf backup/

.PHONY: allclean
allclean: clean clean_backup

