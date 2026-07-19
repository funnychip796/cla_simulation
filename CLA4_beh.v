`timescale 1ns/1ns

module CLA4_beh(input [3:0] x, input [3:0] y, input cin, output [3:0] s, output cout);
    wire [3:0] P;
    assign #1 P = x ^ y;
    
    wire [3:0] G;
    assign #1 G = x & y;
    
    wire [4:1] C;
    assign #2 C[1] = G[0] | (P[0] & cin);
    assign #2 C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign #2 C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
    assign #2 C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);
    
    assign cout = C[4];
    
    assign #1 s[0] = P[0] ^ cin;
    assign #1 s[1] = P[1] ^ C[1];
    assign #1 s[2] = P[2] ^ C[2];
    assign #1 s[3] = P[3] ^ C[3];
endmodule
