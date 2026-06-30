# Makefile Changes for Gate-Level Simulation (GLS)

To perform Gate-Level Simulation (GLS), the original Makefile was modified so that the simulator compiles the synthesized gate-level netlist instead of the RTL source files. Only a few changes were required, but each one is important for successful GLS.

## 1. Simulation Mode

The simulation mode was changed from RTL to GL.

**Before**

```make
SIM ?= RTL
```

**After**

```make
SIM ?= GL
```

This instructs the Makefile to execute the Gate-Level Simulation section instead of the RTL simulation commands.

<br>

<p align="center">
<img src="Screenshots/3.png" width="450">
</p>

<p align="center">
<b>Figure 1:</b> Simulation mode changed from RTL to GL.
</p>

---

## 2. Updating the GLS Compilation Command

The original Makefile compiled the RTL design using the standard Caravel include files. For GLS, the synthesized netlist (`6_final.v`) generated after physical design must be compiled instead.

The following modifications were made inside the `ifeq ($(SIM),GL)` section.

<p align="center">
<img src="Screenshots/4.png" width="800">
</p>

<p align="center">
<b>Figure 2:</b> Updated Gate-Level Simulation compilation command.
</p>

---

## 3. Purpose of Each Makefile Option

### `-y`

```make
-y $(CARAVEL_VERILOG_PATH)/rtl
```

The `-y` option tells Icarus Verilog to search this directory whenever it encounters a module that has not yet been compiled.

Instead of manually listing every RTL file, the simulator automatically searches this directory whenever a required module is instantiated.

In this project, it is used to locate the Caravel RTL modules such as:

- `caravel.v`
- `caravel_core.v`
- other wrapper modules

without explicitly mentioning every file.

---

### `-I`

```make
-I $(CARAVEL_VERILOG_PATH)/rtl
```

The `-I` option specifies the directory where Verilog include files (`.vh`) are located.

Whenever the compiler encounters statements such as

```verilog
`include "defines.v"
```

it searches the directories specified using `-I`.

Without this option, compilation would fail because the required header files could not be located.

---

### `-f`

```make
-f $(VERILOG_PATH)/includes/includes.rtl.$(CONFIG)
```

The `-f` option instructs Icarus Verilog to read a file that contains a list of Verilog source files.

Instead of writing

```bash
iverilog file1.v file2.v file3.v ...
```

the file specified by `-f` contains the complete list of required source files.

This makes the Makefile easier to maintain because only the file list needs to be updated rather than modifying long compile commands.

---

## 4. Including SKY130 Standard Cell Libraries

Unlike RTL simulation, a synthesized netlist is composed of SKY130 standard cells such as:

```verilog
sky130_fd_sc_hd__and2_1
sky130_fd_sc_hd__dfrtp_1
sky130_fd_sc_hd__buf_2
```

These cells are not built into the simulator.

Therefore the following library files must be compiled before the synthesized netlist.

```make
$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
```

This file contains the primitive definitions used by the standard cells.

```make
$(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
```

This file contains the Verilog models for every SKY130 HD standard cell.

Without these libraries, the simulator would report errors such as

```
Unknown module:
sky130_fd_sc_hd__conb_1
```

because it would not recognize the synthesized cells.

---

## 5. Replacing RTL with the Synthesized Netlist

The most important modification was replacing the RTL source with the synthesized gate-level netlist.

Instead of compiling the RTL implementation,

```make
$(CARAVEL_PATH)/rtl/__user_project_wrapper.v
```

the Makefile now compiles

```make
/home/vsduser/vsdsquadron-soc/caravel/verilog/gl/6_final.v
```

The file `6_final.v` is the gate-level netlist generated after synthesis, placement, clock tree synthesis, routing, and optimization.

As a result, the simulator verifies the actual hardware implementation rather than the behavioral RTL description.

---

## 6. Dependency Order During Compilation

The compilation order is important because each stage depends on the previous one.

```
Testbench
      │
      ▼
Caravel RTL Wrapper (-y)
      │
      ▼
Include Files (-I)
      │
      ▼
Source File List (-f)
      │
      ▼
SKY130 Standard Cell Libraries
(primitives.v + sky130_fd_sc_hd.v)
      │
      ▼
Synthesized Netlist (6_final.v)
      │
      ▼
Gate-Level Simulation
```

If any dependency is missing, compilation fails before simulation begins.

---

## Summary

The Makefile modifications were relatively small but essential for enabling Gate-Level Simulation. The simulation mode was changed from RTL to GL, the synthesized netlist (`6_final.v`) replaced the RTL source, and the required SKY130 standard-cell libraries were added to the compilation command. The use of `-y`, `-I`, and `-f` ensured that the simulator could automatically locate RTL modules, include files, and source lists. Together, these changes allowed the existing verification environment to execute gate-level simulations without requiring any modifications to the testbenches.
