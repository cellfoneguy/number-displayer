`default_nettype none

module BCDtoSevenSegment
  (input logic [3:0] bcd,
   output logic [6:0] segment);
  //map bcd input to segment output
  always_comb
    case({bcd})
      4'b0000: segment =  7'b100_0000;
      4'b0001: segment =  7'b111_1001;
      4'b0010: segment =  7'b010_0100;
      4'b0011: segment =  7'b011_0000;
      4'b0100: segment =  7'b001_1001;
      4'b0101: segment =  7'b001_0010;
      4'b0110: segment =  7'b000_0010;
      4'b0111: segment =  7'b111_1000;
      4'b1000: segment =  7'b000_0000;
      4'b1001: segment =  7'b001_1000;
      default: segment =  7'b111_1111;
    endcase

endmodule: BCDtoSevenSegment


module SevenSegmentDigit
  (input logic[3:0] bcd,
   output logic[6:0] segment,
   input logic blank);

  logic [6:0] decoded;

  BCDtoSevenSegment b2ss(bcd, decoded);
  //outputs code for blank if blank is 0
  assign segment = (blank) ? decoded:7'b111_1111;
endmodule: SevenSegmentDigit


//FPGA interface
module ChipInterface
  (output logic [6:0]  HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
   input  logic [17:0] SW,
   input  logic [2:0]  KEY);

  logic [3:0] b0,b1,b2,b3,b4,b5,b6,b7;
  //generic value if not selected by key, specific otherwise
  always_comb begin
    b0=SW[7:4];
    b1=SW[7:4];
    b2=SW[7:4];
    b3=SW[7:4];
    b4=SW[7:4];
    b5=SW[7:4];
    b6=SW[7:4];
    b7=SW[7:4];
    case ({!KEY[2],!KEY[1],!KEY[0]})
      3'b000: b0 = SW[3:0];
      3'b001: b1 = SW[3:0];
      3'b010: b2 = SW[3:0];
      3'b011: b3 = SW[3:0];
      3'b100: b4 = SW[3:0];
      3'b101: b5 = SW[3:0];
      3'b110: b6 = SW[3:0];
      3'b111: b7 = SW[3:0];
    endcase
  end
  SevenSegmentControl ssc(HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
                          b7,b6,b5,b4,b3,b2,b1,b0,
                          SW[17:10]);
endmodule: ChipInterface


//Control for 7 seven segment displays
module SevenSegmentControl
  (output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
   input logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0,
   input logic [7:0] turn_on);

  SevenSegmentDigit ssd0(BCD0,HEX0,turn_on[0]);
  SevenSegmentDigit ssd1(BCD1,HEX1,turn_on[1]);
  SevenSegmentDigit ssd2(BCD2,HEX2,turn_on[2]);
  SevenSegmentDigit ssd3(BCD3,HEX3,turn_on[3]);
  SevenSegmentDigit ssd4(BCD4,HEX4,turn_on[4]);
  SevenSegmentDigit ssd5(BCD5,HEX5,turn_on[5]);
  SevenSegmentDigit ssd6(BCD6,HEX6,turn_on[6]);
  SevenSegmentDigit ssd7(BCD7,HEX7,turn_on[7]);

endmodule: SevenSegmentControl


//test module for binary to seven segment
/*
module b2ssTester(input logic [6:0]segment,
        output logic [3:0] bcd);

  initial begin
    $monitor($time,, "bcd=%b, segment=%b", bcd, segment);
        bcd=0;
    #10 bcd=1;
    #10 bcd=2;
    #10 bcd=3;
    #10 bcd=4;
    #10 bcd=5;
    #10 bcd=6;
    #10 bcd=7;
    #10 bcd=8;
    #10 bcd=9;
    #10 bcd=10;
    #10 $finish;
  end

endmodule: b2ssTester


module top;
  logic [3:0] bcd;
  logic [6:0] segment;

  BCDtoSevenSegment foo(.*);
  b2ssTester t(.*);

endmodule: top
*/
