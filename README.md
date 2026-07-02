# 🚀 Open Source ASIC Design: RTL to GDSII

> A hands-on portfolio documenting my journey through the complete open-source ASIC design flow, from RTL to GDSII, using OpenLane, OpenROAD, ORFS, SKY130, Caravel, and VSDSquadron.

<p align="center">
  <img src="W1 - PicoRV32A ASIC Design Flow -OpenLane/Phase 1/Screenshots/openlane_flow.png" width="900">
</p>

---

# 📖 About

This repository documents my hands-on journey through the complete open-source ASIC design flow, from RTL design to the final GDSII layout using **OpenLane**, **OpenROAD Flow Scripts (ORFS)**, **SKY130**, and the **Caravel SoC** ecosystem.

Along the way, I explored RTL synthesis, physical design, timing analysis, routing, and verification while understanding how each stage transforms a digital design and how implementation decisions impact timing, area, and overall design quality.

Using the **VSDSquadron SoC**, I performed standalone and Caravel-based verification, followed by **Mixed-Mode Gate-Level Simulation (GLS)** to validate synthesized netlists within the complete SoC environment. This provided practical experience with post-layout verification and RTL vs. gate-level behavior.

Beyond learning the tools, this journey strengthened my debugging and problem-solving skills by working through multiple implementation flows, resolving synthesis and routing issues, configuring design environments, and debugging gate-level simulations.

---

# 🏛 About the Caravel SoC

The **Caravel SoC** is an open-source SoC integration platform developed by **Efabless** for the Open MPW shuttle program. It provides a complete RISC-V based system with standardized interfaces, memory, GPIO, Wishbone bus, logic analyzer connections, clocking infrastructure, and a dedicated user project area where custom ASIC designs can be integrated.

Because Caravel already includes the infrastructure required for fabrication and verification, it allows designers to focus on implementing and validating their own hardware while learning realistic SoC integration and verification workflows similar to those used in industry.

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
