# Design Of A CORDIC CORE : RTL to GDS

### **Introduction to the CORDIC Algorithm**:

The **CORDIC (COordinate Rotation Digital Computer)** algorithm, introduced by **Jack E. Volder** in **1959**, is a computational method for efficiently calculating mathematical functions such as trigonometric, logarithmic, hyperbolic, and square root operations. It is based on simple geometric principles and performs iterative calculations using basic operations like addition, subtraction, bit shifts, and comparisons. This simplicity makes it particularly well-suited for hardware implementations, especially in systems lacking multipliers or requiring cost-effective and resource-efficient designs.

CORDIC operates by iteratively rotating a vector in the Cartesian plane to achieve the desired angle, enabling the computation of functions such as sine, cosine, and arctangent. Its ability to compute multiple functions with a unified approach reduces hardware complexity and makes it ideal for embedded systems, digital signal processing (DSP), telecommunications, robotics, and graphics applications.

The algorithm's iterative nature allows adjustable precision by varying the number of iterations, offering scalability to balance accuracy, speed, and power consumption. Additionally, its compatibility with fixed-point arithmetic enhances its efficiency in real-time and low-power hardware systems. CORDIC's versatility, simplicity, and adaptability have made it a cornerstone in digital computation and hardware design.

##
### **Problem Statement**:

Traditional methods like Taylor series and polynomial approximations for computing functions such as sine, cosine, and logarithms are computationally intensive and hardware-inefficient. While the CORDIC algorithm offers a simpler, hardware-friendly alternative using basic operations like addition and shifts, earlier implementations lacked flexibility and optimization for modern systems.

This project aims to develop an optimized and configurable CORDIC core, leveraging advanced physical design techniques to ensure high performance, scalability, and efficiency for applications in signal processing, robotics, and 3D graphics.

##
### **Alternative Algorithms:**
### Taylor Series Expansion:

The Taylor series approximates functions as an infinite sum of terms derived from their derivatives at a specific point. For instance, the sine function can be expressed as a series. While highly accurate for small ranges, it requires significant computational resources due to division, multiplication, and factorial operations. This complexity and memory intensity, especially for higher-order terms, make it better suited for software applications rather than hardware like FPGAs.

The Taylor series provides a way to approximate functions using an infinite sum of terms based on the function's derivatives at a single point. For example, the sine function can be approximated as:

<p align="center">
<img src="https://github.com/user-attachments/assets/90a4b106-aa26-48a4-a9fd-069bf00c3f42">
</p>

**Pros:**

- Provides high accuracy for small values of x.
- Flexible, allowing the computation of a wide variety of functions.
 
**Cons:**

- Computationally expensive in hardware, requiring multiple multiplications and divisions.
- Memory-intensive for high precision due to the large number of terms needed.
- Not optimal for hardware like FPGAs due to the need for complex arithmetic operations

##
### Polynomial Approximation (Chebyshev Polynomials):

Polynomial approximations, such as Chebyshev polynomials, simplify mathematical functions into a set of polynomials with coefficients that minimize error over a specified range. These methods offer a good trade-off between precision and complexity. However, their hardware implementation requires multiple multipliers and accumulators, which increases resource utilization and latency. Though effective for specific functions, they lack the general-purpose flexibility of CORDIC, which supports trigonometric, hyperbolic, and exponential functions using a unified algorithm. Polynomial approximations, such as Chebyshev polynomials, are used to approximate functions with a series of polynomials.: These polynomials minimize the approximation error over a specified interval. 

For example, for a function f(x)f(x)f(x), the Chebyshev approximation might look like:
<h3 align="center">𝑓(𝑥) ≈ 𝑇0(𝑥) + 𝑇1(𝑥) + 𝑇2(𝑥) + ⋯ 𝑓(𝑥)</h3>


where Tn(x) are the Chebyshev polynomials of the first kind.

**Pros:**

- Offers a good trade-off between accuracy and computational efficiency.
- Can be tailored to specific ranges, minimizing approximation error.

**Cons:**

- Requires hardware multipliers for polynomial evaluation, which increases complexity.

##
### Lookup Tables (LUTs):

Lookup tables precompute values for mathematical functions and store them in memory, allowing functions like sine, cosine, or logarithm to be retrieved instantly. This method is extremely fast and efficient in applications where memory is abundant and computation speed is critical. However, LUTs are limited by their resolution and become impractical for applications requiring high precision or a large dynamic range. CORDIC overcomes this by computing values dynamically with a small memory footprint, making it ideal for resource-constrained environments.
Equation for Sine using LUT:

