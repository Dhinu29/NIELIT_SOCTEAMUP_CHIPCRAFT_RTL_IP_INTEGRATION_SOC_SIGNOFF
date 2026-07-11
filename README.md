# 🚀 Design and Implementation of a RISC-V Based SoC Subsystem with AXI4-Lite Interconnect

> Final Internship Project | ChipCraft VLSI Internship

## 📖 Project Overview

A RISC-V based System-on-Chip featuring the PicoRV32 processor core, AXI-Lite
interconnect, ROM, SRAM, and UART peripheral was physically implemented using
OpenLane's open-source RTL-to-GDSII flow. The process kicked off with Yosys performing
logic synthesis to map the Verilog RTL to SkyWater 130nm standard cells, followed by
OpenROAD handling the full backend flow—floorplanning to set die area and power grid, IO
placement for clock/reset/UART ports, global and detailed placement of standard cells, clock
tree synthesis for balanced skew, and two-stage routing (global then detailed) across all
available metal layers.
After routing, OpenSTA verified timing closure with SPEF parasitics at the typical corner,
while Magic handled DRC and Netgen performed LVS checks. The final GDSII file emerged
ready for fabrication, representing the complete physical layout using Klayout. This compact
RISC-V SoC successfully navigated timing, area, and foundry rule constraints through
OpenLane's automated yet highly capable flow.

---

# 🎯 Project Objectives

1. To design and implement a RISC-V based SoC subsystem using the PicoRV32 core
with AXI-Lite interconnect and peripherals.
2. To perform logic synthesis of the RTL design using Yosys and map it to standard cell
libraries.
3. To execute the complete physical design flow (floorplanning, placement, CTS, and
routing) using OpenROAD within the OpenLane framework.
4. To validate the design through timing analysis and physical verification using
OpenSTA, Magic VLSI, and KLayout.
5. To generate the final GDSII layout and analyze power, performance, and area (PPA)
for embedded system applications.

---

# 🏗️ System Architecture
<img width="1263" height="647" alt="image" src="https://github.com/user-attachments/assets/915126cf-927e-4ad9-a42d-4bd9af6166a2" />
---

The PicoRV32 CPU Core consists of modules like the Instruction Decoder, ALU, Register File
(x0–x31), Memory Controller, and IRQ Handler, which together execute instructions.
Inputs such as clk, resetn, irq [31:0], mem_ready, and mem_rdata [31:0] control operation and
provide data. The core generates outputs like mem_valid, mem_addr [31:0], mem_wdata
[31:0], and mem_wstrb [3:0] to interact with memory. It also signals eoi [31:0] for interrupt
completion and trap to indicate the CPU has halted.

<img width="1340" height="641" alt="image" src="https://github.com/user-attachments/assets/5c33f196-817d-4693-b48e-618412580afe" />

The PicoRV32 CPU core is synthesized into standard cells and placed with careful
consideration of timing paths driven by clk and controlled by resetn. The memory interface
signals (mem_valid, mem_ready, mem_addr [31:0], mem_wdata [31:0], mem_rdata [31:0]) are
routed to the AXI Bridge, which is implemented as an FSM and optimized for timing and area.
The AXI Decoder and AXI-Lite Bus (32-bit) require structured floorplanning to ensure
efficient routing and minimal congestion between modules. Memory blocks like ROM and
SRAM are typically implemented as macros and placed strategically to reduce wirelength and
access latency. The UART AXI and UART TX blocks are placed near I/O pads to simplify
routing to the uart_tx pin. Proper clock tree synthesis ensures low skew across all sequential
elements, while power distribution and routing are optimized to maintain signal integrity and
meet timing closure

# 📚 Project Development Stages

## 1. Fundamentals of the RISC-V ISA
## 📖 What is an Instruction Set Architecture (ISA)?
<img width="901" height="421" alt="image" src="https://github.com/user-attachments/assets/a979ffbf-f431-4c4c-81a7-e0f4b16b2a71" />

An **Instruction Set Architecture (ISA)** is the interface between **software** and **hardware**. It defines the set of instructions a processor understands, allowing software to execute consistently across different processors that implement the same ISA.

### 🍽️ Simple Analogy

Think of an ISA as a **restaurant menu**:

| Restaurant Analogy | Computer System                    |
| ------------------ | ---------------------------------- |
| Menu               | Instruction Set Architecture (ISA) |
| Customer           | Software / Program                 |
| Waiter             | Compiler / Operating System        |
| Kitchen            | CPU Hardware                       |
| Dishes             | Machine Instructions               |

