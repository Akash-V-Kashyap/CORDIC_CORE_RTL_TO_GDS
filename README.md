# **Design Of A CORDIC CORE : RTL to GDS**

The below repositry shows a detailed guide to perform physical design of any appilcation code taking CORDIC CORE as an example. I have used gpdk45 as my choice of PDK as it is widely available in any institutions and also its simplicity. The CORDIC (Coordinate Rotation Digital Computer) core is an efficient hardware algorithm for performing complex mathematical computations like trigonometric, hyperbolic, and logarithmic functions without using multipliers. Its simplicity and iterative nature make it ideal for resource-constrained systems in applications such as signal processing, robotics, and communications.

## Basic Details 🚀
#### -  Name: Akash V Kashyap
#### - College: Dayananda Sagar College of Engineering, Bengaluru-560078
#### - Email ID: akashvkashyap@gmail.com
#### - GitHub Profile: [Akash-V-Kashyap](https://github.com/Akash-V-Kashyap) 
#### - LinkedIN Profile: [Akash V Kashyap](https://www.linkedin.com/in/akash-v-kashyap-336003261/)

##
## **Table of Contents**
- [**1. Introduction to the CORDIC Algorithm**](#1-introduction-to-the-cordic-algorithm)
- [**2. Problem Statement**](#2-problem-statement)
  - [**2.1 Alternative Algorithms**](#21-alternative-algorithms)
     - [**2.1.1 Taylor Series Expansion**](#211-taylor-series-expansion)
     - [**2.1.2 Polynomial Approximation (Chebyshev Polynomials)**](#212-polynomial-approximation-chebyshev-polynomials)
     - [**2.1.3 Lookup Tables (LUTs)**](#213-lookup-tables-luts)
- [**3. Why CORDIC Was Chosen?**](#3-why-cordic-was-chosen)
- [**4. Objectives**](#4-objectives)
- [**5. Literature Survey**](#5-literature-survey)
- [**6. Block Diagram**](#6-block-diagram)
- [**7. Flowchart**](#7-flowchart)
- [**8. Tools Used**](#8-tools-used)
- [**9. Implementation**](#9-implementation)
  - [**9.1 RTL Design**](#91-rtl-design)
  - [**9.2 Functional Verification using Cadence NCSim**](#92-functional-verification-using-cadence-ncsim)
  - [**9.3 Synthesis**](#93-synthesis)
  - [**9.4 Physical Design**](#94-physical-design)
      -  [**9.4.1 Importing Design in Cadence Innovus**](#941-importing-design-in-cadence-innovus)
      -  [**9.4.2 Floorplanning**](#942-floorplanning)
      -  [**9.4.3 Power Planning**](#943-power-planning)
      -  [**9.4.4 Pre-Placement**](#944-pre-placement)
      -  [**9.4.5 Placement**](#945-placement)
      -  [**9.4.6 Report Generation and Optimization**](#946-report-generation-and-optimization)
      -  [**9.4.7 Clock Tree Synthesis (CTS)**](#947-clock-tree-synthesis-cts)
      -  [**9.4.8 Routing**](#948-routing)
      -  [**9.4.9 Saving the Database**](#949-saving-the-database)
      -  [**9.4.10 Physical Verification: Capturing DRC and LVS**](#9410-physical-verification-capturing-drc-and-lvs)
  - [**9.5 Additional Checks done to verify design**](#95-additional-checks-done-to-verify-design)
- [**10. Final Project Outcome**](#10-final-project-outcome)
- [**11. Application, Advantages, and Limitations**](#11-application-advantages-and-limitations)
  - [**11.1 Applications**](#111-applications)
  - [**11.2 Advantages**](#112-advantages)
  - [**11.3 Limitations**](#113-limitations)
- [**12. Conclusion**](#12-conclusion)
- [**13. Future Scope**](#13-future-scope)
- [**14. References**](#14-references)

##
## **1. Introduction to the CORDIC Algorithm**

The **CORDIC (COordinate Rotation Digital Computer)** algorithm, introduced by **Jack E. Volder** in **1959**, is a computational method for efficiently calculating mathematical functions such as trigonometric, logarithmic, hyperbolic, and square root operations. It is based on simple geometric principles and performs iterative calculations using basic operations like addition, subtraction, bit shifts, and comparisons. This simplicity makes it particularly well-suited for hardware implementations, especially in systems lacking multipliers or requiring cost-effective and resource-efficient designs.

CORDIC operates by iteratively rotating a vector in the Cartesian plane to achieve the desired angle, enabling the computation of functions such as sine, cosine, and arctangent. Its ability to compute multiple functions with a unified approach reduces hardware complexity and makes it ideal for embedded systems, digital signal processing (DSP), telecommunications, robotics, and graphics applications.

The algorithm's iterative nature allows adjustable precision by varying the number of iterations, offering scalability to balance accuracy, speed, and power consumption. Additionally, its compatibility with fixed-point arithmetic enhances its efficiency in real-time and low-power hardware systems. CORDIC's versatility, simplicity, and adaptability have made it a cornerstone in digital computation and hardware design.

##
## **2. Problem Statement**

Traditional methods like Taylor series and polynomial approximations for computing functions such as sine, cosine, and logarithms are computationally intensive and hardware-inefficient. While the CORDIC algorithm offers a simpler, hardware-friendly alternative using basic operations like addition and shifts, earlier implementations lacked flexibility and optimization for modern systems.

This project aims to develop an optimized and configurable CORDIC core, leveraging advanced physical design techniques to ensure high performance, scalability, and efficiency for applications in signal processing, robotics, and 3D graphics.

##
## **2.1 Alternative Algorithms**
### **2.1.1 Taylor Series Expansion**

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
### **2.1.2 Polynomial Approximation (Chebyshev Polynomials)**

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
### **2.1.3 Lookup Tables (LUTs)**

Lookup tables precompute values for mathematical functions and store them in memory, allowing functions like sine, cosine, or logarithm to be retrieved instantly. This method is extremely fast and efficient in applications where memory is abundant and computation speed is critical. However, LUTs are limited by their resolution and become impractical for applications requiring high precision or a large dynamic range. CORDIC overcomes this by computing values dynamically with a small memory footprint, making it ideal for resource-constrained environments.
Equation for Sine using LUT:

<h3 align="center">𝑠𝑖𝑛 (𝑥) ≈ 𝐿𝑈𝑇[𝑥]</h3>

**Pros:**

- Very fast, as the function evaluation is reduced to a memory lookup.
- Simple hardware implementation.

**Cons:**

- Requires large amounts of memory to store function values, limiting scalability for high precision.
- Limited by the resolution of the stored data; higher precision requires larger tables.

##
## **3. Why CORDIC Was Chosen?**:

CORDIC was chosen for its simplicity, efficiency, and versatility in hardware implementations. Unlike Taylor series or polynomial approximations, which require complex operations like multiplication and division, CORDIC relies on iterative shift-and-add operations, making it ideal for FPGA or ASIC designs with limited resources. Its scalability allows precision to be adjusted by varying the number of iterations, ensuring efficient hardware utilization.

Additionally, CORDIC's single algorithmic structure can compute a wide range of functions—trigonometric, hyperbolic, logarithmic, and square root—without significant modifications. This flexibility surpasses specialized methods like Newton-Raphson or lookup tables, which are limited to specific operations. Its compatibility with fixed-point arithmetic further enhances its suitability for low-power, high-speed applications in signal processing, image processing, telecommunications, and embedded systems.

##
## **4. Objectives**
1. **Development of a Configurable CORDIC IP Core**: Design a highly adaptable CORDIC core capable of computing mathematical functions like trigonometric, logarithmic, and exponential operations with optimized hardware efficiency.

2. **Physical Design and Tapeout Preparation**: Transform the Verilog RTL code into a physical design, focusing on critical steps such as floorplanning, clock tree synthesis (CTS), and static timing analysis (STA) to meet power, area, and timing constraints.

3. **GDS File Generation**: Finalize the design by generating the GDS file, representing the layout for fabrication.

4. **Customization and Flexibility**: Provide a configurable architecture to tailor the CORDIC core for diverse applications, balancing performance, area, power, and resource requirements.

##
## **5. Literature Survey**
| **S.No** | **Paper/Study** | **Existing Approach** | **Implementation to Our Project** |
|------|--------------|------------------------------|-------------------------------|
| 1. | **Volder, J.E. (1959)**	| CORDIC introduced as a method to compute trigonometric functions using only addition, subtraction, and shifting.	Introduced the foundational pipelined algorithm. | Implemented the physical design process for optimized performance and efficient resource utilization.|
| 2. | **Walther, J. (1971)** |	CORDIC expanded to handle a wider range of functions like logarithms, square roots, and exponentials.	| We enhanced the implementation by making the CORDIC core highly configurable, supporting different modes like vector, rotate, and iterative operation.|
| 3. | **Zhang, L. et al. (2018)** | Proposed optimized CORDIC implementations for higher speed, with various improvements in the iterative process. |	We further optimized the CORDIC architecture, implementing floorplanning, CTS (Clock Tree Synthesis), and STA (Static Timing Analysis) to ensure higher performance and better area and power efficiency. | 
| 4. | **Nguyen, D. et al. (2020)** | Introduced parallel CORDIC techniques to improve performance. | We introduced a pipelined design for faster computation and provided comprehensive physical design solutions such as power planning and placement. | 
| 5. | **NPTEL CORDIC Algorithm (2021)** | The NPTEL course covers the basic CORDIC algorithm for computing trigonometric functions and its hardware implementation.	| Our project improves upon this by creating a highly configurable CORDIC IP core, adding advanced physical design techniques and preparing the design for tape-out using industry- standard tools like Cadence Innovus and Genus. |

##
## **6. Block Diagram**

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/79636560-3c64-4dc7-9365-2a073e8d06b2">
</p>

##
## **7. Flowchart**
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/12fc167f-cfd6-4a2b-9a6b-8f83d0b76711">
</p>

##
## **8. Tools Used**

### 1. **Xilinx Vivado :**

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

##
### 2. **Cadence Incisive :**

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

##
### 3. **Cadence Genus:**

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

##
### 4. **Cadence Innovus:**

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
## **9. Implementation**

### **9.1 RTL Design**
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
<p align="center">
<img width=1000 src="https://github.com/user-attachments/assets/31b58d3b-7ef5-4b7a-addb-a072965c3c71">
</p>

<p align="center">
<img width=1000 src="https://github.com/user-attachments/assets/16a71e01-3a36-4295-9507-fd492c553594">
</p>

##
### **9.2 Functional Verification using Cadence NCSim**

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
<p align="center">
<img width=1000 src="https://github.com/user-attachments/assets/6902db7f-f71e-4b95-87de-eb98f28c6237">
</p>

##
### **9.3 Synthesis**

The synthesis process in Cadence Genus transforms RTL code (written in Verilog or VHDL) into a gate-level representation for hardware implementation. Key inputs include:

- **RTL Code**: Defines the logic and functionality of the design.  
- **Constraints Files (e.g., *SDC*)**: Specify timing, clock definitions, input-output relationships, and physical constraints to meet performance and area requirements.  
- **Technology Library Files**: Provide details about available cells, including delays, area, and power for the target fabrication process (e.g., 7nm or 65nm).  
- **Power Constraints**: Optional files to guide power optimization.  

These inputs enable Cadence Genus to optimize the design for timing, area, and power before advancing to implementation.

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

<p align="center">
<img width=800 src="https://github.com/user-attachments/assets/8a00ae87-97f3-4ed7-a2b3-9ef8adeaf577">
</p>

<p align="center">
<img width=800 src="https://github.com/user-attachments/assets/9a4cd378-5081-415c-baee-8b70ec365f26">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/beb374af-0eea-433d-b41c-a5cd60fe5593">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/867fe747-19bc-43ca-b8fb-1cb3f8d895a1">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/4502372e-d259-4515-a49a-a8e0eda76e6d">
</p>

##
### **9.4 Physical Design**

<p align="center">
<img width=800 src="https://github.com/user-attachments/assets/491c842e-0dec-4a69-a2a8-315b0cb611a2">
</p>

The physical design process, carried out using Cadence Innovus, converts the synthesized netlist and constraints into a physical chip layout. Key tasks include floorplanning, cell placement, clock tree synthesis, routing, and optimization for performance, power, and area. 

Using the Verilog netlist and SDC files from Genus, Innovus ensures the design meets all timing and design constraints, preparing it for tape-out and fabrication. The process begins with verifying the digital design and testbench (in Verilog) using functional simulation tools like Incisive Simulator (e.g., *ncvlog, ncelab, ncsim*). After verifying functionality, the design undergoes synthesis to generate the gate-level netlist, Block-Level SDC, Liberty files (.lib), and LEF files. 

### **Inputs for Physical Design**
  1. **Gate Level Netlist:** This is the output of the synthesis stage and serves as the foundation for physical implementation. 
  2. **Block Level SDC:** The timing constraints file generated during synthesis to guide the design implementation. 
  3. **Liberty File (.lib):** Captures timing, power, and functional characteristics of standard cells. 
  4. **LEF Files (Layer Exchange Format):** Contains abstract physical information about standard cells, including pin positions, layout layers, and blockages.

### **Outputs from Physical Design**
  1. **GDSII File:** The final physical design in Graphical Data Stream format for fabrication. 
  2. **SPEF (Standard Parasitic Exchange Format) and SDF (Standard Delay Format):** Used for post-layout timing and parasitic extraction verification.

### **Initiating Innovus**
1. Ensure the synthesis is complete for the target design and open a terminal in the 
corresponding workspace. 
2. Start the Cadence tools and use the command: `innovus` and press Enter. 
3. The Innovus GUI opens, and the terminal enters the Innovus command prompt, ready for tool-specific commands.

##
### **9.4.1 Importing Design in Cadence Innovus**

The design import process in Innovus involves loading all the mandatory inputs, either through script files (e.g., `.globals`, `.view`, `.tcl`) or via the GUI. Below is a step-by-step guide to importing a design:

### **1. Mandatory Input Files**
- **Netlist:** Describes the design's gate-level logic.  
- **LEF Files:** Physical layout information for standard cells, obtained from the foundry (e.g., `/home/install/FOUNDRY/digital/90nm/dig/lef`).  
- **Liberty Files (`.lib`):**
  - **Slow.lib:** Represents the PVT (Process, Voltage, Temperature) corner with slow charge movement (Maximum Delay, Worst Performance).  
  - **Fast.lib:** Represents the PVT corner with fast charge movement (Minimum Delay, Best Performance).  
- **SDC (Synopsys Design Constraints):** Specifies timing constraints like clock definitions and reset.  

The `.lib` and SDC files are combined to analyze:
  - **Setup Timing:** Worst-case delay.  
  - **Hold Timing:** Best-case delay.

### **2. GUI Workflow for Design Import**
1. **Open Innovus Tool:**  
   Navigate to **File → Import Design** in the GUI.  
   
2. **Load Files:**
   - **Netlist:** Browse for the file and set "Top cell: Auto Assign."  
   - **LEF Files:** Select from the foundry directory.  
   
3. **Create Power Supply Pins:**  
   Define **VDD** and **VSS** pins.  

4. **Load Liberty and SDC Files:**
   - Select the **"Create Analysis Configuration"** option at the bottom.  
   - The **MMMC Browser** window opens.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/ffa00fde-194f-428c-a828-8d9ad79f2356">
</p>

5. **Add MMMC Objects:**
   - **Library Sets:** Add `.lib` files (e.g., `slow.lib` and `fast.lib`) with appropriate labels.  
   - **RC Corners:** Define temperature values and include Cap Table/RC Tech files from the foundry.  
   - **Delay Corners:** Combine library sets with RC corners.  
   - **Constraints:** Load the SDC file under MMMC "Constraints."

6. **Create Analysis Views:**  
   - Combine **SDC** and **Delay Corners** to form "Best" and "Worst" analysis views.  
   - Assign:
     - **Best View** → Hold Timing  
     - **Worst View** → Setup Timing  

7. **Save the Configuration:**  
   - Click **"Save & Close"** to save the script (with a `.view` or `.tcl` extension).  
   - Return to the **Import Design** window and click **OK** to load the design.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/6dd6ae53-f9cb-4fe1-a554-d3098d77288c">
</p>

8. **Save Defaults:**  
   Save the settings as `Default.globals` to reload them easily in future sessions.

### **3. Verify the Design Import**
- A rectangular or square **Core Area** should appear in the GUI upon successful import.  
  - If not, check the terminal or log file for errors.  
- **Core Area Details:**
  - **Standard Cell Rows:** Horizontal rows running across the core width.  
  - Alternate rows are flipped to indicate **VDD** and **VSS** power rails, forming the "Flipped Standard Cell Rows" setup.
 
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/c733c6d7-7dbb-4478-b5d6-faa65bfe79c4">
</p>

##
### **9.4.2 Floorplanning**

The floorplanning process defines the chip's physical structure and optimizes the layout for performance and area. Below are the key steps involved:

### **Steps in Floorplanning**
1. **Aspect Ratio:**  
   - Defines the ratio of vertical height to horizontal width of the core.  
   - Adjusted to balance the core shape and placement efficiency.

2. **Core Utilization:**  
   - Specifies the percentage of the core area to be used for floorplanning.  
   - Higher utilization means less unused area but may lead to congestion.

3. **Channel Spacing:**  
   - Distance between the core boundary and the I/O boundary.  
   - Adjusted to ensure proper pin placement and routing space.

#### **Workflow**
1. Navigate to **FloorPlan → Specify Floorplan** in the Innovus GUI.  
2. Modify/Add values for:
   - **Aspect Ratio**  
   - **Core Utilization**  
   - **Channel Spacing**  

3. Upon adjusting these parameters, the **Core Area** is recalculated and modified accordingly.

4. **Unassigned Pins:**  
   - Initially, unassigned pins appear as a yellow patch in the bottom-left corner of the core.  
   - These pins must be placed along the **I/O Boundary**, ensuring proper alignment with standard cells and gates.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/01beb9e2-203c-4ea2-abb0-641aae3151d4">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/b50e09cd-b01e-4e29-8f34-bd3e3aeb4c67">
</p>

##
### **9.4.3 Power Planning**

Power planning ensures that the design receives a reliable and efficient power supply across the entire chip. Below are the key steps involved:

### **Steps in Power Planning**

1. **Connect Global Nets:**  
   - Create two pins: one for **VDD** (power) and one for **VSS** (ground).  
   - Connect these pins to the global nets defined in the `.globals` file or power/ground nets.  
   - **Workflow:**
     - Navigate to **Power → Connect Global Nets**.  
     - Use **"Add to List"** to create the pins and connect them to the corresponding global nets.  
     - Click **"Apply"** to enforce the connections, then close the window.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/3f8d1dae-290d-4457-8134-1fe0d249703d">
</p> 

2. **Adding Power Rings:**  
   - Power rings are added around the core boundary to supply power efficiently from distant power sources.  
   - **Workflow:**
     - Go to **Power → Power Planning → Add Ring**.  
     - Select global nets (e.g., VDD, VSS) from the browse option or type their names (case-sensitive).  
     - Use the highest metal layers for horizontal (H) and vertical (V) segments, as these have the highest width and lowest resistance.  
     - Set **Offset: Center in Channel**, and update the **minimum width** and **spacing**.  
     - Click **OK** to create the rings.
    
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/53c75838-bbf0-43c3-b87f-0963b199e218">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/6105efde-a45a-4a8e-bccc-9f5a69911ddf">
</p>

3. **Adding Power Strips:**  
   - Power strips are added across the core boundary to distribute power efficiently to cells within the core.  
   - **Factors to Consider:**  
     - **Nets** (e.g., VDD, VSS).  
     - **Metal Layers and Directions:** Assign appropriate horizontal (H) or vertical (V) metals.  
     - **Width and Spacing:** Update values based on foundry specifications.  
     - **Set-to-Set Distance:** Calculated as \( ( \text{Minimum Width of Metal} + \text{Minimum Spacing} ) \times 2 \).  
   - Use the same process as power rings to create power strips.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/d37e1037-29a7-48cf-911f-69cb0f17d372">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/13e1f1b0-f2f3-41ac-8cc6-a713bcb9ba01">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/8fc5d666-c751-4534-b25b-7996fb1d8391">
</p>

4. **Special Routing:**  
   - Connects the highest metals (e.g., Metal 9 or 8) to the lowest metal (Metal 1), which supplies power to standard cells.  
   - This is achieved by stacking vias across metal layers.  
   - **Workflow:**
     - Navigate to **Route → Special Route → Add Nets → OK**.  
     - After completing the special route, the standard cell rows will be color-coded to indicate Metal 1 connections.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/ff20e1d1-e17b-4a0f-8816-1dd35e5dd8db">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/39f31db5-7ce7-430f-bead-b27c60120e9b">
</p>

### **Outcome**
The complete power planning process ensures:  
- Efficient power distribution across the chip.  
- Reliable connections from global nets to standard cells.  
- A well-constructed power mesh with sufficient power for every standard cell to operate smoothly.

##
### **9.4.4 Pre-Placement**

Pre-placement involves adding specific physical cells to ensure structural integrity and avoid electrical issues before placing the standard cells. The two key physical cells added are **End Caps** and **Well Taps**.

### **1. End Caps**
- **Purpose:**  
  - End Caps are physical cells placed at the left and right boundaries of the core to prevent standard cells from moving outside the boundary.  
  - They act as blockages and maintain the design's structural integrity.  

- **Workflow:**  
  - Navigate to **Place → Physical Cell → Add End Caps**.  
  - Select **"FILL"** from the available list.  
    - Higher **FILL** values correspond to wider cells.  
  - End Caps will appear below the Power Mesh after placement.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/c214c1db-1abb-4afa-9d60-9d761c230af2">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/0ce1b6ec-e8c1-40b1-906e-dade8fb16431">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/ebc4cf56-7e77-40b0-b9be-15b0c8b83ac2">
</p>
 
### **2. Well Taps**
- **Purpose:**  
  - Well Taps function as shunt resistances to prevent latch-up effects by connecting the substrate or wells to power or ground.  

- **Workflow:**  
  - Go to **Place → Physical Cell → Add Well Tap**.  
  - Select **"FILL X"**, where `X` determines the strength of the fill (e.g., 1, 2, 4, etc.).  
  - Specify the **Distance Interval** (typically between 30–45 μm).  
  - Click **OK** to complete the process.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/09010e3b-e5e6-455c-a60e-77ef5b5a58f3">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/b2ea15aa-15de-461a-ba21-6c0e4370188a">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/99d6c56d-cf35-4e4f-929d-9b1c05570e93">
</p>

### **Outcome**
After adding End Caps and Well Taps:  
- The **End Caps** secure the boundaries of the design.  
- The **Well Taps** ensure electrical stability by minimizing latch-up risks.  
These steps prepare the core for standard cell placement while maintaining reliability and structural consistency.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/3e101787-4464-4ddc-a093-e3300e829ae1">
</p>

##
### **9.4.5 Placement**

Placement involves arranging standard cells and I/O pins within the core area to optimize timing, reduce power consumption, and minimize wirelength. This step ensures that communicating cells are placed close together to improve performance and avoid congestion.

### **Key Steps in Placement**

1. **Place Standard Cells and Pins:**  
   - Navigate to **Place → Place Standard Cell → Run Full Placement**.  
   - Enable **'Place I/O Pins'** in the mode settings and click **OK**.  

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/aa9dc88b-1eff-413f-ade4-3a6a27fa629a">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/312c7c09-8311-4789-81bf-b477e482b2d0">
</p>

2. **Placement Optimization:**  
   - Standard cells are positioned based on their connectivity to minimize net lengths.  
   - The tool verifies constraints such as minimum area, spacing, and alignment with the power grid.  

3. **Layer Visibility:**  
   - Use the **Layer Tab** on the right to toggle layer visibility, which helps visualize the placement and ensure proper alignment.

### **Outcome**
Proper placement ensures:  
- Shorter net lengths for better timing results.  
- Balanced power, area, and timing.  
- A design ready for the next stage: routing.

##
### **9.4.6 Report Generation and Optimization**

Generating reports and optimizing the design are critical steps in analyzing the design's performance and ensuring it meets timing, area, and power constraints. Below are the steps for report generation and optimization:

### **1. Timing Report**
- Navigate to **Timing → Report Timing**.  
- Set the following parameters:  
  - **Design Stage:** Pre-CTS  
  - **Analysis Type:** Setup  
- Click **OK** to generate the timing report.  
- The **Timing Report Summary** will be displayed on the terminal.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/d25408c5-05ec-4512-be26-2009d0fbf685">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/7820d7b7-2ff4-40dc-9e46-4686e631a73f">
</p>

### **2. Area Report**
- Use the following command in the terminal:  
  ```bash
  report_area
  ```

### **3. Power Report**
- Use the following command in the terminal:  
  ```bash
  report_power
  ```

### **4. Design Optimization**
- If there are violating paths, the design can be optimized:  
  - Go to **ECO → Optimize Design**.  
  - Set the following parameters:  
    - **Design Stage:** Pre-CTS  
    - **Optimization Type:** Setup  
  - Click **OK** to run the optimization.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/cfc0cfb2-e9db-4658-aa22-c42153967d7f">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/92dbe11a-61db-4f1c-8d20-c1d854f9a373">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/ad809f43-c388-4cf0-92be-f8f85b722492">
</p>

- After optimization, the updated timing report will be displayed on the terminal.  
- Use the above commands to regenerate timing, area, and power reports to compare pre- and post-optimization results.

### **Outcome**
- This process optimizes the design for timing, area, and power while resolving any violations.  
- Comparing the reports ensures that improvements are quantified and design constraints are met effectively.

##
### **9.4.7 Clock Tree Synthesis (CTS)**

Clock Tree Synthesis (CTS) ensures that the clock signal reaches all registers (flip-flops) simultaneously or with minimal skew to maintain proper communication across the design.

### **Steps for CTS**

1. **Clock Tree Generation:**  
   - Use a pre-written script to build the clock tree.  
   - Source the script through the terminal to execute it.
  
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/73cb38d5-c9fa-4987-b52d-f8d86ae947f7">
</p>

2. **View and Debug Clock Tree:**  
   - Navigate to **Clock → CCOpt Clock Tree Debugger → OK** to build and visualize the clock tree.  
   - In the visual representation:  
     - **Red boxes** indicate the clock pins of flip-flops.  
     - **Yellow pentagon** represents the clock source.
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/f7c2f1ac-0f8a-4c98-afd2-c19f8e738d2f">
</p>

3. **Clock Tree Components:**  
   - The clock tree consists of **clock buffers** and **clock inverters** that amplify and stabilize the clock signal as it propagates through the design.
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/f0d00fec-30f4-46aa-bf04-1350cae7a124">
</p>

### **Outcome**
The CTS process ensures a balanced clock distribution network, minimizing skew and enabling synchronized operation across the design.  

### **Report Generation and Design Optimisation:**
-CTS Stage adds real clock into the design and hence "Hold" Analysis also becomes prominent. Hence, Optimisation can be done for both Setup and Hold, Timing Reports are to be generated for Setup and Hold individually.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/46e3d49d-7060-4317-87b8-36edde91e2f5">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/5e7ed423-cccc-4163-a1f4-5e177963c694">
</p>

##
### **9.4.8 Routing** 

Routing is the process of creating actual physical connections (metal routes) between the design components. This step ensures that logical connectivity is translated into real metal wires, avoiding issues such as opens, shorts, crosstalk, or antenna violations.  

### **Steps for Routing**

1. **Run Routing:**  
   - Go to **Route → Nano Route → Route**.  
   - Enable **Timing Driven** and **SI Driven** options to optimize for timing and signal integrity.  
   - Click **OK** to execute the routing process.

2. **Design Optimization Post-Route:**  
   - After routing, use the terminal or GUI to run **Design Optimization** to further improve the physical design.  

3. **Set Analysis Mode:**  
   - As an alternative to the `setAnalysisMode` command in the terminal, use the GUI:  
     - Navigate to **Tools → Set Mode → Set Analysis Mode**.  
     - Enable **On-Chip Variation** and **CPPR (Clock Path Pessimism Removal)** for improved analysis accuracy.

4. **Generate Reports:**  
   - Post-routing, generate timing, area, and power reports using the same methods as in the earlier Design Optimization phase.  

### **Outcome**  
The routing process translates logical connections into reliable physical connections, ensuring the design is free of routing-related violations and ready for final verification.
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/e3d894d4-597c-4157-9293-85a133d9d83d">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/7ccf4f98-4e42-4927-a6f7-b907d37ef634">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/313c1daa-043e-435b-baea-ff1312e26a59">
</p>

##
### **9.4.9 Saving the Database**

Proper saving of design files is crucial to preserve the progress and ensure compatibility with subsequent design stages.

### **Steps to Save the Database**

1. **Save the Design:**  
   - Go to **File → Save Design**.  
   - Select **Data Type: Innovus**.  
   - Enter the desired file name as `<DesignName>.enc`.  
   - Click **OK**.

2. **Save the Netlist:**  
   - Navigate to **File → Save → Netlist**.  
   - Specify the file name as `<NetlistName>.v`.  
   - Click **OK**.

3. **Save the GDS File:**  
   - Go to **File → Save → GDS/OASIS**.  
   - Enter the desired file name as `<FileName>.gds`.  
   - Click **OK**.

### **Outcome**  
The design, netlist, and GDS files are saved in their respective formats, enabling seamless continuation of the design flow and preparation for tape-out.

##
### **9.4.10 Physical Verification: Capturing DRC and LVS**

Physical verification ensures that the design meets all fabrication and connectivity rules before proceeding to manufacturing. This process includes **Design Rule Check (DRC)** and **Layout Versus Schematic (LVS)**.  

### **Design Rule Check (DRC)**  

**Inputs Required for DRC:**  
1. **Technology Library** and **Rule Sets**: Define the fabrication rules for the specific technology node.  
2. **GDS Files of Standard Cells**: Available at `/home/install/FOUNDRY/90nm/dig/gds` for the 90nm technology node.  

**Outputs from DRC:**  
1. **DRC Violation Report**  
2. Optional: **Physical Netlist**  

**Steps to Run DRC:**  
1. From the Innovus GUI, go to **PVS → Run DRC** to open the DRC Submission Form.  
2. Specify the **Run Directory** where logs, reports, and related files will be saved.  
3. Under the **Rules** tab:  
   - Load the **Technology Library** corresponding to your design's technology node.  
   - The rule set and fabrication rules will automatically be read into the tool.  
4. Add the **GDS Files** of all standard cells.  
5. Provide a name and location for the output report.  
6. Click **Submit** to start the DRC.  

**Post-DRC:**  
- The tool generates a list of DRC errors.  
- Errors are displayed in a dedicated window, and their locations can be highlighted and zoomed in for detailed analysis.  
- Save the DRC run as a **Preset File** for reusability.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/d166d4a9-0538-42c0-8934-387fb042526f">
</p>

#### **Layout Versus Schematic (LVS)**  

**Inputs Required for LVS:**  
1. **Technology Library**  
2. **GDS Files of Standard Cells**  
3. **SPICE Netlist** of all standard cells (provided by the vendor).  

**Outputs from LVS:**  
1. **LVS Match/Mismatch Report**  

**Steps to Run LVS:**  
1. From the Innovus GUI, go to **PVS → Run LVS** to open the LVS Submission Form.  
2. Specify the **Run Directory** and optionally provide a log file name and path.  
3. Load the following under their respective tabs:  
   - **Technology Library**  
   - **GDS Files**  
   - **SPICE Netlist**  

4. Submit the LVS run to check for connectivity between the layout and the schematic.

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/da8a2237-2e73-45d1-b780-833af202134a">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/de276d57-cd51-4c46-b525-d3a33d6f7494">
</p>

**StreamOut Command (Optional):**  
If required, you can create a GDS file and Stream Out file using the following methods:  
- GUI: **File → Save → GDS/Oasis**  
- Command:  
   ```bash
   streamOut <GDSFileName>.gds -streamOut <streamOut>.map
   ```  

**Conclusion:**  
Physical verification through DRC and LVS ensures that the design meets all manufacturing rules and matches the schematic's intent. This step is essential to avoid costly fabrication errors.

##
## **9.5 Additional Checks done to verify design**
<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/edaed946-b53f-4334-984f-bba97b443911">
</p> 

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/71f93998-9cdb-42b6-bb19-7fe1152e87bb">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/a53fc256-c202-42cc-827d-3c8e75e6514b">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/1dca33e6-152b-4d1a-a527-3b942254e7f9">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/a89d71dc-38bf-49f3-82b8-7e8e74814a37">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/46dc8023-c662-4118-a2e2-96d9a0ee5d5b">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/9a3c8b5c-4833-4d69-bbe1-833c335fe00b">
</p>

##
## **10. Final Project Outcome**

### **Power Report:**

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/ec635b52-f684-4997-b44c-7f5253cb2d49">
</p>

### **Area Report:**

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/05ba0155-59bd-4be6-a0c6-400afa58962b">
</p>

### **Final GSII Layout:**

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/1e0d8847-3750-4668-89c0-27820bfa9d49">
</p>

### **3D View:**

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/fbd5eae8-b5a5-44cb-8da4-6cf542226489">
</p>

<p align="center">
<img width=500 src="https://github.com/user-attachments/assets/5e4fc91d-0f43-4a5d-8a7a-c65e51b57796">
</p>

##
## **11. Application, Advantages, and Limitations**

### **11.1 Applications**  
The CORDIC algorithm is widely used across various domains due to its iterative and efficient computation. Key applications include:  

1. **Digital Signal Processing (DSP):**  
   - Computes FFT for spectral analysis and filter design.  
   - Used in adaptive filtering and signal modulation processes.  

2. **Graphics and Image Processing:**  
   - Handles 2D/3D geometric transformations like rotation and scaling.  
   - Essential for real-time rendering in graphics and animation.  

3. **Communication Systems:**  
   - Supports QAM and PSK modulation/demodulation by phase shift calculation.  
   - Widely used in baseband signal processing and software-defined radios.  

4. **Navigation and Control Systems:**  
   - Performs angle calculations for GPS and trajectory computations in robotics.  
   - Used in real-time motion control systems.  

5. **Embedded Systems:**  
   - Executes trigonometric and exponential functions on microcontrollers/DSPs.  
   - Optimized for systems lacking hardware multipliers.  

6. **Medical Imaging:**  
   - Applied in CT and MRI image reconstruction algorithms.  

##
### **11.2 Advantages**  

1. **Hardware Efficiency:**  
   - Eliminates multipliers using only shift-and-add operations, making it ideal for FPGA and ASIC implementations.  

2. **Computational Versatility:**  
   - Supports trigonometric, hyperbolic, and exponential functions in fixed-point or real-time applications.  

3. **Scalability:**  
   - Easily adaptable for different precision and word lengths.  

4. **Low Power Consumption:**  
   - Reduces hardware complexity, lowering power requirements.  

5. **Real-Time Performance:**  
   - High-speed convergence for latency-critical applications like DSP and communication systems.  

##
### **11.3 Limitations**  

1. **Precision Issues:**  
   - Limited accuracy due to truncation and rounding errors in fixed-point implementations.  

2. **Slow Convergence for Small Angles:**  
   - Less efficient for small-angle computations compared to direct methods.  

3. **Scaling Overhead:**  
   - Pre-scaling and post-scaling increase computation time.  

4. **Modern Processor Constraints:**  
   - May underperform compared to multiplier-based algorithms on systems with advanced floating-point units.  

5. **Range Restrictions:**  
   - Input values must be confined to specific ranges without additional modifications.  

The CORDIC algorithm is invaluable for high-performance applications but requires consideration of its trade-offs in precision, range, and modern hardware efficiency.

##
## **12. Conclusion**  

The CORDIC algorithm was successfully implemented and synthesized in this project, demonstrating its ability to perform efficient trigonometric computations with minimal hardware. Using tools like Cadence Genus and Innovus, the RTL-to-GDS flow was completed, and the GDS file was generated, marking readiness for fabrication. This implementation highlights the algorithm’s suitability for low-power, resource-constrained environments and its broad applicability in areas such as signal processing, robotics, and telecommunications, laying a strong foundation for future advancements in computational hardware systems.

##
## **13. Future Scope**
The CORDIC algorithm, with its multiplier-less architecture, has significant potential for scaling into advanced computing systems and emerging technologies. Future enhancements can focus on:

1. **Algorithm Optimization:**
- Improve convergence rate and precision for small angles or complex functions using hybrid or pre-computation techniques.

2. **Hardware Acceleration:**
- Explore implementation on advanced hardware platforms like RISC-V processors, GPUs, and neuromorphic computing for specialized tasks.

3. **AI and ML Integration:**
- Leverage the CORDIC algorithm for matrix operations, feature extraction, and embedded AI solutions in IoT and edge computing.

4. **FPGA and ASIC Applications:**
- Adapt the design for dynamic reconfigurable systems and industry-grade ASICs, targeting high-throughput domains like automotive, aerospace, and 5G communication.

5. **Precision and Speed Enhancements:**
- Develop approaches for higher precision while maintaining low latency, making the algorithm suitable for critical applications such as medical imaging and aerospace navigation.

As technology advances, the CORDIC algorithm’s efficiency in low-power and high-performance systems positions it as a key component in future innovations across multiple industries.

##
## **14. References**

| **S.No.** | **Reference**                                                                                                         | **Details**                                                                                                                                                     |
|-----------|---------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1         | Volder, J. E., “The CORDIC Trigonometric Computing Technique,” IRE Transactions on Electronic Computers, vol. EC-8, no. 3, pp. 330–334, 1959.        | Original paper introducing the CORDIC algorithm.                                                                                                                |
| 2         | Andraka, R., “A Survey of CORDIC Algorithms for FPGA-Based Computers,” Proceedings of the 1998 ACM/SIGDA Sixth International Symposium on Field Programmable Gate Arrays, Monterey, CA, USA, pp. 191–200, 1998. | Survey on FPGA implementations of CORDIC algorithms.                                                                                                           |
| 3         | Parhami, B., *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed., Oxford University Press, 2010.                                              | Comprehensive book on computer arithmetic and hardware designs.                                                                                                |
| 4         | NPTEL, “Digital Signal Processing,” [Online]. Available: [NPTEL DSP Course](https://nptel.ac.in/courses/108/105/108105113/)                            | Online course material on digital signal processing.                                                                                                            |
| 5         | Smith, S. W., *The Scientist and Engineer's Guide to Digital Signal Processing*, California Technical Publishing, 1997.                                 | Guide on digital signal processing for scientists and engineers.                                                                                               |
| 6         | Baker, R. J., *CMOS: Circuit Design, Layout, and Simulation*, 3rd ed., Wiley-IEEE Press, 2010.                                                           | Book focusing on CMOS circuit design and simulation techniques.                                                                                                |
| 7         | Cadence Design Systems, “Innovus User Guide,” [Online]. Available: [Cadence Innovus](https://www.cadence.com)                                           | User guide for Innovus physical design tool.                                                                                                                   |
| 8         | IEEE Standard 1076-1993, *IEEE Standard VHDL Language Reference Manual*, IEEE, 1993.                                                                    | Standard documentation for VHDL language specifications.| 

