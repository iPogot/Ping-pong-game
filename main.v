`include "D:/verilog/projects/Ping-pong-game-master/Ping-pong-game-master/clk25.v"
`include "D:/verilog/projects/Ping-pong-game-master/Ping-pong-game-master/logic.v"
`include "D:/verilog/projects/Ping-pong-game-master/Ping-pong-game-master/btn.v"

module game(
	//buttons
	input PlayerA_up,
	input PlayerA_down,
	input PlayerB_up,
	input PlayerB_down,
	input clk50,
	input reset,

	output [7:0] red,
	output [7:0] green,
	output [7:0] blue,
	output blank_n,
	output sync_n,
	output h_sync,
	output v_sync,
	output clk25
);

wire vga_clk;
wire h_sync_clk;
wire v_sync_clk;

wire PlayerA_up_w;
wire PlayerA_down_w;
wire PlayerB_up_w;
wire PlayerB_down_w;

wire red_w;
wire green_w;
wire blue_w;

wire sync_n_w;
wire blank_n_w;

assign h_sync = h_sync_clk;
assign v_sync = v_sync_clk;

assign red = red_w;
assign green = green_w;
assign blue = blue_w;

assign sync_n = sync_n_w;
assign blank_n = blank_n_w;

assign clk25 = vga_clk;

logic u1(
	.PlayerA_up_u1 (PlayerA_up_w),
	.PlayerA_down_u1 (PlayerA_down_w),
	.PlayerB_up_u1 (PlayerB_up_w),
	.PlayerB_down_u1 (PlayerB_down_w),
	
	.pixel_clk (vga_clk),
	.reset (reset),
	
	.red (red_w),
	.green (green_w),
	.blue (blue_w),

	.h_sync (h_sync_clk),
	.v_sync (v_sync_clk),
	.sync_n (sync_n_w),
	.blank_n (blank_n_w)		
);



vga_clk25  u2(
	.reset 		(reset),
	.clk50 		(clk50),
	.clk25  	(vga_clk) 
 );

btn u3(
	.PlayerA_up_i (PlayerA_up),
	.PlayerA_down_i (PlayerA_down),
	.PlayerB_up_i (PlayerB_up),
	.PlayerB_down_i (PlayerB_down),
	
	.pixel_clk (vga_clk),
	.reset (reset),

    .PlayerA_up_out (PlayerA_up_w),
    .PlayerA_down_out (PlayerA_down_w),
    .PlayerB_up_out (PlayerB_up_w),
    .PlayerB_down_out (PlayerB_down_w)
);


endmodule 
