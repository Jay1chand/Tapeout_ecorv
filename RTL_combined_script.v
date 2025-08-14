///IMPORTANT!!!!!!///
//top module is excluded and can be found at C2S0144.v and testbench is testbench.v
//Becareful to reference other modules if you are planning to use them seperately
`timescale 1ns/10ps
module VALU_ctrl(vfunct_i, VALUCtrl_o);

    input [9:0] vfunct_i; //{funct6, vm, funct3}
    //input [1:0] VALUOp_i;
    output reg [2:0] VALUCtrl_o;

    always @(*) begin
        case (vfunct_i)
            10'b000000_1_001: begin
                VALUCtrl_o = 3'b010; //vector addition
            end 
            10'b010000_1_000: begin
                VALUCtrl_o = 3'b110; //vector subtraction
            end
            10'b000000_1_111: begin
                VALUCtrl_o = 3'b000; //scalar multiplication
            end
            10'b000000_1_110: begin
                VALUCtrl_o = 3'b001; //dot product
            end
            default: begin
                VALUCtrl_o = 3'b000;
            end
        endcase
    end
endmodule

///////////////////////////////////////////////////
`timescale 1ns/10ps
module VALU (v1_i, v2_i, VALUCtrl_i, v_o,over);

    input signed[31:0] v1_i, v2_i; 
    input [2:0] VALUCtrl_i; //VALU instruction
    output reg [31:0] v_o; //output vector
    output reg [3:0]  over;//signed bit
    //output reg VZero_o; //branching signal

    reg signed[7:0] e1, e2, e3, e4;
    reg signed[7:0] b1,b2,b3,b4,b5,b6,b7,b8;
    wire [15:0]  a1,a2,a3,a4,a5,a6,a7,a8;
    reg signed[15:0]   s1,s2,s3,s4;
    //sign extension
    assign a1 = {{8{v1_i[7]}} ,v1_i[7:0]};
    assign a2 = {{8{v2_i[7]}} ,v2_i[7:0]};
    assign a3 = {{8{v1_i[15]}},v1_i[15:8]};
    assign a4 = {{8{v2_i[15]}},v2_i[15:8]};
    assign a5 = {{8{v1_i[23]}},v1_i[23:16]};
    assign a6 = {{8{v2_i[23]}},v2_i[23:16]};
    assign a7 = {{8{v1_i[31]}},v1_i[31:24]};
    assign a8 = {{8{v2_i[31]}},v2_i[31:24]};

    

    parameter VSUM  = 3'b010; //vector addition
    parameter VSUB  = 3'b110; //vector subtraction
    parameter VDP   = 3'b001; //dot product
    //parameter VSM   = 3'b000; //scalar multiplication
    //parameter VADDI = 3'b011; //vector addi
    //parameter VXP  = 3'b100; //cross product
    
    always @(*) begin
        
        //VZero_o = (v1_i - v2_i) ? 0 : 1;
        over[0] = 0;
        over[1] = 0;
        over[2] = 0;
        over[3] = 0;
        b1 = v1_i[7:0];
        b2 = v2_i[7:0];
        b3 = v1_i[15:8];
        b4 = v2_i[15:8];
        b5 = v1_i[23:16];
        b6 = v2_i[23:16];
        b7 = v1_i[31:24];
        b8 = v2_i[31:24];
        case (VALUCtrl_i)
            VSUM: begin
                
                e1 = b1 + b2;
                e2 = b3 + b4;
                e3 = b5 + b6;
                e4 = b7 + b8;
                v_o = {e4,e3,e2,e1};
                
                if( ~v1_i[7]  & ~v2_i[7] )over[0] = 1;
                else over[0] = 0;
                if( ~v1_i[15] & ~v2_i[15] )over[1] = 1;
                else over[1] = 0;
                if( ~v1_i[23] & ~v2_i[23] )over[2] = 1;
                else over[2] = 0;
                if( ~v1_i[31] & ~v2_i[31] )over[3] = 1;
                else over[3] = 0;
                
            end
            
            VSUB: begin

                e1 = b1 - b2;
                e2 = b3 - b4;
                e3 = b5 - b6;
                e4 = b7 - b8;
                v_o = {e4,e3,e2,e1};


                if( ~v1_i[7]  & (v2_i[7]) )over[0] = 1;
                else over[0] = 0;
                if( ~v1_i[15] & (v2_i[15]) )over[1] = 1;
                else over[1] = 0;
                if( ~v1_i[23] & (v2_i[23]) )over[2] = 1;
                else over[2] = 0;
                if( ~v1_i[31] & (v2_i[31]) )over[3] = 1;
                else over[3] = 0;

            end

            VDP: begin
                
                s1  = a1 * a2 ;
                s2  = a3 * a4 ;
                s3  = a5 * a6 ;
                s4  = a7 * a8 ;//16bits
             
                v_o = (s1+s2+s3+s4);

            end

            default: begin
                
                over[0] = 0;
                over[1] = 0;
                over[2] = 0;
                over[3] = 0;
                v_o = v1_i;
                
            end
            
        endcase
        
    end
    
