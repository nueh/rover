OS_NAME := $(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME), darwin)
	LDLIBS=-lncurses
else
	LDLIBS=-lncursesw
endif

PREFIX=/usr/local
MANPREFIX=$(PREFIX)/man
BINDIR=$(DESTDIR)$(PREFIX)/bin
MANDIR=$(DESTDIR)$(MANPREFIX)/man1

all: rover

rover: rover.c config.h
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

install: rover
	rm -f $(BINDIR)/rover
	mkdir -p $(BINDIR)
	cp rover $(BINDIR)/rover
	mkdir -p $(MANDIR)
	cp rover.1 $(MANDIR)/rover.1
	cp roverrc $(HOME)/.roverrc
	$(info Add the following line to your .profile or .bashrc or ...)
	$(info test -e "$HOME/.roverrc" && source "$HOME/.roverrc")

uninstall:
	rm -f $(BINDIR)/rover
	rm -f $(MANDIR)/rover.1
	rm -f $(HOME)/.roverrc

clean:
	rm -f rover
