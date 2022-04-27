/*
Written By: Joe Barchanowicz
scaleable multiplexer
*/

`timescale 1 ns / 1 ns

module scale_mux(A, B, SEL, OUT);

//port delarations
	parameter SIZE = 1; //default parameter size
	
	output reg [SIZE-1:0] OUT;
	input [SIZE-1:0] A, B;
	input SEL;
	integer i;	//dummy variable used for loop operations	

	always @ (A or B or SEL)
	begin
	  if (SEL == 0)		//SEL = 0
	    OUT = A;
	  else if (SEL ==1)	//SEL = 1
	    OUT = B;
	  else			//SEL = x
	    for (i = 0; i < SIZE; i = i +1)	 
	      begin
		if (A[i] == B[i])
		  OUT[i] = A[i];
		else
		  OUT[i] = 1'bx; 
	      end
	end 
	  
endmodule

