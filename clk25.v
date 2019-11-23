module vga_clk25 (
	input reset,
	input clk50,
	output  clk25
);


reg clk2;




assign clk25 = clk2;


always@(posedge clk50) 
begin 
	
	clk2 <= ~reset ? 1'b0 : ~clk2;
end

endmodule
