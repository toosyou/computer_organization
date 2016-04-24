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
			case ALUOP_R:begin
				case( funct_i )
					// add r1,r2,r3
					case 32:ALUCtrl_o = CTRL_ADD;
					// sub r1,r2,r3
					case 34:ALUCtrl_o = CTRL_SUB;
					// and r1,r2,r3
					case 36:ALUCtrl_o = CTRL_AND;
					// or r1,r2,r3
					case 37:ALUCtrl_o = CTRL_OR;
					// slt r1,r2,r3
					case 42:ALUCtrl_o = CTRL_SLT;
					// sra r1,r2,shmat
					case 3:ALUCtrl_o = CTRL_SHR;
					// srav r1,r2,r3
					case 7:ALUCtrl_o = CTRL_SHR;
				endcase
			end
			//addi r1,r2,100
			case ALUOP_ADDI:ALUCtrl_o = CTRL_ADD;
			//sltiu r1,r2,10
			case ALUOP_SLTIU:ALUCtrl_o = CTRL_SLT;
			//beq r1,r2,25
			case ALUOP_BEQ:ALUCtrl_o = CTRL_SUB;
			//lui r1,10
			case ALUOP_LUI:ALUCtrl_o = CTRL_LUI;
			//ori r1,r2,100
			case ALUOP_ORI:ALUCtrl_o = CTRL_OR;
			//bne r1,r2,30
			case ALUOP_BNE:ALUCtrl_o = CTRL_BNE;
		endcase
	end

	//use shamt as input
	always@(*)begin
		if( ALUOp_i == ALUOP_R && funct_i == 3 )
			shamt_ctrl_o = 2; // shamt
		else if( ALUOp_i = ALUOP_ORI && funct_i == 0 )
			shamt_ctrl_o = 1; // zero-extended immediate
		else
			shamt_ctrl_o = 0;
	end

endmodule     





                    
                    