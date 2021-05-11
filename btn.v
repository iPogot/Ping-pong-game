module btn(
	input PlayerA_up_i,
	input PlayerA_down_i,
	input PlayerB_up_i,
	input PlayerB_down_i,
	
	input pixel_clk,
	input reset,

    output reg PlayerA_up_out,
    output reg PlayerA_down_out,
    output reg PlayerB_up_out,
    output reg PlayerB_down_out
);

//Regs to avoid metastable states
reg [1 : 0] PlayerA_up_sw;
reg [1 : 0] PlayerA_down_sw;
reg [1 : 0] PlayerB_up_sw;
reg [1 : 0] PlayerB_down_sw;

//Regs and wires to avoid Дребезг
reg [16 : 0] PlayerA_up_cnt;
reg [16 : 0] PlayerA_down_cnt;
reg [16 : 0] PlayerB_up_cnt;
reg [16 : 0] PlayerB_down_cnt;

reg PlayerA_up_state_o;
reg PlayerA_down_state_o;
reg PlayerB_up_state_o;
reg PlayerB_down_state_o;

wire PlayerA_up_cnt_max = (PlayerA_up_cnt == 16'hFFFF);
wire PlayerA_down_cnt_max = (PlayerA_down_cnt == 16'hFFFF);
wire PlayerB_up_cnt_max = (PlayerB_up_cnt == 16'hFFFF);
wire PlayerB_down_cnt_max = (PlayerB_down_cnt == 16'hFFFF);

wire PlayerA_up_change = (PlayerA_up_state_o != PlayerA_up_sw[1]);
wire PlayerA_down_change = (PlayerA_down_state_o != PlayerA_down_sw[1]);
wire PlayerB_up_change = (PlayerB_up_state_o != PlayerB_up_sw[1]);
wire PlayerB_down_change = (PlayerB_down_state_o != PlayerB_down_sw[1]);


//buttons processing
always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
	begin
        PlayerA_up_sw <= 0;
    end
    else 
    begin
        PlayerA_up_sw <= {PlayerA_up_sw[0], ~PlayerA_up_i};
    end
end

always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
	begin
        PlayerA_down_sw <= 0;
    end
    else 
    begin
	    PlayerA_down_sw <= {PlayerA_down_sw[0], ~PlayerA_down_i};
    end
end

always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
	begin
        PlayerB_up_sw <= 0;
    end
    else 
    begin
	    PlayerB_up_sw <= {PlayerB_up_sw[0], ~PlayerB_up_i};
    end
end

always@(posedge pixel_clk or negedge reset)
begin
    if(!reset)
	begin
        PlayerB_down_sw <= 0;
    end
    else 
    begin
	    PlayerB_down_sw <= {PlayerB_down_sw[0], ~PlayerB_down_i};
    end
end

//counters to avoid interference
always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_up_cnt <= 0;
    end
    else if(PlayerA_up_change)
	begin
		PlayerA_up_cnt <= PlayerA_up_cnt + 1;
	end
	else
	begin
		PlayerA_up_cnt <= 0;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_up_state_o <= 0;
    end
    else if(PlayerA_up_change == 1 && PlayerA_up_cnt_max == 1)
	begin
		PlayerA_up_state_o <= ~PlayerA_up_state_o;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_down_cnt <= 0;
    end
    else if(PlayerA_down_change)
	begin
		PlayerA_down_cnt <= PlayerA_down_cnt + 1;
	end
	else
	begin
		PlayerA_down_cnt <= 0;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_down_state_o <= 0;
    end
    else if(PlayerA_down_change && PlayerA_down_cnt_max)
	begin
		PlayerA_down_state_o <= ~PlayerA_down_state_o;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_up_cnt <= 0;
    end
    else if(PlayerB_up_change)
	begin
		PlayerB_up_cnt <= PlayerB_up_cnt + 1;
	end
	else
	begin
		PlayerB_up_cnt <= 0;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_up_state_o <= 0;
    end
    else if(PlayerB_up_change && PlayerB_up_cnt_max)
	begin
		PlayerB_up_state_o <= ~PlayerB_up_state_o;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_down_cnt <= 0;
    end
    else if(PlayerB_down_change)
	begin
		PlayerB_down_cnt <= PlayerB_down_cnt + 1;
	end
	else
	begin
		PlayerB_down_cnt <= 0;
	end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_down_state_o <= 0;
    end
    else if(PlayerB_down_change && PlayerB_down_cnt_max)
	begin
		PlayerB_down_state_o <= ~PlayerB_down_state_o;
	end
end

//generate output
always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_up_out <= 0;
    end
    else
    begin
        PlayerA_up_out <= PlayerA_up_change & PlayerA_up_cnt_max & ~PlayerA_up_state_o;
    end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerA_down_out <= 0;
    end
    else
    begin
        PlayerA_down_out <= PlayerA_down_change & PlayerA_down_cnt_max & ~PlayerA_down_state_o;
    end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_up_out <= 0;
    end
    else
    begin
        PlayerB_up_out <= PlayerB_up_change & PlayerB_up_cnt_max & ~PlayerB_up_state_o;
    end
end

always@(posedge pixel_clk)
begin
    if(!reset)
	begin
        PlayerB_down_out <= 0;
    end
    else
    begin
        PlayerB_down_out <= PlayerB_down_change & PlayerB_down_cnt_max & ~PlayerB_down_state_o;
    end
end

endmodule