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
#Advanced — Signal/Architecture Level
<img width="995" height="613" alt="image" src="https://github.com/user-attachments/assets/b6738578-f5a2-4543-bbca-511b7e5f406a" />

# 📝 WSTRB (Write Strobe) Encoding

| WSTRB     | Bytes Written | Description                         |
| --------- | ------------- | ----------------------------------- |
| `4'b1111` | `[31:0]`      | Write all four bytes (32-bit write) |
| `4'b0011` | `[15:0]`      | Write lower 16 bits                 |
| `4'b0001` | `[7:0]`       | Write lowest byte only              |
| `4'b0000` | None          | No write operation                  |

---

# 🏗️ AXI4-Lite Architecture

<img width="1046" height="622" alt="image" src="https://github.com/user-attachments/assets/93d7a484-7e79-402f-bd72-a463b3844319" />

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

---

# 3. UART Peripheral Design

### Objectives

Design a UART peripheral for serial communication with external devices.

# 📡 Universal Asynchronous Receiver-Transmitter (UART)

## What is UART?

**UART (Universal Asynchronous Receiver-Transmitter)** is one of the oldest and most widely used **serial communication protocols**. It enables data transmission between two devices by sending **one bit at a time** over dedicated **Transmit (TX)** and **Receive (RX)** lines.

Unlike synchronous communication protocols, **UART does not require a shared clock signal**. Instead, both communicating devices must be configured with the same communication parameters (such as baud rate, data bits, parity, and stop bits).

Because of its simplicity, low hardware cost, and broad compatibility, UART is commonly used for embedded systems, debugging, and peripheral communication.

---

## 📌 UART Overview

| Feature                 | Description                                     |
| ----------------------- | ----------------------------------------------- |
| **Full Form**           | Universal Asynchronous Receiver-Transmitter     |
| **Communication Type**  | Asynchronous Serial Communication               |
| **Transmission**        | Bit-by-bit serial communication                 |
| **Clock Signal**        | Not required (asynchronous)                     |
| **Communication Lines** | TX (Transmit), RX (Receive), and GND            |
| **Communication Mode**  | Full-Duplex (simultaneous transmit and receive) |
| **Cost**                | Low hardware complexity                         |
| **Typical Speed**       | 9.6 kbps to several Mbps (device dependent)     |

---

## 🏗️ UART Frame Format

A UART frame consists of several fields transmitted sequentially.

| Field           | Size                   | Purpose                                    |
| --------------- | ---------------------- | ------------------------------------------ |
| **Start Bit**   | 1 bit                  | Indicates the beginning of a transmission. |
| **Data Bits**   | 5–9 bits (typically 8) | Actual payload data.                       |
| **Parity Bit**  | Optional               | Used for simple error detection.           |
| **Stop Bit(s)** | 1 or 2 bits            | Marks the end of the transmission.         |

### Example (8N1 Configuration)

```text
Start | D0 D1 D2 D3 D4 D5 D6 D7 | Stop
  0   |       8 Data Bits       |   1
```

> **8N1** means **8 data bits**, **No parity**, and **1 stop bit**, which is the most commonly used UART configuration.

---

## 🔄 UART Communication

```text
          TX -----------------------> RX
      +---------+                 +---------+
      | Device A|                 | Device B|
      |  UART   |                 |  UART   |
      +---------+                 +---------+
          RX <----------------------- TX
```

Communication is **full-duplex**, allowing both devices to transmit and receive data simultaneously.

---

## ⚙️ UART Communication Parameters

| Parameter     | Description                                                 |
| ------------- | ----------------------------------------------------------- |
| **Baud Rate** | Number of bits transmitted per second (e.g., 9600, 115200). |
| **Data Bits** | Number of bits representing the data (typically 8).         |
| **Parity**    | Optional error-checking bit (None, Even, or Odd).           |
| **Stop Bits** | Indicates the end of a frame (1 or 2 bits).                 |

---

## 📍 Common Applications

| Application                   | Description                                             |
| ----------------------------- | ------------------------------------------------------- |
| Debug Console                 | Printing logs and debugging embedded systems.           |
| Bootloader Communication      | Firmware download and updates.                          |
| GPS Modules                   | Receiving location and navigation data.                 |
| GSM/LTE Modules               | Communication with cellular modems.                     |
| Bluetooth Modules             | Interfacing with wireless devices (e.g., HC-05, HC-06). |
| Microcontroller Communication | Data exchange between embedded controllers.             |
| Sensor Interfaces             | Communication with serial sensors and peripherals.      |

