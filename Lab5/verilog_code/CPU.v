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
module CPU(
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

//decoder
wire [ 1:0] regDst;
wire        branch;
wire [ 1:0] memToReg;
wire [ 1:0] branchType;
wire        jump;
wire        memRead;
wire        memWrite;
wire [ 2:0] aluOp;
wire        aluSrc;
wire        regWrite;

wire [ 3:0] aluCtrl;
wire [ 1:0] shamtCtrl;
wire        jr_ctrl;

wire [31:0] RSdata;
wire [31:0] RTdata;
wire [31:0] seConstant;
wire [31:0] zeConstant;
wire [31:0] shamt;

//alu
wire [31:0] aluSrc1;
wire [31:0] aluSrc2;
wire [31:0] aluSrc2_shift;
wire [31:0] aluResult;
wire        aluZero;

wire [31:0] pc_next;
wire [31:0] pc_shift;
wire [31:0] pc_branch;
wire [31:0] pc_mux1;
wire [31:0] pc_mux2;
wire [27:0] jump_address_tmp;
wire [31:0] jump_address;
wire        branch_MUX_result;
wire [3:0] dontcare; // dont care

//data memory
wire [31:0] readDataDM;
wire [31:0] writeData;

assign jump_address = { pc_out[31:28], jump_address_tmp };

//Greate componentes

//pc & jump part
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
    .select_i(branch & branch_MUX_result),
    .data_o(pc_mux1)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source_Jump(
    .data0_i(pc_mux1),
    .data1_i(jump_address),
    .select_i(jump),
    .data_o(pc_mux2)
    );

MUX_2to1 #(.size(32)) Mux_PC_Source_Rs(
    .data0_i(pc_mux2),
    .data1_i(RSdata),
    .select_i(jr_ctrl),
    .data_o(pc_in)
    );

Branch_MUX Question_Mark(
    .branchType_i(branchType),
    .zero_i(aluZero),
    .alu_sign_i(aluResult[31]),
    .branch_result_o(branch_MUX_result)
    );

//calculating part

Instr_Memory IM(
    .addr_i(pc_out),
    .instr_o(instr)
    );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
    .data0_i(instr[20:16]),
    .data1_i(instr[15:11]),
    .data2_i(5'd31),
    .select_i(regDst),
    .data_o(writeReg)
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(instr[25:21]),
    .RTaddr_i(instr[20:16]),
    .RDaddr_i(writeReg),
    .RDdata_i(writeData),
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
    .Branch_o(branch),
    .BranchType_o(branchType),
    .Jump_o(jump),
    .MemRead_o(memRead),
    .MemWrite_o(memWrite),
    .MemtoReg_o(memToReg)
    );

ALU_Ctrl AC(
    .funct_i(instr[5:0]),
    .ALUOp_i(aluOp),
    .ALUCtrl_o(aluCtrl),
    .shamt_ctrl_o(shamtCtrl),
    .jr_ctrl_o(jr_ctrl)
    );

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(aluResult),
    .data_i(RTdata),
    .MemRead_i(memRead),
    .MemWrite_i(memWrite),
    .data_o(readDataDM)
    );

MUX_4to1 #(.size(32)) Mux_Write_Data(
    .data0_i(aluResult),
    .data1_i(readDataDM),
    .data2_i(seConstant),
    .data3_i(pc_next),
    .select_i(memToReg),
    .data_o(writeData)
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

endmodule
