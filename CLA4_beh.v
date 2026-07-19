`timescale 1ns/1ns

// ----------------------------------------------------
// 2. 4-bit CLA 
// XY->S=4, XY->Cout=3, Cin->Cout=2, Cin->S=3
// ----------------------------------------------------
module CLA4_beh(input [3:0] x, input [3:0] y, input cin, output [3:0] s, output cout);
    assign {cout, s} = x + y + cin;
    
    specify
        (x *> s) = 4;
        (y *> s) = 4;
        (x *> cout) = 3;
        (y *> cout) = 3;
        
        (cin *> s) = 3;
        (cin *> cout) = 2;
    endspecify
endmodule
