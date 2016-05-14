//0316055_0316313
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
    funct_i,
    ALUOp_i,
	ALUCtrl_o,
	shamt_ctrl_o
    );
          
	//I/O ports 
	input	[6-1:0] funct_i;
	input   [3-1:0] ALUOp_i;

	output  [4-1:0] ALUCtrl_o;
	output reg[1:0] shamt_ctrl_o;
	     
	//Internal Signals
	reg     [4-1:0] ALUCtrl_o;

	//Parameter of ALU Operation
	parameter ALUOP_R 		= 2;
	parameter ALUOP_ADDI 	= 3;
	parameter ALUOP_SLTIU 	= 4;
	parameter ALUOP_ORI 	= 7;

	parameter ALUOP_BRANCH 	= 1;
	parameter ALUOP_LI 		= 6;

	//Parameter of ALU Control
	parameter CTRL_ADD 		= 4'b0010;
	parameter CTRL_SUB 		= 4'b0110;
	parameter CTRL_AND 		= 4'b0000;
	parameter CTRL_OR  		= 4'b0001;
	parameter CTRL_SLT 		= 4'b0111;
	parameter CTRL_SHR		= 4'b1000;
	parameter CTRL_IDLE		= 4'b1111;
	
	parameter CTRL_MUL		= 4'b0100;
	parameter CTRL_LI		= 4'b1001;

	//Select exact operation
	always@(*)begin
		case( ALUOp_i )
			ALUOP_R:begin
				case( funct_i )
					// add rd, rs, rt
					32: ALUCtrl_o = CTRL_ADD;
					// sub rd, rs, rt
					34: ALUCtrl_o = CTRL_SUB;
					// and rd, rs, rt
					36: ALUCtrl_o = CTRL_AND;
					// or rd, rs, rt
					37: ALUCtrl_o = CTRL_OR;
					// slt rd, rs, rt
					42: ALUCtrl_o = CTRL_SLT;
					// sra rd, rt, shamt
					3:  ALUCtrl_o = CTRL_SHR;
					// srav rd, rt, rs
					7:  ALUCtrl_o = CTRL_SHR;
					// mul rd, rt, rs
					24: ALUCtrl_o = CTRL_MUL;
					// all zero
					default:ALUCtrl_o = CTRL_IDLE;
				endcase
			end
			//addi rt, rs, se100
			ALUOP_ADDI: ALUCtrl_o = CTRL_ADD;
			//sltiu rt, rs, ze10
			ALUOP_SLTIU: ALUCtrl_o = CTRL_SLT;
			//ori rt, rs, ze100
			ALUOP_ORI: ALUCtrl_o = CTRL_OR;
			//bne rs, rt, se30
			ALUOP_BRANCH: ALUCtrl_o = CTRL_SUB;
			//li rt, 10
			ALUOP_LI: ALUCtrl_o = CTRL_LI;
		endcase
	end

	//use shamt as input
	always@(*)begin
		if( ALUOp_i == ALUOP_R && funct_i == 3 )
			shamt_ctrl_o = 2'b01; // shamt
		else if( ALUOp_i == ALUOP_ORI || ALUOp_i == ALUOP_SLTIU )
			shamt_ctrl_o = 2'b10; // zero-extended immediate
		else
			shamt_ctrl_o = 2'b00;
	end

endmodule     





                    
                    