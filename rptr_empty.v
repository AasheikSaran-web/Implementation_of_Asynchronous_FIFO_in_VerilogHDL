`timescale 1ns / 1ps

module rptr_empty #(
    parameter ADDR_SIZE = 4
)(
    output reg                  rempty,
    output      [ADDR_SIZE-1:0] raddr,
    output reg  [ADDR_SIZE :0]  rptr,
    input       [ADDR_SIZE :0]  rq2_wptr,
    input                       rinc,
    input                       rclk,
    input                       rrst_n
);

    reg  [ADDR_SIZE:0] rbin;
    wire [ADDR_SIZE:0] rbinnext;
    wire [ADDR_SIZE:0] rgraynext;
    wire               rempty_val;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {rbin, rptr}<= 0;
        else
            {rbin, rptr} <= {rbinnext, rgraynext};
    end

    assign raddr = rbin[ADDR_SIZE-1:0];
    assign rbinnext  = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;
    assign rempty_val = (rgraynext == rq2_wptr);

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1'b1;
        else
            rempty <= rempty_val;
    end

endmodule
