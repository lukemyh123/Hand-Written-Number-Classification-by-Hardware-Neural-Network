
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

reg max_output_valid_r, max_output_valid_w;

reg [3:0] Img_Num_w, Img_Num_r;

reg [25:0] max_1, max_2, max_3, max_4, max_5;
reg [25:0] max_1_w, max_2_w, max_3_w, max_4_w, max_5_w;

reg [3:0] max_n_1, max_n_2, max_n_3, max_n_4, max_n_5;
reg [3:0] max_n_1_w, max_n_2_w, max_n_3_w, max_n_4_w, max_n_5_w;

reg [2:0] state, state_w;

parameter S0 = 3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S_IDLE=3'b100;

assign max_output_valid = max_output_valid_r;
assign Img_Num = Img_Num_r;

always@(state) begin
    case(state)
        S_IDLE: begin
            state_w = S_IDLE;
            max_output_valid_w = 1'b0;
            Img_Num_w = Img_Num_r;
        end
        S0: begin
            state_w = S1;
            max_output_valid_w = 1'b0;
            Img_Num_w = Img_Num_r;
            max_1_w = ($signed(s0) > $signed(s1)) ? s0 : s1;
            max_2_w = ($signed(s2) > $signed(s3)) ? s2 : s3;
            max_3_w = ($signed(s4) > $signed(s5)) ? s4 : s5;
            max_4_w = ($signed(s6) > $signed(s7)) ? s6 : s7;
            max_5_w = ($signed(s8) > $signed(s9)) ? s8 : s9;
            max_n_1_w = ($signed(s0) > $signed(s1)) ? 4'b0000 : 4'b0001;
            max_n_2_w = ($signed(s2) > $signed(s3)) ? 4'b0010 : 4'b0011;
            max_n_3_w = ($signed(s4) > $signed(s5)) ? 4'b0100 : 4'b0101;
            max_n_4_w = ($signed(s6) > $signed(s7)) ? 4'b0110 : 4'b0111;
            max_n_5_w = ($signed(s8) > $signed(s9)) ? 4'b1000 : 4'b1001;
            //$display("s0: %d, s1: %d, s2: %d, s3: %d, s4: %d, s5: %d, s6: %d, s7: %d, s8: %d, s9: %d", $signed(s0), $signed(s1), $signed(s2), $signed(s3), $signed(s4), $signed(s5), $signed(s6), $signed(s7), $signed(s8), $signed(s9));
            //$display("state_w: %d, max_output_valid_w: %d, Img_Num_w: %d, max_1_w: %d, max_2_w: %d, max_3_w: %d, max_4_w: %d, max_5_w: %d", state_w, max_output_valid_w, Img_Num_w, max_1_w, max_2_w, max_3_w, max_4_w, max_5_w);
            //$display("max_n_1_w: %d, max_n_2_w: %d, max_n_3_w: %d, max_n_4_w: %d, max_n_5_w: %d", max_n_1_w, max_n_2_w, max_n_3_w, max_n_4_w, max_n_5_w);
        end
        S1: begin
            state_w = S2;
            max_output_valid_w = 1'b0;
            Img_Num_w = Img_Num_r;
            max_1_w = ($signed(max_1) > $signed(max_2)) ? max_1 : max_2;
            max_2_w = ($signed(max_3) > $signed(max_4)) ? max_3 : max_4;
            max_n_1_w = ($signed(max_1) > $signed(max_2)) ? max_n_1 : max_n_2;
            max_n_2_w = ($signed(max_3) > $signed(max_4)) ? max_n_3 : max_n_4;
            //$display("state_w: %d, max_output_valid_w: %d, Img_Num_w: %d, max_1_w: %d, max_2_w: %d", state_w, max_output_valid_w, Img_Num_w, max_1_w, max_2_w);
            //$display("max_n_1_w: %d, max_n_2_w: %d", max_n_1_w, max_n_2_w);
        end
        S2: begin
            state_w = S3;
            max_output_valid_w = 1'b0;
            Img_Num_w = Img_Num_r;
            max_1_w = ($signed(max_1) > $signed(max_2)) ? max_1 : max_2;
            max_n_1_w = ($signed(max_1) > $signed(max_2)) ? max_n_1 : max_n_2;
            //$display("state_w: %d, max_output_valid_w: %d, Img_Num_w: %d, max_1_w: %d", state_w, max_output_valid_w, Img_Num_w, max_1_w);
            //$display("max_n_1_w: %d", max_n_1_w);
        end
        S3: begin
            max_output_valid_w = 1'b1;
            state_w = S_IDLE;
            Img_Num_w = ($signed(max_1) > $signed(max_5)) ? max_n_1 : max_n_5;
            //$display("state_w: %d, max_output_valid_w: %d, Img_Num_w: %d", state_w, max_output_valid_w, Img_Num_w);
        end


    endcase         
end

always@(posedge clk) begin
 	if(rst) begin
        state <= S_IDLE;
        //state_w <= S_IDLE;
        max_1 <= 26'b0;
        max_2 <= 26'b0;
        max_3 <= 26'b0;
        max_4 <= 26'b0;
        max_5 <= 26'b0;
        max_n_1 <= 4'b0;
        max_n_2 <= 4'b0;
        max_n_3 <= 4'b0;
        max_n_4 <= 4'b0;
        max_n_5 <= 4'b0;
        max_output_valid_r <= 1'b0;
        //max_output_valid_w <= 1'b0;
        Img_Num_r <= 4'b0;
	end
    else begin
        if(Input_Valid == 1) begin
            state <= S0;
        end
        else begin
            state <= state_w;
        end
        max_output_valid_r <= max_output_valid_w;
        Img_Num_r <= Img_Num_w;
        max_1 <= max_1_w;
        max_2 <= max_2_w;
        max_3 <= max_3_w;
        max_4 <= max_4_w;
        max_5 <= max_5_w;
        max_n_1 <= max_n_1_w;
        max_n_2 <= max_n_2_w;
        max_n_3 <= max_n_3_w;
        max_n_4 <= max_n_4_w;
        max_n_5 <= max_n_5_w;
    end
    //$display("rst:%d, state: %d, Input_Valid: %d, max_1: %d, max_2: %d, max_3: %d, max_4: %d, max_5: %d, max_n_5: %d, Img_Num_r: %d, output_valid: %d ", rst, state, Input_Valid, max_1, max_2, max_3, max_4, max_5, max_n_5, Img_Num_r, max_output_valid_r);

end

endmodule