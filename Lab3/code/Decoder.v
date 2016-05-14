//0316055_0316313
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	BranchType_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);

	//I/O ports
	input  [6-1:0] instr_op_i;

	output reg         RegWrite_o;
	output reg [3-1:0] ALU_op_o;
	output reg 		   ALUSrc_o;
	output reg         RegDst_o;
	output reg         Branch_o;
	output reg [2-1:0] BranchType_o;
	output reg		   Jump_o;
	output reg		   MemRead_o;
	output reg		   MemWrite_o;
	output reg		   MemtoReg_o;

	//Parameter of Instruction
	parameter INSTR_R 		= 0;
	parameter INSTR_ADDI 	= 8;
	parameter INSTR_SLTIU	= 9;
	parameter INSTR_BEQ		= 4;
	parameter INSTR_ORI		= 13;
	parameter INSTR_BNE		= 5;
	
	parameter INSTR_LOAD	= 35;
	parameter INSTR_STORE	= 43;
	parameter INSTR_JUMP	= 2;
	parameter INSTR_JAL		= 3;
	parameter INSTR_BLE		= 6;
	parameter INSTR_BLTZ	= 1;
	parameter INSTR_LI 		= 15;

	//Parameter of ALU Operation
	parameter ALUOP_R 		= 2;
	parameter ALUOP_ADDI 	= 3;
	parameter ALUOP_SLTIU 	= 4;
	parameter ALUOP_ORI 	= 7;
	parameter ALUOP_BRANCH 	= 1;
	parameter ALUOP_LI 		= 6;

	//Parameter of branch type
	parameter BRH_ZERO1			= 0;
	parameter BRH_ZERO0			= 1;
	parameter BRH_RESULT1_ZERO1	= 2;
	parameter BRH_RESULT1		= 3;	

	//Main function
	always@(*)begin
		case( instr_op_i )
			INSTR_R: begin // r-type instr: add, sub, and, or, slt
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_R;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 1;
			end
			INSTR_ADDI: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_ADDI;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			INSTR_SLTIU: begin
				Jump_o			<= 0;
				//ALUSrc_o		<= 1; //don't care (zero extended)
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_SLTIU;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			INSTR_BEQ: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= BRH_ZERO1;
				BranchType_o	<= 1;
				ALU_op_o		<= ALUOP_BRANCH;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end
			INSTR_ORI: begin
				Jump_o			<= 0;
				//ALUSrc_o		<= 1; // don't care (zero extended)
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_ORI;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			INSTR_BNE: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= BRH_ZERO0;
				BranchType_o	<= 0;
				ALU_op_o		<= ALUOP_BRANCH;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end
			INSTR_LOAD: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_ADDI;
				MemWrite_o		<= 0;
				MemRead_o		<= 1;
				MemtoReg_o		<= 1;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			INSTR_STORE: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_ADDI;
				MemWrite_o		<= 1;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end
			INSTR_JUMP: begin
				Jump_o			<= 1;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end/*
			INSTR_JAL: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_ADDI;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end*/
			INSTR_BLE: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= 1;
				BranchType_o	<= BRH_RESULT1_ZERO1;
				ALU_op_o		<= ALUOP_BRANCH;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end
			INSTR_BLTZ: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= 1;
				BranchType_o	<= BRH_RESULT1;
				ALU_op_o		<= ALUOP_BRANCH;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				RegWrite_o		<= 0;
			end
			INSTR_LI: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				ALU_op_o		<= ALUOP_LI;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			default: begin
				RegWrite_o <= 0;
			end
		endcase
	end

endmodule





                    
                    