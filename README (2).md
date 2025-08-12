# Asynchronous FIFO (First-In-First-Out) Buffer

## 📌 Introduction
This repository contains a parameterized **Asynchronous FIFO** implementation in Verilog.  
The FIFO allows **safe data transfer between two different clock domains** using **Gray code pointers** and **two-stage synchronizers** to avoid metastability issues.

---

## ⚡ Why Gray Code is Necessary
- In asynchronous designs, pointers need to cross from one clock domain to another.
- **Binary counters** may change multiple bits at once, increasing the risk of metastability.
- **Gray code** changes only **one bit at a time**, making cross-domain sampling much safer.
- This ensures **correct empty/full detection** even when clocks are unrelated.

---

## 📂 Project Structure
```
.
├── FIFO_memory.v     # FIFO memory storage
├── wptr_full.v       # Write pointer logic & full flag generation
├── rptr_empty.v      # Read pointer logic & empty flag generation
├── two_ff_sync.v     # Two-stage synchronizer for clock domain crossing
└── README.md         # Documentation
```

---

## 🧩 Module Descriptions

### 1️⃣ FIFO Memory (`FIFO_memory`)
- Implements the memory array of the FIFO.
- **Synchronous write** (on `wclk`) and **combinational read**.
- Addressed by binary `waddr` and `raddr`.
- Parameterized by:
  - `DATASIZE`: width of each data word.
  - `ADDRSIZE`: address width (FIFO depth = 2^ADDRSIZE).

---

### 2️⃣ Write Pointer & Full Flag (`wptr_full`)
- Maintains **binary write pointer** (`wbin`) and **Gray-coded write pointer** (`wptr`).
- **Full flag calculation:**
```verilog
wfull_val = (wgraynext[ADDRSIZE]   != wq2_rptr[ADDRSIZE])   &&
            (wgraynext[ADDRSIZE-1] != wq2_rptr[ADDRSIZE-1]) &&
            (wgraynext[ADDRSIZE-2:0] == wq2_rptr[ADDRSIZE-2:0]);
```
- Indicates **full** when the next write pointer is exactly one position ahead of the read pointer in a circular buffer.

---

### 3️⃣ Read Pointer & Empty Flag (`rptr_empty`)
- Maintains **binary read pointer** (`rbin`) and **Gray-coded read pointer** (`rptr`).
- **Empty flag calculation:**
```verilog
rempty_val = (rgraynext == rq2_wptr);
```
- Indicates **empty** when read and write pointers are the same in Gray code.

---

### 4️⃣ Two-Stage Synchronizer (`two_ff_sync`)
- Synchronizes pointers between clock domains.
- Passes the incoming pointer through **two flip-flops** to reduce metastability risk.
- Used for:
  - `wptr` → `rq2_wptr` (into read domain)
  - `rptr` → `wq2_rptr` (into write domain)

---

## 🔄 Flag Operation

### **Empty Flag (`rempty`)**
1. Calculate next binary read pointer:
```verilog
rbinnext = rbin + (rinc & ~rempty);
```
2. Convert to Gray code:
```verilog
rgraynext = (rbinnext >> 1) ^ rbinnext;
```
3. Compare with synchronized write pointer:
```verilog
rempty_val = (rgraynext == rq2_wptr);
```

---

### **Full Flag (`wfull`)**
1. Calculate next binary write pointer:
```verilog
wbinnext = wbin + (winc & ~wfull);
```
2. Convert to Gray code:
```verilog
wgraynext = (wbinnext >> 1) ^ wbinnext;
```
3. Compare with synchronized read pointer:
```verilog
wfull_val = (wgraynext[ADDRSIZE]   != wq2_rptr[ADDRSIZE])   &&
            (wgraynext[ADDRSIZE-1] != wq2_rptr[ADDRSIZE-1]) &&
            (wgraynext[ADDRSIZE-2:0] == wq2_rptr[ADDRSIZE-2:0]);
```

---

## ✅ Conclusion
This FIFO design is:
- **Safe for asynchronous clock domains** using Gray code and two-stage synchronizers.
- **Parameterizable** for different data widths and depths.
- **Accurate in full/empty detection** without glitches.

---

## 📜 License
This project is open-source under the MIT License.
