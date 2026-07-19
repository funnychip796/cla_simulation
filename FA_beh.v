`timescale 1ns/1ns

module FA_beh(input x, input y, input cin, output s, output cout);
    // 所有输入到 s 和 cout 都是 2 ΔG
    assign #2 s = x ^ y ^ cin;
    assign #2 cout = (x & y) | (x & cin) | (y & cin);
endmodule
