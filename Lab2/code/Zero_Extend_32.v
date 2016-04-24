//0316055_0316313
//Subject:     CO project 2 - Zero_Extend_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module Zero_Extend_32(
    data_i,
    data_o
    );

parameter size = 0;
			
//I/O ports
input   [size-1:0] data_i;
output reg [31:0] data_o;

//Internal Signals
//reg     [size-1:0] data_o;

//Main function
always @(*) begin
	integer i;
	data_o[size-1:0] = data_i[size-1:0];
	for(i=size;i<32;i=i+1)begin
		data_o[i] = 0;
	end
end

endmodule      
          
          