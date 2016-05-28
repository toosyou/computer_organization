//0316055_0316313
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
	rst_i,
	data_i,
	write_i,
	flush_i,
	data_o
	);

parameter size = 0;

input					clk_i;		  
input					rst_i;
input		[size-1: 0]	data_i;
input					write_i;
input 					flush_i;
output reg	[size-1: 0]	data_o;

always @(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if(flush_i)
    	data_o <= 0;
    else begin
	    if(write_i)
	        data_o <= data_i;
	    else
	    	data_o <= data_o;
    end
end

endmodule	