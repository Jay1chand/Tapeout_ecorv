# ECO RV
A digital design fabrication right from FRONT END RTL to the tapeout

### Introduction:
It is a RISC-V CPU
This is a 32-bit 5-stage pipelined CPU that supports basic instructions and some vector arithmetic.
It supports Hazard detection too.
This model serves as a complete reference design and hands-on project for teaching pipelined CPU design and vector instruction extension principles.
Supported Instructions
•	Basic Instructions
o	and
o	or
o	add
o	sub
o	mul
o	addi
o	lw
o	sw
o	beq
•	Vector Arithmetic
o	VSUM (vector sum)
o	VSUB (vecotr subtraction)
o	VSM (vector scalar multiplication)
o	VDP (vector dot product)

### Technology:
All of the work is done on 180nm technology node provided by CDAC PDK SCLPDKV3 no files of the PDK are revealed to protect confidentiality.

### Application:
Provides a base for exploring custom RISC‑V extensions, instruction scheduling, hazard detection, and forwarding. 
With its vector arithmetic support, it’s suitable for lightweight data-parallel workloads—such as signal processing, simple ML computations, or control systems that benefit from vector ops.

### Frequency:  66.6 MHz
The standard operating frequency on which the package was simulated on is 66.6MHZ with a Time period of 15ns 

### Work flow: 
Worked using PDK files provided by CDAC. Used 4 metal layer combinations<br> 
Designed RTL source files in Verilog (version 2001) <br>
Tools used : xcelium, cadence genus, innovus, virtuoso, conformal LEC, Jasper gold, Sim vision, cadence calibre. <br>
Technology: SCLPDKV3 <br>

Performed RTL analysis, clock domain crossing checks, reset crossings in Jasper gold <br>

Performed simulation in Sim vision <br>

Made a uniformly distributed suitable IO PAD planning using the inputs and outputs. (Reference it from CPU.io) <br>

Performed synthesis in cadence genus using IO pads,  power pads, time constraints and RTL scripts. <br>

Performed Post synthesis Logic Equivalence checks on the generated synthesis netlist. <br>

Created a MMMC configuration file with suitable inputs, outputs and proper analysis views at both setup and hold. <br>

Performed Floor Planning by generating structure, adding filler cells on the generated netlist in cadence innovus <br>

Performed power planning by adding power rings, stripes in the appropriate layers M3, TOP M4. <br>

Performed Early routing and checks for timing analysis to eco optimize design for the setup and hold timing analysis <br>

Performed Clock tree synthesis in the design to create clock and propagate it through the registers in the design and again reperformed Early routing and checks for timing analysis to eco optimize design for the setup and hold timing analysis. <br>

Performed special nano route to complete the eventual routing to all IO pads, Power pads. And once again performed Early routing and checks for timing analysis to eco optimize design for the setup and hold timing analysis.<br>

Performed LEC post routing to completely check the equivalence in design, and performed a gate level simulation on generated netlist from the design. <br>

Completed the physical signoff on the design and generated 2 type of netlists and generated the initial GDS without bonding and packages. <br>

Completed the timing signoff by verifying the timing reports generated and RC extractions among those. <br>

Continued with Tape out by creating and importing standard cell libraries into cadence virtuoso. <br>

Inserted the design cell, seal ring and the silicon number provided by CDAC into the GXL layout completing the design. <br>

Performed a Calibre DRC and antenna checks pre dummy insertion on the design to check the proper alignment of seal ring and bond pads. <br>

Continued on to dummy insertion on the layout to finally complete the tape out, Then proceeded to re run DRC checks. <br>

Finally completed the DRC, Antenna and LVS checks to submit the design in the attached folder.

#### Reference:
The files are in C2S0144_06_08_2025.tar.gz folder for reference. The GDS file is too large to upload it in a regular file format. The gds is tapeout worthy as all the necessary DRC, Antenna, LVS and SPICE simulations are succesfully performed.

## Submissions:
Completed the workflow in both 4 metal layer node and 6 metal layer node <br>

As for tapeout concerns submission is done in 4 metal node for ease of manufacturing.
