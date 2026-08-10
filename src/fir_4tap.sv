module fir_4tap #(
    parameter WIDTH = 8
)(
    input logic clk_i,
    input logic arst_n,
    input logic sample_en,
    input logic [WIDTH-1:0] x_i,
    output logic [WIDTH-1:0] y_o
);
    
    // shift register: x0 = newest sample x3 = oldest sample
    logic [WIDTH-1:0] x0, x1, x2, x3;
    
    //4 taps accumulated result holder
    logic [WIDTH+1:0] acc;  // extra 2 bits are required to avoid overflow
    
    always_comb acc = x0 + x1 + x2 + x3;
    
    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            x0 <= 1'b0;
            x1 <= 1'b0;
            x2 <= 1'b0;
            x3 <= 1'b0;
            y_o <= '0;
        end
        else if (sample_en) begin
            x0 <= x_i;  //shift new sample into the chain
            x1 <= x0;
            x2 <= x1;
            x3 <= x2;
            
            // average calculation: sum of 4 taps/4
            y_o <= acc / 4;    // right shift by 2 means divide by 4
            
        end
    end

endmodule

