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

	//Parameter
	parameter CTRL_ADD 		= 4'b0010;
	parameter CTRL_SUB 		= 4'b0110;
	parameter CTRL_AND 		= 4'b0000;
	parameter CTRL_OR  		= 4'b0001;
	parameter CTRL_SLT 		= 4'b0111;
	//adv
	parameter CTRL_SHR		= 4'b1000;
	parameter CTRL_LUI		= 4'b1001;
	parameter CTRL_BNE		= 4'b1010;
	parameter CTRL_IDLE		= 4'b1111;


	parameter ALUOP_R 		= 2;
	parameter ALUOP_ADDI 	= 3;
	parameter ALUOP_SLTIU 	= 4;
	parameter ALUOP_BEQ 	= 5;
	//adv
	parameter ALUOP_LUI 	= 6;
	parameter ALUOP_ORI 	= 7;
	parameter ALUOP_BNE 	= 1;

	//Select exact operation
	always@(*)begin
		case( ALUOp_i )
			ALUOP_R:begin
				case( funct_i )
					// add rd,rs,rt
					32:ALUCtrl_o = CTRL_ADD;
					// sub rd,rs,rt
					34:ALUCtrl_o = CTRL_SUB;
					// and rd,rs,rt
					36:ALUCtrl_o = CTRL_AND;
					// or rd,rs,rt
					37:ALUCtrl_o = CTRL_OR;
					// slt rd,rs,rt
					42:ALUCtrl_o = CTRL_SLT;
					// sra rd,rt,shamt
					3:ALUCtrl_o = CTRL_SHR;
					// srav rd,rt,rs
					7:ALUCtrl_o = CTRL_SHR;
					// all zero
					default:ALUCtrl_o = CTRL_IDLE;
				endcase
			end
			//addi rt,rs,se100
			ALUOP_ADDI:ALUCtrl_o = CTRL_ADD;
			//sltiu rt,rs,ze10
			ALUOP_SLTIU:ALUCtrl_o = CTRL_SLT;
			//beq rs,rt,se25
			ALUOP_BEQ:ALUCtrl_o = CTRL_SUB;
			//lui rt,10
			ALUOP_LUI:ALUCtrl_o = CTRL_LUI;
			//ori rt,rs,ze100
			ALUOP_ORI:ALUCtrl_o = CTRL_OR;
			//bne rs,rt,se30
			ALUOP_BNE:ALUCtrl_o = CTRL_BNE;
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





                    
                    