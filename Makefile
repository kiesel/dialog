VERSION?=$(shell cat VERSION)

compile: compile-main compile-test

compile-main: dist/main
	xcc -o dist/main -sp src/main/xp src/main/xp

compile-test: dist/test
	xcc -o dist/test -sp src/test/xp src/test/xp

dist:	compile
	cd dist/main && xar cvf ../dialog-$(VERSION).xar .
	cd .. && zip -r dialog/dist/dialog-$(VERSION).zip dialog/dist/dialog-$(VERSION).xar dialog/xsl dialog/doc_root dialog/etc dialog/data -x \*.svn\* -x .cvsignore

dist/main:
	mkdir -p $@

dist/test:
	mkdir -p $@

clean:
	-rm -rf dialog/dist/main/* dialog/dist/test/*

release:	dist
	scp dialog/dist/dialog-$(VERSION).zip xpdoku@xp-forge.net:/home/httpd/xp.php3.de/doc_root/downloads/projects/www/
