# iCE40 Feather Gateware Examples

These projects are my own, and probably have more mistakes and bad practices in them than you can poke a stick at. Use them at your own risk.

Verilog projects are in `verilog`, and after changing into the project directory have the below options.

- `make` to build the project.
- `make prog` to program the board.
- `make simulate` to simulate the design with iverilog using the `$(PROJ)_tb.v` simulation file.
- `make new NAME="name"` to copy current project to new folder called `name` along with changing all in text references.

Common Verilog files are in `verilog/common`.

- To simulate these files, place a file called $(PROJ)_tb.v in `verilog/common/sim`.
- Then run `make simulate PROJ="project" SRC="required_file.v"` from `verilog/common`.
