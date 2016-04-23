//0316055_0316313
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
    clk_i,
    rst_i
	);
		
//I/O port
input   clk_i;
input   rst_i;

//Internal Signles
wire [31:0] pc_in;
wire [31:0] pc_out;
wire [31:0] instr;

wire [ 4:0] writeReg;
wire        regWrite;
wire [ 2:0] aluOp;
wire        aluSrc;
wire        regDst;
wire        branch;

wire        aluCtrl;

wire [31:0] RSdata;
wire [31:0] RTdata;
wire [31:0] constant;
wire [31:0] aluSrc2;
wire [31:0] aluResult;
wire        aluZero;

//Greate componentes
ProgramCounter PC(
    .clk_i(clk_i),      
	.rst_i (rst_i),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
	);
	
Adder Adder1(
    .src1_i(32'd4),     
	.src2_i(pc_out),     
	.sum_o()    
	);
	
Instr_Memory IM(
    .pc_addr_i(pc_out),  
	.instr_o(instr)    
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instr[20:16]),
    .data1_i(instr[15:11]),
    .select_i(regDst),
    .data_o(writeReg)
    );	
		
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i) ,     
    .RSaddr_i(instr[25:21]),  
    .RTaddr_i(instr[20:16]),  
    .RDaddr_i(writeReg),  
    .RDdata_i(result), 
    .RegWrite_i(regWrite),
    .RSdata_o(RSdata),  
    .RTdata_o(RTdata)   
    );
	
Decoder Decoder(
    .instr_op_i(instr[31:26]), 
	.RegWrite_o(regWrite), 
	.ALU_op_o(aluOp),   
	.ALUSrc_o(aluSrc),   
	.RegDst_o(regDst),   
	.Branch_o(branch)   
	);

ALU_Ctrl AC(
    .funct_i(instr[5:0]),   
    .ALUOp_i(aluOp),   
    .ALUCtrl_o(aluCtrl) 
    );
	
Sign_Extend SE(
    .data_i(instr[15:0]),
    .data_o(constant)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(RTdata),
    .data1_i(constant),
    .select_i(aluSrc),
    .data_o(aluSrc2)
    );	
		
ALU ALU(
    .src1_i(RSdata),
	.src2_i(aluSrc2),
	.ctrl_i(aluCtrl),
	.result_o(aluResult),
	.zero_o(aluZero)
	);
		
Adder Adder2(
    .src1_i(),     
	.src2_i(),     
	.sum_o()      
	);
		
Shift_Left_Two_32 Shifter(
    .data_i(),
    .data_o()
    ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(),
    .data1_i(),
    .select_i(branch&aluZero),
    .data_o()
    );	

endmodule
		  