The customer only needs to know **what can be ordered**, not **how the kitchen prepares it**. Similarly, software only needs to know the ISA, while the processor handles the internal implementation.

---

## What Does an ISA Define?

An ISA specifies:

* ✅ The set of valid CPU instructions
* ✅ Processor registers and their usage
* ✅ Memory addressing modes
* ✅ Data types and formats
* ✅ Instruction encoding
* ✅ Privileged operations and exceptions
* ✅ How software communicates with hardware

---

## Why is an ISA Important?

The ISA provides a standardized programming model, enabling compatibility between software and hardware.

### Benefits

* Software written for one ISA can run on **any processor implementing that ISA**.
* Hardware designers can improve processor implementations without changing application software.
* Enables a large ecosystem of compilers, operating systems, debuggers, and development tools.
* Ensures portability and long-term software compatibility.

---

## Common Instruction Set Architectures

| ISA        | Typical Applications                                            |
| ---------- | --------------------------------------------------------------- |
| **x86**    | Desktop PCs, Workstations, Servers                              |
| **ARM**    | Smartphones, Tablets, Embedded Systems                          |
| **MIPS**   | Networking Equipment, Routers, Academic Systems                 |
| **RISC-V** | Open-source processors, Research, Embedded Systems, Modern SoCs |

---

## Why RISC-V?

This project uses the **RISC-V RV32I** architecture because it is:

* Open-source and royalty-free
* Modular and highly customizable
* Well-suited for embedded systems and ASIC design
* Supported by a growing ecosystem of development tools
* Ideal for learning computer architecture and System-on-Chip (SoC) design


## 🖥️ PicoRV32 — CPU Core Used in This Project

### Core Information

| Feature             | Description                |
| ------------------- | -------------------------- |
| **CPU Core**        | PicoRV32                   |
| **RTL File**        | `rtl/picorv32.v`           |
| **RTL Size**        | ~3100 lines of Verilog HDL |
| **Instruction Set** | RV32I (Base Integer ISA)   |

### Core Configuration

| Parameter           | Value         | Description                                                             |
| ------------------- | ------------- | ----------------------------------------------------------------------- |
| `ENABLE_COUNTERS`   | `1`           | Enables cycle and instruction-retired counters (`cycle` and `instret`). |
| `ENABLE_REGS_16_31` | `1`           | Enables the complete 32-register file (`x0`–`x31`).                     |
| `ENABLE_MUL`        | `0`           | Hardware multiplier disabled to reduce area.                            |
| `ENABLE_DIV`        | `0`           | Hardware divider disabled to reduce area.                               |
| `COMPRESSED_ISA`    | `0`           | Compressed (RVC) 16-bit instruction support disabled.                   |
| `CATCH_ILLINSN`     | `1`           | Traps illegal instructions for safe execution.                          |
| `CATCH_MISALIGN`    | `1`           | Traps misaligned memory accesses.                                       |
| `PROGADDR_RESET`    | `0x0000_0000` | Reset vector (boot address).                                            |
| `STACKADDR`         | `0x0001_00FC` | Initial stack pointer address.                                          |

### Memory Interface Signals

| Signal      | Direction | Width   | Description                                          |
| ----------- | --------- | ------- | ---------------------------------------------------- |
| `mem_valid` | Output    | 1 bit   | Indicates a valid memory request.                    |
| `mem_instr` | Output    | 1 bit   | `1` = Instruction fetch, `0` = Data access.          |
| `mem_addr`  | Output    | 32 bits | Target memory address.                               |
| `mem_wdata` | Output    | 32 bits | Data to be written to memory.                        |
| `mem_wstrb` | Output    | 4 bits  | Byte-enable signals for write operations.            |
| `mem_ready` | Input     | 1 bit   | Indicates that the memory transaction has completed. |
| `mem_rdata` | Input     | 32 bits | Data returned from memory during read operations.    |
| `resetn`    | Input     | 1 bit   | Active-low system reset signal.                      |


# 📚 RISC-V Registers (x0–x31)

> **Analogy:** Registers are like your **work desk**, RAM is the **filing cabinet**, and disk storage is the **warehouse**. The CPU performs computations using the data on its "desk" (registers), which provides the fastest access but offers limited storage (32 registers).

