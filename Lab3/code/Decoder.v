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
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);

	//I/O ports
	input  [6-1:0] instr_op_i;

	output         RegWrite_o;
	output [3-1:0] ALU_op_o;
	output         ALUSrc_o;
	output         RegDst_o;
	output         Branch_o;
	output		   BranchType_o;
	output		   Jump_o;
	output		   MemRead_o;
	output		   MemWrite_o;
	output		   MemtoReg_o;
	 
	//Internal Signals
	reg    [3-1:0] ALU_op_o;
	reg            ALUSrc_o;
	reg            RegWrite_o;
	reg            RegDst_o;
	reg            Branch_o;

	//Parameter of Instruction
	parameter INSTR_R 		= 0;
	parameter INSTR_ADDI 	= 8;
	parameter INSTR_SLTIU	= 9;
	parameter INSTR_BEQ		= 4;
	parameter INSTR_LUI 	= 15;
	parameter INSTR_ORI		= 13;
	parameter INSTR_BNE		= 5;
	parameter INSTR_LOAD	= 35;
	parameter INSTR_STORE	= 43;
	parameter INSTR_JUMP	= 2;

	//Parameter of ALU Operation
	parameter ALUOP_R 		= 2;
	parameter ALUOP_ADDI 	= 3;
	parameter ALUOP_SLTIU 	= 4;
	parameter ALUOP_BEQ 	= 5;
	parameter ALUOP_LUI 	= 6;
	parameter ALUOP_ORI 	= 7;
	parameter ALUOP_BNE 	= 1;

	//Main function
	always@(*)begin
		case( instr_op_i )
			INSTR_R: begin // r-type instr: add, sub, and, or, slt
				Jump_o			<= 0;
				ALUSrc_o		<= 0;
				Branch_o		<= 0;
				//BranchType_o	<= 1; //don't care
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
				//BranchType_o	<= 1; //don't care
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
				//BranchType_o	<= 1; //don't care
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
				Branch_o		<= 1;
				BranchType_o	<= 1;
				ALU_op_o		<= ALUOP_BEQ;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				//MemtoReg_o	<= 0; //don't care
				RegWrite_o		<= 0;
				//RegDst_o		<= 0; // don't care
			end
			INSTR_LUI: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				//BranchType_o	<= 1; //don't care
				ALU_op_o		<= ALUOP_LUI;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				MemtoReg_o		<= 0;
				RegWrite_o		<= 1;
				RegDst_o		<= 0;
			end
			INSTR_ORI: begin
				Jump_o			<= 0;
				//ALUSrc_o		<= 1; // don't care (zero extended)
				Branch_o		<= 0;
				//BranchType_o	<= 1; //don't care
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
				Branch_o		<= 1;
				BranchType_o	<= 0;
				ALU_op_o		<= ALUOP_BNE;
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				//MemtoReg_o	<= 0; //don't care
				RegWrite_o		<= 0;
				//RegDst_o		<= 0; // don't care
			end
			INSTR_LOAD: begin
				Jump_o			<= 0;
				ALUSrc_o		<= 1;
				Branch_o		<= 0;
				//BranchType_o	<= 1; //don't care
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
				//BranchType_o	<= 1; //don't care
				ALU_op_o		<= ALUOP_ADDI;
				MemWrite_o		<= 1;
				MemRead_o		<= 0;
				//MemtoReg_o	<= 1; //don't care
				RegWrite_o		<= 0;
				//RegDst_o		<= 0; //don't care
			end
			INSTR_JUMP: begin
				Jump_o			<= 1;
				//ALUSrc_o		<= 1; //don't care
				//Branch_o		<= 0; //don't care
				//BranchType_o	<= 1; //don't care
				//ALU_op_o		<= ALUOP_ADDI; //don't care
				MemWrite_o		<= 0;
				MemRead_o		<= 0;
				//MemtoReg_o	<= 1; //don't care
				RegWrite_o		<= 0;
				//RegDst_o		<= 0; //don't care
			end
			default: begin
				RegWrite_o <= 0;
			end
		endcase
	end

endmodule





                    
                    