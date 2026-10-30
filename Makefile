.PHONY: all clean

all: out/bnuysay
	out/bnuysay "done"

out/bnuysay:
	mkdir -p out
	fasm ./bnuysay.asm out/bnuysay
	chmod +x out/bnuysay

clean:
	rm -r out

