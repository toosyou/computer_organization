//0316055_0316313
module Hazard_Detector(
	input wire ID_EX_MemRead_i,
	input wire [4:0] ID_EX_RTaddr_i,
	input wire [4:0] IF_ID_RSaddr_i,
	input wire [4:0] IF_ID_RTaddr_i,
	input wire PCScr_i,
	output wire PCWrite_o,
	output wire IF_IDWrite_o,
	output wire IF_flush_o,
	output wire ID_flush_o,
	output wire EX_flush_o
	);
 
 	//load use hazard
	wire load_use_hazard = ID_EX_MemRead_i & ( ID_EX_RTaddr_i == IF_ID_RSaddr_i | ID_EX_RTaddr_i == IF_ID_RTaddr_i );

	assign PCWrite_o = ~load_use_hazard;
	//assign ID_flush_o = load_use_hazard;
	assign IF_IDWrite_o = ~load_use_hazard;

	//branch hazard
	wire branch_hazard = ( PCScr_i == 1 );

	assign EX_flush_o = branch_hazard;
	assign ID_flush_o = load_use_hazard | branch_hazard;
	assign IF_flush_o = branch_hazard;

endmodule