# -----------------------------------------------------------------------------
# Clean Makefile for caravel_mgmt_soc_litex standalone tests (gpio_mgmt)
# Adds auto-symlink so linker script INCLUDE ../generated/regions.ld works.
# -----------------------------------------------------------------------------

PWDD   := $(shell pwd)
BLOCKS := $(notdir $(PWDD))

CONFIG ?= caravel
SIM    ?= GL

# Paths
DESIGNS ?= /home/vsduser/vsdsquadron-soc

export PDK_ROOT ?= /home/vsduser/.ciel
export PDK ?= sky130A
export CARAVEL_VERILOG_PATH ?= $(DESIGNS)/caravel/verilog
export CORE_VERILOG_PATH    ?= $(DESIGNS)/caravel_mgmt_soc_litex/verilog
export USER_PROJECT_VERILOG ?= $(DESIGNS)/verilog

export CARAVEL_PATH := $(CARAVEL_VERILOG_PATH)
export VERILOG_PATH := $(CORE_VERILOG_PATH)

# Define these AFTER CORE_VERILOG_PATH is set (important!)
export VIP_PATH      := $(CORE_VERILOG_PATH)/dv/vip
export FIRMWARE_PATH := $(CORE_VERILOG_PATH)/dv/firmware

# Toolchain
export GCC_PATH   ?= /home/vsduser/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14/bin
export GCC_PREFIX ?= riscv64-unknown-elf

# CPU selection
CPU ?= vexriscv

CPUFLAGS_vexriscv := -march=rv32i -mabi=ilp32 -D__vexriscv__
CPUFLAGS_picorv32 := -march=rv32i -mabi=ilp32
CPUFLAGS_ibex     := -march=rv32i -mabi=ilp32

LINKER_SCRIPT :=
SOURCE_FILES  :=
CPUFLAGS      :=

ifeq ($(CPU),picorv32)
  LINKER_SCRIPT := $(FIRMWARE_PATH)/sections.lds
  SOURCE_FILES  := $(FIRMWARE_PATH)/start.s
  CPUFLAGS      := $(CPUFLAGS_picorv32)
endif

ifeq ($(CPU),ibex)
  LINKER_SCRIPT := $(FIRMWARE_PATH)/link_ibex.ld
  SOURCE_FILES  := $(FIRMWARE_PATH)/crt0_ibex.S $(FIRMWARE_PATH)/simple_system_common.c
  CPUFLAGS      := $(CPUFLAGS_ibex)
endif

ifeq ($(CPU),vexriscv)
  LINKER_SCRIPT := $(FIRMWARE_PATH)/sections_vexriscv.lds
  SOURCE_FILES  := $(FIRMWARE_PATH)/start_caravel_vexriscv.s
  CPUFLAGS      := $(CPUFLAGS_vexriscv)
endif

export IVERILOG_DUMPER = fst

.SUFFIXES:

all: $(BLOCKS).vcd $(BLOCKS).lst
hex: $(BLOCKS).hex

# -----------------------------------------------------------------------------
# Linker-script include helper
# sections_vexriscv.lds includes "../generated/regions.ld"
# From gpio_mgmt/, that path means tests-standalone/generated/regions.ld
# We create a symlink there pointing to dv/generated/regions.ld
# -----------------------------------------------------------------------------

GEN_INCLUDE_DIR := $(abspath $(PWDD)/../generated)
REAL_GENERATED  := $(abspath $(VERILOG_PATH)/dv/generated)

prepare-generated:
	@mkdir -p "$(GEN_INCLUDE_DIR)"
	@if [ -f "$(REAL_GENERATED)/regions.ld" ]; then \
		ln -sf "$(REAL_GENERATED)/regions.ld" "$(GEN_INCLUDE_DIR)/regions.ld"; \
	else \
		echo "ERROR: Missing $(REAL_GENERATED)/regions.ld"; exit 1; \
	fi

# -----------------------------------------------------------------------------
# Build firmware
# -----------------------------------------------------------------------------

check-fw: prepare-generated
	@test -n "$(LINKER_SCRIPT)" || (echo "ERROR: LINKER_SCRIPT is empty. Set CPU correctly (CPU=vexriscv/picorv32/ibex)."; exit 1)
	@test -f "$(LINKER_SCRIPT)" || (echo "ERROR: Missing linker script: $(LINKER_SCRIPT)"; exit 1)
	@for f in $(SOURCE_FILES); do \
		test -f $$f || (echo "ERROR: Missing source file: $$f"; exit 1); \
	done

