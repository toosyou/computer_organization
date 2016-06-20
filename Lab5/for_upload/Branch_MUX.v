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

module Branch_MUX(
    input [1:0]branchType_i,
    input zero_i,
    input alu_sign_i,
    output reg branch_result_o
    );

    //Parameter of branch type
	parameter BRH_ZERO1			= 0;
	parameter BRH_ZERO0			= 1;
	parameter BRH_RESULT1_ZERO1	= 2;
	parameter BRH_RESULT1		= 3;

    always @ ( * ) begin
        case(branchType_i)
            BRH_ZERO1:begin
                branch_result_o = zero_i;
            end
            BRH_ZERO0:begin
                branch_result_o = !zero_i;
            end
            BRH_RESULT1_ZERO1:begin
                branch_result_o = alu_sign_i | zero_i ;
            end
            BRH_RESULT1:begin
                branch_result_o = alu_sign_i;
            end
        endcase
    end

endmodule
