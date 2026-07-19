`timescale 1ns/1ns

// ----------------------------------------------------
// 3. 16-bit CLA 
// XY->S=8, XY->Cout=5, Cin->Cout=2, Cin->S=5
// ----------------------------------------------------
module CLA16(input [15:0] x, input [15:0] y, input cin, output [15:0] s, output cout);
    assign {cout, s} = x + y + cin;
    
    specify
        (x *> s) = 8;
        (y *> s) = 8;
        (x *> cout) = 5;
        (y *> cout) = 5;
        
        (cin *> s) = 5;
        (cin *> cout) = 2;
    endspecify
endmodule
