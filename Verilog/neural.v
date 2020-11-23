
//this module is to calculate one sum of the nerual network, there are totally 10 sum that we need to calculaute
//the rest of 9 sum can use this module to calculate
module neural (
	input clk,
	input rst,
	input Input_Valid,
	input [14933:0] wgt,
	input [7859:0] pixel,
	output [25:0] Out_result,
	output Output_Valid
);

reg output_valid_r;

wire [25:0] output_m0;  //the output result from the multiplier_0
wire [25:0] output_m1;  //the output result from the multiplier_1

wire [25:0] output_a0;  //the output from the first adder (adder_0);
reg [25:0] output_a0_r;  //reg for output_a0, as the input of adder_1

wire [25:0] output_a1;  //the output from the second adder (adder_1)
reg [25:0] output_a1_r; //reg for output_a1, as the input of adder_1 (feedback loop)

reg [18:0] wgt_m0;
reg [18:0] wgt_m1;

reg [9:0] pixel_m0;
reg [9:0] pixel_m1;

reg start_input;
reg [8:0] c_cycles; //use to calculate how many cycles we need to get the result after data feeding

reg [25:0] f_result_r;  //final result;
reg [25:0] temp_1r;
reg [25:0] temp_2r;

FixedPointMultiplier multiplier_0 (clk, rst, wgt_m0, pixel_m0, output_m0);
FixedPointMultiplier multiplier_1 (clk, rst, wgt_m1, pixel_m1, output_m1);

FixedPointAdder adder_0 (clk, rst, output_m0, output_m1, output_a0);    //first adder

FixedPointAdder adder_1 (clk, rst, output_a0_r, output_a1_r, output_a1);    //Second adder, feedback loop to calculate all the sum.
 
assign Output_Valid = output_valid_r;
assign Out_result = f_result_r;

always@(c_cycles) begin
	case(c_cycles)
		0: begin
			wgt_m0 <= 0;
			wgt_m1 <= 0;
			pixel_m0 <= 0;
			pixel_m1 <= 0;
			output_a0_r <= 0;
			output_a1_r <= 0;	
			f_result_r <= 0;
		end
		403: begin  //14
			temp_1r = output_a1;
			output_a0_r = output_a0;
			output_a1_r = output_a1;
		end
		404: begin   //15  +1
			output_a0_r = temp_1r;
			output_a1_r = output_a1;
		end
		405: begin   //16   +1
			temp_2r = output_a1;
			output_a0_r = output_a0;
			output_a1_r = output_a1;
		end
		407: begin   //18   +2
			output_a0_r = temp_2r;
			output_a1_r = output_a1;
		end
		410: begin   //21  +3
			output_valid_r = 1;
			f_result_r = output_a1;
		end
		default: begin
			if(c_cycles < 394) begin
				wgt_m0 = wgt[19*(c_cycles*2-2)+:19];   //"c[x+ : N] x +: N, The start position of the vector is given by x and you count up from x by N."
				wgt_m1 = wgt[19*(c_cycles*2-1)+:19];
				pixel_m0 = pixel[10*(c_cycles*2-2)+:10];
				pixel_m1 = pixel[10*(c_cycles*2-1)+:10];
			end
			else begin
				wgt_m0 = 0;
				wgt_m1 = 0;
				pixel_m0 = 0;
				pixel_m1 = 0;
			end
			output_a0_r = output_a0;
			output_a1_r = output_a1;
		end
	endcase
end

always@(posedge clk) begin
	if(rst) begin
		start_input <= 0;
		c_cycles <= 0;
		output_valid_r <= 0;
	end
	else begin
		if(Input_Valid)
			start_input <= 1;
		else begin
			if(start_input == 1) begin
				if(c_cycles < 500)		
					c_cycles <= c_cycles + 1;
				else
					c_cycles <= c_cycles;
			end
		end
	end
	$display("%d, output_m0=%d, output_m1=%d, a0=%d, a1=%d, a0_r=%d, a1_r=%d, temp_1r=%d, temp_2r=%d", c_cycles, output_m0, output_m1, output_a0, output_a1, output_a0_r, output_a1_r, temp_1r, temp_2r);
end

endmodule
