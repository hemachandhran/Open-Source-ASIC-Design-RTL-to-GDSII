# 🚀 Open Source ASIC Design: RTL to GDSII

> A hands-on portfolio documenting my journey through the complete open-source ASIC design flow, from RTL to GDSII, using OpenLane, OpenROAD, ORFS, SKY130, Caravel, and VSDSquadron.

<p align="center">
  <img src="W1 - PicoRV32A ASIC Design Flow/Phase 1/Screenshots/Openlane_flow.png" width="900">
</p>

---

# 📖 About

This repository documents my hands-on journey through the complete open-source ASIC design flow, covering every major stage from RTL design to the final GDSII layout.

Throughout this journey, I explored multiple implementation and verification flows using **OpenLane**, **OpenROAD Flow Scripts (ORFS)**, **SKY130**, and the **Caravel SoC** ecosystem. Rather than simply executing the flow, I focused on understanding how each stage transforms a digital design, how the different tools interact, and how implementation decisions affect timing, area, routing, and overall design quality.

A significant part of this repository also focuses on **verification**. Using the **VSDSquadron SoC**, I explored both standalone peripheral verification and system-level verification within the **Caravel SoC** environment. I further extended this work by performing **Mixed-Mode Gate-Level Simulation (GLS)**, validating synthesized netlists inside the complete SoC without modifying the existing verification infrastructure. This provided valuable insight into post-layout verification and the differences between RTL and gate-level behavior.

Working through multiple implementation flows, debugging failed builds, resolving synthesis and routing issues, fixing floorplanning errors, integrating custom RTL, configuring Makefiles, handling standard-cell libraries, and validating gate-level simulations significantly strengthened my debugging and problem-solving skills. More importantly, it helped me understand not only *how* ASIC tools work, but also *why* different design and verification methodologies are used throughout the modern chip design process.

---

# 🏛 About the Caravel SoC

The **Caravel SoC** is an open-source SoC integration platform developed by **Efabless** for the Open MPW shuttle program. It provides a complete RISC-V based system with standardized interfaces, memory, GPIO, Wishbone bus, logic analyzer connections, clocking infrastructure, and a dedicated user project area where custom ASIC designs can be integrated.

Because Caravel already includes the infrastructure required for fabrication and verification, it allows designers to focus on implementing and validating their own hardware while learning realistic SoC integration and verification workflows similar to those used in industry.

---

# 🛣 ASIC Design Flow

```text
RTL Design
    │
    ▼
Logic Synthesis
    │
    ▼
Static Timing Analysis
    │
    ▼
Floorplanning
    │
    ▼
Placement
    │
    ▼
Clock Tree Synthesis
    │
    ▼
Routing
    │
    ▼
Physical Verification
    │
    ▼
GDSII Generation
    │
    ▼
Mixed-Mode Gate-Level Simulation
```

---

# 📂 Repository Structure

| Week | Topic | Description |
|------|-------|-------------|
| **W1** | PicoRV32A ASIC Design Flow | Complete RTL-to-GDSII implementation using OpenLane |
| **W2** | OpenROAD Flow Scripts (ORFS) | Understanding ORFS architecture, build process, and local execution |
| **W3** | SoC Block-Level Verification | Standalone and Caravel-based verification of VSDSquadron SoC peripherals |
| **W4** | User Project Wrapper | Complete RTL-to-GDSII implementation using ORFS |
| **W5** | Mixed-Mode Gate-Level Simulation | RTL vs GLS validation, waveform analysis, and post-layout verification within the Caravel environment |
| **W6** | Independent ASIC Block Implementation | Complete RTL-to-GDSII implementation and GLS validation of the Housekeeping SPI block |

---

# 🛠 Tools & Technologies

- OpenLane
- OpenROAD
- ORFS
- Yosys
- OpenSTA
- Magic
- KLayout
- GTKWave
- Icarus Verilog
- SKY130 PDK
- Caravel SoC
- VSDSquadron

---

# 🎯 Learning Outcomes

Through this repository, I developed a practical understanding of the complete ASIC design lifecycle, from RTL implementation to physical layout and post-layout verification.

More importantly, exploring different implementation flows and debugging real issues across synthesis, floorplanning, routing, timing analysis, and gate-level simulation strengthened my ability to troubleshoot complex design problems. Working with both standalone verification environments and the Caravel SoC also provided valuable experience with realistic SoC integration and verification methodologies used in modern semiconductor development.

---

# ⭐ Repository Guide

Each folder contains:

- Detailed documentation
- Step-by-step implementation
- Commands used
- Screenshots
- Reports
- Waveform analysis
- Debugging process
- Challenges encountered
- Key learning outcomes

The repository is organized sequentially, allowing readers to follow the complete journey from RTL design to a manufacturable GDSII layout while understanding the reasoning behind each stage of the ASIC implementation flow.
