# Waveform Analysis

This document presents the important waveforms captured during both **Standalone Gate-Level Simulation (GLS)** and **Caravel Gate-Level Simulation (GLS)**. The waveforms were analyzed to verify the functionality of different modules after physical implementation.

---

# 1. Standalone Gate-Level Simulation Waveforms

## UART

The UART waveform confirms successful serial data transmission during gate-level simulation.

![UART Standalone](Waveforms/standalone/uart.png)

---

## GPIO Management

The GPIO waveform shows the expected GPIO transitions generated during simulation.

![GPIO Management Standalone](Waveforms/standalone/gpio_mgmt.png)

---

## Memory

The memory waveform verifies successful read and write operations with the expected checkbit values.

![Memory Standalone](Waveforms/standalone/mem.png)

---

## SPI Master

The SPI waveform shows correct SPI clock generation and data transfer.

![SPI Master Standalone](Waveforms/standalone/spi_master.png)

---

## Timer

The timer waveform was captured before the simulation reached the timeout condition.

![Timer Standalone](Waveforms/standalone/timer.png)

---

## IRQ

The interrupt status waveform captured during gate-level simulation.

![IRQ Standalone](Waveforms/standalone/irq.png)

---

## Debug

The debug waveform captured before the timeout occurred.

![Debug Standalone](Waveforms/standalone/debug.png)

---

## Standalone GLS Result Summary

The overall standalone verification results are shown below.

<p>
<img src="Waveforms/standalone/report.png" width="800">
 
</p>

---

# 2. Caravel Gate-Level Simulation Waveforms

## User Pass Through

The waveform verifies the pass-through interface during Caravel gate-level simulation.

![User Pass Through](Waveforms/caravel/user_pass_thru.png)

---

## UART

UART communication waveform captured during Caravel GLS.

![UART Caravel](Waveforms/caravel/uart.png)

---

## System Controller

System controller waveform observed during the timeout-limited simulation.

![SysCtrl](Waveforms/caravel/sysctrl.png)

---

## SRAM Execution

Waveform showing SRAM execution status transitions.

![SRAM Execution](Waveforms/caravel/sram_exec.png)

---

## SPI Master

SPI Master communication waveform.

![SPI Master](Waveforms/caravel/spi_master.png)

---

## Pull-up/Pull-down

GPIO pull-up and pull-down verification waveform.

![Pullupdown](Waveforms/caravel/pullupdown.png)

---

## PLL

PLL waveform captured during gate-level simulation.

![PLL](Waveforms/caravel/pll.png)

---

## Pass-through Fix

Waveform showing the corrected pass-through implementation.

![Pass Through Fix](Waveforms/caravel/pass_thru_fix.png)

---

## Memory

Memory read/write verification waveform.

![Memory Caravel](Waveforms/caravel/mem.png)

---

## HKSPI Power

HKSPI power-control waveform.

![HKSPI Power](Waveforms/caravel/hkspi_power.png)

---

## GPIO Management

GPIO management waveform captured during Caravel verification.

![GPIO Management Caravel](Waveforms/caravel/gpio_mgmt.png)

---

## HKSPI

HKSPI communication waveform.

![HKSPI](Waveforms/caravel/hkspi.png)

---

## Caravel GLS Result Summary

The overall Caravel verification results are shown below.

![Caravel Report](Waveforms/caravel/report.png)

---

# Summary

The collected waveforms confirm the functionality of the synthesized design during both standalone and Caravel gate-level simulations. The captured traces were used to verify communication interfaces, memory operations, GPIO behavior, interrupt handling, and peripheral functionality after physical implementation.
