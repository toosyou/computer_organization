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
	Branch_o
	);

	//I/O ports
	input  [6-1:0] instr_op_i;

	output         RegWrite_o;
	output [3-1:0] ALU_op_o;
	output         ALUSrc_o;
	output         RegDst_o;
	output         Branch_o;
	 
	//Internal Signals
	reg    [3-1:0] ALU_op_o;
	reg            ALUSrc_o;
	reg            RegWrite_o;
	reg            RegDst_o;
	reg            Branch_o;

	//Parameter
	/*parameter INSTR_ADD 	= 0;
	parameter INSTR_SUB		= 0;
	parameter INSTR_AND		= 0;
	parameter INSTR_OR		= 0;
	parameter INSTR_SLT		= 0;*/

	parameter INSTR_ZERO 	= 0;
	parameter INSTR_ADDI 	= 8;
	parameter INSTR_SLTIU	= 9;
	parameter INSTR_BEQ		= 4;
	//adv
	parameter INSTR_LUI 	= 15;
	parameter INSTR_ORI		= 13;
	parameter INSTR_BNE		= 5;

	parameter ALUOP_R 		= 2;
	parameter ALUOP_ADDI 	= 3;
	parameter ALUOP_SLTIU 	= 4;
	parameter ALUOP_BEQ 	= 5;
	//adv
	parameter ALUOP_LUI 	= 6;
	parameter ALUOP_ORI 	= 7;
	parameter ALUOP_BNE 	= 1;

	//Main function
	always@(*)begin
		case( instr_op_i )
			case INSTR_ZERO:begin // r-type instr: add, sub, and, or, slt
				RegDst_o		= 1;
				ALUSrc_o		= 0;
				RegWrite_o		= 1;
				Branch_o		= 0;
				ALU_op_o		= ALUOP_R;
			end
			case INSTR_ADDI:begin
				RegDst_o		= 0;
				ALUSrc_o		= 1;
				RegWrite_o		= 1;
				Branch_o		= 0;
				ALU_op_o		= ALUOP_ADDI;
			end
			case INSTR_SLTIU:begin
				RegDst_o		= 0;
				ALUSrc_o		= 1;
				RegWrite_o		= 1;
				Branch_o		= 0;
				ALU_op_o		= ALUOP_SLTIU;
			end
			case INSTR_BEQ:begin
				RegDst_o		= 0; // don't care
				ALUSrc_o		= 0;
				RegWrite_o		= 0;
				Branch_o		= 1;
				ALU_op_o		= ALUOP_BEQ;
			end
			case INSTR_LUI:begin
				RegDst_o		= 0;
				ALUSrc_o		= 0;
				RegWrite_o		= 1;
				Branch_o		= 0;
				ALU_op_o		= ALUOP_LUI;
			end
			case INSTR_ORI:begin
				RegDst_o		= 0;
				ALUSrc_o		= 0;
				RegWrite_o		= 1;
				Branch_o		= 0;
				ALU_op_o		= ALUOP_ORI;
			end
			case INSTR_BNE:begin
				RegDst_o		= 0; // don't care
				ALUSrc_o		= 0;
				RegWrite_o		= 0;
				Branch_o		= 1;
				ALU_op_o		= ALUOP_BNE;
			end

		endcase
	end


endmodule





                    
                    