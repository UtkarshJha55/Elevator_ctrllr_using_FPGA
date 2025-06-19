`timescale 1ns/1ns
module tb_elevator();
	reg clk, emer, gnd_b, third_b;
	reg [1:0] floor_set, one, two;
	wire [1:0] floor;
	wire emergency, door_led;
	wire [6:0] seg;
	wire [3:0] led_floor;
	controller uut(clk, floor_set, emer, gnd_b, one, two, third_b, floor, emergency, door_led, led_floor, seg);
	initial clk = 0;
	always #10 clk = ~clk;
	initial begin
		emer = 0; gnd_b = 0; one = 0; two = 0; third_b = 0;
		floor_set = 0;
		#20 floor_set = 2'b10;
		#100 floor_set = 2'b11;
		#100 one = 1;
		#100 one = 0; floor_set = 2'b00;
		#100 emer = 1;
		#100 emer = 0; two = 1;
		#100 two = 0; 
		#100 floor_set = 2'b01; 
		#60  $finish;
	end
endmodule
