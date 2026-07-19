`timescale 1ns/1ns

// ----------------------------------------------------
// 1. FA (1-bit)
// XY->S=2, XY->Cout=2, Cin->Cout=2, Cin->S=2
// ----------------------------------------------------
module FA(input x, input y, input cin, output s, output cout);
    assign s = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
    
    specify
        (x *> s) = 2;
        (y *> s) = 2;
        (cin *> s) = 2;
        
        (x *> cout) = 2;
        (y *> cout) = 2;
        (cin *> cout) = 2;
    endspecify
endmodule
