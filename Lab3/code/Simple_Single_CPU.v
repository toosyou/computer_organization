//0316055_0316313
//Subject:     CO project 3 - Simple Single CPU
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

wire [ 3:0] aluCtrl;
wire [ 1:0] shamtCtrl;

wire [31:0] RSdata;
wire [31:0] RTdata;
wire [31:0] seConstant;
wire [31:0] zeConstant;
wire [31:0] shamt;
wire [31:0] aluSrc1;
wire [31:0] aluSrc2;
wire [31:0] aluSrc2_shift;
wire [31:0] aluResult;
wire        aluZero;

wire [31:0] pc_next;
wire [31:0] pc_shift;
wire [31:0] pc_branch;
wire [27:0] jump_address_tmp;
wire [31:0] jump_address;
wire [3:0] dontcare;

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
    .sum_o(pc_next)
    );

Shift_Left_Two_32 to_jump_address(
    .data_i({6'd0, instr[25:0]}),
    .data_o({dontcare, jump_address_tmp})
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
    .rst_i(rst_i),
    .RSaddr_i(instr[25:21]),
    .RTaddr_i(instr[20:16]),
    .RDaddr_i(writeReg),
    .RDdata_i(aluResult),
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
    .ALUCtrl_o(aluCtrl),
    .shamt_ctrl_o(shamtCtrl)
    );

Zero_Extend_32 #(.size(5)) Shamt(
    .data_i(instr[10:6]),
    .data_o(shamt)
    );

Sign_Extend SE(
    .data_i(instr[15:0]),
    .data_o(seConstant)
    );

Zero_Extend_32 #(.size(16)) ZE(
    .data_i(instr[15:0]),
    .data_o(zeConstant)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc1(
    .data0_i(RSdata),
    .data1_i(shamt),
    .select_i(shamtCtrl[0]),
    .data_o(aluSrc1)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc2(
    .data0_i(RTdata),
    .data1_i(seConstant),
    .select_i(aluSrc),
    .data_o(aluSrc2)
    );

MUX_2to1 #(.size(32)) Mux_ALUSrc2_shift(
    .data0_i(aluSrc2),
    .data1_i(zeConstant),
    .select_i(shamtCtrl[1]),
    .data_o(aluSrc2_shift)
    );

ALU ALU(
    .src1_i(aluSrc1),
    .src2_i(aluSrc2_shift),
    .ctrl_i(aluCtrl),
    .result_o(aluResult),
    .zero_o(aluZero)
    );

Adder Adder2(
    .src1_i(pc_next),
    .src2_i(pc_shift),
    .sum_o(pc_branch)
    );

Shift_Left_Two_32 Shifter(
    .data_i(seConstant),
    .data_o(pc_shift)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source(
    .data0_i(pc_next),
    .data1_i(pc_branch),
    .select_i(branch&aluZero),
    .data_o(pc_in)
    );

endmodule
