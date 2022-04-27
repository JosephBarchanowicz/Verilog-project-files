/*
Written By: Joe Barchanowicz
scaleable multiplexer Test Bench
*/

`timescale 1 ns / 1 ns

module scale_mux_tb();
parameter Size = 6;

wire OUT1;		//size 1
reg A1, B1;
reg SEL;

wire [3:0] OUT4;	//size 4
reg [3:0] A4, B4;

wire [4:0] OUT5;	//size 5
reg [4:0] A5, B5;

wire [Size-1:0] OUT6;	//size 6
reg [Size-1:0] A6, B6;

//scale_mux Instantiation
scale_mux  mux1(A1, B1, SEL, OUT1);		//using default parameter size
scale_mux #(.SIZE(4)) mux4(A4, B4, SEL, OUT4);	//using .SIZE method to change the parameter 
defparam mux5.SIZE = 5;				//using defparam method
scale_mux mux5(A5, B5, SEL, OUT5);
scale_mux #(Size) mux6(A6, B6, SEL, OUT6);	//using a test bench parameter

initial 
  $monitor("SEL = %b \nSize = 1 | A1 = %b B1 = %b OUT1 = %b \nSize = 4 | A4 = %b B4 = %b OUT4 = %b \nSize = 5 | A5 = %b B5 = %b OUT5 = %b \nSize = 6 | A6 = %b B6 = %b OUT6 = %b \n", SEL,A1,B1,OUT1,A4,B4,OUT4,A5,B5,OUT5,A6,B6,OUT6);

  initial begin
    $vcdpluson;
   
    $display("Select = 0");
    SEL = 1'b0;
    A1 = 1'b1; B1 = 1'b0;
    A4 = 4'b1100; B4 = 4'b0011;
    A5 = 5'b11100; B5 = 5'b00011;
    A6 = 6'b111000; B6 = 6'b000111;

    #20 $display("Select = 1");
    SEL = 1'b1;
    A1 = 1'b1; B1 = 1'b0;
    A4 = 4'b1100; B4 = 4'b0011;
    A5 = 5'b11100; B5 = 5'b00011;
    A6 = 6'b111000; B6 = 6'b000111;

    #20 $display("Select = x (A != B)");
    SEL = 1'bx;
    A1 = 1'b1; B1 = 1'b0;
    A4 = 4'b1100; B4 = 4'b0011;
    A5 = 5'b11100; B5 = 5'b00011;
    A6 = 6'b111000; B6 = 6'b000111;

    #20 $display("Select = x(A = B)");
    SEL = 1'bx;
    A1 = 1'b0; B1 = 1'b0;
    A4 = 4'b1100; B4 = 4'b1100;
    A5 = 5'b11100; B5 = 5'b11100;
    A6 = 6'b111000; B6 = 6'b111000;

    #20 $display("Select = x(A shares bits with B)");
    SEL = 1'bx;
    A1 = 1'b1; B1 = 1'b1;
    A4 = 4'b1011; B4 = 4'b1010;
    A5 = 5'b11111; B5 = 5'b00111;
    A6 = 6'b111000; B6 = 6'b001100;

    #40 $finish;
  end
endmodule
    
