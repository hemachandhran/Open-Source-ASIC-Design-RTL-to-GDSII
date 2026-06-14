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
