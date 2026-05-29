# PicoRV32A Custom Standard Cell Integration and Multi-Corner Timing Analysis using OpenLANE (Sky130)

---
## Overview

This project documents the integration of a custom inverter standard cell into the PicoRV32A RISC-V processor using the OpenLANE ASIC flow and the SKY130 Process Design Kit.

The objective was not only to insert a custom cell into the design but also to understand:

* How OpenLane incorporates external standard cells
* How custom timing libraries are linked to a design
* How synthesis utilizes integrated cells
* How OpenLane performs timing analysis
* How OpenSTA can be used for independent multi-corner timing verification
* How timing constraints influence design closure
* How custom cells appear physically after placement

This phase was particularly interesting because the design initially appeared timing-clean inside the OpenLane flow, but a deeper investigation using OpenSTA revealed timing violations under different operating corners.

---

# Integrating the Custom Standard Cell

## Preparing Design Resources

To integrate the custom inverter into the PicoRV32A design, several supporting files were added to the design source directory.

The following files were placed inside the design source folder:

* Slow timing library (.lib)
* Typical timing library (.lib)
* Fast timing library (.lib)
* Custom timing constraint file (my_base.sdc)
* Custom inverter LEF file

### Observation

The Liberty (.lib) files provide timing information for the custom cell under different process corners.

The LEF file provides physical information such as:

* Cell dimensions
* Pin locations
* Routing blockages

The SDC file provides timing constraints that will later be used during OpenSTA analysis.

---

## Configuring OpenLane

The design configuration file was modified to include the custom libraries.

The following environment variables were configured:

* LIB_SYNTH
* LIB_FASTEST
* LIB_SLOWEST
* LIB_TYPICAL

The custom LEF was also linked through:

`EXTRA_LEFS`

### Observation

This step allows OpenLane to recognize the physical and timing information associated with the custom inverter.

Without these modifications, OpenLane would be unaware of the existence of the custom standard cell.

---

# Running Synthesis

## Loading the Custom LEF

Before synthesis, the custom LEF file was loaded into the OpenLane flow.

OpenLane successfully merged the custom inverter LEF with the existing SKY130 standard-cell libraries.

### Observation

Successful LEF merging confirmed that the custom cell was physically compatible with the standard SKY130 cell architecture.

---

## Synthesis Execution

Synthesis was executed after integrating the custom inverter.

During synthesis OpenLane:

* Read RTL Verilog
* Mapped logic to standard cells
* Performed optimization
* Generated a gate-level netlist
* Executed built-in STA

### Observation

The synthesis process completed successfully without any integration errors.

This confirmed that the custom inverter could be used together with the default SKY130 standard cells.

---

## Verifying Cell Usage

The generated synthesis report was inspected.

Important observations:

* Total Cell Count: **15,762**
* Custom Cell Instances: **187**

The report clearly showed the presence of:

```text
sky130_vsdinv
```

inside the synthesized netlist.

### Observation

This was a major milestone because it confirmed that synthesis was actually selecting the custom inverter during technology mapping rather than ignoring it.

The custom cell became a functional part of the processor implementation.

---

## Synthesis Strategy Investigation

The synthesis configuration was examined.

Observed value:

```text
SYNTH_STRATEGY = AREA 0
```

### Observation

AREA 0 focuses on minimizing silicon area rather than aggressively optimizing timing.

This explains why the resulting design achieved a relatively compact implementation while maintaining timing closure inside the default OpenLane flow.

---

# Initial Timing Analysis

## OpenLane STA Results

After synthesis, OpenLane automatically executed Single-Corner Static Timing Analysis.

Reported results:

| Metric            | Value   |
| ----------------- | ------- |
| TNS               | 0.00    |
| WNS               | 0.00    |
| Worst Setup Slack | 0.52 ns |
| Worst Hold Slack  | 0.17 ns |

### Observation

No setup violations were reported.

No hold violations were reported.

At this stage the design appeared completely timing-clean.

This initially suggested that the integration of the custom inverter had no negative impact on timing.

---

# Investigating the Timing Discrepancy

## An Interesting Discovery

While reviewing the OpenLane synthesis flow, it was noticed that the timing reports did not appear to use the custom Liberty files that had been added.

Instead, OpenLane synthesis STA relied on:

* trimmed.lib
* Default SKY130 timing corners
* Internally generated timing constraints

### Observation

This raised an important question:

> If OpenLane was not using the exact custom timing libraries for analysis, were the reported timing results truly representative of the custom cell behavior?

This motivated an independent OpenSTA analysis.

---

# Multi-Corner Timing Analysis using OpenSTA

## Creating pre_sta.conf

A standalone OpenSTA configuration file was created.

The script loaded:

* Fast Liberty Library
* Typical Liberty Library
* Slow Liberty Library
* Synthesized Netlist
* Custom SDC Constraints

The script then generated timing reports for:

* Fast Corner
* Typical Corner
* Slow Corner

### Observation

Unlike the default OpenLane flow, OpenSTA allowed explicit control over the timing environment and analysis corners.

