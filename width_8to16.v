`timescale 1ns/1ns

module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);
reg [7:0]data_r;
reg cnt;
////
always@(posedge clk or negedge rst_n)
if(!rst_n)
begin
data_r <= 'b0;
end
else if(valid_in)
begin
data_r <= data_in;
end
////
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
cnt <= 'b0;
end
else if(valid_in)
begin
cnt <= cnt+1;
end
else if(cnt==1)
cnt <= cnt;
else
cnt <= 'b0;
end
////
always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
data_out <= 'b0;
valid_out <= 'b0;
end
else if(cnt==1 & valid_in)
begin
data_out <= {data_r,data_in};
valid_out <= 1;
end
else
begin
data_out <= data_out;
valid_out <= 'b0;
end
end
/////
endmodule
