`timescale 1ns/1ps

module streamed_led(
    input clk,
    input rstn,
    input mode,
    output reg [7:0]led
);
/////
reg [23:0]cnt;
//reg ready;
always @(posedge clk or negedge rstn)begin
    
if(!rstn)begin
cnt <= 'd0;
//ready <= 1'b0;
end
else if (cnt == 500-1) begin
    cnt <= 'd0;
    //ready <= 1'b0;
end
else begin
cnt <= cnt + 1'b1;
//ready <= 1'b1;
end
end

reg dv_clk;
always @(posedge clk or negedge rstn)begin
    if (!rstn) begin
        dv_clk <= 'b0;
    end
else if (cnt == 24'd1) begin
    dv_clk <= 1;
end 
else dv_clk <= '0;
end

reg [2:0] dv_cnt;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        dv_cnt <= 'b0;
    end
     else if(dv_cnt == 7)begin
         dv_cnt <= 'b0;
     end
     else if (dv_clk) begin
         dv_cnt <= dv_cnt + 1'b1;
     end
     else  dv_cnt <= dv_cnt;
////
end

always @(posedge clk or negedge rstn)begin

    if(!rstn)begin
    led <= 8'b00000001;
    end

    else if (mode == 0) 
    begin
        if(dv_clk == 1)
        begin
            led <= {led[6:0],led[7]};
        end
        else led <= led;
    end

    else if (mode == 1) begin
        case (dv_cnt)
           0 : led <= 8'b00000001;//0
           1 : led <= 8'b00000100;//2
           2 : led <= 8'b00010000;//4
           3 : led <= 8'b01000000;//6
           4 : led <= 8'b00000001;//1
           5 : led <= 8'b00001000;//3
           6 : led <= 8'b00100000;//5
           7 : led <= 8'b10000000;//7
            default: led <= led;
        endcase
    end
    

    end
    


endmodule