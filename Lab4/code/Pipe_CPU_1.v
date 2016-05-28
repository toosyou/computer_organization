//0316055_0316313
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
wire [31:0] ID_se_immediate;
wire [31:0] ID_ze_immediate;
wire [31:0] ID_shamt;
wire 		PCWrite;
wire 		IF_IDWrite;
wire 		IF_flush;
wire 		ID_flush;
wire 		EX_flush;


//control signal
wire [ 4:0] ID_ctrl_EX;
wire [ 2:0] ID_ctrl_MEM;
wire [ 1:0] ID_ctrl_WB;
wire [ 9:0] ID_ctrl_all;

/**** EX stage ****/
wire [31:0] EX_pc;
wire [31:0] EX_pc_label;
wire [31:0] EX_pc_branch;

wire [31:0] EX_RS_data;
wire [31:0] EX_RT_data;
wire [31:0] EX_se_immediate;
wire [31:0] EX_ze_immediate;
wire [31:0] EX_shamt;
wire [ 1:0] EX_src1_select;
wire [31:0] EX_src1_forward;
wire [31:0] EX_alu_src1;
wire [ 1:0] EX_src2_select;
wire [31:0] EX_src2_forward;
wire [31:0] EX_alu_src2_mux;
wire [31:0] EX_alu_src2;
wire [31:0] EX_alu_result;
wire 		EX_alu_zero;
wire [ 3:0] EX_alu_ctrl;
wire [ 1:0] EX_shamt_ctrl;

wire [ 4:0] EX_RS_addr;
wire [ 4:0] EX_RT_addr;
wire [ 4:0] EX_RD_addr;
wire [ 4:0] EX_write_addr;

//control signal
wire [ 4:0] EX_ctrl_EX;
wire [ 2:0] EX_ctrl_MEM;
wire [ 1:0] EX_ctrl_WB;
wire [ 4:0] EX_ctrl_all;

/**** MEM stage ****/
wire 		MEM_RegWrite;
wire 		MEM_branch;
wire [31:0] MEM_pc_branch;
wire 		MEM_alu_zero;
wire 		MEM_PCSrc;
wire [31:0] MEM_alu_result;
wire [31:0] MEM_RT_data;
wire 		MEM_MemWrite;
wire 		MEM_MemRead;
wire [31:0] MEM_read_data;
wire [ 4:0] MEM_write_addr;


//control signal
wire [ 1:0] MEM_ctrl_WB;


/**** WB stage ****/
wire [ 4:0] WB_write_addr;
wire [31:0] WB_write_data;
wire 		WB_RegWrite;
wire 		WB_MemtoReg;
wire [31:0] WB_mem_read_data;
wire [31:0] WB_alu_result;

//control signal
wire [ 1:0] WB_ctrl_WB;

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) PC_MUX(
	.data0_i(IF_pc_add4),
	.data1_i(MEM_pc_branch),
	.select_i(MEM_PCSrc),
	.data_o(IF_pc_mux_out)
	);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(IF_pc_mux_out),
	.PCWrite_i(PCWrite),
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
	.write_i(IF_IDWrite),
	.flush_i(IF_flush),
	.data_o({ID_pc, ID_instruction})
	);
		
//Instantiate the components in ID stage
Hazard_Detector HD(
	.ID_EX_MemRead_i(EX_ctrl_MEM[1]),
	.ID_EX_RTaddr_i(EX_RT_addr),
	.IF_ID_RSaddr_i(ID_instruction[25:21]),
	.IF_ID_RTaddr_i(ID_instruction[20:16]),
	.PCScr_i(MEM_PCSrc),
	.PCWrite_o(PCWrite),
	.IF_IDWrite_o(IF_IDWrite),
	.IF_flush_o(IF_flush),
	.ID_flush_o(ID_flush),
	.EX_flush_o(EX_flush)
	);

Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_i),
    .RSaddr_i(ID_instruction[25:21]),
    .RTaddr_i(ID_instruction[20:16]),
    .RDaddr_i(WB_write_addr),
    .RDdata_i(WB_write_data),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_RS_data),
    .RTdata_o(ID_RT_data)
	);

Decoder Control(
	.instr_op_i(ID_instruction[31:26]),
	.RegDst_o(ID_ctrl_EX[4]),
	.ALU_op_o(ID_ctrl_EX[3:1]),
	.ALUSrc_o(ID_ctrl_EX[0]),
	.Branch_o(ID_ctrl_MEM[2]),
	.MemRead_o(ID_ctrl_MEM[1]),
	.MemWrite_o(ID_ctrl_MEM[0]),
	.RegWrite_o(ID_ctrl_WB[1]),
	.MemtoReg_o(ID_ctrl_WB[0])
	);

MUX_2to1 #(.size(10)) MUX_ID_flush(
	.data0_i({ID_ctrl_WB, ID_ctrl_MEM, ID_ctrl_EX}),
	.data1_i(10'd0),
	.select_i(ID_flush),
	.data_o(ID_ctrl_all)
	);

Zero_Extend_32 #(.size(5)) Shamt_Extend(
    .data_i(ID_instruction[10:6]),
    .data_o(ID_shamt)
    );

Sign_Extend Sign_Extend(
	.data_i(ID_instruction[15:0]),
    .data_o(ID_se_immediate)
	);

Zero_Extend_32 #(.size(16)) Zero_Extend(
    .data_i(ID_instruction[15:0]),
    .data_o(ID_ze_immediate)
    );