<h3 align="center">𝑠𝑖𝑛 (𝑥) ≈ 𝐿𝑈𝑇[𝑥]</h3>

**Pros:**

- Very fast, as the function evaluation is reduced to a memory lookup.
- Simple hardware implementation.

**Cons:**

- Requires large amounts of memory to store function values, limiting scalability for high precision.
- Limited by the resolution of the stored data; higher precision requires larger tables.

### **Why CORDIC Was Chosen?**:

CORDIC was chosen for its simplicity, efficiency, and versatility in hardware implementations. Unlike Taylor series or polynomial approximations, which require complex operations like multiplication and division, CORDIC relies on iterative shift-and-add operations, making it ideal for FPGA or ASIC designs with limited resources. Its scalability allows precision to be adjusted by varying the number of iterations, ensuring efficient hardware utilization.

Additionally, CORDIC's single algorithmic structure can compute a wide range of functions—trigonometric, hyperbolic, logarithmic, and square root—without significant modifications. This flexibility surpasses specialized methods like Newton-Raphson or lookup tables, which are limited to specific operations. Its compatibility with fixed-point arithmetic further enhances its suitability for low-power, high-speed applications in signal processing, image processing, telecommunications, and embedded systems.

##
### **Objectives:**
1. **Development of a Configurable CORDIC IP Core**: Design a highly adaptable CORDIC core capable of computing mathematical functions like trigonometric, logarithmic, and exponential operations with optimized hardware efficiency.

2. **Physical Design and Tapeout Preparation**: Transform the Verilog RTL code into a physical design, focusing on critical steps such as floorplanning, clock tree synthesis (CTS), and static timing analysis (STA) to meet power, area, and timing constraints.

3. **GDS File Generation**: Finalize the design by generating the GDS file, representing the layout for fabrication.

4. **Customization and Flexibility**: Provide a configurable architecture to tailor the CORDIC core for diverse applications, balancing performance, area, power, and resource requirements.

##
### **Literature Survey**:
| **S.No** | **Paper/Study** | **Existing Approach** | **Implementation to Our Project** |
|------|--------------|------------------------------|-------------------------------|
| 1. | **Volder, J.E. (1959)**	| CORDIC introduced as a method to compute trigonometric functions using only addition, subtraction, and shifting.	Introduced the foundational pipelined algorithm. | Implemented the physical design process for optimized performance and efficient resource utilization.|
| 2. | **Walther, J. (1971)** |	CORDIC expanded to handle a wider range of functions like logarithms, square roots, and exponentials.	| We enhanced the implementation by making the CORDIC core highly configurable, supporting different modes like vector, rotate, and iterative operation.|
| 3. | **Zhang, L. et al. (2018)** | Proposed optimized CORDIC implementations for higher speed, with various improvements in the iterative process. |	We further optimized the CORDIC architecture, implementing floorplanning, CTS (Clock Tree Synthesis), and STA (Static Timing Analysis) to ensure higher performance and better area and power efficiency. | 
| 4. | **Nguyen, D. et al. (2020)** | Introduced parallel CORDIC techniques to improve performance. | We introduced a pipelined design for faster computation and provided comprehensive physical design solutions such as power planning and placement. | 
| 5. | **NPTEL CORDIC Algorithm (2021)** | The NPTEL course covers the basic CORDIC algorithm for computing trigonometric functions and its hardware implementation.	| Our project improves upon this by creating a highly configurable CORDIC IP core, adding advanced physical design techniques and preparing the design for tape-out using industry- standard tools like Cadence Innovus and Genus. |

##
### **Block Diagram**:
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/79636560-3c64-4dc7-9365-2a073e8d06b2">
</p>

##
### **Flowchart**:
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/12fc167f-cfd6-4a2b-9a6b-8f83d0b76711">
</p>

##
### **Tools Used**:

1.	**Xilinx Vivado :**

**Purpose:**

- Used for initial RTL design, functional simulation, and FPGA implementation.
- Provides a development environment for synthesizing the CORDIC core and testing it on FPGA platforms.

**Key Features:**

