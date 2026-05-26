# RV32I RISC-V Processor in Verilog

A synthesizable, single-cycle 32-bit RISC-V processor implementing the RV32I instruction set, written in Verilog HDL. Designed for RTL learning, FPGA prototyping, and ASIC synthesis experimentation.

---

## Table of Contents

- [Overview](#overview)
- [Supported Instructions](#supported-instructions)
- [Module Descriptions](#module-descriptions)
- [Branch & Jump Logic](#branch--jump-logic)
- [Writeback Logic](#writeback-logic)
- [Memory Organization](#memory-organization)
- [Project Structure](#project-structure)
- [Synthesis Compatibility](#synthesis-compatibility)
- [Future Improvements](#future-improvements)

---

## Overview

This processor follows a **single-cycle datapath** — every instruction completes in one clock period. All combinational logic resolves within a single cycle; state elements update on the active clock edge.

**Execution stages (all within one cycle):**

| Stage | Name |
|---|---|
| IF | Instruction Fetch |
| ID | Instruction Decode |
| EX | Execute |
| MEM | Memory Access |
| WB | Write Back |

**Intended for:**
- Processor architecture study
- RTL design and Verilog practice
- FPGA implementation
- ASIC synthesis experimentation
- Educational digital design projects

---

## Supported Instructions

### R-Type — Register–Register

| Instruction | Operation |
|---|---|
| `ADD` | `rd = rs1 + rs2` |
| `SUB` | `rd = rs1 - rs2` |
| `AND` | `rd = rs1 & rs2` |
| `OR` | `rd = rs1 \| rs2` |
| `XOR` | `rd = rs1 ^ rs2` |
| `SLL` | `rd = rs1 << rs2` |
| `SRL` | `rd = rs1 >> rs2` (logical) |
| `SRA` | `rd = rs1 >>> rs2` (arithmetic) |
| `SLT` | `rd = (rs1 < rs2) ? 1 : 0` (signed) |
| `SLTU` | `rd = (rs1 < rs2) ? 1 : 0` (unsigned) |

**Format:** `funct7 | rs2 | rs1 | funct3 | rd | opcode`

### I-Type — Immediate Arithmetic

| Instruction | Operation |
|---|---|
| `ADDI` | `rd = rs1 + imm` |
| `ANDI` | `rd = rs1 & imm` |
| `ORI` | `rd = rs1 \| imm` |
| `XORI` | `rd = rs1 ^ imm` |
| `SLLI` | `rd = rs1 << imm` |
| `SRLI` | `rd = rs1 >> imm` (logical) |
| `SRAI` | `rd = rs1 >>> imm` (arithmetic) |
| `SLTI` | `rd = (rs1 < imm) ? 1 : 0` (signed) |
| `SLTIU` | `rd = (rs1 < imm) ? 1 : 0` (unsigned) |

**Format:** `imm[11:0] | rs1 | funct3 | rd | opcode`

### Load / Store

| Instruction | Operation |
|---|---|
| `LW` | `rd = MEM[rs1 + imm]` |
| `SW` | `MEM[rs1 + imm] = rs2` |

### Branch

| Instruction | Condition |
|---|---|
| `BEQ` | `rs1 == rs2` |
| `BNE` | `rs1 != rs2` |
| `BLT` | `rs1 < rs2` (signed) |
| `BGE` | `rs1 >= rs2` (signed) |
| `BLTU` | `rs1 < rs2` (unsigned) |
| `BGEU` | `rs1 >= rs2` (unsigned) |

### Jump

| Instruction | Operation |
|---|---|
| `JAL` | `rd = PC + 4; PC = PC + offset` |
| `JALR` | `rd = PC + 4; PC = (rs1 + imm) & ~1` |

### U-Type

| Instruction | Operation |
|---|---|
| `LUI` | `rd = imm << 12` |
| `AUIPC` | `rd = PC + (imm << 12)` |

---

## Module Descriptions

### `program_counter.v`
Maintains the current instruction address. Resets to `0`; updates to `next_pc` on each positive clock edge.

```verilog
// On reset:       PC <= 0
// On clock edge:  PC <= next_pc
```

### `instr_mem.v`
Read-only instruction store. Fetches using `mem[pc[11:2]]` — word-aligned, so `PC=0` → `mem[0]`, `PC=4` → `mem[1]`, etc.

### `decoder.v`
Parses the 32-bit instruction into fields (`opcode`, `rd`, `rs1`, `rs2`, `funct3`, `funct7`) and generates sign-extended immediates for all format types (R, I, S, B, U, J).

### `control_unit.v`
Generates one-hot control signals from `dec_bits = {funct7[5], funct3, opcode}`. Signals determine ALU operation, branch/jump behavior, memory access, register write enable, and writeback source. Only one decode path activates per instruction.

### `regfile.v`
32 × 32-bit register file with two asynchronous read ports and one synchronous write port. `x0` is permanently tied to zero — writes to `x0` are silently ignored.

```verilog
rd1 = regs[rs1];          // async read
rd2 = regs[rs2];          // async read
regs[rd] <= wd;           // sync write (x0 ignored)
```

### `alu.v`
Handles all computation: arithmetic, logic, shifts, comparisons, memory address generation (`rs1 + imm`), jump return addresses (`PC + 4`), and upper-immediate operations (`LUI`, `AUIPC`). Branch instructions output a 1-bit comparison result.

### `dmem.v`
Read/write data memory with word-aligned addressing (`mem[addr[11:2]]`). Writes are synchronous; reads are asynchronous.

### `RISCV_top.v`
Top-level integration module. Connects all submodules, implements PC update logic (branch/jump/sequential), and routes writeback data.

---

## Branch & Jump Logic

```verilog
// Branch condition
branch_taken = (is_beq  & alu_result[0]) |
               (is_bne  & alu_result[0]) |
               (is_blt  & alu_result[0]) |
               (is_bge  & alu_result[0]) |
               (is_bltu & alu_result[0]) |
               (is_bgeu & alu_result[0]);

// Target addresses
branch_target = pc + imm;
jalr_target   = (rd1 + imm) & 32'hFFFFFFFE;

// PC update priority
next_pc = is_jal         ? branch_target :
          is_jalr        ? jalr_target   :
          branch_taken   ? branch_target :
                           pc + 4;
```

---

## Writeback Logic

```verilog
wb_data = is_lw ? dmem_out : alu_result;
```

Register write enable is asserted for instructions that produce a result: `ADD`, `SUB`, `ADDI`, `LW`, `JAL`, `JALR`, `LUI`, `AUIPC`, and all other arithmetic/logical variants. `SW` and branch instructions do **not** write to the register file.

---

## Memory Organization

| Memory | Contents | Access |
|---|---|---|
| Instruction Memory (`instr_mem.v`) | Compiled machine code | Read-only, word-aligned |
| Data Memory (`dmem.v`) | Runtime program data | Read/write, word-aligned |
| Register File (`regfile.v`) | CPU working registers (`x0`–`x31`) | 2 async reads, 1 sync write |

Both memories use `reg [31:0] mem [0:1023]` arrays (1 KB each).

---

## Project Structure

| File | Description |
|---|---|
| `RISCV_top.v` | Top-level integration |
| `program_counter.v` | Program counter |
| `instr_mem.v` | Instruction memory |
| `decoder.v` | Instruction decode & immediate generation |
| `control_unit.v` | Control signal generation |
| `regfile.v` | Register file |
| `alu.v` | Arithmetic logic unit |
| `dmem.v` | Data memory |

---

## Synthesis Compatibility

This design is fully synthesizable and compatible with:

- **Cadence Genus**
- **Synopsys Design Compiler**
- **FPGA synthesis tools** (Vivado, Quartus, etc.)

Memory is implemented as `reg` arrays. For ASIC targets, these can be replaced with dedicated SRAM/ROM macros.

---

## Future Improvements

- Complete RV32I coverage
- Pipelined architecture (5-stage)
- Hazard detection unit
- Data forwarding / bypassing
- Cache hierarchy (I$ / D$)
- CSR registers and interrupt support
- UART, GPIO, and timer peripherals
- AXI / APB / AHB bus interfaces
- External instruction and data memory interfaces
