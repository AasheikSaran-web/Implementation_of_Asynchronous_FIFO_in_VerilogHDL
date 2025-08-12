`timescale 1ns / 1ps

module two_ff_sync #(
    parameter WIDTH = 4
)(
    output reg [WIDTH-1:0] q2,
    input  [WIDTH-1:0]     din,
    input                  clk,
    input                  rst_n
);

    reg [WIDTH-1:0] q1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q1 <= {WIDTH{1'b0}};
            q2 <= {WIDTH{1'b0}};
        end 
        else begin
            q1 <= din;
            q2 <= q1;
        end
    end

endmodule
