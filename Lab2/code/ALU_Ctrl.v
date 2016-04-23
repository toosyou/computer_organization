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
    ALUCtrl_o
    );
          
	//I/O ports 
	input	[6-1:0] funct_i;
	input   [3-1:0] ALUOp_i;

	output  [4-1:0] ALUCtrl_o;    
	     
	//Internal Signals
	reg     [4-1:0] ALUCtrl_o;

	//Parameter
	parameter CTRL_ADD = 4'b0010;
	parameter CTRL_SUB = 4'b0110;
	parameter CTRL_AND = 4'b0000;
	parameter CTRL_OR  = 4'b0001;
	parameter CTRL_SLT = 4'b0111;
	       
	//Select exact operation
	always@(*)begin
		case( ALUOp_i )
			case 0:begin
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
				endcase
			end
			//addi r1,r2,100
			case 8:ALUCtrl_o = CTRL_ADD;
			//sltiu r1,r2,10
			case 9:ALUCtrl_o = CTRL_SLT;
			//beq r1,r2,25
			case 4:ALUCtrl_o = CTRL_SUB;
		endcase
	end

endmodule     





                    
                    