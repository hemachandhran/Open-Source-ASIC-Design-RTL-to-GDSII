#---------------------------------------
# Housekeeping SPI Makefile
#---------------------------------------

SIM = GL
# Change to GL for Gate-Level Simulation

IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

TB  = housekeeping_spi_tb.v
RTL = rtl/housekeeping_spi.v
GL  = gl/6_final.v

PDK_ROOT = /home/vsduser/.ciel
STD_CELL = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog

ifeq ($(SIM),RTL)

SRC = \
	$(TB) \
	$(RTL)

endif

ifeq ($(SIM),GL)

SRC = \
	$(TB) \
	$(STD_CELL)/primitives.v \
	$(STD_CELL)/sky130_fd_sc_hd.v \
	$(GL)

endif

all:
	$(IVERILOG) \
		-g2012 \
		-Ttyp \
		-DFUNCTIONAL \
		-DSIM \
		-DUSE_POWER_PINS \
		-DUNIT_DELAY=\#1 \
		$(SRC) \
		-o sim.out

	$(VVP) sim.out

wave:
	$(GTKWAVE) housekeeping_spi.vcd

clean:
	rm -f sim.out *.vcd *.fst
