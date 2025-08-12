`timescale 1ns / 1ps

module wptr_full #(
    parameter ADDR_SIZE = 4
)(
    output reg                  wfull,
    output      [ADDR_SIZE-1:0] waddr,
    output reg  [ADDR_SIZE :0]  wptr,
    input       [ADDR_SIZE :0]  wq2_rptr,
    input                       winc,
    input                       wclk,
    input                       wrst_n
);

    reg  [ADDR_SIZE:0] wbin;
    wire [ADDR_SIZE:0] wbinnext;
    wire [ADDR_SIZE:0] wgraynext;
    wire               wfull_val;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            {wbin, wptr} <= 0;
        else
            {wbin, wptr} <= {wbinnext, wgraynext};
    end

    assign waddr      = wbin[ADDR_SIZE-1:0];
    assign wbinnext   = wbin + (winc & ~wfull);
    assign wgraynext  = (wbinnext >> 1) ^ wbinnext;

    assign wfull_val  = (wgraynext[ADDR_SIZE]   != wq2_rptr[ADDR_SIZE]   ) &&
                        (wgraynext[ADDR_SIZE-1] != wq2_rptr[ADDR_SIZE-1] ) &&
                        (wgraynext[ADDR_SIZE-2:0] == wq2_rptr[ADDR_SIZE-2:0]);

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end

endmodule
