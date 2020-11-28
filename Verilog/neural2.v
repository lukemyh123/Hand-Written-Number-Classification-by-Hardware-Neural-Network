
//this module is to calculate one sum of the nerual network, there are totally 10 sum that we need to calculaute
//the rest of 9 sum can use this module to calculate
module neural2 (
	input clk,
	input rst,
	input Input_Valid,
	input [14914:0] wgt,
	input [7849:0] pixel,
	output [25:0] Out_result,
	output Output_Valid
);

reg output_valid_r;

wire [25:0] output_m0;  //the output result from the multiplier_0

reg [25:0] output_m0_r;  //reg for output_a0, as the input of adder_1

wire [25:0] output_a1;  //the output from the second adder (adder_1)
reg [25:0] output_a1_r; //reg for output_a1, as the input of adder_1 (feedback loop)

reg [18:0] wgt_m0;
reg [9:0] pixel_m0;

reg start_input;
reg [10:0] c_cycles; //use to calculate how many cycles we need to get the result after data feeding

reg [25:0] f_result_r;  //final result;
reg [25:0] temp_1r;
reg [25:0] temp_2r;

FixedPointMultiplier multiplier_0 (clk, rst, wgt_m0, pixel_m0, output_m0);

FixedPointAdder adder_0 (clk, rst, output_m0_r, output_a1_r, output_a1);    //adder

assign Output_Valid = output_valid_r;
assign Out_result = f_result_r;

always@(c_cycles) begin
	case(c_cycles)
		0: begin
			wgt_m0 = 0;
			pixel_m0 = 0;
			output_m0_r = 0;
			output_a1_r = 0;	
			f_result_r = 0;
		end
		793: begin  //14
			temp_1r = output_a1;
			output_m0_r = output_m0;
			output_a1_r = output_a1;
		end
		794: begin   //15  +1
			output_m0_r = temp_1r;
			output_a1_r = output_a1;
		end
		795: begin   //16   +1
			temp_2r = output_a1;
			output_m0_r = output_m0;
			output_a1_r = output_a1;
		end
		797: begin   //18   +2
			output_m0_r = temp_2r;
			output_a1_r = output_a1;
		end
		800: begin   //21  +3
			output_valid_r = 1;
			f_result_r = output_a1;
		end
		801: begin
			output_valid_r = 0;
			wgt_m0 = 0;
			pixel_m0 = 0;
			output_m0_r = 0;
			output_a1_r = 0;	
			f_result_r = 0;
			start_input = 0;
			c_cycles = 0;
		end
		default: begin
			if(c_cycles < 786) begin   //7
            	wgt_m0 = wgt[19*(c_cycles-1)+:19];   //"c[x+ : N] x +: N, The start position of the vector is given by x and you count up from x by N."
           		pixel_m0 = pixel[10*(c_cycles-1)+:10];
			end
			else begin
				wgt_m0 = 0;
				pixel_m0 = 0;
			end
			output_m0_r = output_m0;
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
				c_cycles <= c_cycles + 1;
			end
		end
	end
	//$display("%d, m0=%d, m0_r=%d, a1=%d, a1_r=%d, temp_1r=%d, temp_2r=%d", c_cycles, output_m0, output_m0_r, output_a1, output_a1_r, temp_1r, temp_2r);
end

endmodule
