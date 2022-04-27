//Writen By: Joe Barchanowicz
//Traffic Control Systems

`timescale 1 s / 100 ms

//Traffic Signal Delays
`define G2YDELAY_MAIN 	40	 	//green to yellow delay(main street)
`define G2YDELAY_SIDE 	30		//green to yellow delay(side street)	
`define G2YDELAY_ARROW	20		//green to yellow delay(Arrow)
`define Y2RDELAY	 	5		//yellow to red delay(main street)
`define R2GDELAY 		5 		//red to green delay

//Walk Signal Delays
`define WDELAY			10		//WALK Signal delay

//ms = main street
//turn_ms_sensor = turning sensor main street
//ss = side street
//walk_ms_sensor = walk main street sensor
//wm = walk main signal
//walk_ss_sensor = walk side street sensor
//ws = walk side signal

module traf(ms_1, ms_2, ss_1, ss_2, wm, ws, turn_ms_sensor, walk_ms_sensor, walk_ss_sensor, CLK, RST);
	
	//ports
	output reg [4:0] ms_1, ms_2;
	output reg [2:0] ss_1, ss_2;
	output reg wm, ws;

	input turn_ms_sensor, walk_ms_sensor, walk_ss_sensor;
	input CLK, RST;

	parameter MAIN_RED = 5'b00100;
	parameter MAIN_YELLOW = 5'b00010;
	parameter MAIN_GREEN = 5'b00001;
	parameter MAIN_YELLOW_ARROW = 5'b01000;
	parameter MAIN_GREEN_ARROW = 5'b10000;
	parameter SIDE_RED = 3'b100;
	parameter SIDE_YELLOW = 3'b010;
	parameter SIDE_GREEN = 3'b001;
	
	
	//STATE definition 				ms1			ms2			ss1			ss2			wms		wss
	parameter S0 = 4'b0000;		//	Main_Red	Main_Red	Side_Red	Side_Red	off		off
	parameter S1 = 4'b0001;		//	Main_Green	Main_Green	Side_Red	Side_Red	off		off
	parameter S2 = 4'b0010;		//	Main_Yellow	Main_Yellow	Side_Red	Side_Red	off		off
	parameter S3 = 4'b0011;		//	Main_Red	Main_Red	Side_Red	Side_Red	off		off
	parameter S4 = 4'b0100;		//	Main_Red	Main_Red	Side_Green	Side_Green	off		off
	parameter S5 = 4'b0101;		//	Main_Red	Main_Red	Side_Yellow	Side_Yellow	off		off
	parameter S6 = 4'b0110;		//	Main_Red	Main_Red	Side_Red	Side_Red	off		off
	parameter S7 = 4'b0111;		// 	Main_G_A	Main_G_A	Side_Red	Side_Red	off		off
	parameter S8 = 4'b1000;  	//  Main_Y_A	Main_Y_A	Side_Red	Side_Red	off		off
	parameter S9 = 4'b1001;		//	Main_Green	Main_Green	Side_Red	Side_Red	off		on/off
	parameter S10= 4'b1010;		//	Main_Red	Main_Red	Side_Green	Side_Green	on/off	off
	
	//Internal state variables
	reg [3:0] state;
	reg [3:0] next_state;
	
	always @(posedge CLK)
		if(RST)
			state <= S0; // Controller starts in S0 state
		else
			state <= next_state;
	
	always @(state) begin
		ms_1 = MAIN_RED; ms_2 = MAIN_RED;
		ss_1 = SIDE_RED; ss_2 = SIDE_RED;
		wm = 0; ws = 0; 
		case(state)
			S0: begin
					ms_1 = MAIN_RED;
					ms_2 = MAIN_RED;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S1: begin
					ms_1 = MAIN_GREEN;
					ms_2 = MAIN_GREEN;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S2: begin
					ms_1 = MAIN_YELLOW;
					ms_2 = MAIN_YELLOW;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S3: begin
					ms_1 = MAIN_RED;
					ms_2 = MAIN_RED;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S4: begin
					ms_1 = MAIN_RED;
					ms_2 = MAIN_RED;
					ss_1 = SIDE_GREEN;
					ss_2 = SIDE_GREEN;
					wm = 0;
					ws = 0;
				end
			S5: begin
					ms_1 = MAIN_RED;
					ms_2 = MAIN_RED;
					ss_1 = SIDE_YELLOW;
					ss_2 = SIDE_YELLOW;
					wm = 0;
					ws = 0;
				end
			S6: begin 
					ms_1 = MAIN_RED;	
					ms_2 = MAIN_RED;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S7: begin
					ms_1 = MAIN_GREEN_ARROW;
					ms_2 = MAIN_GREEN_ARROW;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S8: begin
					ms_1 = MAIN_YELLOW_ARROW;
					ms_2 = MAIN_YELLOW_ARROW;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					wm = 0;
					ws = 0;
				end
			S9: begin
					ms_1 = MAIN_GREEN;
					ms_2 = MAIN_GREEN;
					ss_1 = SIDE_RED;
					ss_2 = SIDE_RED;
					ws = 1;
					wm = 0;
					#`WDELAY; ws = 0;
				end
			S10: begin
					ms_1 = MAIN_RED;
					ms_2 = MAIN_RED;
					ss_1 = SIDE_GREEN;
					ss_2 = SIDE_GREEN;
					ws = 0;
					wm = 1;
					#`WDELAY; wm = 0;
				end
		endcase
	end

	always @(state or turn_ms_sensor or walk_ms_sensor or walk_ss_sensor) begin
		case (state)
			S0: begin
					#`R2GDELAY;
					if (walk_ss_sensor)
						next_state = S9;
					else
						next_state = S1;
				end
			S1: begin
					#`G2YDELAY_MAIN;
					next_state = S2;
				end
			S2: begin
					#`Y2RDELAY;
					next_state = S3;
				end
			S3: begin
					#`R2GDELAY;
					if(walk_ms_sensor)
						next_state = S10;
					else
						next_state = S4;
				end
			S4: begin
					#`G2YDELAY_SIDE;
					next_state = S5;
				end
			S5: begin
					#`Y2RDELAY;
					if(turn_ms_sensor)
						next_state = S6;
					else
						next_state = S0; 
				end
			S6: begin
					#`R2GDELAY;
					next_state = S7;
				end
			S7: begin
					#`G2YDELAY_ARROW;
					next_state = S8;
				end
			S8: begin
					#`Y2RDELAY;
					next_state = S0;
				end
			S9: begin
					#`G2YDELAY_MAIN;
					next_state = S2;
				end
			S10: begin
					#`G2YDELAY_SIDE;
					next_state = S5;
				end
			default: next_state = S0;
		endcase
	end
endmodule