- RTL Design Entry: Writing Verilog/VHDL code for the CORDIC algorithm.
- Simulation: Testing functionality using built-in waveform viewers.
- Synthesis: Converts the RTL code into gate-level netlists for FPGA implementation.
- FPGA Deployment: Allows testing the CORDIC core on hardware.

**Where Used in the Project:**

- RTL Design: The initial Verilog implementation of the CORDIC algorithm was written and simulated in Xilinx Vivado.
- Functional Verification: Basic waveforms were generated for checking the correctness of the sin, cos, and arctan outputs.

2.	**Cadence Incisive :**

**Purpose:**

- Performs functional verification of the CORDIC design at the RTL level.

**Key Features:**

- Simulation: Verifies the design using testbenches written in SystemVerilog or Verilog.
- Waveform Viewer: Analyzes signals and debugging issues in the design.
- Code Coverage: Ensures all parts of the design are tested effectively.
 
**Where Used in the Project:**

- Functional Verification: After writing the RTL code, Cadence Incisive was used to simulate the design with comprehensive testbenches.
- Waveform Analysis: Ensured that the design behaved as expected under various input scenarios, such as different angles and vector inputs.
- Debugging: Helped identify and fix logical errors in the RTL code by analyzing simulation outputs.

3.	**Cadence Genus:**

**Purpose:**

- Used for logic synthesis to convert the RTL design into a gate-level netlist.

**Key Features:**

- Synthesis: Maps the RTL code to standard cells from the technology library.
- Timing Analysis: Checks if the design meets timing constraints.
- Optimization: Minimizes area and power while maintaining performance.

**Inputs Required:**

1.	RTL Code: The Verilog/VHDL design.
2.	SDC File: Describes timing constraints for synthesis.
3.	Library File: Contains the characteristics of standard cells.

**Outputs Generated:**

- Gate-level netlist.
- Timing reports and constraints.
 
4.	**Cadence Innovus:**

**Purpose:**

- Performs physical design, including floorplanning, placement, routing, and clock tree synthesis.

**Key Features:**

- Floorplanning: Defines the placement of blocks on the chip.
- Power Planning: Creates power rings and straps to ensure proper power distribution.
- Placement and Routing: Arranges and connects the components of the design.
- DRC and LVS Checks: Ensures the layout complies with design and manufacturing rules.

**Workflow in the Project:**

1.	Initial Design and Simulation: Xilinx Vivado.
2.	Functional Verification: Cadence Incisive.
3.	Logic Synthesis: Cadence Genus.
4.	Physical Design: Cadence Innovus.
5.	Timing Analysis: Cadence Innovus.
6.	Automation: TCL scripts for Genus and Innovus.

##
### **Implementation**:

### **RTL Design:**
### Inputs:

1.	`clk` (Clock Signal)

    - Type: `wire`

    -	Description: Synchronizes the operation of the pipeline stages. Each iteration of the CORDIC algorithm is computed on the rising edge of this clock.
 
2.	`rst` (Reset Signal)

    -	Type: `wire`

    - Description: Initializes all internal registers (`x`, `y`, `z`) to zero when set high. Useful for resetting the system during startup or error conditions.

3.	`x_in` (16-bit Signed Input for X-coordinate)

    -	Type: `signed [15:0]`

    - Description: Represents the initial X-coordinate of the input vector in Cartesian space. When calculating trigonometric functions, it is typically initialized to a scaled constant (CORDIC gain adjusted).

4.	`y_in` (16-bit Signed Input for Y-coordinate)

    -	Type: `signed [15:0]`

    - Description: Represents the initial Y-coordinate of the input vector in Cartesian space. Usually initialized to zero for calculating sine and cosine.
5.	`theta_in` (16-bit Signed Input for Angle)

    -	Type: `signed [15:0]`

    - Description: The angle of rotation in fixed-point representation. Used to determine how much the input vector should rotate.
  
### Outputs:

1.	`x_out` (16-bit Signed Output for X-coordinate)

    -	Type: `signed [15:0]`

    - Description: Final X-coordinate after all iterations, representing the cosine value of the input angle (scaled by CORDIC gain).
 
2.	`y_out` (16-bit Signed Output for Y-coordinate)

    -	Type: `signed [15:0]`

    -	Description: Final Y-coordinate after all iterations, representing the sine value of the input angle (scaled by CORDIC gain).

