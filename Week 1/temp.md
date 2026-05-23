# PicoRV32A Synthesis using OpenLANE (Sky130)

## Overview

This project documents the synthesis phase of the picorv32a RISC-V core using the OpenLANE ASIC flow with the Sky130 PDK.

The goal was not just to run commands blindly, but to understand:

- how OpenLANE organizes a design run
- how synthesis transforms RTL into gate-level hardware
- how reports are generated
- how timing and area are analyzed after synthesis

This repository captures screenshots, reports, and observations collected during the synthesis stage.

---

# Environment Setup

The OpenLANE container was launched and the design was prepared interactively.

---

# Design Preparation

## Observation

During preparation:

- OpenLANE loaded the picorv32a configuration
- Sky130A PDK was initialized
- Standard cell library `sky130_fd_sc_hd` was selected
- Run directory was automatically created

One interesting thing noticed here was that OpenLANE internally creates a timestamped run folder for every execution.

This makes experiments reproducible and prevents overwriting previous runs.

### Screenshot

```
1_design_preparation.png
```

---

# Run Directory Structure

## Generated Run Directory

### Observation

The run directory contained:

- `logs/`
- `reports/`
- `results/`
- `tmp/`

This separation makes debugging easier because:

- logs show execution flow
- reports contain analysis
- results contain generated design files
- tmp stores intermediate files

It felt surprisingly organized for such a complex ASIC flow.

### Screenshot

```
2_run_directory_structure.png
```

---

# Running Synthesis

## Synthesis Execution

### Observation

The synthesis stage converts RTL Verilog into:

- logic gates
- flip-flops
- buffers
- optimized netlists

OpenLANE also automatically performed:

- single-corner STA
- timing checks
- optimization

At this point, the design stops looking like “code” and starts looking like actual hardware.

### Screenshot

```
3_run_synthesis.png
```

---

# Synthesis Reports

## Generated Reports

### Observation

The synthesis reports included:

- area reports
- DFF statistics
- timing reports
- synthesis statistics

This showed how much information ASIC tools generate automatically after compilation.

### Screenshot

```
4_synthesis_reports.png
```

---

# Cell Count Analysis

## Synthesized Cell Statistics

### Observation

The synthesized design contained:

- **Total Cells: 15762**

A large number of logic cells were inserted automatically during synthesis.

Interesting observation:

many simple RTL operations expand into hundreds or thousands of actual gates after optimization.

The design heavily used:

- XOR gates
- OR gates
- combinational logic
- buffers

This gave a better appreciation for how large even a “small” processor really becomes at gate level.

### Screenshot

```
5_synthesis_cellcount.png
```

---

# Chip Area Report

## Area Estimation

### Observation

Reported chip area:

```text
160816.736000
```

This value represents the estimated silicon area occupied by the synthesized design.

One important realization here:

optimization is not only about functionality, but also:

- area
- timing
- power
- routability

ASIC design is basically controlled engineering chaos wrapped in reports.

### Screenshot

```
6_synthesis_area.png
```

---

# Flip-Flop Analysis

## DFF Count Report

### Observation

The design contained:

- **DFF Count: 1613**

Flop ratio calculation:

```text
1613 / 18508 = 0.0871
```

Approximately **8.7%** of the total cells are sequential elements.

This indicates the processor contains a significant amount of:

- state storage
- pipelined/control logic
- sequential circuitry

The remaining cells are mostly combinational logic.

### Screenshot

```
7_dff_count_report.png
```

---

# Pre-Synthesis Statistics

## Initial Synthesis Statistics

### Observation

Before technology mapping:

- the design was represented using generic logic cells
- synthesis optimization reduced and transformed the logic

Comparing pre-synthesis and mapped reports helped visualize how synthesis reshapes the hardware internally.

### Screenshot

```
8_pre_synthesis_stats.png
```

---

# Timing Analysis

## Timing Summary Report

### Key Results

```text
TNS = 0.00
WNS = 0.00
Worst Setup Slack = 0.52
Worst Hold Slack = 0.16
```

### Observation

This was probably the most satisfying part of the run.

The synthesized design passed timing successfully:

- no setup violations
- no hold violations

The positive slack values indicate that the design meets timing requirements under the analyzed corner.

This is where ASIC design suddenly feels very real.

### Screenshot

```
9_timing_summary_report.png
```

---

# Post-Synthesis Netlist

## Gate-Level Netlist

### Observation

The RTL was transformed into real standard cells such as:

```text
sky130_fd_sc_hd__buf_2
```

This gate-level netlist represents actual hardware components that can eventually be placed and routed physically.

At this stage:

- the design is no longer behavioral RTL
- it becomes manufacturable logic representation

Seeing the processor reduced into thousands of standard cells was honestly one of the coolest moments in the flow.

### Screenshot

```
10_post_synthesis_netlist.png
```

---

# Final Thoughts

This synthesis run helped in understanding:

- ASIC flow structure
- OpenLANE workflow
- synthesis reports
- timing analysis
- gate-level hardware representation

### Biggest takeaway

> Writing Verilog is only the beginning.  
> The real story starts when the tools begin transforming it into physical hardware.

---

# Tools Used

- OpenLANE
- OpenROAD
- Sky130A PDK
- PicoRV32A RISC-V Core
- VS Code Codespaces
- Docker
