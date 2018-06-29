`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:20 06/27/2018 
// Design Name: 
// Module Name:    VGA 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GPU(	input clk,
				input [8:0] row,
				input [9:0] col,
				output reg [18:0] vram_addr,
				
				input [11:0] vram_data,
				output reg [11:0] vga_data
    );

always @(posedge clk) begin
	if(col < 10'd640 && row < 9'd480) begin
		vram_addr <= col + 640 * row;
		vga_data <= vram_data;
	end
	else begin
		vga_data <= 12'h000; //black
	end
end
endmodule