### **Verilog Code**:
```v
𝑚𝑜𝑑𝑢𝑙𝑒 𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑖𝑝𝑒𝑙𝑖𝑛𝑒(
𝑖𝑛𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑐𝑙𝑘,
𝑖𝑛𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑟𝑠𝑡,
𝑖𝑛𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑥_𝑖𝑛,
𝑖𝑛𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑦_𝑖𝑛,
𝑖𝑛𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑡ℎ𝑒𝑡𝑎_𝑖𝑛,
𝑜𝑢𝑡𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑥_𝑜𝑢𝑡,
𝑜𝑢𝑡𝑝𝑢𝑡 𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑦_𝑜𝑢𝑡);
𝑝𝑎𝑟𝑎𝑚𝑒𝑡𝑒𝑟 𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 = 16;
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑥 [0: 𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 − 1];
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑦 [0: 𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 − 1];
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑧 [0: 𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 − 1];
𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒 [0: 15];
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[0]	=	16′𝑑11520; // 𝑎𝑡𝑎𝑛(2^0) 45 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[1]	=	16′𝑑6800; // 𝑎𝑡𝑎𝑛(2^ − 1) 26.565 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[2]	=	16′𝑑3552; // 𝑎𝑡𝑎𝑛(2^ − 2) 14.036 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[3]	=	16′𝑑1804; // 𝑎𝑡𝑎𝑛(2^ − 3) 7.125 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[4]	=	16′𝑑906;	// 𝑎𝑡𝑎𝑛(2^ − 4) 3.576 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[5]	=	16′𝑑455;	// 𝑎𝑡𝑎𝑛(2^ − 5) 1.790 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[6]	=	16′𝑑227;	// 𝑎𝑡𝑎𝑛(2^ − 6) 0.895 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[7]	=	16′𝑑114;	// 𝑎𝑡𝑎𝑛(2^ − 7) 0.448 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[8]	=	16′𝑑57;	// 𝑎𝑡𝑎𝑛(2^ − 8) 0.224 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[9]	=	16′𝑑28;	// 𝑎𝑡𝑎𝑛(2^ − 9) 0.112 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[10]	=	16′𝑑14;	// 𝑎𝑡𝑎𝑛(2^ − 10) 0.056 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[11]	=	16′𝑑7;	// 𝑎𝑡𝑎𝑛(2^ − 11) 0.028 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[12]	=	16′𝑑4;	// 𝑎𝑡𝑎𝑛(2^ − 12) 0.014 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[13]	=	16′𝑑2;	// 𝑎𝑡𝑎𝑛(2^ − 13) 0.007 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[14]	=	16′𝑑1;	// 𝑎𝑡𝑎𝑛(2^ − 14) 0.004 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑎𝑠𝑠𝑖𝑔𝑛 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[15]	=	16′𝑑0;	// 𝑎𝑡𝑎𝑛(2^ − 15) 0.002 𝑑𝑒𝑔𝑟𝑒𝑒𝑠
𝑔𝑒𝑛𝑣𝑎𝑟 𝑖;
𝑔𝑒𝑛𝑒𝑟𝑎𝑡𝑒
𝑓𝑜𝑟 (𝑖 = 0; 𝑖 < 𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆; 𝑖 = 𝑖 + 1) 𝑏𝑒𝑔𝑖𝑛 ∶ 𝑐𝑜𝑟𝑑𝑖𝑐_𝑠𝑡𝑎𝑔𝑒
𝑎𝑙𝑤𝑎𝑦𝑠 @(𝑝𝑜𝑠𝑒𝑑𝑔𝑒 𝑐𝑙𝑘 𝑜𝑟 𝑝𝑜𝑠𝑒𝑑𝑔𝑒 𝑟𝑠𝑡) 𝑏𝑒𝑔𝑖𝑛
𝑖𝑓 (𝑟𝑠𝑡) 𝑏𝑒𝑔𝑖𝑛
            𝑥[𝑖] <= 0;
            𝑦[𝑖] <= 0;
            𝑧[𝑖] <= 0;
𝑒𝑛𝑑 𝑒𝑙𝑠𝑒 𝑖𝑓 (𝑖 == 0) 𝑏𝑒𝑔𝑖𝑛
            𝑥[𝑖] <= 𝑥_𝑖𝑛;
            𝑦[𝑖] <= 𝑦_𝑖𝑛;
            𝑧[𝑖] <= 𝑡ℎ𝑒𝑡𝑎_𝑖𝑛;
𝑒𝑛𝑑 𝑒𝑙𝑠𝑒 𝑏𝑒𝑔𝑖𝑛
𝑖𝑓 (𝑧[𝑖 − 1] < 0) 𝑏𝑒𝑔𝑖𝑛
            𝑥[𝑖] <= 𝑥[𝑖 − 1] + (𝑦[𝑖 − 1] >>> 𝑖);
            𝑦[𝑖] <= 𝑦[𝑖 − 1] − (𝑥[𝑖 − 1] >>> 𝑖);
            𝑧[𝑖] <= 𝑧[𝑖 − 1] + 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[𝑖 − 1];
𝑒𝑛𝑑 𝑒𝑙𝑠𝑒 𝑏𝑒𝑔𝑖𝑛
            𝑥[𝑖] <= 𝑥[𝑖 − 1] − (𝑦[𝑖 − 1] >>> 𝑖);
            𝑦[𝑖] <= 𝑦[𝑖 − 1] + (𝑥[𝑖 − 1] >>> 𝑖);
            𝑧[𝑖] <= 𝑧[𝑖 − 1] − 𝑎𝑟𝑐𝑡𝑎𝑛_𝑡𝑎𝑏𝑙𝑒[𝑖 − 1];
            𝑒𝑛𝑑
        𝑒𝑛𝑑
    𝑒𝑛d
𝑒𝑛𝑑
𝑒𝑛𝑑𝑔𝑒𝑛𝑒𝑟𝑎𝑡𝑒
𝑎𝑠𝑠𝑖𝑔𝑛 𝑥_𝑜𝑢𝑡 = 𝑥[𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 − 1];
𝑎𝑠𝑠𝑖𝑔𝑛 𝑦_𝑜𝑢𝑡 = 𝑦[𝐼𝑇𝐸𝑅𝐴𝑇𝐼𝑂𝑁𝑆 − 1];
𝑒𝑛𝑑𝑚𝑜𝑑𝑢𝑙𝑒
```

