//0316055_0316313
module Hazard_Detector(
	input wire ID_EX_MemRead_i,
	input wire [4:0] ID_EX_RTaddr_i,
	input wire [4:0] IF_ID_RSaddr_i,
	input wire [4:0] IF_ID_RTaddr_i,
	input wire PCScr_i,
	output reg PCWrite_o,
	output reg IF_IDWrite_o,
	output reg IF_flush_o,
	output reg ID_flush_o,
	output reg EX_flush_o
	);
 
 	//load use hazard
	wire load_use_hazard = ID_EX_MemRead_i & ( ID_EX_RTaddr_i == IF_ID_RSaddr_i | ID_EX_RTaddr_i == IF_ID_RTaddr_i );
	//branch hazard
	wire branch_hazard = ( PCScr_i == 1 );

	always @(*) begin
		if(load_use_hazard)begin
			PCWrite_o = 0;
			IF_IDWrite_o = 0;
		end
		else begin
			PCWrite_o = 1;
			IF_IDWrite_o = 1;
		end
	end

	always @(*) begin
		if(branch_hazard)begin
			EX_flush_o = 1;
			IF_flush_o = 1;
		end
		else begin
			EX_flush_o = 0;
			IF_flush_o = 0;
		end
	end

	always @(*) begin
		if(load_use_hazard | branch_hazard)
			ID_flush_o = 1;
		else
			ID_flush_o = 0;
	end

endmodule