| Register(s) | ABI Name | Purpose                                                     |
| ----------- | -------- | ----------------------------------------------------------- |
| `x0`        | `zero`   | Constant zero. Reads always return `0`; writes are ignored. |
| `x1`        | `ra`     | Return address used during function calls.                  |
| `x2`        | `sp`     | Stack pointer pointing to the top of the stack.             |
| `x3`        | `gp`     | Global pointer for accessing global/static variables.       |
| `x4`        | `tp`     | Thread pointer used in multi-threaded applications.         |
| `x5–x7`     | `t0–t2`  | Temporary registers (caller-saved).                         |
| `x8`        | `s0/fp`  | Saved register or frame pointer.                            |
| `x9`        | `s1`     | Saved register preserved across function calls.             |
| `x10–x11`   | `a0–a1`  | Function arguments 1–2 and return values.                   |
| `x12–x17`   | `a2–a7`  | Function arguments 3–8.                                     |
| `x18–x27`   | `s2–s11` | Saved registers (callee-saved).                             |
| `x28–x31`   | `t3–t6`  | Additional temporary registers (caller-saved).              |

---

# 📝 RISC-V Instruction Formats

All **RV32I instructions are 32 bits wide**. Different instruction types use different bit layouts.

| Format     | Purpose                                                               | Bit Layout                                                        |
| ---------- | --------------------------------------------------------------------- | ----------------------------------------------------------------- |
| **R-Type** | Register-to-register arithmetic and logic (`ADD`, `SUB`, `AND`, `OR`) | `funct7 \| rs2 \| rs1 \| funct3 \| rd \| opcode`                  |
| **I-Type** | Immediate arithmetic and loads (`ADDI`, `LW`)                         | `imm[11:0] \| rs1 \| funct3 \| rd \| opcode`                      |
| **S-Type** | Store instructions (`SW`, `SH`, `SB`)                                 | `imm[11:5] \| rs2 \| rs1 \| funct3 \| imm[4:0] \| opcode`         |
| **B-Type** | Conditional branches (`BEQ`, `BNE`, `BLT`)                            | `imm[12\|10:5] \| rs2 \| rs1 \| funct3 \| imm[4:1\|11] \| opcode` |
| **U-Type** | Upper immediate instructions (`LUI`, `AUIPC`)                         | `imm[31:12] \| rd \| opcode`                                      |
| **J-Type** | Jump instruction (`JAL`)                                              | `imm[20\|10:1\|11\|19:12] \| rd \| opcode`                        |

---

# ⚙️ Instruction Support & PicoRV32 Configuration

## Supported Instructions

