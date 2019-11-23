
module syncronisation(
            //vga parameteres
            
			input                pixel_clk,
			input                reset,
			output reg           h_sync,
			output reg           v_sync,
			output reg  [7:0]    red,
            output reg  [7:0]    green,
			output reg  [7:0]    blue,
			output               sync_n,
			output               blank_n,

            //input from keyboard 
            input wire            break,
            input wire            keyboard_data
            //input wire synchчяыв

);
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	45 + 3;
parameter	H_SYNC_ACT	=	640;	//	646
parameter	H_SYNC_FRONT=	13 + 3;
parameter	H_SYNC_TOTAL=	800;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	30 + 2;
parameter	V_SYNC_ACT	=	480;	//	484
parameter	V_SYNC_FRONT=	9 + 2;
parameter	V_SYNC_TOTAL=	525;
//	Start Offset
parameter	X_START		=	H_SYNC_CYC + H_SYNC_BACK + 4;
parameter	Y_START		=	V_SYNC_CYC + V_SYNC_BACK;


reg [9:0] H_Cont;
reg [9:0] V_Cont;


 
assign blank_n = 1'b1;
assign sync_n = 1'b0;


 
//	H_Sync Generator, Ref. 25 MHz Clock
always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
    begin
        H_Cont	<=	0;
        h_sync	<=	0;
    end
    else
    begin
            //	H_Sync Counter
        if(H_Cont < H_SYNC_TOTAL )
            H_Cont	<=	H_Cont + 1;
        else
            H_Cont	<=	0;

        //	H_Sync Generator
        if( H_Cont < H_SYNC_CYC )
            h_sync	<=	0;
        else
            h_sync	<=	1;
    end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
    begin
        V_Cont		<=	0;
        v_sync		<=	0;
    end
    else
    begin
    //	When H_Sync Re-start
        if(H_Cont == 0)
        begin
            //	V_Sync Counter
            if( V_Cont < V_SYNC_TOTAL )
                V_Cont	<=	V_Cont + 1;
            else
                V_Cont	<=	0;
            //	V_Sync Generator
            if(	V_Cont < V_SYNC_CYC )
                v_sync	<=	0;
            else
                v_sync	<=	1;
        end
    end
end


always@(posedge break) 
begin
	if(keyboard_data == 8'h72)                                                   				//key = "r"
        begin
            green   <= (H_Cont >= X_START + 9  && H_Cont < X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
            red     <= (H_Cont >= X_START + 9  && H_Cont < X_START + H_SYNC_ACT + 9)    ?   8'b00000111 : 0 ;
            blue    <= (H_Cont >= X_START + 9  && H_Cont < X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
        end
        else if(keyboard_data == 8'h67)                                                 			//key = "g"
        begin
            green   <= (H_Cont >= X_START + 9 	&& H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b00000111 : 0 ;
            red     <= (H_Cont >= X_START + 9 	&& H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
            blue    <= (H_Cont >= X_START + 9 	&& H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
        end
        else if(keyboard_data == 8'h62)                                                 			//key = "b"
        begin	
            green   <= (H_Cont >= X_START + 9  &&  H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
            red     <= (H_Cont >= X_START + 9  &&  H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b0 : 0 ;
            blue    <= (H_Cont >= X_START + 9  &&  H_Cont<X_START + H_SYNC_ACT + 9)    ?   8'b00000111 : 0 ;
        end
end
endmodule

