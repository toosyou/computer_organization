//0316055_0316313
module Forwarding(
    EX_RS_addr_i,
	EX_RT_addr_i,
	MEM_write_addr_i,
	MEM_RegWrite_i,
	WB_write_addr_i,
	WB_RegWrite_i,
	RS_select_o,
	RT_select_o
	);

	//I/O ports
	input [4:0] EX_RS_addr_i;
	input [4:0] EX_RT_addr_i;
	input [4:0] MEM_write_addr_i;
	input		MEM_RegWrite_i;
	input [4:0] WB_write_addr_i;
	input		WB_RegWrite_i;

	output reg [1:0] RS_select_o;
	output reg [1:0] RT_select_o;

	//Internal signals
	reg    [32-1:0] result_o;
	wire            zero_o;

	
	//Main function
	always @(*) begin
		if( MEM_RegWrite_i && MEM_write_addr_i!=0 && MEM_write_addr_i == EX_RS_addr_i)
			RS_select_o <= 2'd1;
		else if( WB_RegWrite_i && WB_write_addr_i!=0 && WB_write_addr_i == EX_RS_addr_i)
			RS_select_o <= 2'd2;
		else
			RS_select_o <= 2'd0;
	end

	always @(*) begin
		if( MEM_RegWrite_i && MEM_write_addr_i!=0 && MEM_write_addr_i == EX_RT_addr_i)
			RT_select_o <= 2'd1;
		else if( WB_RegWrite_i && WB_write_addr_i!=0 && WB_write_addr_i == EX_RT_addr_i)
			RT_select_o <= 2'd2;
		else
			RT_select_o <= 2'd0;
	end

	/*always @(*) begin
		if (MEM_RegWrite_i && MEM_write_addr_i!=0) begin
			if (MEM_write_addr_i == EX_RS_addr_i) RS_select_o <= 2'd1;
			else if (MEM_write_addr_i == EX_RT_addr_i) RT_select_o <= 2'd1;
		end
		else if (WB_RegWrite_i && WB_write_addr_i!=0) begin
			if (WB_write_addr_i == EX_RS_addr_i) RS_select_o <= 2'd2;
			else if (WB_write_addr_i == EX_RT_addr_i) RT_select_o <= 2'd2;
		end
		else begin
			RS_select_o <= 2'd0;
			RT_select_o <= 2'd0;
		end
	end*/

endmodule