Pipe_Reg #(.size(217)) ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.write_i(1'b1),
	.flush_i(1'b0),
	.data_i({ID_ctrl_all, 
		ID_pc, ID_RS_data, ID_RT_data, ID_shamt, ID_se_immediate, ID_ze_immediate,
		ID_instruction[25:21], ID_instruction[20:16], ID_instruction[15:11]}),
	.data_o({EX_ctrl_WB, EX_ctrl_MEM, EX_ctrl_EX,
		EX_pc, EX_RS_data, EX_RT_data, EX_shamt, EX_se_immediate, EX_ze_immediate,
		EX_RS_addr, EX_RT_addr, EX_RD_addr})
	);
		
//Instantiate the components in EX stage	   
Adder Add_pc_branch(
	.src1_i(EX_pc),
	.src2_i(EX_pc_label),
	.sum_o(EX_pc_branch)
	);

Shift_Left_Two_32 pc_branch(
    .data_i(EX_se_immediate),
    .data_o(EX_pc_label)
    );

Forwarding Forwarding_Unit(
    .EX_RS_addr_i(EX_RS_addr),
	.EX_RT_addr_i(EX_RT_addr),
	.MEM_write_addr_i(MEM_write_addr),
	.MEM_RegWrite_i(MEM_ctrl_WB[1]),
	.WB_write_addr_i(WB_write_addr),
	.WB_RegWrite_i(WB_ctrl_WB[1]),
	.RS_select_o(EX_src1_select),
	.RT_select_o(EX_src2_select)
	);
		
ALU_Ctrl ALU_Control(
	.funct_i(EX_se_immediate[5:0]),
    .ALUOp_i(EX_ctrl_EX[3:1]),
	.ALUCtrl_o(EX_alu_ctrl),
	.shamt_ctrl_o(EX_shamt_ctrl)
	);

MUX_3to1 #(.size(32)) ALU_src1_forward_Mux(
    .data0_i(EX_RS_data),
    .data1_i(MEM_alu_result),
    .data2_i(WB_write_data),
    .select_i(EX_src1_select),
    .data_o(EX_src1_forward)
    );

MUX_2to1 #(.size(32)) ALU_src1_Mux(
	.data0_i(EX_src1_forward),
    .data1_i(EX_shamt),
    .select_i(EX_shamt_ctrl[0]),
    .data_o(EX_alu_src1)
    );

MUX_3to1 #(.size(32)) ALU_src2_forward_Mux(
    .data0_i(EX_RT_data),
    .data1_i(MEM_alu_result),
    .data2_i(WB_write_data),
    .select_i(EX_src2_select),
    .data_o(EX_src2_forward)
    );

MUX_2to1 #(.size(32)) ALU_se_src2_Mux(
	.data0_i(EX_src2_forward),
    .data1_i(EX_se_immediate),
    .select_i(EX_ctrl_EX[0]),
    .data_o(EX_alu_src2_mux)
    );

MUX_2to1 #(.size(32)) ALU_ze_src2_Mux(
	.data0_i(EX_alu_src2_mux),
    .data1_i(EX_ze_immediate),
    .select_i(EX_shamt_ctrl[1]),
    .data_o(EX_alu_src2)
    );

ALU ALU(
	.src1_i(EX_alu_src1),
	.src2_i(EX_alu_src2),
	.ctrl_i(EX_alu_ctrl),
	.result_o(EX_alu_result),
	.zero_o(EX_alu_zero)
	);
		
MUX_2to1 #(.size(5)) Write_reg_Mux(
	.data0_i(EX_RT_addr),
    .data1_i(EX_RD_addr),
    .select_i(EX_ctrl_EX[4]),
    .data_o(EX_write_addr)
    );

MUX_2to1 #(.size(5)) MUX_EX_flush(
	.data0_i({EX_ctrl_WB, EX_ctrl_MEM}),
	.data1_i(5'd0),
	.select_i(EX_flush),
	.data_o(EX_ctrl_all)
	);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.write_i(1'b1),
	.flush_i(1'b0),
	.data_i({EX_ctrl_all,
		EX_pc_branch, EX_alu_zero, EX_alu_result, EX_src2_forward, EX_write_addr}),
	.data_o({MEM_ctrl_WB, MEM_branch, MEM_MemRead, MEM_MemWrite,
		MEM_pc_branch, MEM_alu_zero, MEM_alu_result, MEM_RT_data, MEM_write_addr})
	);
			   
//Instantiate the components in MEM stage
assign MEM_PCSrc = MEM_branch & MEM_alu_zero;

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(MEM_alu_result),
	.data_i(MEM_RT_data),
	.MemRead_i(MEM_MemRead),
	.MemWrite_i(MEM_MemWrite),
	.data_o(MEM_read_data)
	);

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .write_i(1'b1),
	.flush_i(1'b0),
    .data_i({MEM_ctrl_WB, MEM_read_data, MEM_alu_result, MEM_write_addr}),
    .data_o({WB_RegWrite, WB_MemtoReg, WB_mem_read_data, WB_alu_result, WB_write_addr})
	);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Write_data_Mux(
	.data0_i(WB_alu_result),
	.data1_i(WB_mem_read_data),
	.select_i(WB_MemtoReg),
	.data_o(WB_write_data)
    );

/****************************************
signal assignment
****************************************/	
endmodule