endmodule
//////////////////////////////////////////////////
`timescale 1ns/10ps
module Sign_Extend(
    select_i,
    data0_i,
    data1_i,
    data_o     
);
input [11:0] data0_i,data1_i;
input select_i;
output[31:0] data_o;

assign data_o = (select_i)? {{20{data1_i[11]}},data1_i} : {{20{data0_i[11]}},data0_i} ; 

endmodule

/////////////////////////////////////////////////////

`timescale 1ns/10ps
module Shift1 (
  input [31:0] data_i,
  output [31:0] data_o
);

assign data_o = {data_i[30:0],1'b0};

endmodule

/////////////////////////////////////////////////

`timescale 1ns/10ps
module Registers
(
    clk_i,
    reset,
    op_address,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i, 
    RDdata_i,
    RegWrite_i,
    is_pos_i, 
    RSdata_o, 
    RTdata_o,
    reg_o,
    pos_o
);
integer i;
// Ports
input               clk_i;
input               reset;
input   [4:0]       op_address;
input   [4:0]       RSaddr_i;
input   [4:0]       RTaddr_i;
input   [4:0]       RDaddr_i;
input   [31:0]      RDdata_i;
input               RegWrite_i;
input   [3:0]       is_pos_i;
output  [31:0]      RSdata_o; 
output  [31:0]      RTdata_o;
output  [31:0]       reg_o;
output  [3:0]       pos_o;
// Register File
reg     [31:0]      register        [0:31];
reg     [3:0]       pos             [0:31];
// Read Data      
assign  RSdata_o = register[RSaddr_i];
assign  RTdata_o = register[RTaddr_i];
assign  reg_o    = register[op_address];
assign  pos_o    = pos[op_address];
// Write Data

always@(negedge clk_i or posedge reset)begin
    if(reset) begin
        for(i=0;i<32;i=i+1)register[i] <= 0;
        for(i=0;i<32;i=i+1)pos[i]      <= 0;
    end  

    else  begin
        if(RegWrite_i)begin
            register[RDaddr_i] <= RDdata_i;
            pos[RDaddr_i]      <= is_pos_i;
        end
    end      
end
   
endmodule 

/////////////////////////////////////////////////////

`timescale 1ns/10ps
module PC
(
    clk_i,
    start_i,
    pc_i,
    hazardpc_i,
    pc_o,
);

// Ports
input               clk_i;
input               start_i, hazardpc_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;
reg     flag,flag_next;

always@(*)begin
    if(pc_i == 32'd248)flag_next = 1;
    else flag_next = flag;
end

always@(posedge clk_i or negedge start_i) begin
    if(~start_i) begin
        pc_o <= 32'b0;
        flag <= 0;
    end
    else begin
        flag <= flag_next;
        if(start_i & (!hazardpc_i))
            pc_o <= (flag)? 32'd248 : pc_i ;
        else
            pc_o <= pc_o;
    end
end

endmodule

////////////////////////////////////////////////

`timescale 1ns/10ps
module MUX_Control(
    Hazard_i, 
    RegDst_i,  
    ALUOp_i, 
    ALUSrc_i,  
    RegWrite_i, 
    MemToReg_i, 
    MemRead_i,
    MemWrite_i,
    RegDst_o,  
    ALUOp_o, 
    ALUSrc_o,  
    RegWrite_o, 
    MemToReg_o, 
    MemRead_o,
    MemWrite_o,  
);

input	[1:0]	ALUOp_i;
input 	[4:0]	RegDst_i;
input	Hazard_i, ALUSrc_i, RegWrite_i, MemToReg_i, MemRead_i, MemWrite_i; 

output	reg [1:0]	ALUOp_o;
output 	reg [4:0]	RegDst_o;
output	reg ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o; 

always@(*)begin
    case(Hazard_i)
    1'b1 : begin
    RegDst_o <= 4'b0000;  
    ALUOp_o <= 2'b00;
    ALUSrc_o <= 1'b0; 
    RegWrite_o <= 1'b0;
    MemToReg_o <= 1'b0;
    MemRead_o <= 1'b0;
    MemWrite_o <= 1'b0;
    end

    1'b0 : begin
    RegDst_o <= RegDst_i;  
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i; 
    RegWrite_o <= RegWrite_i;
    MemToReg_o <= MemToReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    end

    default : begin
    RegDst_o <= RegDst_i;  
    ALUOp_o <= ALUOp_i;
    ALUSrc_o <= ALUSrc_i; 
    RegWrite_o <= RegWrite_i;
    MemToReg_o <= MemToReg_i;
    MemRead_o <= MemRead_i;
    MemWrite_o <= MemWrite_i;
    end

    endcase

end
endmodule

//////////////////////////////
`timescale 1ns/10ps
module MUX32(
    data1_i    ,
    data2_i    ,
    select_i   ,
    data_o     
);

input [31:0] data1_i,data2_i;
input select_i;
output[31:0] data_o;

assign data_o = (select_i)? data2_i : data1_i ;

endmodule
////////////////////////////////////
`timescale 1ns/10ps
module MEM_WB(
	clk_i,
	start_i,
	ALUResult_i,
	RDData_i,
	RDaddr_i,
	RegWrite_i,
	MemToReg_i,
	DataMemReadData_i,
	ALUResult_o,
	RDData_o,
	RDaddr_o,
	RegWrite_o,
	MemToReg_o,
	DataMemReadData_o
);

input	clk_i, RegWrite_i, MemToReg_i, start_i;
input	[31:0]	ALUResult_i, RDData_i, DataMemReadData_i;
input	[4:0]	RDaddr_i;

output	 RegWrite_o, MemToReg_o;
output	[31:0]	ALUResult_o, RDData_o, DataMemReadData_o;

reg	 RegWrite_o, MemToReg_o;
reg	[31:0]	ALUResult_o, RDData_o, DataMemReadData_o;
output reg	[4:0]	RDaddr_o;

always@(posedge clk_i or negedge start_i) begin
	if(~start_i) begin
		ALUResult_o <= 0;
		RDData_o <= 0;
		RDaddr_o <= 0;
		RegWrite_o <= 0;
		MemToReg_o <= 0;
		DataMemReadData_o<=0;
	end
	else begin
		ALUResult_o <= ALUResult_i;
		RDData_o <= RDData_i;
		RDaddr_o <= RDaddr_i;
		RegWrite_o <= RegWrite_i;
		MemToReg_o <= MemToReg_i;
		DataMemReadData_o <= DataMemReadData_i;
	end
end

endmodule

////////////////////////////////////////////


`timescale 1ns/10ps
module Instruction_Memory
(
    clk,
    reset,
    addr_i, 
    instr_i,
    instr_o
);
integer i;
// Interface
input               clk;
input               reset;
input   [31:0]      addr_i;
input   [7:0]       instr_i;
output  [31:0]      instr_o;

// Instruction memory
reg     [31:0]     memory  [0:63];
reg     [1:0]      quad,quad_d1;
reg     [7:0]      instr_read;
reg     [5:0]      address_read;
reg                flag,flag_next;
reg     [1:0]      counter,counter_next;
reg     [5:0]      instr_wr_address,instr_wr_address_next;

assign  instr_o = memory[addr_i>>2];  

always@(*)begin
    if(instr_i == 8'b1111_1110)flag_next = 1;
    else if (instr_i == 8'b1111_1111)flag_next = 0;
    else flag_next = flag;

    if(flag)counter_next = counter + 2'd1;
    else counter_next = counter;

    if(counter == 2'b11)instr_wr_address_next = instr_wr_address + 6'd1;
    else instr_wr_address_next = instr_wr_address;
end

always@(posedge clk or posedge reset)begin
    if(reset)begin
        for(i=0;i<63;i=i+1)begin
            memory[i] <= 0;
        end
        counter         <= 0;
        quad            <= 0;
        instr_read      <= 0;
        flag            <= 0;
        address_read    <= 0;
        instr_wr_address<=0;
    end
    else begin
        flag             <= flag_next;
        counter          <= counter_next;
        quad             <= (2'b11-counter);
        quad_d1          <= quad;
        instr_wr_address <= instr_wr_address_next;
        address_read     <= instr_wr_address;
        instr_read       <= instr_i;
        
        
        if(flag)begin
            case(quad)
            2'b00: memory[address_read][7:0]   <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b01: memory[address_read][15:8]  <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b10: memory[address_read][23:16] <= (instr_read == 8'b1111_1111)?0:instr_read;
            2'b11: memory[address_read][31:24] <= (instr_read == 8'b1111_1111)?0:instr_read;
            default: memory[address_read][7:0] <= (instr_read == 8'b1111_1111)?0:instr_read;
            endcase
        end
    end
end
endmodule

/////////////////////////////////////////////////////////

`timescale 1ns/10ps
module IF_ID(
	clk_i,
	start_i,
	pc_i,
	inst_i,
	hazard_i,
	flush_i,
	pcIm_i,
	pcIm_o,
	pc_o,
	inst_o,
);

input	clk_i, hazard_i, flush_i, start_i;
input	[31:0]	inst_i, pc_i;
input 	[11:0]	pcIm_i;
output 	[11:0]	pcIm_o;
output	[31:0]	pc_o, inst_o;

reg [31:0]	pc_o, inst_o;
reg [11:0] 	pcIm_o;

always@(posedge clk_i) begin
	if(~start_i) begin
		pc_o <= 32'b0;
		inst_o <= 32'b0;
		pcIm_o <= 12'b0;
	end
	else if(flush_i) begin
		pc_o <= pc_i;
		inst_o <= 32'b0;
		pcIm_o <= 12'b0;
	end
	else if(hazard_i) begin
		pc_o <= pc_i;
		inst_o <= inst_o;
		pcIm_o <= pcIm_i;
	end
	else begin
		pc_o <= pc_i;
		inst_o <= inst_i;
		pcIm_o <= pcIm_i;
	end
end

endmodule

/////////////////////////////////////////////////
`timescale 1ns/10ps
module ID_EX(
	clk_i,
	start_i,
	inst_i,
	pc_i,
	pcEx_i,
	RDData0_i,
	RDData1_i,
	SignExtended_i,
	RegDst_i,
	ALUOp_i,
	ALUSrc_i,
	RegWrite_i,
	MemToReg_i,
	MemRead_i,
	MemWrite_i,
	inst_o,
	PC_branch_select_i,
	RSaddr_i,     
    RTaddr_i,
	pc_o,
	pcEx_o,
	RDData0_o,
	RDData1_o,
	SignExtended_o,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	MemToReg_o,
	MemRead_o,
	MemWrite_o,
	PC_branch_select_o,
	RSaddr_o,
	RTaddr_o
);

input	clk_i, ALUSrc_i, RegWrite_i, MemToReg_i, MemRead_i, MemWrite_i, start_i; 
input	[31:0]	inst_i, pc_i, RDData0_i, RDData1_i, SignExtended_i;
input	[1:0]	ALUOp_i;
input 	[4:0]	RegDst_i,RSaddr_i,RTaddr_i;
input  [31:0] pcEx_i;
input PC_branch_select_i;
output	ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;  
output	[31:0]	inst_o, pc_o, RDData0_o, RDData1_o, SignExtended_o;
output	[1:0]	ALUOp_o;
output 	[4:0]	RegDst_o,RSaddr_o,RTaddr_o;
output  [31:0] pcEx_o;
output reg PC_branch_select_o;
reg	ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;  
reg	[31:0]	inst_o, pc_o, RDData0_o, RDData1_o, SignExtended_o,pcEx_o;
reg	[1:0]	ALUOp_o;
reg [4:0]	RegDst_o,RSaddr_o,RTaddr_o;

always@(posedge clk_i or negedge start_i) begin
	if(~start_i) begin
		inst_o <= 0;
		pc_o <= 0 ;
		RDData0_o <= 0;
		RDData1_o <= 0;
		SignExtended_o <= 0;
		RegDst_o <= 0;
		ALUOp_o <= 0;
		ALUSrc_o <= 0;
		RegWrite_o <= 0;
		MemToReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		pcEx_o <= 0;
		PC_branch_select_o <=0;
		RSaddr_o <= 0;
		RTaddr_o <= 0;
	end
	else begin
		inst_o <= inst_i;
		pc_o <= pc_i ;
		RDData0_o <= RDData0_i;
		RDData1_o <= RDData1_i;
		SignExtended_o <= SignExtended_i;
		RegDst_o <= RegDst_i;
		ALUOp_o <= ALUOp_i;
		ALUSrc_o <= ALUSrc_i;
		RegWrite_o <= RegWrite_i;
		MemToReg_o <= MemToReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		pcEx_o <= pcEx_i;
		PC_branch_select_o <= PC_branch_select_i;
		RSaddr_o <= RSaddr_i;
		RTaddr_o <= RTaddr_i;
	end
end

endmodule

/////////////////////////////////////////////////
`timescale 1ns/10ps
module HazradDetect(
    IF_IDrs1_i,
    IF_IDrs2_i,
    ID_EXrd_i,
    ID_EX_MemRead_i,
    Hazard_o,
);

input ID_EX_MemRead_i;
input [4:0] IF_IDrs1_i, IF_IDrs2_i, ID_EXrd_i;
output Hazard_o;

assign Hazard_o = ((ID_EX_MemRead_i && (ID_EXrd_i == IF_IDrs1_i || ID_EXrd_i == IF_IDrs2_i))? 1'b1 : 1'b0);

endmodule
////////////////////////////////////////////////

`timescale 1ns/10ps
module ForwardingUnit
(   
    EX_MEM_RegWrite_i,
    EX_MEM_RD_i,
    ID_EX_RS_i,
    ID_EX_RT_i,
    MEM_WB_RegWrite_i,
    MEM_WB_RD_i,
    ForwardA_o,
    ForwardB_o
);

input			    EX_MEM_RegWrite_i, MEM_WB_RegWrite_i;
input	    [4:0]	ID_EX_RS_i, ID_EX_RT_i, EX_MEM_RD_i, MEM_WB_RD_i;
output reg	[1:0]	ForwardA_o, ForwardB_o;

always@(*)begin
    ForwardA_o = 2'b00;

    if(EX_MEM_RegWrite_i && 
    (EX_MEM_RD_i != 5'b00000) && 
    (EX_MEM_RD_i == ID_EX_RS_i)) ForwardA_o = 2'b10;

    else if(MEM_WB_RegWrite_i &&
    (MEM_WB_RD_i != 5'b00000) &&
    MEM_WB_RD_i == ID_EX_RS_i)  ForwardA_o = 2'b01;

    ForwardB_o = 2'b00;

    if(EX_MEM_RegWrite_i && 
    (EX_MEM_RD_i != 5'b00000) && 
    (EX_MEM_RD_i == ID_EX_RT_i)) ForwardB_o = 2'b10;

    else if(MEM_WB_RegWrite_i &&
    (MEM_WB_RD_i != 5'b00000) &&
    MEM_WB_RD_i == ID_EX_RT_i)  ForwardB_o = 2'b01;

end
endmodule
///////////////////////////////////////////////////////////

`timescale 1ns/10ps
module ForwardingMUX(
    select_i,
    data_i,
    EX_MEM_i,
    MEM_WB_i,
    data_o
);

input	[1:0]		select_i;
input	[31:0]		data_i, EX_MEM_i, MEM_WB_i;
output reg[31:0]	data_o;


always @(*) begin
	case(select_i)
        2'b00: data_o = data_i;

        2'b01: data_o = MEM_WB_i;

		2'b10: data_o = EX_MEM_i;	

        default : data_o = data_i;
	endcase
end

endmodule
////////////////////////////////////////////////////////

`timescale 1ns/10ps
module EX_MEM(
	clk_i,
	start_i,
	pc_i,
	zero_i,
	ALUResult_i,
    VALUResult_i, //NEW
	RDData_i,
	RDaddr_i,
	RegWrite_i,
	MemToReg_i,
	MemRead_i,
	MemWrite_i,
	instr_i,
	instr_o,
	pc_o,
	zero_o,
	ALUResult_o,
    VALUResult_o, //NEW
	RDData_o,
	RDaddr_o,
	RegWrite_o,
	MemToReg_o,
	MemRead_o,
	MemWrite_o,
);

input	clk_i, zero_i, RegWrite_i, MemToReg_i, MemRead_i, MemWrite_i, start_i;
input	[31:0]	pc_i, ALUResult_i, RDData_i, VALUResult_i; //NEW
input	[4:0] RDaddr_i;
input 	[31:0] instr_i;
output reg [31:0] instr_o;
output	zero_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;
output	[31:0]	pc_o, ALUResult_o, RDData_o, VALUResult_o; //NEW
output reg[4:0] RDaddr_o;
reg	 zero_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;
reg	[31:0]	pc_o, ALUResult_o, RDData_o, VALUResult_o;//NEW

always@(posedge clk_i or negedge start_i) begin
	if(~start_i) begin
		pc_o <= 0;
		zero_o <= 0;
		ALUResult_o <= 0;
        VALUResult_o <= 0; //NEW
		RDData_o <= 0;
		RDaddr_o <= 0;
		RegWrite_o <= 0;
		MemToReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		instr_o	<= 0;
	end
	else begin
		pc_o <= pc_i;
		zero_o <= zero_i;
		ALUResult_o <= ALUResult_i;
        VALUResult_o <= VALUResult_i; //NEW
		RDData_o <= RDData_i;
		RDaddr_o <= RDaddr_i;
		RegWrite_o <= RegWrite_i;
		MemToReg_o <= MemToReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		instr_o    <= instr_i;
	end
end

endmodule
///////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module Data_Memory
(   
    clk_i,
    reset,
    op_addr,
    addr_i,
    data_i,
    MemWrite_i,
    MemRead_i,
    data_o,
    data_mem_o
);


input clk_i;
input reset;
input [4:0] op_addr;
input [31:0] addr_i,data_i;
input MemWrite_i, MemRead_i;
integer i;
output [31:0] data_o;
output [31:0] data_mem_o;

reg [7:0] memory [0:31];
wire [31:0] op;

assign op = { memory[addr_i + 3],memory[addr_i + 2],
memory[addr_i + 1],memory[addr_i]};

assign data_mem_o = { memory[op_addr + 3],memory[op_addr + 2],
memory[op_addr + 1],memory[op_addr]};

assign data_o = (MemRead_i) ? op : 32'b0;

always @(posedge clk_i or posedge reset) begin

    if(reset)for(i=0;i<32;i=i+1)memory[i] <= 0;
     else if(MemWrite_i) begin
            memory[addr_i + 3] <= data_i[31:24];
            memory[addr_i + 2] <= data_i[23:16];
            memory[addr_i + 1] <= data_i[15:8];
            memory[addr_i]     <= data_i[7:0];
        end
end

endmodule

////////////////////////////////////////////////
`timescale 1ns/10ps
module Control(
    Op_i       ,
    ALUOp_o    ,
    ALUSrc_o   ,
    RegWrite_o ,
    MemRd_o,
    MemWr_o,
    MemToReg_o,
    immSelect_o
);

//ports

input [6:0]     Op_i;
output reg[1:0]     ALUOp_o;
output  reg      ALUSrc_o,immSelect_o;
output  reg    RegWrite_o ,MemRd_o,MemWr_o,MemToReg_o;




always@(*)begin

  case(Op_i)

  7'b0010011 : begin //addi
  ALUOp_o = 2'b11;
  ALUSrc_o = 1'b1;
  RegWrite_o = 1'b1;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b0;
  end
  
  7'b0110011 : begin //others
  ALUOp_o = 2'b10;
  ALUSrc_o = 1'b0;
  RegWrite_o = 1'b1;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b0;
  end

  7'b1100011 : begin //beq
  ALUOp_o = 2'b01;
  ALUSrc_o = 1'b1;
  RegWrite_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b0;
  end

  7'b0000011 : begin //lw
  ALUOp_o = 2'b00;
  ALUSrc_o = 1'b1;
  MemRd_o = 1'b1;
  MemToReg_o = 1'b1;
  RegWrite_o = 1'b1;
  MemWr_o = 1'b0;
  immSelect_o = 1'b0;
  end

  7'b0100011 : begin //sw
  ALUOp_o = 2'b00;
  ALUSrc_o = 1'b1;
  MemWr_o = 1'b1;
  RegWrite_o = 1'b0;
  MemRd_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b1;
  end

  //---------NEW-----------
  7'b1010111: begin //vector
  ALUOp_o = 2'b00; //useless
  ALUSrc_o = 1'b0;
  RegWrite_o = 1'b1;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b0;
  end
  //---------NEW-----------

  default : begin
  ALUOp_o = 2'b11;
  ALUSrc_o = 1'b1;
  RegWrite_o = 1'b0;
  MemRd_o = 1'b0;
  MemWr_o = 1'b0;
  MemToReg_o = 1'b0;
  immSelect_o = 1'b0;
  end
  endcase
end
endmodule
////////////////////////////////////////////
`timescale 1ns/10ps
module ALU_Control(
    funct_i    ,
    ALUOp_i    ,
    ALUCtrl_o 
);

input [9:0] funct_i;//funct7[9:3]+funct3[2:0]
input [1:0] ALUOp_i;//00 for addi
output reg[2:0] ALUCtrl_o;

always@(*)begin

  case(ALUOp_i)

    2'b11 : begin
        ALUCtrl_o = 3'b001;//add
    end

    2'b10 : begin
        case(funct_i)

            10'b0000000000 : begin
                ALUCtrl_o = 3'b001;//add
            end
            10'b0100000000 : begin
                ALUCtrl_o = 3'b010;//sub
            end
            10'b0000001000 : begin
                ALUCtrl_o = 3'b110;//MUL
            end
            10'b0000000110 : begin
                ALUCtrl_o = 3'b100;//OR
            end
            10'b0000000111 : begin
                ALUCtrl_o = 3'b011;//AND
            end
            default : begin
                ALUCtrl_o = 3'b001;
            end
        endcase
    end

    2'b01 : begin //beq,ALU do subtraction
    ALUCtrl_o = 3'b010;//sub
    end
    default : begin
        ALUCtrl_o = 3'b001;
    end
endcase

end

endmodule
//not sure how to deal w/ ALUOp to o/p the corresponing code,
//stop by here
////////////////////////////////////////////////////////////

`timescale 1ns/10ps
module ALU (data1_i, data2_i, ALUCtrl_i, data_o,Zero_o);

input [31:0] data1_i, data2_i;
input [2:0] ALUCtrl_i;
output reg[31:0] data_o;
output reg Zero_o;

parameter SUM = 3'b001;
parameter SUB = 3'b010;
parameter AND = 3'b011;
parameter OR  = 3'b100;
parameter XOR = 3'b101;
parameter MUL = 3'b110;


/* implement here */
always@(*)begin
Zero_o   = (data1_i - data2_i)?0:1;
case(ALUCtrl_i)

  SUM : begin
    data_o = data1_i + data2_i;
  end
  SUB : begin
    data_o = data1_i - data2_i;
  end
  AND : begin
    data_o = data1_i & data2_i;
  end
  OR : begin
    data_o = data1_i | data2_i;
  end
  XOR : begin
    data_o = data1_i ^ data2_i;
  end
  MUL : begin
    data_o = data1_i * data2_i;
  end
  default : begin
    data_o = data1_i;
  end

endcase

end

endmodule
///////////////////////////////////////////////
`timescale 1ns/10ps
module Adder
(
    data1_in,
    data2_in,
    data_o
);

input [31:0] data1_in,data2_in;
output [31:0] data_o;

assign data_o = data1_in + data2_in ;

endmodule









