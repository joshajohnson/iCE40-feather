simulate:
	iverilog -Wall -o out/$(PROJ)_out sim/$(PROJ)_tb.v $(SRC)
	vvp out/$(PROJ)_out -lxt2
	mv $(PROJ)_tb.lxt out/$(PROJ)_out.lxt
	gtkwave out/$(PROJ)_out.lxt sim/$(PROJ)_config.gtkw

clean:
	rm -f out/*