module keyboard(
	input 	wire 		reset,
	input 	wire 		kb_clock, 		// This is the clock signal from Keyboard
	input 	wire 		input_data, 			//This is the clock signal from Keyboard
	output 	reg  [7:0] 	output_data, 		//LED outputs on the kit
	output 	reg		break
);

//Declare Additional Registers required 
reg [7:0] d_current;
//reg [7:0] d_previous;
reg [3:0] count;
//reg break;



//Receive the data from keyboard
always @(negedge kb_clock) //at the falling edge of the clock
begin
	if(!reset) 
	begin									//Intialize the declared Registers
        count      <=  4'h1; 				// count to keep a track of the current data bit
		break      <=  1'b0;
		output_data  <=  8'hf0;
		//d_previous <=  8'hf0;
	end  
	else
	case(count)
		1:; 											//starting bit
		2: 	output_data[0]  	<=  input_data; 		// read next 8 data bits
		3: 	output_data[1]   	<=  input_data;
		4: 	output_data[2]   	<=  input_data;
		5: 	output_data[3]   	<=  input_data;
		6: 	output_data[4]   	<=  input_data;
		7: 	output_data[5]   	<=  input_data;
		8: 	output_data[6]   	<=  input_data;
		9: 	output_data[7]   	<=  input_data;
		10: break           <=  1'b1; 					//Parity bit
		11: break           <=  1'b0; 					//Ending bit
	endcase

 	if(count <= 10)
 		count <= count + 1;
 	else if(count == 11)
 		count <= 1;

end
endmodule
//============================ Receive the data from keyboard ================== END ========

//============================ Display the read data ================== Start ========
/*always@(posedge break) // Printing data obtained to led lights
begin
	if(d_current==8'hf0)
	begin
		case(d_previous)
			8'h16: led <= 4'b1110;  //1
			8'h1E: led <= 4'b1101; //2
			8'h26: led <= 4'b1100; //3
			8'h25: led <= 4'b1011; //4
			8'h2E: led <= 4'b1010; //5
			8'h36: led <= 4'b1001; //6
			8'h3D: led <= 4'b1000; //7
			8'h3E: led <= 4'b0111; //8
			8'h46: led <= 4'b0110; //9
			8'h45: led <= 4'b1111; //10
		default: led <= 4'b0000; // diaplay all lights high when any other key is pressed
endcase
end
 else
 d_previous<=d_current;
//============================ Display the read data ================== END ========
end */
