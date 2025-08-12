

module FIFO_memory #(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)(
    input                       wclk,
    input                       wclken,
    input                       wfull,
    input  [ADDRSIZE-1:0]       waddr,
    input  [ADDRSIZE-1:0]       raddr,
    input  [DATASIZE-1:0]       wdata,
    output [DATASIZE-1:0]       rdata
);

    localparam DEPTH = 1 << ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always @(posedge wclk) begin
        if (wclken && !wfull) begin
            mem[waddr] <= wdata;
        end
    end

endmodule
