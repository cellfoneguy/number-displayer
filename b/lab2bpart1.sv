`default_nettype none

module Comparator
  (input  logic [3:0] A, B, 
   output logic AeqB);
   assign AeqB = (A == B);
endmodule: Comparator

module BCDOneDigitAdd
  (input  logic [3:0] A, B, 
   input  logic       Cin, 
   output logic [3:0] Sum, 
   output logic       Cout);
   always_comb
     {Cout, Sum} = A + B + Cin;
endmodule: BCDOneDigitAdd

module triAdd
  (input logic [3:0] A, B, C,
   output logic [3:0] sum1, sum2);
   logic C1, C2;
   logic [3:0] secsum;
   BCDOneDigitAdd add1(A, B, 1'b0, secsum, C1);
   BCDOneDigitAdd add2(secsum, C, 1'b0, sum2, C2);
   assign sum1 = {2'b00, C1} + {2'b00, C2};
endmodule:triAdd

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

module isMagicShell
  (input  logic [3:0] num1, num2, num3, //top row, L to R 
   input  logic [3:0] num4, num5, num6, //middle row 
   input  logic [3:0] num7, num8, num9, //bottom row 
   output logic [3:0] sum1, sum2,  //sum1 is most significant 
   output logic       it_is_magic);
endmodule: isMagicShell