### **Testbench Code**:
```v
𝑚𝑜𝑑𝑢𝑙𝑒 𝑡𝑏_𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑖𝑝𝑒𝑙𝑖𝑛𝑒;
𝑟𝑒𝑔 𝑐𝑙𝑘;
𝑟𝑒𝑔 𝑟𝑠𝑡;
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑥_𝑖𝑛;
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑦_𝑖𝑛;
𝑟𝑒𝑔 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑡ℎ𝑒𝑡𝑎_𝑖𝑛;
𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑥_𝑜𝑢𝑡;
𝑤𝑖𝑟𝑒 𝑠𝑖𝑔𝑛𝑒𝑑 [15: 0] 𝑦_𝑜𝑢𝑡;
𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑖𝑝𝑒𝑙𝑖𝑛𝑒 𝑐𝑜𝑟𝑑𝑖𝑐_𝑖𝑛𝑠𝑡 (.𝑐𝑙𝑘(𝑐𝑙𝑘),.𝑟𝑠𝑡(𝑟𝑠𝑡),.𝑥_𝑖𝑛(𝑥_𝑖𝑛),.𝑦_𝑖𝑛(𝑦_𝑖𝑛),.𝑡ℎ𝑒𝑡𝑎_𝑖𝑛(𝑡ℎ𝑒𝑡𝑎_𝑖𝑛),.𝑥_𝑜𝑢𝑡(𝑥_𝑜𝑢𝑡),.𝑦_𝑜𝑢𝑡(𝑦_𝑜𝑢𝑡));
𝑖𝑛𝑖𝑡𝑖𝑎𝑙 𝑏𝑒𝑔𝑖𝑛
𝑐𝑙𝑘 = 0;
𝑓𝑜𝑟𝑒𝑣𝑒𝑟 #5 𝑐𝑙𝑘 = ~𝑐𝑙𝑘;
𝑒𝑛𝑑
𝑖𝑛𝑖𝑡𝑖𝑎𝑙 𝑏𝑒𝑔𝑖𝑛
𝑟𝑠𝑡 = 1;
#10;
𝑟𝑠𝑡 = 0;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = 16′𝑑0; #100;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = 16′𝑑11520; #100;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = 16′𝑑23040; #100;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = −16′𝑑11520; #100;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = 16′𝑑46080; #100;
𝑥_𝑖𝑛 = 16′𝑑32768;
𝑦_𝑖𝑛 = 16′𝑑0;
𝑡ℎ𝑒𝑡𝑎_𝑖𝑛 = 16′𝑑7680; #100;
$𝑠𝑡𝑜𝑝;
𝑒𝑛𝑑
𝑖𝑛𝑖𝑡𝑖𝑎𝑙 𝑏𝑒𝑔𝑖𝑛
$𝑚𝑜𝑛𝑖𝑡𝑜𝑟("𝑇𝑖𝑚𝑒: %0𝑡 | 𝑋_𝑖𝑛: %0𝑑 | 𝑌_𝑖𝑛: %0𝑑 | 𝑇ℎ𝑒𝑡𝑎_𝑖𝑛: %0𝑑 | 𝑋_𝑜𝑢𝑡: %0𝑑 | 𝑌_𝑜𝑢𝑡: %0𝑑",$𝑡𝑖𝑚𝑒, 𝑥_𝑖𝑛, 𝑦_𝑖𝑛, 𝑡ℎ𝑒𝑡𝑎_𝑖𝑛, 𝑥_𝑜𝑢𝑡, 𝑦_𝑜𝑢𝑡);
𝑒𝑛𝑑
𝑒𝑛𝑑𝑚𝑜𝑑𝑢𝑙𝑒
```
### **Functional Verification using Cadence NCSim:**
#### Commands to visualize the Waveforms in Cadence NCSim

  - First step is to compile the Verilog design.
  - Second step is to elaborate and optimize the design.
  - Third step is to run the simulation.

