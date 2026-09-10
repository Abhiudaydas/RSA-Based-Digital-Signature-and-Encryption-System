module rsa_calculator(

 

    input [31:0] e,
    input [31:0] a,
    input [31:0] b,
    input [31:0] m,
    output reg [63:0] d,
    output reg [63:0] c,
    output reg [63:0] dec
);

    reg [63:0] phi;
    reg [63:0] n;

    // Modular exponentiation by squaring
    function [63:0] mod_exp;
        input [63:0] base;
        input [63:0] exponent;
        input [63:0] modulus;
        reg [63:0] result;
        reg [63:0] b;
        reg [63:0] e;
        begin
            result = 1;
            b = base % modulus;
            e = exponent;
            while (e > 0) begin
                if (e[0] == 1)
                    result = (result * b) % modulus;
                e = e >> 1;
                b = (b * b) % modulus;
            end
            mod_exp = result;
        end
    endfunction

    // Modular inverse using Extended Euclidean Algorithm
    function [63:0] modinv;
        input [63:0] e;
        input [63:0] phi;
        reg signed [63:0] t, new_t;
        reg signed [63:0] r, new_r;
        reg signed [63:0] quotient, temp;
        begin
            t = 0; new_t = 1;
            r = phi; new_r = e;

            while (new_r != 0) begin
                quotient = r / new_r;

                temp = t - quotient * new_t;
                t = new_t;
                new_t = temp;

                temp = r - quotient * new_r;
                r = new_r;
                new_r = temp;
            end

            if (r > 1)
                modinv = 0;  // No inverse
            else if (t < 0)
                modinv = t + phi;
            else
                modinv = t;
        end
    endfunction

    always @(*) begin
        n = a * b;
        phi = (a - 1) * (b - 1);

        d = modinv(e, phi);
        c = mod_exp(m, e, n);
        dec = mod_exp(c, d, n);
    end

endmodule