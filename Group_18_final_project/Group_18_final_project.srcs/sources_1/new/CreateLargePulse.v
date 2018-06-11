`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/12 09:42:37
// Design Name: 
// Module Name: CreateLargePulse
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CreateLargePulse (
	output wire large_pulse,
	input wire small_pulse,
	input wire rst,
	input wire clk
);

	parameter n = 16;

	reg state, next_state;
	reg[n-1:0] counter, next_counter;

	assign large_pulse = (counter != 0) ? 1 : 0;

	always@ (posedge clk) begin
		if(rst) begin
				state <= 0;
				counter <= 0;
		end
		else begin
				state <= next_state;
				counter <= next_counter;
		end
	end

	always@(*) begin
		case(state)
				0 : begin
						if(small_pulse == 1) begin
								next_state = 1;
								next_counter = counter + 1;
						end
						else begin
								next_state = 0;
								next_counter = 0;
						end
				end
				1 : begin
						if(counter == 0) begin
								next_state = 0;
								next_counter = 0;
						end
						else begin
								next_state = 1;
								next_counter = counter + 1;
						end
				end
		endcase
	end

endmodule
