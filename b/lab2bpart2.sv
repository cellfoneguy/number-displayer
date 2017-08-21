`default_nettype none

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
  (input logic[4:0] s1, s2, s3, s4, s5, s6, s7, s8,
    output logic allEqual);

  assign allEqual = (s1==s2) &&  (s2==s3) && (s3==s4) && (s4==s5) && (s5==s6)
                   && (s6==s7) && (s7==s8);

endmodule: allCompare

module testallCompare;
  logic[4:0] s1, s2, s3, s4, s5, s6, s7, s8;
  logic allEqual;

  allCompare dut(s1, s2, s3, s4, s5, s6, s7, s8, allEqual);

  initial begin
    $monitor($time, "s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b, s8=%b, allEqual=%b",
      s1, s2, s3, s4, s5, s6, s7, s8, allEqual);
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