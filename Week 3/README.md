# Block-Level Verification of VSDSquadron SoC

This repository documents my journey of understanding, executing, analyzing, and documenting the block-level verification flow of the VSDSquadron SoC in two levels:

1. **Standalone Verification** – Individual blocks were tested independently to validate their functionality.
2. **Caravel Integrated Verification** – The same peripherals were verified within the complete SoC environment to study real system interactions.

Through these activities, I gained hands-on experience with firmware compilation, RTL simulation, waveform generation, debugging, PASS/FAIL analysis, and SoC verification methodologies. This provided valuable insight into how modern semiconductor companies validate functional correctness before proceeding to later implementation stages such as synthesis, physical design, and tapeout.

---
## What is VSDSquadron SoC?

The **VSDSquadron SoC** is an educational RISC-V System-on-Chip platform developed by **VLSI System Design (VSD)** to help students and engineers learn modern SoC design, verification, firmware development, and hardware-software interaction. It is built around the **Caravel SoC framework** and incorporates the **VexRISC-V processor**, providing a complete environment for exploring open-source silicon design and verification workflows.

The platform exposes several commonly used peripherals and interfaces such as:

* VexRISC-V Processor
* SPI Interface
* UART Interface
* SRAM and External Flash Memory
* GPIO Interfaces
* Housekeeping SPI (HKSPI)
* PLL and System Control Blocks
* USB-based Programming through FTDI

These peripherals make the VSDSquadron SoC an ideal platform for learning how different hardware blocks interact within a complete SoC environment.

## Why VSDSquadron SoC?

Learning individual RTL blocks such as UARTs, FIFOs, FSMs, and SPI controllers is important, but real semiconductor products integrate hundreds of such blocks into a single chip. VSDSquadron bridges this gap by providing a realistic SoC environment where these components can be verified and validated together.

The platform enables engineers to:

* Understand SoC-level integration concepts.
* Learn firmware-driven verification methodologies.
* Execute standalone and system-level verification tests.
* Analyze interactions between processor, memory, and peripherals.
* Explore the complete RTL simulation and debugging workflow.
* Gain practical exposure to open-source silicon development.

---

## Phase 1: Standalone SPI Master Verification

Performed a detailed study of the SPI Master standalone verification environment to understand the complete verification workflow.

### Highlights

* Verification environment study
* Firmware compilation flow
* RTL simulation execution
* Waveform analysis
* PASS/FAIL mechanism understanding

---

## Phase 2: Standalone Block Verification

Executed all standalone verification tests and documented their simulation results.

### Highlights

* Test execution
* Result validation
* Timeout analysis
* Waveform inspection

### Standalone Results

| Test | Status |
|--------|--------|
| GPIO Mgmt | PASS |
| Memory | PASS |
| UART | PASS |
| SPI Master | PASS |
| Timer | FAIL (Timeout) |
| IRQ | FAIL (Timeout) |
| Debug | FAIL (Timeout) |

---

## Phase 3: Caravel Integrated Verification

Executed all Caravel-integrated verification tests to validate peripherals and management SoC functionality inside the Caravel environment.

### Highlights

* Caravel test execution
* Peripheral validation
* Simulation result analysis
* PASS/FAIL verification

### Caravel Results

| Test | Status |
|--------|--------|
| user_pass_thru | PASS |
| uart | PASS |
| sysctrl | FAIL (Timeout) |
| sram_exec | PASS |
| spi_master | PASS |
| pullupdown | PASS |
| pll | FAIL |
| pass_thru_fix | PASS |
| mem | PASS |
| hkspi_power | PASS |
| gpio_mgmt | PASS |
| hkspi | PASS |

---

## Phase 4: Verification Flow Understanding

Studied the verification methodology used across all standalone and Caravel test environments.

### General Verification Flow

```text
Makefile
   ↓
Firmware Compilation
   ↓
HEX Generation
   ↓
RTL + Testbench Compilation
   ↓
Simulation (VVP)
   ↓
Waveform Generation (.vcd)
   ↓
Result Analysis
   ↓
PASS / FAIL
```

### Highlights

* Build flow understanding
* Simulation workflow study
* Testbench interaction analysis
* Verification methodology overview

---

## Learning Experience

Week-3 focused on understanding the complete block-level verification infrastructure used in the VSDSquadron SoC environment. I studied a standalone SPI Master verification flow in detail, executed standalone and Caravel-integrated tests, analyzed simulation outcomes, and documented the overall verification methodology.

This experience strengthened my understanding of firmware-assisted verification, RTL simulation, waveform analysis, debugging techniques, and SoC verification workflows.