---
# 🔄 How UART Works

UART communication transfers data **one bit at a time** using two dedicated lines:

* **TX (Transmit)** – Sends data.
* **RX (Receive)** – Receives data.

Since UART is **asynchronous**, there is **no shared clock signal** between the transmitter and receiver. Instead, both devices must be configured with the **same baud rate**, data format, parity, and stop bits before communication begins.

---

## 📡 UART Transmission Process

| Step  | Stage                     | Description                                                                                                                                                                                                                           |
| ----- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1** | **Idle State**            | The **TX line remains HIGH (logic 1)** when no data is being transmitted. Both transmitter and receiver stay in this idle state until a new frame begins.                                                                             |
| **2** | **Start Bit**             | The transmitter drives the TX line **LOW (logic 0)** for one bit period. This transition signals the receiver that a new data frame is starting and allows it to synchronize its sampling timing.                                     |
| **3** | **Data Bits**             | The payload (typically **8 bits**) is transmitted **Least Significant Bit (LSB) first**. Each bit occupies exactly **1 / Baud Rate** seconds. The receiver samples each bit near the middle of the bit period for reliable detection. |
| **4** | **Parity Bit (Optional)** | An optional parity bit provides basic error detection. **Even parity** ensures the total number of logic 1's is even, while **Odd parity** ensures the total number of logic 1's is odd. Many UART systems disable parity (`None`).   |
| **5** | **Stop Bit(s)**           | The transmitter returns the TX line to **HIGH (logic 1)** for **1 or 2 bit periods**, indicating the end of the frame and allowing the receiver to prepare for the next transmission.                                                 |

---

## 📦 UART Frame Structure

```text
Idle ── Start ── D0 ── D1 ── D2 ── D3 ── D4 ── D5 ── D6 ── D7 ── Parity ── Stop
  1        0       LSB -----------------------------------------------> MSB      1
```

> **Note:** The parity bit is optional. A common UART configuration is **8N1**, which consists of **8 data bits**, **No parity**, and **1 stop bit**.

---

## ⏱️ UART Timing

| Parameter          | Description                                                                          |
| ------------------ | ------------------------------------------------------------------------------------ |
| **Baud Rate**      | Number of bits transmitted per second (e.g., 9600, 115200 bps).                      |
| **Bit Time**       | Duration of one bit = **1 / Baud Rate** seconds.                                     |
| **Sampling Point** | Receiver samples each bit near the center of the bit period for maximum reliability. |

---

## 🔁 UART Communication Flow

```text
+-------------+                         +-------------+
| Transmitter |                         |  Receiver   |
+-------------+                         +-------------+
       |                                       |
       | Idle (TX = 1)                         |
       |-------------------------------------->|
       | Start Bit (0)                         |
       |-------------------------------------->|
       | Data Bits (LSB First)                 |
       |-------------------------------------->|
       | Optional Parity                       |
       |-------------------------------------->|
       | Stop Bit(s) (1)                       |
       |-------------------------------------->|
```

---

## 💡 UART in This Project

In this project, the **RISC-V processor** communicates with the **UART peripheral** through an **AXI4-Lite interconnect**. Software running on the CPU performs **memory-mapped read and write operations** to the UART registers, while the UART hardware serializes the data into the standard UART frame format for transmission over the **TX** line and reconstructs incoming data received on the **RX** line.

## 💡 UART in This Project

In this project, the **UART peripheral** is integrated with the **RISC-V processor** through an **AXI4-Lite interconnect**. The CPU accesses the UART using **memory-mapped registers**, allowing firmware to transmit and receive serial data by performing standard read and write operations over the AXI bus.

This UART interface is verified using Verilog testbenches and waveform analysis before being integrated into the complete RISC-V SoC subsystem.


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

## 📥 UART RX Finite State Machine (FSM)

### 2-FF Synchronizer — Why It Exists

The external **`rx`** signal arrives **asynchronously**, meaning its transitions are not aligned with the system clock (50 MHz). Sampling this signal directly can cause **metastability**, where a flip-flop temporarily enters an undefined state.

To safely transfer the signal into the system clock domain, a **two-stage flip-flop synchronizer** is used:

```text
rx → rx_sync0 → rx_sync1 → rx_s
```

