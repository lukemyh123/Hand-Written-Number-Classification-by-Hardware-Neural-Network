
//max_selector module

module max_selector (
    input clk,
    input rst,
    input Input_Valid,
    input [25:0] s0,
    input [25:0] s1,
    input [25:0] s2,
    input [25:0] s3,
    input [25:0] s4,
    input [25:0] s5,
    input [25:0] s6,
    input [25:0] s7,
    input [25:0] s8,
    input [25:0] s9,
    output max_output_valid,
    output [3:0] Img_Num
);

reg max_output_valid_r;
reg [3:0] Img_Num_r;

reg [25:0] max_1, max_2, max_3, max_4, max_5;
reg [3:0] max_n_1, max_n_2, max_n_3, max_n_4, max_n_5;

reg [2:0] max_state, next_max_state;

parameter S0 = 3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S_IDLE=3'b100;

assign max_output_valid = max_output_valid_r;
assign Img_Num = Img_Num_r;

always@(max_state) begin
    case(max_state)
        S_IDLE: begin
            next_max_state = S_IDLE;
            max_output_valid_r = 0;
        end
        S0: begin
            max_1 = ($signed(s0) > $signed(s1)) ? s0 : s1;
            max_2 = ($signed(s2) > $signed(s3)) ? s2 : s3;
            max_3 = ($signed(s4) > $signed(s5)) ? s4 : s5;
            max_4 = ($signed(s6) > $signed(s7)) ? s6 : s7;
            max_5 = ($signed(s8) > $signed(s9)) ? s8 : s9;
            max_n_1 = ($signed(s0) > $signed(s1)) ? 4'b0000 : 4'b0001;
            max_n_2 = ($signed(s2) > $signed(s3)) ? 4'b0010 : 4'b0011;
            max_n_3 = ($signed(s4) > $signed(s5)) ? 4'b0100 : 4'b0101;
            max_n_4 = ($signed(s6) > $signed(s7)) ? 4'b0110 : 4'b0111;
            max_n_5 = ($signed(s8) > $signed(s9)) ? 4'b1000 : 4'b1001;
            next_max_state = S1;
            //$display("next_state: %d, max_1: %d, max_2: %d, max_3: %d, max_4: %d, max_5: %d, max_n_1: %d, max_n_2: %d, max_n_3: %d, max_n_4: %d, max_n_5: %d", next_max_state, max_1, max_2, max_3, max_4, max_5, max_n_1, max_n_2, max_n_3, max_n_4, max_n_5);
        end
        S1: begin
            max_n_1 = ($signed(max_1) > $signed(max_2)) ? max_n_1 : max_n_2;
            max_n_2 = ($signed(max_3) > $signed(max_4)) ? max_n_3 : max_n_4;
            max_1 = ($signed(max_1) > $signed(max_2)) ? max_1 : max_2;
            max_2 = ($signed(max_3) > $signed(max_4)) ? max_3 : max_4;
            next_max_state = S2;
            //$display("next_state: %d, max_1: %d, max_2: %d, max_n_1: %d, max_n_2: %d", next_max_state, max_1, max_2, max_n_1, max_n_2);
        end
        S2: begin
            max_n_1 = ($signed(max_1) > $signed(max_2)) ? max_n_1 : max_n_2;
            max_1 = ($signed(max_1) > $signed(max_2)) ? max_1 : max_2;
            next_max_state = S3;
            //$display("next_state: %d, max_1: %d, max_n_1: %d", next_max_state, max_1, max_n_1);
        end
        S3: begin
            Img_Num_r = ($signed(max_1) > $signed(max_5)) ? max_n_1 : max_n_5;
            max_output_valid_r = 1;
            next_max_state = S_IDLE;
            //$display("next_state: %d, Img_Num_r: %d", next_max_state, Img_Num_r);
        end


    endcase         
end

always@(posedge clk) begin
 	if(rst) begin
        max_state = S_IDLE;
        next_max_state = S_IDLE;
        max_1 = 0;
        max_2 = 0;
        max_3 = 0;
        max_4 = 0;
        max_5 = 0;
        max_n_1 = 0;
        max_n_2 = 0;
        max_n_3 = 0;
        max_n_4 = 0;
        max_n_5 = 0;
        max_output_valid_r = 0;
        Img_Num_r = 0;
	end
    else begin
        if(Input_Valid == 1) begin
            max_state = S0;
           // $display("hhhhhhhhhhhhhhhhhhhhhhhhhhh");
        end
        else
            max_state = next_max_state;
    end
    //$display("rst:%d, max_state: %d, Input_Valid: %d, max_1: %d, max_2: %d, max_3: %d, max_4: %d, max_5: %d, max_n_5: %d, Img_Num_r: %d, output_valid: %d ", rst, max_state, Input_Valid, max_1, max_2, max_3, max_4, max_5, max_n_5, Img_Num_r, max_output_valid_r);

end

endmodule