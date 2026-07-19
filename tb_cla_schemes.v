`timescale 1ns/1ns

// ====================================================
// Testbench 仿真五种排列方案
// ====================================================
module tb_cla_schemes;

    reg [27:0] x, y;
    reg cin;

    // ----- Scheme 1: FA -> 4b -> 16b -> 4b -> FA (26 bits) -----
    wire [25:0] s1;
    wire c1_1, c1_5, c1_21, c1_25, c1_26;
    FA_beh    u1_1  (x[0],       y[0],       cin,   s1[0],     c1_1);
    CLA4_beh  u1_2  (x[4:1],     y[4:1],     c1_1,  s1[4:1],   c1_5);
    CLA16_beh u1_3  (x[20:5],    y[20:5],    c1_5,  s1[20:5],  c1_21);
    CLA4_beh  u1_4  (x[24:21],   y[24:21],   c1_21, s1[24:21], c1_25);
    FA_beh    u1_5  (x[25],      y[25],      c1_25, s1[25],    c1_26);

    // ----- Scheme 2: FA -> 4b -> 4b -> 16b -> FA (26 bits) -----
    wire [25:0] s2;
    wire c2_1, c2_5, c2_9, c2_25, c2_26;
    FA_beh    u2_1  (x[0],       y[0],       cin,   s2[0],     c2_1);
    CLA4_beh  u2_2  (x[4:1],     y[4:1],     c2_1,  s2[4:1],   c2_5);
    CLA4_beh  u2_3  (x[8:5],     y[8:5],     c2_5,  s2[8:5],   c2_9);
    CLA16_beh u2_4  (x[24:9],    y[24:9],    c2_9,  s2[24:9],  c2_25);
    FA_beh    u2_5  (x[25],      y[25],      c2_25, s2[25],    c2_26);

    // ----- Scheme 3: 4b -> 16b -> 4b -> 4b (28 bits) -----
    wire [27:0] s3;
    wire c3_4, c3_20, c3_24, c3_28;
    CLA4_beh  u3_1  (x[3:0],     y[3:0],     cin,   s3[3:0],   c3_4);
    CLA16_beh u3_2  (x[19:4],    y[19:4],    c3_4,  s3[19:4],  c3_20);
    CLA4_beh  u3_3  (x[23:20],   y[23:20],   c3_20, s3[23:20], c3_24);
    CLA4_beh  u3_4  (x[27:24],   y[27:24],   c3_24, s3[27:24], c3_28);

    // ----- Scheme 4: 4b -> 4b -> 16b -> 4b (28 bits) -----
    wire [27:0] s4;
    wire c4_4, c4_8, c4_24, c4_28;
    CLA4_beh  u4_1  (x[3:0],     y[3:0],     cin,   s4[3:0],   c4_4);
    CLA4_beh  u4_2  (x[7:4],     y[7:4],     c4_4,  s4[7:4],   c4_8);
    CLA16_beh u4_3  (x[23:8],    y[23:8],    c4_8,  s4[23:8],  c4_24);
    CLA4_beh  u4_4  (x[27:24],   y[27:24],   c4_24, s4[27:24], c4_28);

    // ----- Scheme 5: 4b -> 4b -> 4b -> 16b (28 bits, 高16位放置) -----
    wire [27:0] s5;
    wire c5_4, c5_8, c5_12, c5_28;
    CLA4_beh  u5_1  (x[3:0],     y[3:0],     cin,   s5[3:0],   c5_4);
    CLA4_beh  u5_2  (x[7:4],     y[7:4],     c5_4,  s5[7:4],   c5_8);
    CLA4_beh  u5_3  (x[11:8],    y[11:8],    c5_8,  s5[11:8],  c5_12);
    CLA16_beh u5_4  (x[27:12],   y[27:12],   c5_12, s5[27:12], c5_28);

    // ----------------------------------------------------
    // 测试激励：产生最长进位链
    // ----------------------------------------------------
    time t_start;

    initial begin
        $display("==================================================");
        $display("   26-bit/28-bit CLA Critical Path Simulation");
        $display("==================================================");
        
        $dumpfile("cla_simulation.vcd");
        $dumpvars(0, tb_cla_schemes);
        
        // 初始化稳定状态
        x = 0; y = 0; cin = 0;
        #50;
        
        $display("\nApplying worst-case stimulus at Time %0t...", $time);
        t_start = $time;
        
        // 使用极限输入：触发完整的进位涟波 (ripple)
        x = 28'hFFFFFFF;
        y = 28'h0000001; 
        cin = 0;
        
        // 留够时间让所有信号结算
        #30;
        $display("\nSimulation Complete.");
        $finish;
    end
    
    // 捕获各方案求和输出变化（你将在控制台看到每种方案最后稳定的准确纳秒级时间）
    always @(s1) if ($time > t_start) $display("[Scheme 1: FA->4b->16b->4b->FA] S updated at +%0t ns", $time - t_start);
    always @(s2) if ($time > t_start) $display("[Scheme 2: FA->4b->4b->16b->FA] S updated at +%0t ns", $time - t_start);
    always @(s3) if ($time > t_start) $display("[Scheme 3: 4b->16b->4b->4b]     S updated at +%0t ns", $time - t_start);
    always @(s4) if ($time > t_start) $display("[Scheme 4: 4b->4b->16b->4b]     S updated at +%0t ns", $time - t_start);
    always @(s5) if ($time > t_start) $display("[Scheme 5: 4b->4b->4b->16b]     S updated at +%0t ns  <-- 12 ΔG", $time - t_start);

endmodule
