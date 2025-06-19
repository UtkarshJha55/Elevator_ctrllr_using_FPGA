`timescale 1ns/1ns
module controller(clk, floor_set, emer, gnd_b, one, two, third_b, floor, emergency, door_led, led_floor, seg);
input clk;
input[1:0] floor_set; //4 floors
input gnd_b, third_b; // ground and third floor buttons
input [1:0] one, two; // UP and DOWN 
input emer; //Emergency key
		//output is display on 7 segment
reg[1:0] curr_floor, next_floor, out_floor;
reg toggle, button; //emergency blink
initial toggle = 0;
output reg [1:0] floor; //floor display
output reg emergency, door_led;
output reg [3:0] led_floor;
output reg [6:0] seg;
parameter [1:0] ground = 2'b00,
					 first = 2'b01,
					 second = 2'b10,
					 third = 2'b11;
 
//next stage logic
always @(posedge clk) begin
	curr_floor <= next_floor;
	//door <= 0;
	if (curr_floor != next_floor) begin
		door_led <= 1; count <= 0;
		end
	else if(button) begin
		count <= count + 1; end
	else begin
		door_led <= 0;
		count <= 0; end
	if (emer) begin
        toggle <= ~toggle;
        emergency <= toggle;
		  door_led <= 1;
    end 
	 else
        emergency <= 0;
	if(count == 1) 
		door_led <= count;
	end
//output logic

always @(*) begin
	case (curr_floor)
	ground: begin
		$display("current floor: ground");
		if(floor_set == ground) begin
			next_floor <= ground;
		 end
		else if(floor_set == first) begin
			$display("next_floor : first");
			next_floor <= first;
			end
		else if(floor_set == second) begin
			$display("next_floor : second");
			next_floor <= second;
			end
		else if(floor_set == third) begin
			$display("next_floor : third");
			next_floor <= third;
			end
		else if(emer) begin
			next_floor <= first;
			led_floor = 4'b0001;
			end
		end
	first: begin
		$display("current floor: first");
		if(floor_set == ground) begin
			next_floor <= ground;
			end
		else if(floor_set == first) begin
			$display("next_floor : first");
			next_floor <= first;
			end
		else if(floor_set == second) begin
			$display("next_floor : second");
			next_floor <= second;
			end
		else if(floor_set == third) begin
			$display("next_floor : third");
			next_floor <= third;
			end
		else if(emer) begin
			next_floor <= second;
			end
		end
	second: begin
		$display("current floor: second");
		if(floor_set == ground) begin
			next_floor <= ground;
			end
		else if(floor_set == first) begin
			$display("next_floor : first");
			next_floor <= first;
			end
		else if(floor_set == second) begin
			$display("next_floor : second");
			next_floor <= second;
			end
		else if(floor_set == third) begin
			$display("next_floor : third");
			next_floor <= third;
			end
		else if(emer) begin
			next_floor <= third;
			end
		end
	third: begin
		$display("current floor: third");
		if(floor_set == ground) begin
			next_floor <= ground;
			end
		else if(floor_set == first) begin
			$display("next_floor : first");
			next_floor <= first;
			end
		else if(floor_set == second) begin
			$display("next_floor : second");
			next_floor <= second;
			end
		else if(floor_set == third) begin
			$display("next_floor : third");
			next_floor <= third;
			end
		else if(emer) begin
			next_floor <= third;
			end
		end
		default: begin
		next_floor <= ground; 
		end
	endcase
	if(gnd_b == 1 || one == 2'b01 || one == 2'b10|| two == 2'b01 || two == 2'b10 || third_b == 1) begin
		button <= (emer)?0:1;
		if(gnd_b) begin
			out_floor <= ground;  end
		else if (one) 	begin
			out_floor <= first;  end
		else if (two) 	begin
			out_floor <= second; end
		else 				begin
			out_floor <= third; end
	end
	else button <= 0;
	floor <= (button)?out_floor:next_floor;
	if(floor == 0) begin
		seg <= 7'b0000001;
		led_floor <= 4'b0001; end
	else if(floor == 2'b01) begin
		seg <= 7'b1001111;
		led_floor <= 4'b0010; end
	else if(floor == 2'b10) begin
		seg <= 7'b1001111;
		led_floor <= 4'b0100; end
	else if(floor == 2'b11) begin
		seg <= 7'b0000110;
		led_floor <= 4'b1000; end
	end
endmodule
