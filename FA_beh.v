`timescale 1ns/1ns

module FA_beh(input x, input y, input cin, output s, output cout);
    // All path delays from inputs to s and cout are 2 ΔG
    assign #2 s = x ^ y ^ cin;
    assign #2 cout = (x & y) | (x & cin) | (y & cin);
endmodule
