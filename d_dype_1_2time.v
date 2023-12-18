// module even_div
//     (
//     input     wire rst ,
//     input     wire clk_in,
//     output    wire clk_out2,
//     output    wire clk_out4,
//     output    wire clk_out8
//     );
 
 
//     reg [2:0]cnt;
//     always@(posedge clk_in or negedge rst)
//         if(!rst)
//             cnt <= 3'b011;
//     else
//         cnt <= cnt+1;
     
//     assign clk_out2 = ~cnt[0];
//     assign clk_out4 = ~cnt[1];
//     assign clk_out8 = cnt[2];
// endmodule
module Odd_Freq_Div_N (    
  input clk_in,
  input rst_n,
  output clk_out

);

parameter N = 7;

reg [2:0] cnt_p,cnt_n;
reg       clk_p,clk_n;

always @(posedge clk_in or negedge rst_n)
begin
  if(!rst_n)
    cnt_p <= 3'b000;
  else if (cnt_p == N-1)
    cnt_p <= 3'b000;
  else
    cnt_p <= cnt_p + 1'b1;
end

always @(posedge clk_in or negedge rst_n) 
begin
  if(!rst_n)
    clk_p <= 1'b0;
  else if (cnt_p == (N-1)/2)
    clk_p <= ~clk_p;
  else if (cnt_p == N-1)
    clk_p <= ~clk_p;
  else
    clk_p <= clk_p;
end

always @(negedge clk_in or negedge rst_n)
begin
  if(!rst_n)
    cnt_n <= 3'b000;
  else if (cnt_n == N-1)
    cnt_n <= 3'b000;
  else
    cnt_n <= cnt_n + 1'b1;
end

always @(negedge clk_in or negedge rst_n) 
begin
  if(!rst_n)
    clk_n <= 1'b0;
  else if (cnt_n == (N-1)/2)
    clk_n <= ~clk_n;
  else if (cnt_n == N-1)
    clk_n <= ~clk_n;
  else
    clk_n <= clk_n;
end

assign clk_out = clk_p | clk_n;
endmodule