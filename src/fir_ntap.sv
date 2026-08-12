module fir_ntap #(
    parameter TAP= 8,
    parameter WIDTH = 8

)(
    input logic clk_i,
    input logic arst_n,
    input logic sample_en,
    input logic [WIDTH-1:0] x_i,
    output logic [WIDTH-1:0] y_o
);
    
    localparam ACCW = WIDTH + $clog2(TAP);
    
    // shift register: x0 = newest sample xn = oldest sample
    logic [WIDTH-1:0] x[0:TAP-1];
    
    logic [ACCW-1:0] acc;   // store accumulated value
    
    always_comb begin
        acc = '0;
        for (int i = 0; i < TAP; i++) begin
            acc += x[i];
        end
    end
    
    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            for (int i = 0; i < TAP; i++) begin
                x[i] <= '0;
            end
        end
        else if (sample_en) begin
            x[0] <= x_i;  //shift new sample into the chain
            for (int i = 1; i < TAP; i++) begin
                x[i] <= x[i-1];
            end

        end
    end
    
    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
             y_o <= '0;
        end
        else if (sample_en) begin
            y_o <= acc / TAP;
        end
    end


endmodule