| Category                              | Instructions                                | Status      |
| ------------------------------------- | ------------------------------------------- | ----------- |
| Integer Arithmetic                    | `ADD`, `SUB`, `ADDI`, `LUI`, `AUIPC`        | ✅ Supported |
| Logic Operations                      | `AND`, `OR`, `XOR`, `ANDI`, `ORI`, `XORI`   | ✅ Supported |
| Shift Operations                      | `SLL`, `SRL`, `SRA`, `SLLI`, `SRLI`, `SRAI` | ✅ Supported |
| Comparison                            | `SLT`, `SLTU`, `SLTI`, `SLTIU`              | ✅ Supported |
| Load / Store                          | `LW`, `LH`, `LB`, `SW`, `SH`, `SB`          | ✅ Supported |
| Branches                              | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`  | ✅ Supported |
| Jumps                                 | `JAL`, `JALR`                               | ✅ Supported |
| Multiply / Divide (M Extension)       | `MUL`, `DIV`, `REM`, `MULH`                 | ❌ Disabled  |
| Compressed Instructions (C Extension) | 16-bit Instructions                         | ❌ Disabled  |

### PicoRV32 Configuration Flags

| Configuration    | Value | Description                                |
| ---------------- | ----- | ------------------------------------------ |
| `ENABLE_MUL`     | `0`   | Hardware multiplier disabled.              |
| `ENABLE_DIV`     | `0`   | Hardware divider disabled.                 |
| `COMPRESSED_ISA` | `0`   | Compressed instruction extension disabled. |
| `BARREL_SHIFTER` | `0`   | Barrel shifter disabled to reduce area.    |

---

# 🚀 Boot Configuration

| Item              | Value                      | Description                                                   |
| ----------------- | -------------------------- | ------------------------------------------------------------- |
| First Instruction | `0x00020137`               | `LUI x2, 0x20`                                                |
| Purpose           | —                          | Initializes the stack pointer during system boot.             |
| Compiler Flags    | `-march=rv32i -mabi=ilp32` | Matches the PicoRV32 configuration without M or C extensions. |
| `mem_instr = 1`   | Instruction Fetch          | CPU is fetching an instruction.                               |
| `mem_instr = 0`   | Data Access                | CPU is performing a load/store operation (`LW`, `SW`, etc.).  |

---

# ⚡ PicoRV32 Five-Stage CPU Pipeline

| Stage   | Name               | Function                                                                                   |
| ------- | ------------------ | ------------------------------------------------------------------------------------------ |
| **IF**  | Instruction Fetch  | Fetches the next instruction from memory using the Program Counter (PC).                   |
| **ID**  | Instruction Decode | Decodes the instruction, reads source registers, and generates control signals.            |
| **EX**  | Execute            | Performs ALU operations such as arithmetic, comparison, shifting, and address calculation. |
| **MEM** | Memory Access      | Reads from or writes to data memory (`LW`, `SW`, etc.).                                    |
| **WB**  | Write Back         | Writes the execution or memory result back to the destination register.                    |

---

# 🔄 PicoRV32 Memory Transaction Flow

| Step | Operation                                                                                               |
| ---- | ------------------------------------------------------------------------------------------------------- |
| 1    | `mem_valid = 1` initiates a memory transaction.                                                         |
| 2    | `mem_instr` indicates whether the access is an instruction fetch or data access.                        |
| 3    | `PC → mem_addr` places the target address on the memory bus.                                            |
| 4    | The instruction is decoded, source registers are read, and immediates are sign-extended.                |
| 5    | The ALU performs arithmetic, branch comparison, or address calculation.                                 |
| 6    | The CPU **stalls** while `mem_valid = 1` until `mem_ready = 1` is asserted by memory or the peripheral. |
| 7    | Read data (`mem_rdata`) is written into the destination register during the Write-Back stage.           |

> **⚠️ PicoRV32 Stall Rule:** Only **one outstanding memory transaction** is allowed at a time. The processor holds `mem_valid = 1` and freezes the pipeline until the connected memory or peripheral asserts `mem_ready = 1`, ensuring simple and deterministic bus behavior.


### Practical Outcome

Successfully explored the RISC-V instruction set and understood processor execution at the hardware level.

---

# 🔄 AXI4-Lite Communication Protocol

## What is AXI4-Lite?

**AXI4-Lite** is a lightweight version of the **ARM AMBA AXI4** protocol used for communication between a processor (master) and memory-mapped peripherals (slaves). It is optimized for **register-level access** and is widely used in embedded SoC designs.

---

## 🤝 Handshake Analogy

Think of AXI4-Lite communication as a **two-person handshake**.

* The **Master** (CPU) says **"I have a request."** by asserting `VALID`.
* The **Slave** (Peripheral) says **"I'm ready."** by asserting `READY`.
* A transaction occurs **only when both `VALID` and `READY` are HIGH on the same clock edge**.

This decoupled handshake allows the master and slave to operate independently without requiring synchronized timing.

---

## 📬 Write Transaction Analogy

| Step | AXI Channel            | Description                                                   |
| ---- | ---------------------- | ------------------------------------------------------------- |
| 1    | **AW (Write Address)** | The master sends the destination address.                     |
| 2    | **W (Write Data)**     | The master sends the data to be written.                      |
| 3    | **B (Write Response)** | The slave acknowledges that the write completed successfully. |

---

## 📖 Read Transaction Analogy

| Step | AXI Channel           | Description                               |
| ---- | --------------------- | ----------------------------------------- |
| 1    | **AR (Read Address)** | The master requests data from an address. |
| 2    | **R (Read Data)**     | The slave returns the requested data.     |

---

# 📡 AXI4-Lite Channels

| Channel                | Direction      | Signals                              | Purpose                 |
| ---------------------- | -------------- | ------------------------------------ | ----------------------- |
| **AW** (Write Address) | Master → Slave | `AWADDR`, `AWVALID`, `AWREADY`       | Transfers write address |
| **W** (Write Data)     | Master → Slave | `WDATA`, `WSTRB`, `WVALID`, `WREADY` | Transfers write data    |
| **B** (Write Response) | Slave → Master | `BRESP`, `BVALID`, `BREADY`          | Returns write status    |
| **AR** (Read Address)  | Master → Slave | `ARADDR`, `ARVALID`, `ARREADY`       | Transfers read address  |
| **R** (Read Data)      | Slave → Master | `RDATA`, `RRESP`, `RVALID`, `RREADY` | Returns read data       |

---

# ⚡ Handshake Rule

A transfer occurs **only** when both signals are HIGH during the rising edge of the clock.

| VALID | READY | Transaction            |
| :---: | :---: | ---------------------- |
|   0   |   0   | No transfer            |
|   1   |   0   | Master waits           |
|   0   |   1   | Slave waits            |
| **1** | **1** | ✅ Data transfer occurs |

---

# 📌 AXI4-Lite Design Rules

| Rule                                                                              | 
| --------------------------------------------------------------------------------- |
| Master can assert `VALID` before the slave is ready.                              |           
| Slave can assert `READY` before the master sends data (pre-ready).                |            
| `VALID` must remain asserted until the handshake completes.                       |             
| `BRESP = 2'b00` and `RRESP = 2'b00` indicate a successful (**OKAY**) transaction. |             
| `WSTRB` selects which bytes are written during a write operation.                 |             

---

# 📝 WSTRB (Write Strobe) Encoding

| WSTRB     | Bytes Written | Description                         |
| --------- | ------------- | ----------------------------------- |
| `4'b1111` | `[31:0]`      | Write all four bytes (32-bit write) |
| `4'b0011` | `[15:0]`      | Write lower 16 bits                 |
| `4'b0001` | `[7:0]`       | Write lowest byte only              |
| `4'b0000` | None          | No write operation                  |

