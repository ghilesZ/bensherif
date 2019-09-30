# targets
TARGETS = cyclicProd cyclicSum list opt

build:
	ocamlc -o cyclicProd cyclic.ml
	ocamlc -o cyclicSum cy.ml
	ocamlc -o list lst.ml
	ocamlc -o opt option.ml

run: build
	./bch.sh

clean:
	rm -f .depend $(TARGETS)
	rm -f `find . -name "*.o"`
	rm -f `find . -name "*.a"`
	rm -f `find . -name "*.cm*"`
	rm -f `find . -name "*~"`
# .png files and .dat files are generated from the benchmarks
	rm -f `find . -name "*.png"`
	rm -f `find . -name "*.dat"`
	rm -f $(TARGETS)
