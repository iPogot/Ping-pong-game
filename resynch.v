module resynch (
    input reset,
    input vga_clk,
    output wire synch 
)


reg [12:0] counter; 

always(@posedge vga_clk)
begin
    if(!reset)
        counter <= 0;
    else
        counter <= counter + 1;

    if(counter == 2500)
    begin
        synch <= ~synch;
        counter <= 0;
    end
end



endmodule


