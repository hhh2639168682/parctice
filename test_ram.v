
`timescale 1ns/1ns

module tb_ram_mod;

	reg clk;
	reg rst_n;
	reg write_en;
	reg [7:0] write_addr;
	reg [3:0] write_data;
	reg read_en;
	reg [7:0] read_addr;
	wire [3:0] read_data;

	ram_mod dut (
		.clk(clk),
		.rst_n(rst_n),
		.write_en(write_en),
		.write_addr(write_addr),
		.write_data(write_data),
		.read_en(read_en),
		.read_addr(read_addr),
		.read_data(read_data)
	);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		rst_n = 0;
		write_en = 0;
		write_addr = 0;
		write_data = 0;
		read_en = 0;
		read_addr = 0;
end
initial begin
		#10 rst_n = 1;
		write_en = 1;
		write_data = 1; 
		#10 write_addr = 1; write_data = 2;
		#10 write_addr = 2; write_data = 4;
		#10 write_en = 0; write_addr = 3; write_data = 6;
		#10 write_en = 1; write_addr = 4; write_data = 8;
		#10 write_addr = 5; write_data = 10;
		#10 write_en = 0; write_addr = 6; write_data = 12;
		#10 write_en = 1; write_addr = 7; write_data = 14;
		#10 read_en = 1; 
		#10 read_addr = 1; 
		#10 read_addr = 2; 
		#10 read_addr = 3; 
		#10 read_addr = 4; 
		#10 read_addr = 5; 
		#10 read_addr = 6; 
		#10 read_addr = 7;    // Read from address 4

end

endmodule


