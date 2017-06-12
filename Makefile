DEBUG_OPTION=-g
SOURCE_DIR=src/

PACKAGES=-package lablgtk2 -package oUnit -package sqlite3 
LIBS=#-lib dynlink -lib graphics
BUILD=ocamlbuild -no-hygiene -r \
	  -build-dir "$(BUILD_DIR)" \
	  -cflags "$(DEBUG_OPTION)" \
	  $(PACKAGES) $(LIBS)

BUILD_DIR=debug/

DOC_DIR=terrier.docdir

default: debug

debug:
	@rm -f terrier.debug
	$(BUILD) src/terrier.native
	@ln -s $(BUILD_DIR)/src/terrier.native terrier.debug

#test:
#	@rm -f test.debug
#	$(BUILD) tests/test.native
#	@ln -s $(BUILD_DIR)/tests/test.native test.debug

#runtests: test plugins
#	./test.debug -no-cache-filename -output-file test_logs.log

release:
	@rm -f terrier.release
	$(BUILD) src/terrier.native
	@ln -s $(BUILD_DIR)src/terrier.native terrier.release

#doc: debug
#	ocamlbuild -use-ocamlfind -no-hygiene $(PACKAGES) $(DOC_DIR)/index.html
#	cd plugins && make doc

clean:
	@rm -rf debug/
	@rm -rf release/
	@ocamlbuild -clean
	@cd plugins && make clean

mrproper: clean
	@rm -f *.debug *.release *.dvi *.tex *.log *.pdf *.aux oUnit*
	@rm -rf doc/

.PHONY: debug mrproper
