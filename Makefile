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

DB = db/stock.db	
DB_TEST = db/test1.db db/test2.db db/test3.db db/test4.db

db/%.db: db/%.sql
	sqlite3 $@ < $<	

default: debug

debug: clean $(DB)  
	@rm -f terrier.debug
	$(BUILD) src/terrier.native
	@ln -s $(BUILD_DIR)/src/terrier.native terrier.debug

unittests: clean $(DB) $(DB_TEST)
	@rm -f unittests.debug
	$(BUILD) tests/unittests.native
	@ln -s $(BUILD_DIR)/tests/unittests.native unittests.debug
	./unittests.debug -no-cache-filename -output-file unittests_logs.log

integrationtests: clean $(DB)
	@rm -f integrationtests.debug
	$(BUILD) tests/integrationtests.native
	@ln -s $(BUILD_DIR)/tests/integrationtests.native unittests.debug
	./integrationtests.debug -no-cache-filename -output-file unittests_logs.log

systemtests: clean $(DB)
	@rm -f systemtests.debug
	$(BUILD) tests/systemtests.native
	@ln -s $(BUILD_DIR)/tests/systemtests.native unittests.debug
	./systemtests.debug -no-cache-filename -output-file unittests_logs.log

tests: unittests integrationtests

#Pas fonctionnel pour l'instant il faudra se passer de la compilation en mode 
#debug du -g
#release: dbreset
#	@rm -f terrier.release
#	$(BUILD) src/terrier.native
#	@ln -s $(BUILD_DIR)src/terrier.native terrier.release

doc: debug
	ocamlbuild -use-ocamlfind -no-hygiene $(PACKAGES) $(DOC_DIR)/index.html

clean:
	@rm -rf debug/
	@rm -rf release/
	@rm -rf db/*.db
	@ocamlbuild -clean

mrproper: clean 
	@rm -f *.debug *.release *.dvi *.tex *.log *.pdf *.aux oUnit*
	@rm -f *.logs *.log
	@rm -rf db/core.db
	@rm -rf doc/

.PHONY: debug mrproper 
