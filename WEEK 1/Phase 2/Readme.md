# PicoRV32A Floorplanning and Placement using OpenLANE (Sky130)

---

# Overview

This project documents the floorplanning and placement phases of the picorv32a RISC-V core using the OpenLANE ASIC flow with the Sky130 PDK.

The objective was not simply to execute commands but to understand:

- how synthesized logic is converted into physical space
- how floorplanning determines chip dimensions
- how utilization affects area and density
- how power planning begins before cell placement
- how placement transforms an empty floorplan into organized hardware

This phase felt like the point where the design stopped being Verilog and started becoming a real chip.

---

# 1. Running Floorplan

The floorplanning stage was executed after synthesis.

## Command

```bash
run_floorplan
```

During execution OpenLANE generated:

- Core dimensions
- IO placement
- Tap/Decap insertion
- Power Distribution Network (PDN)

### Observed Output

```text
Floorplanned with width = 1267.76 µm
Floorplanned with height = 1267.52 µm
```

---

# Aspect Ratio

Aspect ratio defines the shape of the chip core.

## Formula

```text
Aspect Ratio = Width of Die / Height of Die
```

Substituting:

```text
Aspect Ratio = 1267.76 / 1267.52 ≈ 1
```

## Observation

The generated floorplan was nearly square.

A balanced aspect ratio helps:

- simplify routing
- reduce congestion
- improve placement quality

### Screenshot

```text
1_running_floorplan.png
```

---

# 2. Understanding Design Configuration

The design configuration file was inspected.

## File

```text
designs/picorv32a/config.tcl
```

Observed:

```tcl
set ::env(FP_CORE_UTIL) "10"
```

---

#Utilization Factor

Utilization determines how densely cells occupy the available core.

## Formula

```text
Utilization (%) = (Cell Area / Core Area) × 100
```

For:

```text
FP_CORE_UTIL = 10
```

Only **10%** of the core area is intended to be occupied.

## Observation

Lower utilization results in:

- larger chip area
- lower congestion
- easier routing

### Screenshot

```text
2_design_config.tcl.png
```

---

# 3. Verifying Applied Configuration

The generated run configuration was inspected.

## Location

```text
runs/RUN_xxx/config.tcl
```

This revealed an important OpenLANE concept.

## Configuration Application Order

```text
1. SKY130 PDK Config
   Technology defaults
      ↓
2. Design Config
   User overrides
      ↓
3. OpenLANE Defaults
      ↓
Final configuration stored inside:
runs/RUN_xxx/config.tcl
```

## Observation

The run folder acts as a frozen snapshot of the executed configuration.

### Screenshot

```text
3_initial_core_utilization.png
```

---

# 4. Observing Die Area

The generated DEF file was inspected.

## Location

```text
results/floorplan/picorv32a.def
```

Observed:

```text
UNITS DISTANCE MICRONS 1000 ;
DIEAREA ( 0 0 ) ( 1279175 1289895 ) ;
```

DEF stores:

- die dimensions
- rows
- placement information

DEF stores dimensions in Database Units (DBU).

Since:

```text
1000 DBU = 1 µm
```

### Die Area Calculation

```text
Die Area = Width × Height
= 1279.175 × 1289.895
≈ 1,650,898 µm²
```

## Observation

The die dimensions reflected utilization directly.

More whitespace produced larger chip dimensions.

### Screenshot

```text
4_die_area_def_file.png
```

---

# 5. Viewing Floorplan in Magic

The floorplan was loaded using Magic.

## Command

```bash
magic -T sky130A.tech \
lef read ../../../tmp/merged.nom.lef \
def read picorv32a.def &
```

## Observation

Magic converts OpenLANE output into actual physical structures.

This allowed visualization of:

- rows
- metal layers
- boundaries
- placement regions

### Screenshot

```text
5_magic_command_for_floorplanning_view.png
```

---

# 6. Floorplan Layout Review

## Observation

At this stage:

- rows existed
- PDN existed
- placement had not started

The layout looked like an empty city waiting for buildings.

### Screenshot

```text
6_floorplan_full_layout.png
```

---

# 7. Standard Cells and Macro Awareness

Zooming into the layout revealed standard cells.

Standard cells are:

- small logic blocks
- fixed height
- automatically arranged

Examples:

- NAND
- NOR
- Flip-Flops

### Screenshot

```text
7_standard_cells in.png
```

## Why RAM behaves differently from standard cells

Macros such as SRAM:

