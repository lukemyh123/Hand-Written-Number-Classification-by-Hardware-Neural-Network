//time sclae for simulation perposes
`timescale 1 ns/10 ps

module test_multiplier_tb();

//inputs
reg clk;
reg t_rst;
reg [18:0] wgt;
reg [9:0] pixel;
reg [8:0] count_r = 0;

//outputs
wire [25:0] data_find;
reg [25:0] out_put;

FixedPointMultiplier tb_0(
	.clk (clk),
  	.GlobalReset (t_rst),
  	.WeightPort (wgt), // sfix19_En18
  	.PixelPort (pixel), // sfix10_En0
  	.Output_syn (data_find) // sfix26_En18
);


parameter halfclock=1;
parameter fullclock=2*halfclock;
// Oscillate the clock (cycle time is 100*timescales)
always #halfclock clk = ~clk;

always @(posedge clk) begin
  	out_put <= data_find;
	count_r <= count_r + 1;
end

always @(posedge clk) begin
  	if(count_r >= 3) begin
		wgt = wgt + 1;
		pixel = pixel + 1;
	end
end

initial begin
	wgt = 6;
	pixel = 6;

	t_rst = 1'b0;
	clk = 1'b1;
	
	#fullclock;
	t_rst = 1'b1;
	#halfclock;
	t_rst = 1'b0;

	#(10*fullclock);
	$display(out_put);
	#20 $stop;
end

endmodule
