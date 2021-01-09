all: $(PROJ).rpt $(PROJ).bin

%.blif: %.v $(ADD_SRC) $(ADD_DEPS)
	yosys -l $*.log -p 'synth_ice40 -top top -blif $@' $< $(ADD_SRC)

%.json: %.v $(ADD_SRC) $(ADD_DEPS)
	yosys -l $*.log -p 'synth_ice40 -top top -json $@' $< $(ADD_SRC)

%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --$(DEVICE) --json $(filter-out $<,$^) --pcf $< --asc $@ --package sg48

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

simulate:
	iverilog -Wall -o sim/$(PROJ)_tb $(PROJ)_tb.v $(ADD_SRC)
	vvp sim/$(PROJ)_tb -lxt2
	mv $(PROJ)_tb.lxt sim/$(PROJ)_tb.lxt
	gtkwave sim/$(PROJ)_tb.lxt sim/gtkwaveConfig.gtkw

new: 
	make clean
	cd .. && \
	cp -r $(PROJ) $(NAME) && cd $(NAME) && \
	mv $(PROJ).v $(NAME).v && mv $(PROJ)_tb.v $(NAME)_tb.v && \
	sed -i 's/$(PROJ)/$(NAME)/g' Makefile $(NAME)*
	
clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ).json $(PROJ).log sim/$(PROJ)_tb sim/$(PROJ)_tb.lxt $(ADD_CLEAN)

.SECONDARY:
.PHONY: all prog clean