---

# 🏗️ AXI4-Lite Architecture

```text
                  +----------------+
                  |   RISC-V CPU   |
                  |  AXI Master    |
                  +--------+-------+
                           |
                   AXI4-Lite Bus
                           |
          +----------------+----------------+
          |                                 |
   UART Peripheral                  Memory-Mapped Registers
        (Slave)                           (Slave)
```

---

# 🔄 AXI-Lite Slave State Machines

## Write State Machine

| State     | Operation                               |
| --------- | --------------------------------------- |
| `IDLE`    | Wait for `AWVALID`.                     |
| `WR_ADDR` | Latch write address.                    |
| `WR_DATA` | Receive write data and update register. |
| `WR_RESP` | Assert `BVALID` and wait for `BREADY`.  |
| `IDLE`    | Ready for the next transaction.         |

---

## Read State Machine

| State     | Operation                                    |
| --------- | -------------------------------------------- |
| `IDLE`    | Wait for `ARVALID`.                          |
| `RD_ADDR` | Latch read address and fetch register value. |
| `RD_DATA` | Assert `RVALID` and return data.             |
| `IDLE`    | Ready for the next read transaction.         |

---

# 📁 Project Files

| File                          | Description                                                 |
| ----------------------------- | ----------------------------------------------------------- |
| `tb/tb_axi_lite_standalone.v` | Self-contained AXI4-Lite master/slave educational testbench |
| `tb/tb_axi_lite.v`            | Complete AXI4-Lite testbench with UART peripheral           |
| `tb/tb_axi_lite_master.v`     | Reusable AXI4-Lite master task library                      |
| `rtl/axi_lite_interconnect.v` | Production AXI4-Lite interconnect (1 Master → 3 Slaves)     |

---

# ⚙️ AXI Master Tasks

## Write Transaction

| Phase             | Description                                         |
| ----------------- | --------------------------------------------------- |
| **1. AW Channel** | Send write address and wait for `AWREADY`.          |
| **2. W Channel**  | Send write data and wait for `WREADY`.              |
| **3. B Channel**  | Wait for `BVALID`, then acknowledge using `BREADY`. |

---

## Read Transaction

| Phase             | Description                               |
| ----------------- | ----------------------------------------- |
| **1. AR Channel** | Send read address and wait for `ARREADY`. |
| **2. R Channel**  | Wait for `RVALID` and capture `RDATA`.    |

---

# 🗂️ AXI-Lite Slave Register Map

| Address  | Register      | Description                       |
| -------- | ------------- | --------------------------------- |
| `0x0000` | `reg_file[0]` | Register 0                        |
| `0x0004` | `reg_file[1]` | Register 1 (used in this project) |
| `0x0008` | `reg_file[2]` | Register 2                        |
| `0x000C` | `reg_file[3]` | Register 3                        |

**Address-to-Index Mapping**

```text
index = (address >> 2) % NUM_REGS
```

This converts a byte address into the corresponding register index inside the AXI-Lite slave.


### Practical Outcome

Implemented and verified AXI4-Lite communication between processor and peripherals.

---

# 3. UART Peripheral Design

### Objectives

Design a UART peripheral for serial communication with external devices.

### Features

* UART Transmitter
* UART Receiver
* Configurable Baud Rate
* Serial Data Transfer
* Register Interface