---

## Fast Corner Analysis

Result:

```text
Slack = +0.252 ns
```

### Observation

The design successfully met timing requirements.

The faster transistor behavior reduced propagation delay and improved timing margins.

---

## Typical Corner Analysis

Result:

```text
Slack = +1.32 ns
```

### Observation

The design comfortably met timing requirements under nominal operating conditions.

This represented the expected operating environment.

---

## Slow Corner Analysis

Result:

```text
Slack = -10.75 ns
```

**Violation Detected**

### Observation

The slow process corner produced significant setup timing violations.

This demonstrated how dramatically process variations can affect circuit performance.

Although the design appeared timing-clean during OpenLane synthesis, the slow corner exposed hidden timing weaknesses.

---

## Final OpenSTA Summary

Reported:

```text
WNS = -10.75 ns
TNS = -552.47 ns
```

### Key Discovery

```text
Same Netlist
Different Libraries
Different Constraints
Different Timing Results
```

This became the most important learning outcome of the entire phase.

Timing closure depends heavily on analysis conditions and cannot be judged from a single timing corner alone.

---

# Timing Optimization Experiments

## Synthesis Parameter Exploration

Several synthesis options were explored:

* SYNTH_STRATEGY
* SYNTH_SIZING
* SYNTH_BUFFERING

These settings influence:

* Gate sizing
* Buffer insertion
* Area optimization
* Delay optimization

### Observation

Modifying these parameters produced only minor improvements.

Although OpenLane timing reports improved slightly, the custom Liberty-based OpenSTA analysis still showed violations.

This indicated that the root cause was not solely synthesis optimization.

---

# Constraint Engineering

## Improving Timing through SDC Modifications

To further investigate the timing violations, additional constraints were introduced inside the SDC file.

The following parameters were modified.

### Clock Uncertainty

```tcl
set_clock_uncertainty -1.25 [get_clocks clk]
```

**Purpose**

Represents clock margin and uncertainty between launch and capture clocks.

**Effect**

Adjusted the timing window used during analysis.

---

### Timing Derates

```tcl
set_timing_derate -early 0.95
set_timing_derate -late 1.05
```

**Purpose**

Models manufacturing variation effects.

**Effect**

Provides more realistic timing estimation under process variation.

---

### Clock Transition

```tcl
set_clock_transition 0.15 [get_clocks clk]
```

**Purpose**

Defines clock slew characteristics.

**Effect**

Improves timing modeling accuracy.

---

### Input Transition

```tcl
set_input_transition 0.15 [all_inputs]
```

**Purpose**

Models realistic signal arrival behavior.

**Effect**

Produces timing calculations closer to physical operation.

---

## Results after Constraint Modification

Updated OpenSTA Results:

```text
WNS = -2.36 ns
TNS = -31.90 ns
```

### Observation

The timing violation was significantly reduced.

| Metric | Before     | After     |
| ------ | ---------- | --------- |
| WNS    | -10.75 ns  | -2.36 ns  |
| TNS    | -552.47 ns | -31.90 ns |

This demonstrated the importance of accurate timing constraints in achieving timing closure.

Constraint engineering proved more effective than merely changing synthesis settings.

---

# Physical Verification

## Floorplan and Placement

After timing analysis, floorplanning and placement were executed.

The generated placement DEF file was inspected inside Magic.

### Observation

The objective was to verify whether the custom inverter had been physically instantiated inside the placed design.

---

## Finding the Custom Cell

The placed design was searched manually inside Magic.

After examining the placement rows, an instance of:

```text
sky130_vsdinv
```

was successfully located.

### Observation

This confirmed:

* Successful logical integration
* Successful physical integration
* Successful placement inside the processor layout

The custom inverter was no longer just a library entry.

It had become part of the physical silicon implementation.

Finding the tiny cell among thousands of placed instances took several minutes, but it served as the final proof that the integration was successful.

(*Ngl, it took me about 5 minutes to find this minion among thousands of standard cells 😄*)

---

# Final Thoughts

This phase helped in understanding:

* Custom standard cell integration
* Liberty and LEF usage
* OpenLane synthesis behavior
* Technology mapping
* Multi-corner timing analysis
* OpenSTA workflows
* Timing constraints
* Timing optimization techniques
* Physical verification in Magic

## Biggest Takeaway

A timing-clean synthesis report does not guarantee timing closure under all operating conditions.

Only by analyzing multiple timing corners and carefully constructing constraints can the true behavior of a design be understood.

The custom inverter was successfully integrated, analyzed, optimized, and physically verified inside the PicoRV32A processor, completing the transition from a standalone cell to a functional component of a larger ASIC design.

## Tools Used

- **OpenLane v1.0.2** - RTL-to-GDSII ASIC Design Flow
- **OpenSTA** - Static Timing Analysis
- **Yosys** - RTL Synthesis
- **Magic VLSI** - Layout Visualization
- **SKY130A PDK** - Process Design Kit
- **GitHub Codespaces** - Linux Development Environment
- **Visual Studio Code** - Editing and Analysis
