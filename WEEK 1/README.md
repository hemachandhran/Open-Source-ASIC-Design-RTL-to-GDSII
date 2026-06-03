# PicoRV32A ASIC Design Flow using OpenLane (SKY130)

This repository documents the complete RTL-to-GDSII implementation of the PicoRV32A RISC-V processor using the OpenLane flow and SKY130A PDK.

---

## Phase 1: Synthesis
Converts RTL into a gate-level netlist using SKY130 standard cells.

**Highlights**
- Technology mapping
- Cell count and area analysis
- Timing report analysis
- Gate-level netlist generation

---

## Phase 2: Floorplanning & Placement
Creates the physical layout framework and places standard cells inside the design core.

**Highlights**
- Core utilization and die area
- Standard cells and macros
- Power infrastructure
- Global and detailed placement

---

## Phase 3: Custom Cell Integration & STA
Integrates a custom inverter and performs timing analysis across multiple process corners.

**Highlights**
- Custom LEF/Liberty integration
- Multi-corner STA
- Synthesis optimization
- Constraint engineering

---

## Phase 4: Clock Tree Synthesis (CTS)
Builds the clock distribution network and analyzes post-CTS timing behavior.

**Highlights**
- Clock buffer insertion
- Clock skew and fanout analysis
- Setup and hold timing
- Pre-CTS vs Post-CTS comparison

---

## Phase 5: PDN, Routing & Signoff Preparation
Generates the power network and completes signal routing.

**Highlights**
- PDN generation
- Global and detailed routing
- Routed layout inspection
- SPEF, DRC, LVS and signoff concepts

---

## Learning Experience

Working through the complete ASIC implementation flow provided valuable insight into how a digital design evolves from RTL code into a manufacturable integrated circuit.

Throughout this project, I gained hands-on experience with RTL synthesis, floorplanning, placement, timing analysis, clock tree synthesis, power distribution, routing, and signoff concepts using industry-relevant open-source tools. Beyond learning individual stages, the project highlighted how closely area, timing, power, congestion, and physical constraints are interconnected.

One of the most valuable takeaways was understanding that successful chip design is an iterative optimization process. Decisions made during synthesis can influence placement, timing, clock distribution, routing complexity, and ultimately the final physical implementation.

This journey provided a strong foundation in modern VLSI design methodologies and significantly improved my understanding of both frontend and backend ASIC design flows.