The synchronized signal (`rx_s`) is then used by the UART receiver state machine.

---

## UART RX FSM States

| State     | Description                                                                                                                                                                                                               |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **IDLE**  | Monitors `rx_s` for a falling edge (start bit). When `rx_s` transitions from **1 → 0**, the receiver moves to the **START** state.                                                                                        |
| **START** | Waits **217 clock cycles** (half a bit period) before sampling the start bit. If the sampled value is still `0`, the receiver proceeds to the **DATA** state; otherwise, it returns to **IDLE**.                          |
| **DATA**  | Samples one data bit every **434 clock cycles** at the middle of each bit period. Each sampled bit is shifted into the receive register using: `shift_reg ← {rx_s, shift_reg[7:1]}`.                                      |
| **STOP**  | Waits one full bit period (**434 clock cycles**) and checks that the stop bit is `1`. If valid, the received byte is copied to `data_out`, and `data_valid` is asserted for one clock cycle before returning to **IDLE**. |

---

## Receiver Outputs

| Signal          | Description                                                         |
| --------------- | ------------------------------------------------------------------- |
| `data_out[7:0]` | Received 8-bit data byte. Valid only when `data_valid` is asserted. |
| `data_valid`    | Single-clock-cycle pulse indicating a successful byte reception.    |

---

## UART Sampling Timing

| Parameter          | Value                | Description                                                                                        |
| ------------------ | -------------------- | -------------------------------------------------------------------------------------------------- |
| `CLKS_PER_BIT`     | **434**              | Number of system clock cycles for one UART bit period.                                             |
| `CLKS_HALF_BIT`    | **217**              | Half-bit delay used to sample the center of the start bit.                                         |
| Start Bit Sampling | **217 cycles**       | Receiver waits half a bit period after detecting the falling edge before confirming the start bit. |
| Data Bit Sampling  | **Every 434 cycles** | Each data bit is sampled at the center of its bit period for reliable reception.                   |

## ⏱️ Baud Rate & Project Configuration

### Project Configuration

| Parameter                                 | Value                      |
| ----------------------------------------- | -------------------------- |
| **System Clock (`CLK_FREQ`)**             | **50 MHz (50,000,000 Hz)** |
| **UART Baud Rate (`BAUD_RATE`)**          | **115200 bps**             |
| **Clock Cycles per Bit (`CLKS_PER_BIT`)** | **434**                    |
| **Half Bit Delay (`CLKS_HALF_BIT`)**      | **217**                    |

---

## Baud Rate Calculation

| Calculation                           | Result                                        |
| ------------------------------------- | --------------------------------------------- |
| `CLKS_PER_BIT = CLK_FREQ ÷ BAUD_RATE` | `50,000,000 ÷ 115,200 = 434` clock cycles/bit |
| `CLKS_HALF_BIT = CLKS_PER_BIT ÷ 2`    | `434 ÷ 2 = 217` clock cycles                  |
| Bit Period                            | `434 × 20 ns = 8.68 µs`                       |
| UART Frame (8N1)                      | `10 × 8.68 µs = 86.8 µs`                      |

---

## RTL Configuration

```verilog
localparam CLK_FREQ      = 50_000_000;
localparam BAUD_RATE     = 115_200;
localparam CLKS_PER_BIT  = CLK_FREQ / BAUD_RATE; // 434
```

### Data Transmission Logic

```verilog
if (clk_cnt == CLKS_PER_BIT - 1) begin
    clk_cnt   <= 0;
    shift_reg <= shift_reg >> 1; // LSB first
    bit_cnt   <= bit_cnt + 1;
end
```

---

## 8N1 UART Configuration

| Setting       | Value    | Description                                                      |
| ------------- | -------- | ---------------------------------------------------------------- |
| **Data Bits** | **8**    | Transmits 8 data bits (`bit_cnt` counts from 0 to 7).            |
| **Parity**    | **None** | No parity bit is transmitted, reducing frame length.             |
| **Stop Bits** | **1**    | TX remains HIGH for one bit period before the next frame begins. |

---

## Common UART Baud Rates (50 MHz System Clock)

| Baud Rate (bps) |     Clock Divider (`CLKS_PER_BIT`) |
| --------------: | ---------------------------------: |
|           9,600 |                               5208 |
|          19,200 |                               2604 |
|          38,400 |                               1302 |
|          57,600 |                                868 |
|     **115,200** | **434** ✅ *(Used in this project)* |
|         230,400 |                                217 |
|         921,600 |                                 54 |


