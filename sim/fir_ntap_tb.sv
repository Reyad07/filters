module fir_ntap_tb;
    localparam TAP = 8;
    localparam WIDTH = 8;
    
    logic clk_i = '0;
    logic arst_n;
    logic sample_en;
    logic [WIDTH-1:0] x_i;
    logic [WIDTH-1:0] y_o;
    
    logic [WIDTH-1:0] sample [5] = '{100, 100, 100, 200, 100};
    
   fir_ntap #(
        .TAP(TAP),
        .WIDTH(WIDTH)
    ) u_fir_ntap (
        .clk_i      (clk_i),
        .arst_n     (arst_n),
        .sample_en  (sample_en),
        .x_i        (x_i),
        .y_o        (y_o)
    );
    
    always #5 clk_i = ~clk_i;
    
    initial begin
        arst_n <= 1'b0;
        sample_en <= 1'b0;
        repeat(5) @(posedge clk_i);
        arst_n <= 1'b1;
        
        sample_en <= 1'b1;
//        foreach(sample[i]) begin
//            @(posedge clk_i)
//            x_i <= sample[i];
//        end
    
        repeat (5000) begin
            @(posedge clk_i);
            x_i <= $random;
        end
    end
    
endmodule

