//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] IF_pc_mux_out;
wire [31:0] IF_pc_out;
wire [31:0] IF_pc_add4;
wire [31:0] IF_instruction;

/**** ID stage ****/
wire [31:0] ID_pc;
wire [31:0] ID_instruction;
wire [31:0] ID_RS_data;
wire [31:0] ID_RT_data;
wire [31:0] ID_immediate;

//control signal
wire [ 4:0] ID_ctrl_EX;
wire [ 2:0] ID_ctrl_MEM;
wire [ 1:0] ID_ctrl_WB;

/**** EX stage ****/
wire [31:0] EX_pc;
wire [31:0] EX_RS_data;
wire [31:0] EX_RT_data;
wire [31:0] EX_immediate;
wire [ 4:0] EX_RT_reg;
wire [ 4:0] EX_RD_reg;

//control signal
wire [ 4:0] EX_ctrl_EX;
wire [ 2:0] EX_ctrl_MEM;
wire [ 1:0] EX_ctrl_WB;

/**** MEM stage ****/
wire 		MEM_PCSrc;
wire [31:0] MEM_ALU_result;

//control signal


/**** WB stage ****/
wire [ 4:0] WB_write_reg;
wire [31:0] WB_write_data;

//control signal
wire [ 1:0] WB_ctrl_WB;

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) PC_MUX(
	.data0_i(IF_pc_add4),
	.data1_i(MEM_ALU_result),
	.select_i(MEM_PCSrc),
	.data_o(IF_pc_mux_out)
	);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(IF_pc_mux_out),
	.pc_out_o(IF_pc_out)
	);

Instr_Memory IM(
	.addr_i(IF_pc_out),
	.instr_o(IF_instruction)
	);
			
Adder Add_pc(
	.src1_i(IF_pc_out),
	.src2_i(32'd4),
	.sum_o(IF_pc_add4)
	);

		
Pipe_Reg #(.size(32*2)) IF_ID(//top to down
	.clk_i(clk_i),
	.rst_i(rst_i),
	.data_i({IF_pc_add4, IF_instruction}),
	.data_o({ID_pc, ID_instruction})
	);
		
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
    .RSaddr_i(ID_instruction[25:21]),
    .RTaddr_i(ID_instruction[20:16]),
    .RDaddr_i(WB_write_reg),
    .RDdata_i(WB_write_data),
    .RegWrite_i(WB_ctrl_WB[1]),
    .RSdata_o(ID_RS_data),
    .RTdata_o(ID_RT_data)
	);

Decoder Control(
	instr_op_i(ID_instruction[31:26]),
	RegDst_o(ID_ctrl_EX[4]),
	ALU_op_o(ID_ctrl_EX[3:1]),
	ALUSrc_o(ID_ctrl_EX[0]),
	Branch_o(ID_ctrl_MEM[2]),
	MemRead_o(ID_ctrl_MEM[1]),
	MemWrite_o(ID_ctrl_MEM[0]),
	RegWrite_o(ID_ctrl_WB[1]),
	MemtoReg_o(ID_ctrl_WB[0])
	);

Sign_Extend Sign_Extend(
	data_i(ID_instruction[15:0]),
    data_o(ID_immediate)
	);	

Pipe_Reg #(.size(N)) ID_EX(
	clk_i(clk_i),
	rst_i(rst_i),
	data_i({ID_ctrl_WB, ID_ctrl_MEM, ID_ctrl_EX, 
		ID_pc, ID_RS_data, ID_RT_data, ID_immediate, ID_instruction[20:16], ID_instruction[15:11]}),
	data_o({EX_ctrl_WB, EX_ctrl_MEM, EX_ctrl_EX,
		EX_pc, EX_RS_data, EX_RT_data, EX_immediate, EX_RT_reg, EX_RD_reg})
	);
		
//Instantiate the components in EX stage	   
ALU ALU(

		);
		
ALU_Control ALU_Control(

		);

MUX_2to1 #(.size(32)) Mux1(

        );
		
MUX_2to1 #(.size(5)) Mux2(

        );

Pipe_Reg #(.size(N)) EX_MEM(

		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(

	    );

Pipe_Reg #(.size(N)) MEM_WB(
        
		);

//Instantiate the components in WB stage
MUX_3to1 #(.size(32)) Mux3(

        );

/****************************************
signal assignment
****************************************/	
endmodule

