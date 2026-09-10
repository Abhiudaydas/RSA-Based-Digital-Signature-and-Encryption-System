`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/16/2025 03:22:38 AM
// Design Name:
// Module Name: rsa_calculator_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module rsa_calculator_tb;


    // Inputs
    reg [31:0] e;
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] m;

    // Outputs
    wire [31:0] d;
    wire [31:0] c;
    wire [31:0] dec;

    // Instantiate the design under test
    rsa_calculator uut (
        .e(e),
        .a(a),
        .b(b),
        .m(m),
        .d(d),
        .c(c),
        .dec(dec)
    );

    initial begin
        $display("Starting simulation...");

        // Test Case 1
        e = 65537;
        a = 463;
        b = 671;
        m = 47;
        #10;

        $display("Inputs: e=%0d, a=%0d, b=%0d, m=%0d", e, a, b, m);
        $display("Outputs: d=%0d, c=%0d, dec=%0d", d, c, dec);

        // Check correctness
        if (dec == m)
            $display("Test Passed : Message decrypted correctly.");
        else
            $display("Test Failed : Decrypted message does not match original.");

        #10 $finish;
    end

endmodule