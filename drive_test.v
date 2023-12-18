`timescale 1ns/1ns
module data_driver(
    input clk_a,
    input rst_n,
    input data_ack,
    output reg [3:0]data,
    output reg data_req
    );
     
    
    reg data_ack_d0_r;
    reg data_ack_d1_r;

    parameter  IDLE = 4'b0001;
    parameter  S1 = 4'b0010;
    parameter  S2 = 4'b0100;
    // parameter zero = 4'b1000; 

    reg [4:0] current_state;
    reg [4:0] next_state;
    reg [3:0]cnt_r;

always @(posedge clk_a or negedge rst_n) begin
    if(!rst_n)begin
            current_state <= IDLE;
            end
    else 
            current_state <= next_state;
    
end

always @(*) begin
      next_state = current_state;

        case(current_state)

        IDLE : begin
            if (data_ack_d1_r) begin
                next_state = S1;
            end
            else begin
                next_state = IDLE;
            end
        end

        S1 : begin
                if (cnt_r == 4) begin
                next_state = S2;
            end
            else begin
                next_state = current_state;
        end
        end

        S2 : begin
                next_state = IDLE;
            end            
        
        // zero : begin
        //     next_state = IDLE;
        // end

        default : begin
            next_state = current_state;
        end
        endcase

    end


always @(posedge clk_a or negedge rst_n) begin
    if(!rst_n)begin
        data <= 0;
        cnt_r <= 'd0;
        data_req <= 'd0;
    end

    else begin
        case(current_state)

        IDLE : begin
            data_req <= 'd1;
            data <= data; 
            cnt_r <= 'd0;
            end

        S1 : begin
            cnt_r <= cnt_r + 1;
            data <= data;
            data_req <= 'd0;     
        end 

        S2 : begin
            data <=  (data == 'd7) ?  'd0 : (data+ 1'd1); 
            cnt_r <= 0;
            data_req <= 'd1;
        end

        // zero : begin
        //     data <= 'd0;
        //     data_req <= 'd1;
        // end
    endcase
    end   
end


     always @(posedge clk_a or negedge rst_n) begin
         if (!rst_n) begin
             data_ack_d0_r <= 'd0;
             data_ack_d1_r <= 'd0;
         end
         else begin
             data_ack_d0_r <= data_ack;
             data_ack_d1_r <= data_ack_d0_r;

         end
     end

 endmodule





module data_receiver(
    input clk_b,
    input rst_n,
    input data_req,
    input  [3:0]data,
    output reg data_ack
    );

    reg data_req_d0_r;
    reg data_req_d1_r;
	reg [3:0]data_r;

	always @(posedge clk_b or negedge rst_n)begin
		if(!rst_n)begin
		data_req_d0_r <= 'd0;
    	data_req_d1_r <= 'd0;
		end

		else begin
		data_req_d0_r <= data_req;
        data_req_d1_r <= data_req_d0_r;
        end
	end


	always @(posedge clk_b or negedge rst_n)begin
		if(!rst_n)begin
			data_r <= 'b0;
			data_ack <= 'b0;
		end

		else if(data_req_d1_r)begin
			data_ack <= 1'd1;
			data_r <= data;
		end
		else 
			data_ack <= 'b0;
		
	end
endmodule