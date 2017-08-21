`default_nettype none

module Comparator
  (input  logic [3:0] A, B, 
   output logic AeqB);
   assign AeqB = (A == B);
endmodule: Comparator

module ComparatorTester;
  logic [3:0] num1, num2;
  logic equal;
   
  Comparator test(num1, num2, equal);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, equal=%b",
    num1, num2, equal);
     //expect 0
     num1=4'b0000;
     num2=4'b0001;
     //expect 1
     #1num1=4'b0001;
     //expect 0
     #1num1=4'b1111;
     num2=4'b0000;
     //expect 1
     #1num2=4'b1111;
  end
endmodule: ComparatorTester

module BCDOneDigitAdd
  (input  logic [3:0] A, B, 
   input  logic       Cin, 
   output logic [3:0] Sum, 
   output logic       Cout);
   always_comb
     {Cout, Sum} = A + B + Cin;
endmodule: BCDOneDigitAdd

module BCDTester;
  logic [3:0] num1, num2, sum;
  logic Cin, Cout;
   
  BCDOneDigitAdd test(num1, num2, Cin, sum, Cout);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, Cin=%b, Cout=%b, sum=%b",
    num1, num2, Cin, Cout, sum);
     //expect (sum, Cout)
     //(0010, 0) testing basic addition
     num1=4'b0001;
     num2=4'b0001;
     Cin=0;
     //(0010, 0) testing Carryin
     #1num1=4'b0001;
     num2=4'b0000;
     Cin=1;
     //(1110, 1) testing Carryout
     #1num1=4'b1111;
     num2=4'b1111;
     Cin=0;
     //(1111, 1) testing Max Case
     #1num1=4'b1111;
     num2=4'b1111;
     Cin=1;
     //(0000, 0) testing Min case
     #1num1=4'b0000;
     num2=4'b0000;
     Cin=0;
  end
endmodule: BCDTester

module triAdd
  (input logic [3:0] A, B, C,
   output logic [3:0] sum1, sum2);
   logic C1, C2;
   logic [3:0] secsum;
   BCDOneDigitAdd add1(A, B, 1'b0, secsum, C1);
   BCDOneDigitAdd add2(secsum, C, 1'b0, sum2, C2);
   assign sum1 = {3'b000, C1} + {3'b000, C2};
endmodule:triAdd

module TriTester;
  logic [3:0] num1, num2, num3, sum1, sum2;
   
  triAdd test(num1, num2, num3, sum1, sum2);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, num3=%b, sum1=%b, sum2=%b",
    num1, num2, num3, sum1, sum2);
     //expect (sum1, sum2)
     //(0000, 1001) testing basic addition
     num1=4'b0001;
     num2=4'b0111;
     num3=4'b0001;
     //(0001, 1011) 3 9's, max row/col/diag caseworst case scenario
     #1num1=4'b1001;
     num2=4'b1001;
     num3=4'b1001;
     //(0000, 0110) min case for valid magic square
     #1num1=4'b0011;
     num2=4'b0010;
     num3=4'b0001;
     //(0001, 1000) max case for valid magic square
     #1num1=4'b1001;
     num2=4'b1000;
     num3=4'b0111;
  end
endmodule: TriTester

module Adder
  (input  logic [3:0] num1, num2, num3, //top row, L to R 
   input logic [3:0] num4, num5, num6, //middle row 
   input logic [3:0] num7, num8, num9, //bottom row
   output logic [3:0] sum1A, sum2A, sum3A, //rows
   output logic [3:0] sum4A, sum5A, sum6A, //cols
   output logic [3:0] sum7A, sum8A, //diagonals
   output logic [3:0] sum1B, sum2B, sum3B, //rows
   output logic [3:0] sum4B, sum5B, sum6B, //cols
   output logic [3:0] sum7B, sum8B); //diagonals
   triAdd a1(num1, num2, num3, sum1A, sum1B);
   triAdd a2(num4, num5, num6, sum2A, sum2B);
   triAdd a3(num7, num8, num9, sum3A, sum3B);
   triAdd a4(num1, num4, num7, sum4A, sum4B);
   triAdd a5(num2, num5, num8, sum5A, sum5B);
   triAdd a6(num3, num6, num9, sum6A, sum6B);
   triAdd a7(num1, num5, num9, sum7A, sum7B);
   triAdd a8(num3, num5, num7, sum8A, sum8B);
endmodule: Adder

module AdderTester;
   logic [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9;
   logic [3:0] sum1A, sum2A, sum3A;//rows
   logic [3:0] sum4A, sum5A, sum6A; //cols
   logic [3:0] sum7A, sum8A; //diagonals
   logic [3:0] sum1B, sum2B, sum3B;//rows
   logic [3:0] sum4B, sum5B, sum6B; //cols
   logic [3:0] sum7B, sum8B; //diagonals
   Adder test(num1, num2, num3,
	      num4, num5, num6, 
	      num7, num8, num9,
	      sum1A, sum2A, sum3A, 
	      sum4A, sum5A, sum6A,
	      sum7A, sum8A,
	      sum1B, sum2B, sum3B,
	      sum4B, sum5B, sum6B,
	      sum7B, sum8B);

  initial begin
    $monitor($time,, "%d, %d, %d\n%d, %d, %d\n%d, %d, %d\nrows=%d, %d, %d,\
%d, %d, %d\ncols=%d, %d, %d, %d, %d, %d\ndiag=%d, %d, %d, %d", 
	     num1, num2, num3,
	     num4, num5, num6, 
	     num7, num8, num9,
	     sum1A, sum1B, sum2A, sum2B, sum3A, sum3B,
	     sum4A, sum4B, sum5A, sum5B, sum6A, sum6B,
	     sum7A, sum7B, sum8A, sum8B);
     //testing given magic square
     num1=4'd8;
     num2=4'd1;
     num3=4'd6;
     num4=4'd3;
     num5=4'd5;
     num6=4'd7;
     num7=4'd4;
     num8=4'd9;
     num9=4'd2;
     //testing magic square from 
     // https://en.wikipedia.org/wiki/Magic_square
     #1num1=4'd2;
     num2=4'd7;
     num3=4'd6;
     num4=4'd9;
     num5=4'd5;
     num6=4'd1;
     num7=4'd4;
     num8=4'd3;
     num9=4'd8;
     //testing invalid max square
     #1num1=4'd9;
     num2=4'd9;
     num3=4'd9;
     num4=4'd9;
     num5=4'd9;
     num6=4'd9;
     num7=4'd9;
     num8=4'd9;
     num9=4'd9;
     //testing invalid min square
     #1num1=4'd1;
     num2=4'd1;
     num3=4'd1;
     num4=4'd1;
     num5=4'd1;
     num6=4'd1;
     num7=4'd1;
     num8=4'd1;
     num9=4'd1;
     //testing random invalid square
     #1num1=4'd1;
     num2=4'd2;
     num3=4'd3;
     num4=4'd4;
     num5=4'd5;
     num6=4'd6;
     num7=4'd7;
     num8=4'd8;
     num9=4'd9;
  end
endmodule: AdderTester

module validNumbers
  (input logic [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9,
   output logic valid);
  always_comb begin
    valid = 1;
    if(num1 < 1 || num1 > 9)begin
      valid = 0;
    end

    if(num2 < 1 || num2 > 9)begin
      valid = 0;
    end

    if(num3 < 1 || num3 > 9)begin
      valid = 0;
    end

    if(num4 < 1 || num4 > 9)begin
      valid = 0;
    end

    if(num5 < 1 || num5 > 9)begin
      valid = 0;
    end

    if(num6 < 1 || num6 > 9)begin
      valid = 0;
    end

    if(num7 < 1 || num7 > 9)begin
      valid = 0;
    end

    if(num8 < 1 || num8 > 9)begin
      valid = 0;
    end

    if(num9 < 1 || num9 > 9)begin
      valid = 0;
    end
  end
endmodule: validNumbers

module bin2BCD(input logic [7:0] bin, 
					output logic [3:0] sum1, sum2);

	always_comb begin
		if(bin>20) begin
			sum1=4'b0010;
			sum2=bin-20;
		end else if(bin>10) begin
			sum1=4'b0001;
			sum2=bin-10;
		end else begin
			sum1=0;
			sum2=bin;
		end
	end
					
endmodule:bin2BCD

module validNumbersTester;
  logic [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9;
  logic valid;

  validNumbers dut(num1, num2, num3, num4, num5, num6, num7, num8, num9, valid);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, num3=%b, num4=%b, num5=%b, num6=%b, num7=%b, num8=%b, num9=%b, valid=%b",
      num1, num2, num3, num4, num5, num6, num7, num8, num9, valid);

        num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=0; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=10;
    #10 num1=1; num2=1; num3=1; num4=1; num5=1; num6=1; num7=1; num8=1; num9=1;
    #10 $finish;
  end
endmodule: validNumbersTester

module decoder
  (input logic[3:0] num,
   output logic[8:0] oneHot);
  always_comb
    case(num)
      4'b0001: oneHot = 9'b0_0000_0001;
      4'b0010: oneHot = 9'b0_0000_0010;
      4'b0011: oneHot = 9'b0_0000_0100;
      4'b0100: oneHot = 9'b0_0000_1000;
      4'b0101: oneHot = 9'b0_0001_0000;
      4'b0110: oneHot = 9'b0_0010_0000;
      4'b0111: oneHot = 9'b0_0100_0000;
      4'b1000: oneHot = 9'b0_1000_0000;
      4'b1001: oneHot = 9'b1_0000_0000;
      default: oneHot = 9'b0_0000_0000;
    endcase
endmodule: decoder

module decoderTester;
  logic [3:0] num;
  logic [8:0] oneHot;

  decoder dut(num, oneHot);

  initial begin
    $monitor($time,, "num=%b, oneHot=%b", num, oneHot);
        num = 4'b0001;
    #10 num = 4'b0010;
    #10 num = 4'b0011;
    #10 num = 4'b0100;
    #10 num = 4'b0101;
    #10 num = 4'b0110;
    #10 num = 4'b0111;
    #10 num = 4'b1000;
    #10 num = 4'b1001;
    #10 $finish;
  end
endmodule: decoderTester

module uniqueNumbers
  (input logic[3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9,
   output logic allUnique);

  logic [8:0] check;
  logic [8:0] d1, d2, d3, d4, d5, d6, d7, d8, d9;
  decoder dec1(num1, d1);
  decoder dec2(num2, d2);
  decoder dec3(num3, d3);
  decoder dec4(num4, d4);
  decoder dec5(num5, d5);
  decoder dec6(num6, d6);
  decoder dec7(num7, d7);
  decoder dec8(num8, d8);
  decoder dec9(num9, d9);
  always_comb begin
    check = d1|d2|d3|d4|d5|d6|d7|d8|d9;
    if(check == 9'b1_1111_1111) begin
      allUnique = 1;
    end else begin
      allUnique = 0;
    end
  end
endmodule: uniqueNumbers

module uniqueNumbersTester;
  logic[3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9;
  logic allUnique;

  uniqueNumbers dut (num1, num2, num3, num4, num5, num6, num7, num8, num9,
                     allUnique);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, num3=%b, num4=%b, num5=%b, num6=%b, num7=%b, num8=%b, num9=%b, allUnique=%b",
    num1, num2, num3, num4, num5, num6, num7, num8, num9, allUnique);
        num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=1; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=8;
    #10 num1=1; num2=1; num3=1; num4=1; num5=1; num6=1; num7=1; num8=1; num9=1;
    #10 $finish;
  end
endmodule: uniqueNumbersTester

module allCompare
  (input logic[3:0] s1, s2, s3, s4, s5, s6, s7, s8,
   output logic[3:0] sum,
   output logic allEqual);

   assign allEqual = (s1==s2) &&  (s2==s3) && (s3==s4) && (s4==s5) && (s5==s6)
                   && (s6==s7) && (s7==s8);
   assign sum = s1;

endmodule: allCompare

module testallCompare;
  logic[3:0] s1, s2, s3, s4, s5, s6, s7, s8, sum;
  logic allEqual;

  allCompare dut(s1, s2, s3, s4, s5, s6, s7, s8, sum, allEqual);

  initial begin
    $monitor($time, "s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b, s8=%b, sum=%b, allEqual=%b",
      s1, s2, s3, s4, s5, s6, s7, s8, sum, allEqual);
        s1=6; s2=6; s3=6; s4=6; s5=6; s6=6; s7=6; s8=6;
    #10 s1=6; s2=6; s3=6; s4=6; s5=6; s6=6; s7=6; s8=7;
    #10 s1=1; s2=2; s3=6; s4=6; s5=6; s6=6; s7=6; s8=6;
    #10 $finish;
  end
endmodule: testallCompare

module legalBoard
  (input[3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9,
    output legal);

  logic val;
  logic uni;
  validNumbers valid(num1, num2, num3, num4, num5, num6, num7, num8, num9, val);
  uniqueNumbers uniqu(num1, num2, num3, num4, num5, num6, num7, num8, num9, uni);

  assign legal = val && uni;

endmodule: legalBoard

module legalBoardTester;
  logic[3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9;
  logic legal;

  legalBoard dut(num1, num2, num3, num4, num5, num6, num7, num8, num9, legal);

  initial begin
    $monitor($time,, "num1=%b, num2=%b, num3=%b, num4=%b, num5=%b, num6=%b, num7=%b, num8=%b, num9=%b, legal =%b",
      num1, num2, num3, num4, num5, num6, num7, num8, num9, legal);
        num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=1; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=8;
    #10 num1=1; num2=1; num3=1; num4=1; num5=1; num6=1; num7=1; num8=1; num9=1;
    #10 num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=0; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=9;
    #10 num1=1; num2=2; num3=3; num4=4; num5=5; num6=6; num7=7; num8=8; num9=10;
    #10 num1=1; num2=1; num3=1; num4=1; num5=1; num6=1; num7=1; num8=1; num9=1;
    #10 $finish;
  end
endmodule: legalBoardTester

module isMagicShell
  (input  logic [3:0] num1, num2, num3, //top row, L to R 
   input  logic [3:0] num4, num5, num6, //middle row 
   input  logic [3:0] num7, num8, num9, //bottom row 
   output logic [3:0] sum1, sum2,  //sum1 is most significant 
   output logic       it_is_magic);
   logic [3:0] 	      sum1A, sum2A, sum3A; //rows
   logic [3:0] 	      sum4A, sum5A, sum6A; //cols
   logic [3:0] 	      sum7A, sum8A; //diagonals
   logic [3:0] 	      sum1B, sum2B, sum3B; //rows
   logic [3:0] 	      sum4B, sum5B, sum6B; //cols
   logic [3:0] 	      sum7B, sum8B; //diagonals
   logic 	      legal, equalH, equalL;
	logic [3:0]				sum1bin, sum2bin;
   legalBoard leg(num1, num2, num3, num4, num5, num6, num7, num8, num9, legal);
	Adder add(num1, num2, num3,
	      num4, num5, num6, 
	      num7, num8, num9,
	      sum1A, sum2A, sum3A, 
	      sum4A, sum5A, sum6A,
	      sum7A, sum8A,
	      sum1B, sum2B, sum3B,
	      sum4B, sum5B, sum6B,
	      sum7B, sum8B);
   allCompare high(sum1A, sum2A, sum3A, sum4A, sum5A, sum6A, sum7A, sum8A, sum1bin, equalH);
   allCompare low(sum1B, sum2B, sum3B, sum4B, sum5B, sum6B, sum7B, sum8B, sum2bin, equalL);
	bin2BCD bcd({sum1bin, sum2bin}, sum1, sum2);
   assign it_is_magic = legal && equalH && equalL;
endmodule: isMagicShell

module IsMagic 
  (input  logic [3:0] num1, num2, num3, //top row, L to R 
   input  logic [3:0] num4, num5, num6, //middle row 
   input  logic [3:0] num7, num8, num9, //bottom row 
   output logic [3:0] sum1, sum2,  //sum1 is most significant 
   output logic       it_is_magic);
   isMagicShell Shell(num1, num2, num3, num4, num5, num6, num7, num8, num9, sum1, sum2, it_is_magic);
endmodule:IsMagic

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
   output logic[6:0] segment);

  logic [6:0] decoded;

  BCDtoSevenSegment b2ss(bcd, decoded);
  //outputs code for blank if blank is 0
  assign segment = decoded;
endmodule: SevenSegmentDigit

module enter_9_bcd
  (input  logic [3:0] entry,
   input  logic [3:0] selector,
   input  logic       enableL, zeroL, set_defaultL, clock,
   output logic [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9);

  always_ff @(posedge clock) begin
    if (~zeroL) begin
      num1 <= 4'b0000;
      num2 <= 4'b0000;
      num3 <= 4'b0000;
      num4 <= 4'b0000;
      num5 <= 4'b0000;
      num6 <= 4'b0000;
      num7 <= 4'b0000;
      num8 <= 4'b0000;
      num9 <= 4'b0000;
    end
    else if (~set_defaultL) begin
      num1 <= 4'b1000;
      num2 <= 4'b0001;
      num3 <= 4'b0110;
      num4 <= 4'b0011;
      num5 <= 4'b0101;
      num6 <= 4'b0111;
      num7 <= 4'b0100;
      num8 <= 4'b1001;
      num9 <= 4'b0010;
    end
    else if (~enableL)
    unique case (selector)
      4'b0001: num1 <= entry;
      4'b0010: num2 <= entry;
      4'b0011: num3 <= entry;
      4'b0100: num4 <= entry;
      4'b0101: num5 <= entry;
      4'b0110: num6 <= entry;
      4'b0111: num7 <= entry;
      4'b1000: num8 <= entry;
      4'b1001: num9 <= entry;
    endcase
  end

endmodule: enter_9_bcd

module ChipInterface
  (output logic [6:0] HEX7, HEX6, // sum1, sum2
                      HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
   output logic [7:0] LEDG,
   input logic [17:0] SW,
   input logic [3:0] KEY,
   input logic CLOCK_50); // needed for enter_9_bcd

  logic [3:0] num1, num2, num3,
              num4, num5, num6,
              num7, num8, num9;
  logic [3:0] sum1, sum2, test1, test2;
  logic       it_is_magic;
  
  enter_9_bcd e(.entry(SW[3:0]),
                .selector(SW[7:4]),
                .enableL(KEY[0]),
                .zeroL(KEY[2]),
                .set_defaultL(KEY[1]),
                .clock(CLOCK_50),
                .*);

  IsMagic im(num1, num2, num3,
             num4, num5, num6,
             num7, num8, num9,
             sum1, sum2, 
             it_is_magic);

  //my code
  always_comb begin

    LEDG[0] = it_is_magic;
    LEDG[1] = it_is_magic;
    LEDG[2] = it_is_magic;
    LEDG[3] = it_is_magic;
    LEDG[4] = it_is_magic;
    LEDG[5] = it_is_magic;
    LEDG[6] = it_is_magic;
    LEDG[7] = it_is_magic;
  end


  SevenSegmentDigit ss0 (sum1, HEX7);
  SevenSegmentDigit ss1 (sum2, HEX6);
  /*SevenSegmentDigit ss0 (num1, HEX7);
  SevenSegmentDigit ss1 (num2, HEX6);
  SevenSegmentDigit ss3 (num3, HEX5);
  SevenSegmentDigit ss4 (num4, HEX4);
  SevenSegmentDigit ss5 (num5, HEX3);
  SevenSegmentDigit ss6 (num6, HEX2);
  SevenSegmentDigit ss7 (num7, HEX1);
  SevenSegmentDigit ss8 (num8, HEX0);*/
  
// Output it_is_magic to all 8 bits of LEDG
// Display sum1 and sum2 on the 7 segment display
endmodule : ChipInterface
