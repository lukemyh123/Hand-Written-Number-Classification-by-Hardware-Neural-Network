`timescale 1 ns/10 ps

module max_selector_tb ();


//inputs
reg clk;
reg GlobalReset;
reg Input_Valid;
wire max_output_valid_r;
wire [3:0] Img_Num;

reg [25:0] s0;
reg [25:0] s1;
reg [25:0] s2;
reg [25:0] s3;
reg [25:0] s4;
reg [25:0] s5;
reg [25:0] s6;
reg [25:0] s7;
reg [25:0] s8;
reg [25:0] s9;

wire [25:0] s0_w = s0;
wire [25:0] s1_w = s1;
wire [25:0] s2_w = s2;
wire [25:0] s3_w = s3;
wire [25:0] s4_w = s4;
wire [25:0] s5_w = s5;
wire [25:0] s6_w = s6;
wire [25:0] s7_w = s7;
wire [25:0] s8_w = s8;
wire [25:0] s9_w = s9;

max_selector my_max_selector(
    .clk(clk),
    .rst(~GlobalReset),
    .Input_Valid(Input_Valid),
    .s0(s0_w),
    .s1(s1_w),
    .s2(s2_w),
    .s3(s3_w),
    .s4(s4_w),
    .s5(s5_w),
    .s6(s6_w),
    .s7(s7_w),
    .s8(s8_w),
    .s9(s9_w),
    .max_output_valid(max_output_valid_r),
    .Img_Num(Img_Num)
);

parameter halfclock=1;
parameter fullclock=2*halfclock;
// Oscillate the clock (cycle time is 100*timescales)
always #halfclock clk = ~clk;


initial begin
	GlobalReset = 1'b0;
	clk = 1'b1;
	

	#halfclock ;
	#fullclock GlobalReset=1'b1;

    #fullclock;
    #halfclock ;
    Input_Valid = 1'b0;
    
    s0 = 26'b00000000000000000000000000;
    s1 = 26'b00000000000000000000000001;
    s2 = 26'b00000000000000000000000010;
    s3 = 26'b00000000000000000000000011;
    s4 = 26'b00000000000000000000000100;
    s5 = 26'b00000000000000001000000101;
    s6 = 26'b00000000000000000000000110;
    s7 = 26'b00000000000000000000000111;
    s8 = 26'b00000000000000000000001000;
    s9 = 26'b00000000000000000000001001;

    #fullclock;
    Input_Valid = 1'b0;


    #(10*fullclock);
  //  Input_Valid = 1'b0;	

    #(10*fullclock);
    $stop;

end


endmodule