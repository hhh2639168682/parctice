`timescale 1ns/1ns

module pulse_detect(
	input 				clk_fast	, 
	input 				clk_slow	,   
	input 				rst_n		,
	input				data_in		,

	output  		 	dataout
);
    reg fast_req, slow_ack;
    reg [2:0] slow_req;
    reg [2:0] fast_ack;
    
    //fast???
    
    //?slow??????????????fast???
    always @(posedge clk_fast, negedge rst_n) begin
        if(!rst_n) begin
            fast_ack <= 3'b0;
        end else begin
            fast_ack <= {fast_ack[1:0], slow_ack};
        end 
    end
    
    //??????fast_req
    always @(posedge clk_fast, negedge rst_n) begin
        if(!rst_n) begin
            fast_req <= 1'b0;
        end else if (data_in) begin
            fast_req <= 1'b1;
        end else begin
            fast_req <= (fast_ack[1] & (~fast_ack[2])) ? 1'b0 : fast_req;
        end
    end
    
    //slow???
    
    //?fast??????????????slow???
    always @(posedge clk_slow, negedge rst_n) begin
        if(!rst_n) begin
            slow_req <= 3'b0;
        end else  begin
            slow_req <= {slow_req[1:0], fast_req};
        end 
    end
    
    //??????slow_ack
    always @(posedge clk_slow, negedge rst_n) begin
        if(!rst_n) begin
            slow_ack <= 1'b0;
        end else if (slow_req[1] & (~slow_req[2])) begin
            slow_ack <= 1'b1;
        end else begin
            slow_ack <= (slow_req[2] & (~slow_req[1])) ? 1'b0 : slow_ack;
        end
    end
    assign dataout = (~slow_req[2]) & (slow_req[1]);
    //
    
endmodule
