set_units -time 1.0ns;
set_units -capacitance 1.0pF;
set CLOCK_PERIOD 15;
set CLOCK_NAME clk;
set SKEW_setup  [expr $CLOCK_PERIOD*0.025]; 
set SKEW_hold   [expr $CLOCK_PERIOD*0.025]; 
set MINRISE     [expr $CLOCK_PERIOD*0.125]; 
set MAXRISE     [expr $CLOCK_PERIOD*0.2]; 
set MINFALL     [expr $CLOCK_PERIOD*0.125]; 
set MAXFALL     [expr $CLOCK_PERIOD*0.2]; 
set MIN_PORT 1; 
set MAX_PORT 2.5; 
####### CLOCK CONSTRAINTS ######### 
create_clock -name "$CLOCK_NAME"   -period "$CLOCK_PERIOD"   -waveform "0 [expr $CLOCK_PERIOD/2]"  [get_ports "clk_i_pad"] 
create_clock -name vir_clk_i -period 10
set_clock_latency   -source   -max   0.85   -late    [get_clocks  clk] 
set_clock_latency   -source   -min   0.5   -late    [get_clocks  clk] 
set_clock_latency   -source   -max   0.75    -early   [get_clocks  clk] 
set_clock_latency   -source   -min   0.85   -early   [get_clocks  clk] 

# Write clock transition 
set_clock_transition   -rise   -min   $MINRISE   [get_clocks  clk] 
set_clock_transition   -rise   -max   $MAXRISE   [get_clocks  clk] 
set_clock_transition   -fall   -min   $MINRISE   [get_clocks  clk] 
set_clock_transition   -fall   -max   $MAXRISE   [get_clocks  clk] 

set_clock_uncertainty -setup $SKEW_setup  [get_clocks  clk] 
set_clock_uncertainty -hold  $SKEW_hold   [get_clocks  clk]
 
 
set_false_path  -from   [get_ports reset_pad]  -to  [all_registers] 
group_path -name   I2R   -from   [all_inputs]      -to   [all_registers] 
group_path -name   R2O   -from   [all_registers]   -to   [all_outputs] 
group_path -name   R2R   -from   [all_registers]   -to   [all_registers] 
group_path -name   I2O   -from   [all_inputs]      -to   [all_outputs] 
