# Frontend to dune.

.PHONY: default build install uninstall test clean

default: build

build:
	dune build src/bensherif.cma

test:
	dune runtest -f

install:
	dune install

uninstall:
	dune uninstall

clean:
	dune clean
# Optionally, remove all files/folders ignored by git as defined
# in .gitignore (-X).
	git clean -dfX