# 🔗 RISC-V to AXI4-Lite Integration

## Integration Problem Statement

### 💡 Concept

The **PicoRV32 processor** communicates using its own simple **native memory interface** (`mem_valid` / `mem_ready`), whereas most modern SoC peripherals communicate using the **AXI4-Lite protocol**.

Since these interfaces are fundamentally different, they **cannot be connected directly**. An interface bridge (adapter) is required to translate between the two protocols.

> **Analogy:** Think of the PicoRV32 memory interface and AXI4-Lite as electrical plugs from different countries. Both serve the same purpose, but they use different connectors. A **plug adapter** is needed so they can work together.

---

## PicoRV32 Native Memory Interface

| Feature              | Description                                              |
| -------------------- | -------------------------------------------------------- |
| Request Signal       | `mem_valid` indicates a memory transaction request.      |
| Response Signal      | `mem_ready` acknowledges completion of the transaction.  |
| Transaction Model    | Supports only **one outstanding transaction** at a time. |
| Interface Complexity | Simple single-channel memory interface.                  |
| Communication        | No separate address, data, or response channels.         |

---

## Why Direct Connection is Not Possible

| PicoRV32 Native Bus                 | AXI4-Lite                                             |
| ----------------------------------- | ----------------------------------------------------- |
| Single memory interface             | Five independent communication channels               |
| `mem_valid` / `mem_ready` handshake | Separate `VALID` / `READY` handshake for each channel |
| One transaction at a time           | Independent read and write operations                 |
| Simple control interface            | Industry-standard interconnect protocol               |
| Direct peripheral access            | Standard interface for SoC IP blocks                  |

---

## Solution: AXI Adapter

To integrate the processor with AXI4-Lite peripherals, an adapter converts the PicoRV32 native memory interface into an AXI4-Lite master interface.

Two common approaches are:

| Method                         | Description                                                                                                                       |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| **`picorv32_axi`**             | PicoRV32 version with a built-in AXI4-Lite master interface.                                                                      |
| **`picorv32` + `axi_adapter`** | Uses the standard PicoRV32 core together with an external bridge that converts the native memory bus into AXI4-Lite transactions. |

---

## Protocol Conversion

```text id="zjuhxv"
      PicoRV32                     AXI Adapter                  AXI4-Lite Bus
+----------------+          +--------------------+        +----------------------+
| Native Memory  |          | Protocol Converter |        | AXI Master Interface |
| mem_valid      |  ----->  |                    | -----> | AW, W, B, AR, R      |
| mem_ready      | <-----   |                    | <----- | VALID / READY        |
+----------------+          +--------------------+        +----------------------+
```

The adapter translates the **single-channel PicoRV32 memory bus** into the **five independent AXI4-Lite channels**, allowing the processor to communicate with standard AXI peripherals such as UART, GPIO, timers, and memory controllers.

---

## Benefits of the AXI Adapter

| Benefit                  | Description                                                                   |
| ------------------------ | ----------------------------------------------------------------------------- |
| Protocol Translation     | Converts the PicoRV32 native memory interface into AXI4-Lite transactions.    |
| Peripheral Compatibility | Enables communication with industry-standard AXI IP cores.                    |
| Modular Design           | Keeps the CPU independent of peripheral implementations.                      |
| Scalability              | Additional AXI peripherals can be integrated without modifying the processor. |
| SoC Integration          | Provides a clean AXI master interface for the complete SoC subsystem.         |

---

## Prerequisites

Before understanding the integration process, the following concepts are assumed:

| Topic          | Knowledge Required                                                                                                   |
| -------------- | -------------------------------------------------------------------------------------------------------------------- |
| **RISC-V ISA** | Understanding of `LW`, `SW`, load/store instructions, and memory access.                                             |
| **AXI4-Lite**  | Knowledge of the five communication channels (`AW`, `W`, `B`, `AR`, `R`) and the `VALID`/`READY` handshake protocol. |


## 🧠 PicoRV32 Native Memory Interface

The **PicoRV32** processor communicates with memory and peripherals through a simple **native memory interface** based on a request/acknowledge handshake. Unlike AXI4-Lite, this interface supports **only one memory transaction at a time**, making it lightweight and easy to integrate.

---

## Handshake Rules

