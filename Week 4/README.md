# RTL-to-GDS Implementation of User Project Wrapper
---

# PHASE 1 – Analyze the Top-Level Wrapper

## Dependency Tree of the Wrapper

![](Screenshots/1.png)
The `user_project_wrapper` is the top-level module responsible for integrating the user project with the Caravel SoC infrastructure. Rather than implementing application logic itself, it provides the interface between the Wishbone bus, GPIO, Logic Analyzer, debug registers, and optional test modules.

The dependency hierarchy of the wrapper is shown below:

```text
user_project_wrapper
│
├── debug_regs
│
├── user_project_gpio_example     (compiled only when GPIO_TESTING is enabled)
│
└── user_project_la_example       (compiled only when LA_TESTING is enabled)
```

The `debug_regs` module is always instantiated to provide Wishbone-accessible debug registers. The GPIO and Logic Analyzer example modules are conditionally included using Verilog preprocessor directives and are mainly intended for testing and validation.

---

## RTL Files Required by the Design

The wrapper depends on multiple RTL source files to build the complete hierarchy. Each file contributes a specific function within the design.

| RTL File                      | Description                                                                              |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| `user_project_wrapper.v`      | Top-level integration module that interfaces the user project with the Caravel platform. |
| `debug_regs.v`                | Implements the debug register block accessed through the Wishbone interface.             |
| `defines.v`                   | Contains macro definitions and configuration parameters required by the wrapper.         |
| `user_project_gpio_example.v` | Example GPIO module instantiated during GPIO testing.                                    |
| `user_project_la_example.v`   | Example Logic Analyzer module instantiated during LA testing.                            |

Among these, `user_project_wrapper.v` serves as the top module, while the remaining files provide supporting functionality required during synthesis or testing.

---

## Module Hierarchy Explanation

The design follows a simple hierarchical organization with `user_project_wrapper` at the highest level. This module connects the user design to the Caravel SoC by exposing the system clock, reset, Wishbone slave interface, GPIO pins, Logic Analyzer interface, analog I/O, and interrupt signals.

One of the primary responsibilities of the wrapper is address decoding. Based on the incoming Wishbone address, it separates normal user transactions from debug register accesses. Requests targeting the reserved debug address space are routed to the `debug_regs` module, while all other accesses are directed to the user project.

The wrapper also supports optional verification modules. When the `GPIO_TESTING` macro is enabled, the `user_project_gpio_example` module is instantiated to validate GPIO functionality. Likewise, enabling `LA_TESTING` instantiates the `user_project_la_example` module for Logic Analyzer verification. These modules are excluded from the synthesis flow unless the corresponding compile-time flags are defined.

From the compilation perspective, all lower-level modules must be available before the top-level wrapper is elaborated. Maintaining the correct dependency order ensures successful synthesis and prevents unresolved module reference errors during the RTL-to-GDS implementation flow.

---

# PHASE 2 – Prepare the ORFS Design Environment

To perform the RTL-to-GDS implementation, an OpenROAD Flow Scripts (ORFS) design workspace was created for the `user_project_wrapper` design. The required RTL files were collected into a dedicated `rtl` directory, and the necessary configuration files were added to allow the OpenROAD flow to recognize the design hierarchy and timing constraints.

## Directory Structure

![](Screenshots/2.png)

### Directory Description

| File / Directory | Description |
|------------------|-------------|
| `config.mk` | Contains the OpenROAD Flow configuration, including the design name, platform, RTL sources, and implementation parameters. |
| `constraints.sdc` | Defines the timing constraints used during synthesis and timing analysis. |
| `rtl/` | Stores all RTL source files required by the top-level wrapper. |

## RTL Integration

The following RTL files were included in the project:

| RTL File | Purpose |
|----------|---------|
| `__user_project_wrapper.v` | Top-level wrapper connecting the user project to the Caravel SoC infrastructure. |
| `debug_regs.v` | Implements the Wishbone-accessible debug register block. |
| `defines.v` | Contains macro definitions and platform-specific parameters used throughout the design. |
| `__user_project_gpio_example.v` | Optional GPIO demonstration module used when `GPIO_TESTING` is enabled. |
| `__user_project_la_example.v` | Optional Logic Analyzer demonstration module used when `LA_TESTING` is enabled. |

The top module for the design was configured as `user_project_wrapper`, while the RTL source files were referenced through the `VERILOG_FILES` variable in `config.mk`. The design was targeted for the `sky130hd` technology platform.

The configuration file also specifies the die area, core area, placement density, and other implementation parameters required by the OpenROAD flow. These settings allow the synthesis and physical design stages to execute successfully.

---

# PHASE 3 – Apply 100 MHz Clock Constraint

## Constraint File

To ensure correct timing analysis during synthesis and implementation, a Synopsys Design Constraints (SDC) file named `constraints.sdc` was created.

The following clock constraint was added:

![](Screenshots/3.png)
This defines a clock with a period of **10 ns**, corresponding to a target operating frequency of **100 MHz**.

## Clock Port Identification

![](Screenshots/4.png)
The clock input was identified by examining the top-level module `user_project_wrapper`. Among the module inputs, the signal `wb_clk_i` serves as the primary system clock and is distributed to all synchronous modules, including the debug register block.

Since this signal drives the sequential logic within the design, it was selected as the reference clock for timing analysis.

## Constraint Verification

The constraint file was linked to the OpenROAD Flow through the `SDC_FILE` variable in `config.mk`.

During synthesis and subsequent implementation stages, the timing engine uses this constraint to perform setup and hold analysis based on the specified 10 ns clock period.

The successful loading of the constraint enables the design to be optimized for the required operating frequency while ensuring accurate static timing analysis throughout the RTL-to-GDS implementation flow.
