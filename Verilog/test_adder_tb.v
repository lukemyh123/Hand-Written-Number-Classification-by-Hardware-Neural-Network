//time sclae for simulation perposes
`timescale 1 ns/10 ps

module test_adder_tb();

//inputs
reg clk;
reg GlobalReset;
reg [25:0] port1;
reg [25:0] port2;

//outputs
wire [25:0] data_find;
reg [25:0] out_put;

FixedPointAdder tb_1(
	.clk (clk),
  	.GlobalReset (t_rst),
  	.Port2 (port2), // sfix26_En18
  	.Port1 (port1), // sfix26_En18
  	.Output_syn (data_find) // sfix26_En18
);


parameter halfclock=1;
parameter fullclock=2*halfclock;
// Oscillate the clock (cycle time is 100*timescales)
always #halfclock clk = ~clk;

always @(posedge clk) begin
  out_put <= data_find;
end

initial begin
	port1 = 26'b11111111111111111111111110;
	port2 = 1;

	GlobalReset = 1'b0;
	clk = 1'b1;
	
	#halfclock ;
	#fullclock GlobalReset=1'b1;

	#(8*fullclock);
	$display(out_put);
	#20 $stop;
end

endmodule