| Rule  | Description                                                                                                                             |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **1** | `mem_valid` **must remain HIGH** until `mem_ready` is asserted.                                                                         |
| **2** | `mem_wstrb ≠ 0` indicates a **write transaction**; `mem_wstrb = 0` indicates a **read transaction**.                                    |
| **3** | Only **one outstanding memory transaction** is allowed at any time.                                                                     |
| **4** | `CATCH_MISALIGN = 1` and `CATCH_ILLINSN = 1` are enabled, allowing the CPU to trap misaligned memory accesses and illegal instructions. |

---

## Native Memory Interface Signals

| Signal      | Direction |  Width  | Description                                                                    |
| ----------- | :-------: | :-----: | ------------------------------------------------------------------------------ |
| `mem_valid` |   Output  |    1    | Indicates that the CPU has initiated a memory request.                         |
| `mem_ready` |   Input   |    1    | Asserted by the memory or peripheral to acknowledge completion of the request. |
| `mem_addr`  |   Output  | 32 bits | Byte address for the memory access.                                            |
| `mem_wdata` |   Output  | 32 bits | Data to be written during a write transaction.                                 |
| `mem_wstrb` |   Output  |  4 bits | Byte-enable signals. A non-zero value indicates a write; `0` indicates a read. |
| `mem_rdata` |   Input   | 32 bits | Data returned to the CPU during a read transaction.                            |
| `mem_instr` |   Output  |    1    | Indicates the type of access: `1` = Instruction Fetch, `0` = Data Access.      |

# 🏗️ SoC Architecture Overview

The SoC integrates the **PicoRV32 processor** with an **AXI4-Lite interconnect**, allowing the CPU to communicate with memory and peripherals through a unified, industry-standard bus architecture.

---

## System Architecture

```text id="y7o7l4"
                     +----------------------+
                     |     PicoRV32 CPU     |
                     +----------+-----------+
                                |
                     Native Memory Interface
                  (mem_valid / mem_ready / addr)
                                |
                                ▼
                  +---------------------------+
                  |     CPU-to-AXI Bridge     |
                  |       (rtl/top.v)         |
                  +------------+--------------+
                               |
                     AXI4-Lite Master Interface
                 (AW, W, B, AR, R Channels)
                               |
                               ▼
                  +---------------------------+
                  |  AXI-Lite Interconnect    |
                  |    + Address Decoder      |
                  +-----+-----------+---------+
                        |           |
          +-------------+-----------+-------------+
          |                           |           |
          ▼                           ▼           ▼
   +-------------+             +-------------+  +-------------+
   |  ROM (S0)   |             | SRAM (S1)   |  | UART (S2)   |
   +-------------+             +-------------+  +-------------+
   0x0000_0000                0x0001_0000     0x1000_0000
   – 0x0000_FFFF              – 0x0001_FFFF   – 0x1000_00FF
```

---

## SoC Components

| Component                 | File                          | Address Range               | Description                                                                |
| ------------------------- | ----------------------------- | --------------------------- | -------------------------------------------------------------------------- |
| **PicoRV32 CPU**          | `rtl/picorv32.v`              | —                           | Executes the RISC-V RV32I instruction set and generates memory requests.   |
| **CPU-to-AXI Bridge**     | `rtl/top.v`                   | —                           | Converts the PicoRV32 native memory interface into AXI4-Lite transactions. |
| **AXI-Lite Interconnect** | `rtl/axi_lite_interconnect.v` | —                           | Routes AXI transactions from the CPU to the appropriate slave peripheral.  |
| **Address Decoder**       | `rtl/axi_decoder.v`           | —                           | Decodes the AXI address and selects the target slave device.               |
| **ROM (S0)**              | `rtl/rom.v`                   | `0x0000_0000 – 0x0000_FFFF` | Stores the boot program and executable instructions.                       |
| **SRAM (S1)**             | `rtl/sram.v`                  | `0x0001_0000 – 0x0001_FFFF` | Read/write data memory used during program execution.                      |
| **UART (S2)**             | `rtl/uart_axi.v`              | `0x1000_0000 – 0x1000_00FF` | Memory-mapped UART peripheral for serial communication.                    |

---

## Memory Map

|  Slave | Peripheral | Base Address  | End Address   |
| :----: | ---------- | ------------- | ------------- |
| **S0** | ROM        | `0x0000_0000` | `0x0000_FFFF` |
| **S1** | SRAM       | `0x0001_0000` | `0x0001_FFFF` |
| **S2** | UART       | `0x1000_0000` | `0x1000_00FF` |