%.elf: %.c check-fw
	$(GCC_PATH)/$(GCC_PREFIX)-gcc -g \
	  -I$(FIRMWARE_PATH) \
	  -I$(VERILOG_PATH)/dv/generated \
	  -I$(VERILOG_PATH)/dv/ \
	  -I$(VERILOG_PATH)/common \
	  $(CPUFLAGS) \
	  -ffreestanding -nostdlib \
	  -Wl,-Bstatic \
	  -Wl,-T,$(LINKER_SCRIPT) \
	  -Wl,--strip-debug \
	  -o $@ $(SOURCE_FILES) $<

%.lst: %.elf
	$(GCC_PATH)/$(GCC_PREFIX)-objdump -d -S $< > $@

%.hex: %.elf
	$(GCC_PATH)/$(GCC_PREFIX)-objcopy -O verilog $< $@
	#sed -ie 's/@10/@00/g' $@
	sed -i 's/^@1000/@0000/' $@

%.bin: %.elf
	$(GCC_PATH)/$(GCC_PREFIX)-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# -----------------------------------------------------------------------------
# Run simulations
# -----------------------------------------------------------------------------

%.vvp: %_tb.v %.hex

ifeq ($(SIM),RTL)
ifeq ($(CONFIG),caravel_user_project)
	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	  -f$(VERILOG_PATH)/includes/includes.rtl.caravel \
	  -f$(USER_PROJECT_VERILOG)/includes/includes.rtl.$(CONFIG) \
	  -o $@ $<
else
	iverilog -Ttyp -DFUNCTIONAL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	  -y /home/vsduser/vsdsquadron-soc/caravel/verilog/rtl \
	  -I /home/vsduser/vsdsquadron-soc/caravel/verilog/rtl \
	  -f $(VERILOG_PATH)/includes/includes.rtl.$(CONFIG) \
	  -o $@ $(CARAVEL_PATH)/rtl/__user_project_wrapper.v $<
endif
endif

ifeq ($(SIM),GL)
ifeq ($(CONFIG),caravel_user_project)
	iverilog -Ttyp -DFUNCTIONAL -DGL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	  -f$(VERILOG_PATH)/includes/includes.gl.caravel \
	  -f$(USER_PROJECT_VERILOG)/includes/includes.gl.$(CONFIG) \
	  -o $@ $<
else
	iverilog -Ttyp -DFUNCTIONAL -DGL -DSIM -DUSE_POWER_PINS -DUNIT_DELAY=#1 \
	  -y $(CARAVEL_VERILOG_PATH)/rtl \
	  -I $(CARAVEL_VERILOG_PATH)/rtl \
	  -f $(VERILOG_PATH)/includes/includes.rtl.$(CONFIG) \
	  $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
	  $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
          /home/vsduser/vsdsquadron-soc/caravel/verilog/gl/6_final.v \
	  -o $@ $<
endif
endif

ifeq ($(SIM),GL_SDF)
ifeq ($(CONFIG),caravel_user_project)
	cvc64 +interp \
	  +define+SIM +define+FUNCTIONAL +define+GL +define+USE_POWER_PINS +define+UNIT_DELAY +define+ENABLE_SDF \
	  +change_port_type +dump2fst +fst+parallel2=on +nointeractive +notimingchecks +mipdopt \
	  -f $(VERILOG_PATH)/includes/includes.gl+sdf.caravel \
	  -f $(USER_PROJECT_VERILOG)/includes/includes.gl+sdf.$(CONFIG) $<
else
	cvc64 +interp \
	  +define+SIM +define+FUNCTIONAL +define+GL +define+USE_POWER_PINS +define+UNIT_DELAY +define+ENABLE_SDF \
	  +change_port_type +dump2fst +fst+parallel2=on +nointeractive +notimingchecks +mipdopt \
	  -f $(VERILOG_PATH)/includes/includes.gl+sdf.$(CONFIG) \
	  -f $(CARAVEL_PATH)/gl/__user_project_wrapper.v $<
endif
endif

%.vcd: %.vvp
ifeq ($(SIM),RTL)
	vvp $<
	mv $@ RTL-$@
endif
ifeq ($(SIM),GL)
	vvp $<
	mv $@ GL-$@
endif
ifeq ($(SIM),GL_SDF)
	mv $@ GL_SDF-$@
endif

clean:
	rm -f *.elf *.hex *.bin *.vvp *.log *.vcd *.lst *.hexe
	rm -f *.hexie
	rm -rf "$(GEN_INCLUDE_DIR)"

.PHONY: clean hex all prepare-generated check-fw

