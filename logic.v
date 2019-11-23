module logic(
	input PlayerA_up,
	input PlayerA_down,
	input PlayerB_up,
	input PlayerB_down,
	
	input pixel_clk,
	input reset,
	
	output reg [7:0] red,
	output reg [7:0] green,
	output reg [7:0] blue,

	output reg h_sync,
	output reg v_sync,
	output sync_n,
	output blank_n		
);

//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	45+3;
parameter	H_SYNC_ACT	=	640;	//	646
parameter	H_SYNC_FRONT=	13+3;
parameter	H_SYNC_TOTAL=	800;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	30+2;
parameter	V_SYNC_ACT	=	480;	//	484
parameter	V_SYNC_FRONT=	9+2;
parameter	V_SYNC_TOTAL=	525;
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK+4;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;

reg [9:0] H_Cont; //x_pixel
reg [9:0] V_Cont; //y_pixel

//Players position
reg [9:0] PlayerA_xpos;
reg [9:0] PlayerA_ypos;

reg [9:0] PlayerB_xpos;
reg [9:0] PlayerB_ypos;

//Size of Player's rectangle
reg [9:0] Player_width;
reg [9:0] Player_length;

//Translation of Player, when button is pushed
reg [9:0] Player_translation;

//Ball position
reg [9:0] Ball_xpos;
reg [9:0] Ball_ypos;

reg [9:0] Ball_size;

//Ball velocity
reg [9:0] Ball_xvel;
reg [9:0] Ball_yvel;

//Current pixel for drawing
reg [9:0] Current_X;
reg [9:0] Current_Y;
wire [9:0] connect_x;
wire [9:0] connect_y;

assign blank_n = 1'b1;
assign sync_n = 1'b0;
assign connect_x = H_Cont;
assign connect_x = Current_X;
assign connect_y = V_Cont;
assign connect_y = Current_Y;
 
//	H_Sync Generator, Ref. 25 MHz Clock
always@(posedge pixel_clk or negedge reset)
    begin
        if(!reset)
            begin
                H_Cont	<= 0;
                h_sync	<= 0;
            end
        else
            begin
                //	H_Sync Counter
                if( H_Cont < H_SYNC_TOTAL )
                    H_Cont	<=	H_Cont+1;
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
                V_Cont <= 0;
                v_sync <= 0;
            end
        else
            begin
                //	When H_Sync Re-start
                if(H_Cont==0)
                    begin
                        //	V_Sync Counter
                        if( V_Cont < V_SYNC_TOTAL )
                            V_Cont	<=	V_Cont+1;
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

//Drawing block
always@(posedge pixel_clk)
begin
	if(!reset)
		begin
			Current_X <= 0;
			Current_Y <= 0;
			
			Player_width <= 20;
			Player_length <= 120;

			PlayerA_xpos <= 50;
			PlayerA_ypos <= 180;

			PlayerB_xpos <= 180;
			PlayerB_ypos <= 590;

			Ball_xpos <= 320;
			Ball_ypos <= 240;
			
			Ball_size <= 20;
			
			Ball_xvel <= 5;
			Ball_yvel <= 5;
			
			Player_translation <= 20;
		end
	//Drawing ball
	if((Current_X >= Ball_xpos) & (Current_X <= Ball_xpos + Ball_size) & (Current_Y >= Ball_ypos) & (Current_Y <= Ball_ypos + Ball_size))
		begin
			red <=  8'b11111111;
			green <= 8'b11111111;
			blue <= 8'b00000000;
		end	
	else
	//Drawing PlayerA block
	if((Current_X >= PlayerA_xpos) & (Current_X <= PlayerA_xpos + Player_width) & (Current_Y >= PlayerA_ypos) & (Current_Y <= PlayerA_ypos + Player_length))
		begin
			red <=  8'b11111111;
			green <= 8'b11111111;
			blue <= 8'b11111111;
		end
	else
	//Drawing PlayerB block
	if((Current_X >= PlayerB_xpos) & (Current_X <= PlayerB_xpos + Player_width) & (Current_Y >= PlayerB_ypos) & (Current_Y <= PlayerB_ypos + Player_length))
		begin
			red <=  8'b11111111;
			green <= 8'b11111111;
			blue <= 8'b11111111;
		end	
	else
	//Else background is black
		begin
			red <=  8'b00000000;
			green <= 8'b00000000;
			blue <= 8'b00000000;
		end	