## 🔄 CPU-to-AXI Bridge FSM

```text
                    +----------------+
                    |    ST_IDLE     |
                    |    (3'd0)      |
                    +----------------+
                           |
                 cpu_mem_valid = 1
                           |
          +----------------+----------------+
          |                                 |
   mem_wstrb ≠ 0                     mem_wstrb = 0
      (Write)                           (Read)
          |                                 |
          ▼                                 ▼
+----------------+                 +----------------+
|    ST_WR_AW    |                 |    ST_RD_AR    |
|     (3'd1)     |                 |     (3'd3)     |
| AWVALID = 1    |                 | ARVALID = 1    |
| WVALID = 1     |                 | Wait ARREADY   |
+----------------+                 +----------------+
          |                                 |
 AWREADY & WREADY                    ARREADY = 1
          |                                 |
          ▼                                 ▼
+----------------+                 +----------------+
|    ST_WR_B     |                 |    ST_RD_R     |
|     (3'd2)     |                 |     (3'd4)     |
| Wait BVALID    |                 | Wait RVALID    |
| cpu_mem_ready  |                 | Capture RDATA  |
+----------------+                 | cpu_mem_ready  |
          |                        +----------------+
          |                                 |
          +---------------+-----------------+
                          |
                          ▼
                    +----------------+
                    |    ST_IDLE     |
                    +----------------+
```

## 📝 AXI Write Transaction (UART TX Example)

**Example:** CPU writes the character **'H' (0x48)** to the UART TX register at **`0x10000000`**

```text
┌──────────────────────────────┐
│ ① AW Channel (Address Phase) │
├──────────────────────────────┤
│ AWADDR  = 0x10000000         │
│ AWVALID = 1                  │
│ AWREADY = 1                  │
│                              │
│ ✓ Address Handshake Complete │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ② W Channel (Data Phase)     │
├──────────────────────────────┤
│ WDATA   = 0x48 ('H')         │
│ WSTRB   = 4'h1               │
│ WVALID  = 1                  │
│ WREADY  = 1                  │
│                              │
│ ✓ Data Handshake Complete    │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ③ B Channel (Response Phase) │
├──────────────────────────────┤
│ BVALID = 1                   │
│ BREADY = 1                   │
│ BRESP  = 2'b00 (OKAY)        │
│                              │
│ ✓ Write Successful           │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ④ CPU Transaction Complete   │
├──────────────────────────────┤
│ ready_r        = 1           │
│ cpu_mem_ready  = 1 (Pulse)   │
│ Bridge → ST_IDLE             │
│                              │
│ ✓ CPU Continues Execution    │
└──────────────────────────────┘
```

> **Note:** `WSTRB = 4'h1` because the firmware uses the **SB (Store Byte)** instruction to write a single byte to the UART transmit register. The **AW (Address)** and **W (Data)** channels may complete simultaneously, improving write performance.


## 📖 AXI Read Transaction (UART STATUS Example)

**Example:** CPU reads the **UART STATUS Register** at **`0x10000008`**

```text
┌──────────────────────────────┐
│ ① AR Channel (Address Phase) │
├──────────────────────────────┤
│ ARADDR  = 0x10000008         │
│ ARVALID = 1                  │
│ ARREADY = 1                  │
│                              │
│ ✓ Address Handshake Complete │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ② Bridge State               │
├──────────────────────────────┤
│ ST_IDLE → ST_RD_AR           │
│                              │
│ RREADY = 1                   │
│                              │
│ ✓ Waiting for Read Data      │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ③ R Channel (Read Data)      │
├──────────────────────────────┤
│ RVALID = 1                   │
│ RREADY = 1                   │
│                              │
│ RDATA → rdata_r              │
│                              │
│ ✓ Data Received              │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ ④ CPU Transaction Complete   │
├──────────────────────────────┤
│ ready_r        = 1 (Pulse)   │
│ cpu_mem_ready  = 1           │
│ Bridge → ST_IDLE             │
│                              │
│ ✓ CPU Resumes Execution      │
└──────────────────────────────┘
```

### UART Memory Map

| Register        | Address      |
| --------------- | ------------ |
| **UART TX**     | `0x10000000` |
| **UART RX**     | `0x10000004` |
| **UART STATUS** | `0x10000008` |

































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









