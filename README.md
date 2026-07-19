# 26-bit CLA Critical Path Analysis & Simulation

This repository contains Verilog simulation models to analyze and verify the critical path delay of various **26-bit / 28-bit Carry Lookahead Adder (CLA)** structures. 

The analysis is based on the article: [26-bit CLA Critical Path Analysis](https://0.707106.xyz/26-bit_CLA_Critical_Path_Analysis.html).

## Background & Module Delays
We want to construct the fastest possible 26-bit (or 28-bit) adder using three basic building blocks: a 1-bit Full Adder (FA), a 4-bit CLA block, and a 16-bit CLA block. The delays for these blocks are given in terms of gate delays ($\Delta G$):

| Module | $XY \to S$ | $XY \to C_{out}$ | $C_{in} \to C_{out}$ | $C_{in} \to S$ |
|--------|:---:|:---:|:---:|:---:|
| **FA (1-bit)** | 2 | 2 | 2 | 2 |
| **4-bit CLA** | 4 | 3 | 2 | 3 |
| **16-bit CLA** | 8 | 5 | 2 | 5 |

## Simulated Cascading Schemes

We cascaded these modules in different arrangements to find the optimal delay. The findings show that placing the 16-bit CLA block at the very highest position causes a timing bottleneck due to its large $C_{in} \to S$ delay. 

### Evaluated Configurations:

1. **Scheme 1:** `FA → 4b → 16b → 4b → FA` (26-bit)  
   **Critical Path Delay: 10 ΔG** (Optimal)
2. **Scheme 2:** `FA → 4b → 4b → 16b → FA` (26-bit)  
   **Critical Path Delay: 11 ΔG**
3. **Scheme 3:** `4b → 16b → 4b → 4b` (28-bit)  
   **Critical Path Delay: 10 ΔG** (Optimal)
4. **Scheme 4:** `4b → 4b → 16b → 4b` (28-bit)  
   **Critical Path Delay: 10 ΔG** (Optimal)
5. **Scheme 5 (High-order 16b):** `4b → 4b → 4b → 16b` (28-bit)  
   **Critical Path Delay: 12 ΔG** (Suboptimal)

## Key Takeaway: Delay Masking

A common intuition is to place the largest block (16-bit CLA) at the most significant bits. However, doing so forces the 16-bit block to wait for the carry signal to ripple through the lower stages. Once the carry arrives, the 16-bit block still takes **5 ΔG** ($C_{in} \to S$) to compute its final sum.

**The optimal strategy is "Delay Masking"**: by placing the 16-bit CLA in the middle (e.g., Stage 2 or 3), its internal computation ($XY \to S = 8\Delta G$) overlaps with the carry propagation from the lower stages. When the carry finally arrives, the 16-bit block is already prepared and can rapidly absorb it, achieving the theoretical minimum limit of **10 ΔG**.

## Simulation Details

The repository uses Verilog `specify` blocks to mock the exact hardware path delays for each block. This allows for cycle-accurate timing simulation using tools like **QuestaSim / ModelSim** or **Icarus Verilog**.

### Files:
- `FA_beh.v`: Timing-annotated behavioral model of a 1-bit FA.
- `CLA4_beh.v`: Timing-annotated behavioral model of a 4-bit CLA.
- `CLA16_beh.v`: Timing-annotated behavioral model of a 16-bit CLA.
- `tb_cla_schemes.v`: Testbench instantiating and testing all 5 schemes simultaneously under the worst-case carry ripple scenario.

### Running Simulation (QuestaSim)
```bash
vlog *.v
vsim -c tb_cla_schemes -do "run -all; quit"
```
