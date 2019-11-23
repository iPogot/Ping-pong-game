`include "D:/verilog/projects/new_course_project/clk25.v"
`include "D:/verilog/projects/new_course_project/signal_sync.v"
`include "D:/verilog/projects/new_course_project/ps2.v"


module vga(
	//keyboard
	input kb_clock,
	input kb_input_data,

	//vga
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

wire 		kb_break;
wire [7:0] 	kb_output;




syncronisation    u1(

	.pixel_clk 	(clk25),
	.reset 		(reset),
	.h_sync 	(h_sync),
	.v_sync 	(v_sync),
	.red 		(red),
	.green 		(green),
	.blue		(blue),
	.sync_n 	(sync_n),
	.blank_n 	(blank_n),	

	.break 			(main_break),
	.keyboard_data	(kb_output)		

);



vga_clk25  u2(
	.reset 		(reset),
	.clk50 		(clk50),
	.clk25  	(clk25) 
 );

keyboard u3(
	.reset 			(reset),
	.kb_clock 		(kb_clock), 				
	.input_data 	(kb_input_data), 			
	.output_data 	(kb_output),
	.break 			(main_break)
);


endmodule 
