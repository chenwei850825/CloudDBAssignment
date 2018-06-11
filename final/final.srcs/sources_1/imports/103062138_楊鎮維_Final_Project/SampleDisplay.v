module SampleDisplay(
	/*output wire [6:0] display,
	output wire [3:0] digit,*/
	output reg set,
	output reg ok,
	output reg stop,
	output reg snooze,
	output reg uphour,
	output reg downhour,
	output reg upminute,
	output reg downminute,
	output reg upsec,
	output reg downsec,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	
	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:19] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0101,	// 4 => 25
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		9'b0_0100_0110,	// 9 => 46
		
		9'h1B, // set
		9'h5A, // enter
		9'h29, // snooze
		9'h76, // stop
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101  // right_9 => 7D
	};
	
	reg [15:0] nums;
	reg [3:0] key_num;
	reg [9:0] last_key;
	
	wire shift_down;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
	
	/*SevenSegment seven_seg (
		.display(display),
		.digit(digit),
		.nums(nums),
		.rst(rst),
		.clk(clk)
	);*/
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			set <= 0;
			ok <= 0;
			stop <= 0;
			snooze <= 0;
			uphour <= 0;
			downhour <= 0;
			upminute <= 0;
			downminute <= 0;
			upsec <= 0;
			downsec <= 0;
		end else begin
			set <= 0;
			ok <= 0;
			stop <= 0;
			snooze <= 0;
			uphour <= 0;
            downhour <= 0;
            upminute <= 0;
            downminute <= 0;
            upsec <= 0;
            downsec <= 0;
			if (been_ready && key_down[last_change] == 1'b1) begin
				if ( last_change == KEY_CODES[10] ) set <= 1;
				if ( last_change == KEY_CODES[11] ) ok <= 1;
				if ( last_change == KEY_CODES[12] ) snooze <= 1;
				if ( last_change == KEY_CODES[13] ) stop <= 1;
				if ( last_change == KEY_CODES[1] ) uphour <= 1;
				if ( last_change == KEY_CODES[2] ) downhour <= 1;
				if ( last_change == KEY_CODES[3] ) upminute <= 1;
				if ( last_change == KEY_CODES[4] ) downminute <= 1;
				if ( last_change == KEY_CODES[5] ) upsec <= 1;
				if ( last_change == KEY_CODES[6] ) downsec <= 1;
			end
		end
	end
	
	always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 4'b0000;
			KEY_CODES[01] : key_num = 4'b0001;
			KEY_CODES[02] : key_num = 4'b0010;
			KEY_CODES[03] : key_num = 4'b0011;
			KEY_CODES[04] : key_num = 4'b0100;
			KEY_CODES[05] : key_num = 4'b0101;
			KEY_CODES[06] : key_num = 4'b0110;
			KEY_CODES[07] : key_num = 4'b0111;
			KEY_CODES[08] : key_num = 4'b1000;
			KEY_CODES[09] : key_num = 4'b1001;
			KEY_CODES[10] : key_num = 4'b0000;
			KEY_CODES[11] : key_num = 4'b0001;
			KEY_CODES[12] : key_num = 4'b0010;
			KEY_CODES[13] : key_num = 4'b0011;
			KEY_CODES[14] : key_num = 4'b0100;
			KEY_CODES[15] : key_num = 4'b0101;
			KEY_CODES[16] : key_num = 4'b0110;
			KEY_CODES[17] : key_num = 4'b0111;
			KEY_CODES[18] : key_num = 4'b1000;
			KEY_CODES[19] : key_num = 4'b1001;
			default		  : key_num = 4'b1111;
		endcase
	end
	
endmodule