end

//Player moving
always@(posedge pixel_clk)
begin
	//PlayerA moving
	if(PlayerA_up & ((PlayerA_ypos - Player_translation) >= 0))
		PlayerA_ypos <= PlayerA_ypos - Player_translation;
	else 
	if(PlayerA_down & ((PlayerA_ypos + Player_translation) <= 480))
		PlayerA_ypos <= PlayerA_ypos + Player_translation;
	//PlayerB moving
	else
	if(PlayerB_up & ((PlayerB_ypos - Player_translation) >= 0))
		PlayerB_ypos <= PlayerB_ypos - Player_translation;
	else 
	if(PlayerB_down & ((PlayerB_ypos + Player_translation) <= 480))
		PlayerB_ypos <= PlayerB_ypos + Player_translation;
end

//Tracking ball position
always@(posedge pixel_clk)
begin
	//Ball moving
	Ball_xpos <= Ball_xpos + Ball_xvel;
	Ball_ypos <= Ball_ypos + Ball_xvel;
	
	//Top side
	if (Ball_ypos <= 0)
		Ball_yvel <= 0 + Ball_yvel; //Reflection without using multiply
	
	//Bottom side
	if (Ball_ypos >= 480)
		Ball_yvel <= 0 - Ball_ypos;
		
	//Left side
	//Right side
		//TODO Scores and reset game
		
	//PlayerA reflection
	//front side of Player A rectangle
	if ((Ball_xpos <= (PlayerA_xpos + Player_width + 50)) & (Ball_ypos >= PlayerA_ypos) & (Ball_ypos <= (PlayerA_ypos + Player_length))) 
		Ball_xvel <= 0 + Ball_xvel;
	//back side of Player A rectangle
	if ((Ball_xpos >= (PlayerA_xpos + 50)) & (Ball_ypos >= PlayerA_ypos) & (Ball_ypos <= (PlayerA_ypos + Player_length)))
		Ball_xvel <= 0 - Ball_xvel;
	//top side of Player A rectangle
	if ((Ball_ypos >= PlayerA_ypos) & (Ball_xpos >= PlayerA_xpos + 50) & (Ball_xpos <= (PlayerA_xpos + 50 + Player_width))) 
		Ball_yvel <= 0 - Ball_yvel;
	//bottom side of Player A rectangle
	if ((Ball_ypos <= PlayerA_ypos + Player_length) & (Ball_xpos >= PlayerA_xpos + 50) & (Ball_xpos <= (PlayerA_xpos + 50 + Player_width))) 
		Ball_yvel <= 0 + Ball_yvel;
	
	//PlayerB reflection
	//front side of Player B rectangle
	if ((Ball_xpos >= (PlayerB_xpos + 590)) & (Ball_ypos >= PlayerB_ypos) & (Ball_ypos <= (PlayerB_ypos + Player_length)))
		Ball_xvel <= 0 - Ball_xvel;
	//back side of Player B rectangle
	if ((Ball_xpos <= (PlayerB_xpos + 590 + Player_width)) & (Ball_ypos >= PlayerB_ypos) & (Ball_ypos <= (PlayerB_ypos + Player_length)) )
		Ball_xvel <= 0 + Ball_xvel;
	//top side of Player B rectangle
	if ((Ball_ypos >= PlayerB_ypos) & (Ball_xpos >= PlayerB_xpos + 590) & (Ball_xpos <= (PlayerB_xpos + 590 + Player_width))) 
		Ball_yvel <= 0 - Ball_yvel;
	//bottom side of Player B rectangle
	if ((Ball_ypos <= PlayerB_ypos + Player_length) & (Ball_xpos >= PlayerB_xpos + 590) & (Ball_xpos <= (PlayerB_xpos + 590 + Player_width))) 
		Ball_yvel <= 0 + Ball_yvel;
	
	
end


endmodule