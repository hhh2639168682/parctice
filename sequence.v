module sequence (
    input clk,
    input rstn,
    input A,
    input B,
    output reg flag
);
reg [9:0]cnt;
///clear noise//
reg ra,rb;

//cnt//
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
        cnt <= 'b0;
        ra <= '0;
        rb <= '0;
        end else if ((cnt == 0) && (A | B)) begin
            cnt <= 10; // assuming the clock is 10MHz, this will be roughly 1ms
        end else if (cnt > 0) begin
            cnt <= cnt - 1;
        end
        if (cnt == 0) begin
      ra <= A;
      rb <= B;
        end
    end
//////
always @(posedge clk or negedge rstn) begin
    if (!rstn) 
    begin
    ra <= 'b0;
    rb <= 'b0;
    end
    else
    begin
      ra <= A;
      rb <= B;
    end
end


//////

parameter IDLE = 6'b000001;
parameter S1 = 6'b000010;
parameter S2 = 6'b000100;
parameter S3 = 6'b001000;
parameter S4 = 6'b010000;
parameter OVER = 6'b100000;

reg [5:0] present_state;
reg [5:0] next_state;
//clear//
always @(posedge clk or negedge rstn) 
begin
if (!rstn) begin
present_state <= IDLE;
end    
else 
present_state <= next_state;
end

always @* begin
if (!rstn) begin
next_state = present_state;
end  
case (present_state)
   IDLE : 
   begin
       if(ra)
       next_state = S1;
       else next_state = present_state;
   end 

   S1 : 
   begin
       if(rb)
       next_state = S2;
       else 
       next_state = S1; 
   end

   S2 : 
   begin if (rb) 
       next_state = S3;
    else next_state = S1;
   end 

   S3 : 
   begin
       if(ra)
       next_state = S4;
       else next_state = IDLE;
   end
   S4 : 
   begin
       if(ra)
       next_state = OVER;
       else 
       next_state = S2;
   end
   OVER:
   begin
        next_state = IDLE;
   end
    default: next_state = present_state;
endcase
end

always @(posedge clk or negedge rstn) 
begin
if (!rstn) 
    flag <= 'b0;
else if (present_state==OVER) 
    flag <= 'b1;
else
    flag <='b0;
end
endmodule
