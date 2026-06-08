# Block-Level Verification of VSDSquadron SoC

This repository documents my journey of understanding, executing, analyzing, and documenting the block-level verification flow of the VSDSquadron SoC using both Standalone and Caravel-integrated verification environments.

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
