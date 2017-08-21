/*
 *
 * Lab 2a: Testing
 *
 * This SystemVerilog file (and associated benchXX.sve file) contain a
 * set of "buggy" black-box modules that you will test for bugs. Your
 * task is to systematically test the modules and tell us which modules
 * contain the bugs and what they are.
 *
 * Note: you may NOT modify any of the modules named "Adder",
 * "Subtractor", or "Comparator". ALL OF YOUR TEST CODE MUST GO INTO THE
 * "test_design" MODULE!!
 *
 * The correct functionality of the top-level circuit is:
 *
 *    out = (a + b) < (c - d)
 *
 */


module system();
   logic [3:0] a, b, c, d;
   logic       out;

   top            dut(.*);
   test_design  bench(.*);

endmodule : system




module test_design
  (input  logic       out,
   output logic [3:0] a, b, c, d);

  initial begin
     $monitor($time,,"out=%b, a=%b, b=%b, c=%b, d=%b",out,a,b,c,d);
     a=4'b1111;
     b=4'b0000;
     c=4'b1111;
     d=4'b0000;
     #10 a=4'b0000;
     b=4'b0001;
     c=4'b0000;
     d=4'b0000;
     #10 a=4'b0000;
     b=4'b0000;
     c=4'b0001;
     d=4'b0000;
     #10 a=4'b0001;
     b=4'b0000;
     c=4'b0000;
     d=4'b0000;
     #10 a=4'b0101;
     b=4'b0110;
     c=4'b1010;
     d=4'b1001;




    // DO NOT USE ANY LOOPS

    // YOU SHOULD HAVE LESS THAN 50, CERTAINLY LESS THAN 100 TESTS

  end

endmodule : test_design