#### Setup the design environment by clicking terminal and invoke into the Cadence environment.
Follow the below procedures and Type the following commands in the terminal:
```txt
Step:1 Create logical library by the following procedures:
a)  mkdir <directory name>- Create library directory and provide a logical library name.
b)  vi <file name>.v – To write the Verilog code
c)  vi <file name>_tb.v – To write the test bench
d)  vi cds.lib – Create cds lib for mapping
e)  make the following entries in new tab DEFINE <directory name>_lib ./<directory name>.lib
f)  mkdir <directory name>.lib - create a work directory for logical mapping.
g)  vi hdl.var – Create variable library and make the following entry in new tab DEFINE WORK <directory name>_lib

Step:2 Compilation process – Following commands are used for compiling design and test bench files.
a)  ncvlog <file name>.v –mess
b)  ncvlog <file name>_tb.v –mess

Step:3 Elaborate process- elaboration switches comes in handy to access read/write and connectivity access.
a)  ncelab <testbench module name> –access +rwc –mess

Step:4 Simulate the design
a)  ncsim <testbench module name> –gui

Step:5 NCSIM Design Browser window pops up
a)  Select the <testbench module name> instance and click SEND the SELECTED SIGNALS TO THE TARGETED WAVEFORM WINDOW.
b)  In the waveform window press RUN.
c)  Now you will be able to visualize the waveforms
```
##
### **Synthesis**

### **SDC Script:**
- Type the following script and save in a file named "cordic.sdc"

```sdc
𝑐𝑟𝑒𝑎𝑡𝑒_𝑐𝑙𝑜𝑐𝑘 −𝑛𝑎𝑚𝑒 "𝑐𝑙𝑘" −𝑝𝑒𝑟𝑖𝑜𝑑 10.0 −𝑤𝑎𝑣𝑒𝑓𝑜𝑟𝑚 {0 5} [𝑔𝑒𝑡_𝑝𝑜𝑟𝑡𝑠 𝑐𝑙𝑘]
```

