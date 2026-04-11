`timescale 1ns / 1ps

module tb_aes_128();

    reg clk;
    reg rst;
    reg start;
    reg  [127:0] plaintext;
    reg  [127:0] key;
    wire [127:0] ciphertext;
    wire         done;
    reg [15:0] STEP_CHK ;

    // AES-128 トップモジュールのインスタンス化
    aes_128 uut_1 (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );


    // クロック生成 (100MHz)
    always #5 clk = ~clk;

    initial begin
        STEP_CHK=16'hA5A2 ;
        $dumpfile("aes_test.vcd"); // 波形データの保存先
        $dumpvars(0, tb_aes_128);  // すべての信号を記録

        // --- 初期化 ---
        clk = 0;
        rst = 1;
        start = 0;
        plaintext = 0;
        key = 0;

        // リセット解除
        #20 rst = 0;
        
        #10;
        // --- テストケース1 (NIST FIPS 197 公式例) ---
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;
        start = 1;
        #10 start = 0;
        #10000 ;
        #10;
        $display("--- AES-128 Simulation Result ---");
        $display("Plaintext:  %h", plaintext);
        $display("Key:        %h", key);
        $display("Result:     %h", ciphertext);
        $display("Expected:   69c4e0d86a7b0430d8cdb78070b4c55a");

        if (ciphertext == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $display("Test Passed!");
        else
            $display("Test Failed...");

        #50 $finish;
    end

endmodule
