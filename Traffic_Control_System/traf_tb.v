//Writen By: Joe Barchanowicz
//Traffic Control Systems Test Bench

`timescale 1s / 100 ms
module traf_tb();

wire [4:0] MAIN_1, MAIN_2;
wire [2:0] SIDE_1, SIDE_2;
reg WALK_SS_SENSOR, WALK_MS_SENSOR, TURN_SENSOR;
reg CLK, RST;

traf UUT(MAIN_1, MAIN_2, SIDE_1, SIDE_2, WALK_MAIN, WALK_SIDE, TURN_SENSOR, WALK_MS_SENSOR, WALK_SS_SENSOR, CLK, RST);

initial
	$monitor("%d: Main(N) = %b, Main(S) = %b | Side(E) = %b, Side(W) = %b | Walk Main = %b, Walk Side = %b | TURN(SENS) = %b, Walk Main(SENS) = %b, Walk Side(Sens) = %b | Reset = %b",$time, MAIN_1, MAIN_2, SIDE_1, SIDE_2, WALK_MAIN, WALK_SIDE, TURN_SENSOR, WALK_MS_SENSOR, WALK_SS_SENSOR, RST);

initial begin
	CLK = 1'b0;
	forever #5 CLK=~CLK;
end

initial begin
	RST = 1'b1;
	#5 RST = 1'b0;
end

initial begin
	$vcdpluson;	

	$display("\nNormal Operation test\n");
	TURN_SENSOR = 1'b0; WALK_SS_SENSOR = 1'b0; WALK_MS_SENSOR = 1'b0;
		
	#200 $display("\nTurn Sensor Activated\n");	
	TURN_SENSOR = 1'b1;

	#200 $display("\nTurn Sensor Deactivated, Return to normal operation\n");
	TURN_SENSOR = 1'b0;

	#50 $display("\nWalk Main Street Sensor Activated\n");
	WALK_MS_SENSOR = 1'b1;

	#200 $display("\nWalk Main Street Sensor Deactivated, normal operation\n");
	WALK_MS_SENSOR = 1'b0;

	#50 $display ("\nWalk Side Street Sensor Activated\n");
	WALK_SS_SENSOR = 1'b1;

	#200 $display ("\nWalk Sisde street sensor deactivated, normal operation\n");
	WALK_SS_SENSOR = 1'b0;

	#50 $display ("\nALL sensors activated\n");
	TURN_SENSOR = 1'b1; WALK_MS_SENSOR = 1'b1; WALK_SS_SENSOR = 1'b1;

	#200 $display("\nALL sesors deactivated, normal operation\n");
	TURN_SENSOR = 1'b0; WALK_MS_SENSOR = 1'b0; WALK_SS_SENSOR = 1'b0;

	#200 $display("\nSystem Reset test\n");
	RST = 1'b1;
	#5 RST = 1'b0;
	#40 RST = 1'b1;
	
	#5 $display ("\nNormal Operation test\n");
	RST = 1'b0;
	
	#150 $finish;
end
endmodule