### Verification

UART functionality was verified using Verilog simulations and waveform analysis.

---

# 4. Memory-Mapped UART Interface

### Overview

The UART peripheral was integrated into the processor's address space using memory-mapped I/O.

### Functional Flow

```text
CPU Instruction

↓

Memory Address Access

↓

AXI4-Lite Bus

↓

UART Registers

↓

Serial Output
```

### Learning Outcomes

* Address decoding
* Peripheral register mapping
* Embedded hardware communication

---

# 5. RISC-V Processor Integration

The processor was connected to the AXI4-Lite interconnect, enabling communication with memory and peripherals.

### Integrated Components

* RISC-V Core
* AXI4-Lite Interconnect
* UART Peripheral
* Memory
* Reset Logic
* Clock Network

---

# 6. AXI4-Lite UART Peripheral

### Features

* AXI Slave Interface
* UART Control Register
* Status Register
* Data Register
* Interrupt Ready Signals

### Verification

* Read Transactions
* Write Transactions
* Register Access
* UART Communication

---

# 7. Embedded Firmware Development

Firmware was developed to demonstrate communication between software and hardware.

### Example Tasks

* UART Initialization
* Character Transmission
* Register Access
* Polling Operations
* Peripheral Testing

This stage demonstrated hardware/software co-design principles in embedded systems.

---

# 8. Complete SoC Integration

After validating individual modules, the complete subsystem was integrated.

### Final SoC Includes

* RISC-V Processor
* AXI4-Lite Interconnect
* UART Peripheral
* Memory Interface
* Clock Logic
* Reset Controller

The integrated design was verified through functional simulation.

---

# 9. Functional Verification

Verification was performed using Verilog/SystemVerilog testbenches.

### Verification Activities

* RTL Simulation
* Functional Verification
* Waveform Analysis
* Signal Debugging
* Bus Transaction Verification
* UART Timing Verification

### Tools

* Verilator
* GTKWave

---

# 10. RTL-to-GDSII ASIC Implementation

The verified RTL design was synthesized and implemented using OpenLane.

## Design Flow

```text
RTL Design
      │
      ▼
Logic Synthesis
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
DRC & LVS
      │
      ▼
GDSII Generation
```

### Tools Used

* Yosys
* OpenSTA
* OpenLane
* Magic
* Netgen

---

# 🛠️ Development Tools

| Tool        | Purpose                 |
| ----------- | ----------------------- |
| Verilog HDL | RTL Design              |
| Verilator   | Simulation              |
| GTKWave     | Waveform Analysis       |
| Yosys       | RTL Synthesis           |
| OpenSTA     | Static Timing Analysis  |
| OpenLane    | Physical Design         |
| Git         | Version Control         |
| GitHub      | Project Management      |
| Linux       | Development Environment |

---

# 📂 Repository Structure

```text
RISCV-AXI-SoC/
│
├── docs/
│   ├── MODULES.md
│   ├── Project_Report.md
│   └── Images/
│
├── rtl/
│
├── testbench/
│
├── firmware/
│
├── synthesis/
│
├── openlane/
│
├── waveforms/
│
├── images/
│
└── README.md
```

---

# 🎓 Skills Demonstrated

* RISC-V Computer Architecture
* RTL Design using Verilog
* Embedded System Design
* AXI4-Lite Protocol
* UART Communication
* Memory-Mapped I/O
* Digital System Integration
* Functional Verification
* Waveform Debugging
* RTL Synthesis
* Static Timing Analysis
* Physical Design
* ASIC Design Flow
* OpenLane Implementation
* Git & GitHub Workflow

---

# 📌 Project Outcomes

* Successfully studied the RISC-V ISA and processor architecture.
* Designed and verified an AXI4-Lite based communication subsystem.
* Implemented a UART peripheral with memory-mapped access.
* Integrated processor, bus, and peripherals into a functional SoC subsystem.
* Developed firmware for embedded communication and peripheral control.
* Verified system functionality using simulation and waveform analysis.
* Completed RTL synthesis, timing analysis, and ASIC physical design.
* Generated an ASIC-ready GDSII layout using the OpenLane flow.

---

# 🚀 Conclusion

This project provided practical experience in the complete ASIC development lifecycle—from RTL design and subsystem integration to verification, synthesis, physical implementation, and GDSII generation. It demonstrates the integration of a RISC-V processor with an AXI4-Lite interconnect and UART peripheral, highlighting both hardware design and embedded software development in a modern open-source ASIC design environment.