### **TCL Script:**
- Type the following script and save in a file named "run.tcl"
```tcl
𝑟𝑒𝑎𝑑_ℎ𝑑𝑙 /ℎ𝑜𝑚𝑒/𝑣𝑙𝑠𝑖/𝐶𝑜𝑟𝑑𝑖𝑐/𝑐𝑜𝑟𝑑𝑖𝑐.𝑣
𝑟𝑒𝑎𝑑_𝑙𝑖𝑏𝑠 /ℎ𝑜𝑚𝑒/𝑖𝑛𝑠𝑡𝑎𝑙𝑙/𝐹𝑂𝑈𝑁𝐷𝑅𝑌/𝑑𝑖𝑔𝑖𝑡𝑎𝑙/45𝑛𝑚/𝑑𝑖𝑔/𝑙𝑖𝑏/𝑠𝑙𝑜𝑤.𝑙𝑖𝑏
𝑒𝑙𝑎𝑏𝑜𝑟𝑎𝑡𝑒 𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑖𝑝𝑒𝑙𝑖𝑛𝑒
𝑠𝑦𝑛_𝑔𝑒𝑛𝑒𝑟𝑖𝑐
𝑠𝑦𝑛_𝑚𝑎𝑝
𝑟𝑒𝑎𝑑_𝑠𝑑𝑐 𝑐𝑜𝑟𝑑𝑖𝑐.𝑠𝑑𝑐
𝑠𝑦𝑛_𝑜𝑝𝑡
# 𝑔𝑢𝑖_𝑠ℎ𝑜𝑤
# 𝑔𝑢𝑖_ℎ𝑖𝑑𝑒
𝑐ℎ𝑒𝑐𝑘_𝑑𝑒𝑠𝑖𝑔𝑛
𝑐ℎ𝑒𝑐𝑘_𝑡𝑖𝑚𝑖𝑛𝑔_𝑖𝑛𝑡𝑒𝑛𝑡
𝑟𝑒𝑝𝑜𝑟𝑡_𝑞𝑜𝑟 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑞𝑜𝑟.𝑟𝑒𝑝
𝑟𝑒𝑝𝑜𝑟𝑡_𝑡𝑖𝑚𝑖𝑛𝑔 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑡𝑖𝑚𝑖𝑛𝑔.𝑟𝑒𝑝
𝑟𝑒𝑝𝑜𝑟𝑡_𝑝𝑜𝑤𝑒𝑟 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑜𝑤𝑒𝑟.𝑟𝑒𝑝
𝑟𝑒𝑝𝑜𝑟𝑡_𝑎𝑟𝑒𝑎 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑎𝑟𝑒𝑎.𝑟𝑒𝑝
𝑤𝑟𝑖𝑡𝑒_𝑛𝑒𝑡𝑙𝑖𝑠𝑡 𝑐𝑜𝑟𝑑𝑖𝑐_𝑝𝑖𝑝𝑒𝑙𝑖𝑛𝑒 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑠𝑦𝑛𝑡ℎ.v
𝑤𝑟𝑖𝑡𝑒_𝑠𝑑𝑐 > 𝑐𝑜𝑟𝑑𝑖𝑐_𝑠𝑑𝑐.𝑠𝑑𝑐
```
### **Explaination**:

1.	`read_hdl /home/vlsi/Cordic/cordic.v`: Reads the Verilog HDL file for the CORDIC design, which contains the logic description of the module.
2.	`read_libs /home/install/FOUNDRY/digital/45nm/dig/lib/slow.lib`: Loads the technology library file (slow.lib) for synthesis, providing cell definitions for the target process (45nm).
3.	`elaborate cordic_pipeline`: Performs elaboration of the design, which means interpreting the Verilog code and resolving design objects.
4.	`syn_generic`: Generates a generic RTL representation of the design for synthesis.
5.	`syn_map`: Maps the RTL design to specific cells in the target technology library (45nm), optimizing for area and timing.
6.	`read_sdc cordic.sdc`: Reads the SDC (Synopsys Design Constraints) file, which contains timing and physical constraints for the design.
7.	`syn_opt`: Performs optimization of the synthesized design to improve timing, area, and power.
8.	`check_design`: Verifies that the design is correct and all logical components are in place.
9.	`check_timing_intent`: Ensures that the design's timing constraints are met and properly implemented.
10.	`report_qor > cordic_qor.rep`: Generates a Quality of Results (QoR) report, which includes overall design metrics like area, timing, and power.
11.	`report_timing > cordic_timing.rep`: Generates a detailed timing report showing the setup and hold times of the design.
12.	`report_power > cordic_power.rep`: Generates a power report showing the estimated power consumption of the design.
13.	`report_area > cordic_area.rep`: Generates an area report showing the total area used by the design in the layout.
14.	`write_netlist cordic_pipeline > cordic_synth.v`: Writes the synthesized netlist to a Verilog file (`cordic_synth.v`), which contains the final design in terms of gates and connections.
15.	`write_sdc > cordic_sdc.sdc`: Writes the design constraints (SDC) to a new file (`cordic_sdc.sdc`), which is used in the subsequent steps of implementation.

### **Commands**:

- **In Cadence Environment type the following in the terminal:**
```bash
gedit run.tcl //Type the TCL Script in this file
gedit cordic.sdc //Type the SDC Script in this file
genus ./run.tcl
gui_show
```