- have fixed size
- cannot be reshaped
- occupy dedicated regions

Standard cells:

- are flexible
- automatically optimized
- densely packed

Macros influence:

- congestion
- routing
- floorplan quality

Standard cells are placed automatically during placement, while macros remain fixed and influence available placement regions.

---

# 8. Decaps and Metal Pins

## Magic Command

```bash
what
```

Selected layer:

```text
metal3
```

## Observation

Metal pins provide routing access.

Decap cells act as local charge reservoirs to:

- stabilize voltage
- reduce switching noise
- improve power integrity

### Screenshot

```text
8_pin_layer_identification.png
```

---

# 9. Power Distribution Network (PDN)

During floorplan execution OpenLane automatically generated the PDN.

Observed labels:

- VPWR
- VGND

These represent:

- VPWR → Power
- VGND → Ground

## Observation

One interesting realization here was that OpenLANE starts building electrical infrastructure before actual logic placement.

PDN ensures:

- stable power delivery
- reduced IR drop
- improved voltage reliability

The horizontal rails distribute current while vertical rails connect power across the core.

This showed that floorplanning is not only geometry but also electrical planning.

### Screenshot

```text
9_power_distribution_network_layout.png
```

---

# 10. Modifying Utilization

Before:

```text
FP_CORE_UTIL = 10
```

After:

```text
FP_CORE_UTIL = 30
```

## Observation

Increasing utilization reduced whitespace and compressed the design.

### Screenshot

```text
10_modified_design_config.tcl.png
```

---

# 11. Confirming Configuration Override

Observed:

```text
FP_CORE_UTIL = 30
```

## Observation

This confirmed successful configuration override.

### Screenshot

```text
11_updated_core_utilization.png
```

---

# 12. Updated Die Area

Initial:

```text
1279175 × 1289895
```

Updated:

```text
743200 × 753920
```

Width = **743.2 µm**  
Height = **753.92 µm**

## Calculation

```text
Die Area = Width × Height
= 743.2 × 753.92
≈ 560,915 µm²
```

## Observation

Increasing utilization significantly reduced die dimensions.

Relationship observed:

```text
More utilization → Smaller area → Higher density
```

### Screenshot

```text
12_updated_die_area_def_file.png
```

---

# 13. Running Placement

## Command

```bash
run_placement
```

Placement stages:

### Global Placement

Determines approximate locations.

Goal:

- minimize wirelength
- reduce congestion

### Detailed Placement

Refines placement.

Goal:

- remove overlap
- legalize cells

## Observation

Placement transforms synthesized standard cells into physically optimized locations while minimizing wirelength and reducing congestion.

Higher utilization increases placement density and may increase routing congestion.

### Screenshot

```text
13_running_placement.png
```

---

# 14. Viewing Placement in Magic

## Command

```bash
magic -T sky130A.tech \
lef read ../../../tmp/merged.nom.lef \
def read picorv32a.def &
```

### Screenshot

```text
14_magic_command_for_placement_view.png
```

---

# 15. Placement Layout

## Observation

Thousands of synthesized cells occupied the floorplan automatically.

Compared to floorplan:

### Before

- Empty rows

### After

- Actual cell organization

This was the first stage where the chip began looking like real hardware.

### Screenshot

```text
15_placement_full_layout.png
```

---

# 16. Post-Placement Standard Cell Inspection

## Observation

Individual standard cells became visible.

Examples observed:

- buffers
- multiplexers
- flip-flops
- clock buffers
- logic gates

Cells appeared aligned along placement rows.

Placement decisions were influenced by:

- connectivity
- timing requirements
- congestion reduction
- routing feasibility

## Inference

This image confirmed that placement is not random.

Placement transforms the logical netlist into an optimized physical arrangement of standard cells inside the core.

This stage prepares the design for later routing stages and converts RTL into visible silicon organization.

### Screenshot

```text
16_post_placement_standard_cell_view.png
```

---

# Final Thoughts

This phase helped in understanding:

- floorplanning decisions
- utilization factor
- aspect ratio
- PDN generation
- DEF interpretation
- standard cells vs macros
- placement behavior
- congestion concepts

## Biggest takeaway

> Writing RTL creates logic.  
> Floorplanning decides where that logic lives.  
> Placement decides how that logic is physically organized.

---

# Tools Used

- OpenLANE
- OpenROAD
- Magic Layout Viewer
- SKY130A PDK
- PicoRV32A RISC-V Core
- VS Code Codespaces
- Docker
