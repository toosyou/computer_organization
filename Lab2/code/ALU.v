module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);

	//I/O ports
	input  signed [32-1:0]	src1_i;
	input  signed [32-1:0]	src2_i;
	input  [4-1:0]  ctrl_i;

	output signed [32-1:0] result_o;
	output          zero_o;

	//Internal signals
	reg    [32-1:0] result_o;
	wire            zero_o;

	//Parameter
	localparam [3:0] OP_AND=4'b0000, OP_OR=4'b0001, OP_ADD=4'b0010, OP_SUB=4'b0110, OP_SLT=4'b0111;
	localparam [3:0] OP_SHR=4'b1000, OP_LUI=4'b1001, OP_BNE=4'b1010;
	
	//Main function
	assign zero_o = (result_o==0);	//zero is true if result_o is 0

	always @(ctrl_i, src1_i, src2_i) begin	//reevaluate if these changes
		case (ctrl_i) 
			OP_AND:	result_o <= src1_i & src2_i;
			OP_OR:	result_o <= src1_i | src2_i;
			OP_ADD:	result_o <= src1_i + src2_i;
			OP_SUB:	result_o <= src1_i - src2_i;
			OP_SLT:	result_o <= (src1_i<src2_i)? 1: 0;
			OP_SHR:	result_o <= src2_i >>> src1_i;
			OP_LUI:	result_o <= src2_i << 16;
			OP_BNE:	result_o <= (src1_i == src2_i);
			default:result_o <= 0;
		endcase
	end

endmodule
