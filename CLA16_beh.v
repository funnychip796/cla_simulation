`timescale 1ns/1ns

module CLA16_beh(input [15:0] x, input [15:0] y, input cin, output [15:0] s, output cout);
    wire [3:0] c_block;
    wire [3:0] P_group, G_group;
    
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : grp
            wire [4:0] sum0 = x[i*4+3 : i*4] + y[i*4+3 : i*4];
            wire [4:0] sum1 = x[i*4+3 : i*4] + y[i*4+3 : i*4] + 1;
            assign #3 G_group[i] = sum0[4];
            assign #3 P_group[i] = sum1[4] & ~sum0[4];
        end
    endgenerate

    // BCLA block logic (Delay = 2)
    assign #2 c_block[0] = G_group[0] | (P_group[0] & cin);
    assign #2 c_block[1] = G_group[1] | (P_group[1] & G_group[0]) | (P_group[1] & P_group[0] & cin);
    assign #2 c_block[2] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & G_group[0]) | (P_group[2] & P_group[1] & P_group[0] & cin);
    assign #2 c_block[3] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & G_group[0]) | (P_group[3] & P_group[2] & P_group[1] & P_group[0] & cin);
    
    assign cout = c_block[3];

    // Compute sum for each block based on their specific block carry
    generate
        for (i=0; i<4; i=i+1) begin : sum_gen
            wire [3:0] P_bit;
            assign #1 P_bit = x[i*4+3 : i*4] ^ y[i*4+3 : i*4];
            
            wire [3:0] G_bit;
            assign #1 G_bit = x[i*4+3 : i*4] & y[i*4+3 : i*4];
            
            wire cin_blk = (i==0) ? cin : c_block[i-1];
            
            wire [3:1] c_int;
            assign #2 c_int[1] = G_bit[0] | (P_bit[0] & cin_blk);
            assign #2 c_int[2] = G_bit[1] | (P_bit[1] & G_bit[0]) | (P_bit[1] & P_bit[0] & cin_blk);
            assign #2 c_int[3] = G_bit[2] | (P_bit[2] & G_bit[1]) | (P_bit[2] & P_bit[1] & G_bit[0]) | (P_bit[2] & P_bit[1] & P_bit[0] & cin_blk);
            
            assign #1 s[i*4+0] = P_bit[0] ^ cin_blk;
            assign #1 s[i*4+1] = P_bit[1] ^ c_int[1];
            assign #1 s[i*4+2] = P_bit[2] ^ c_int[2];
            assign #1 s[i*4+3] = P_bit[3] ^ c_int[3];
        end
    endgenerate
endmodule
