module Matrix_Core(
    input wire clk,
    input wire m_rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] acc
);
    reg [31:0]c;
    reg  [31:0]acc_r;

    assign acc = acc_r;

    always@(posedge clk) begin
        c <= a*b;
        if (m_rst) begin
            acc_r <= c;
        end
        else begin
            acc_r <= acc_r + c;
        end
    end
endmodule