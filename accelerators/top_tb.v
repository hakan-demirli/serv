module top_tb();

    parameter F_MATRIX_ROW_SIZE_MAX = 3;
    parameter F_MATRIX_COLUMN_SIZE_MAX = 3;
    parameter S_MATRIX_COLUMN_SIZE_MAX = 3;
    // 2x5    5x2
    integer f_matrix_row_size = 3;
    integer f_matrix_column_size = 3;
    integer s_matrix_column_size = 3;
    integer waiting;
    reg i_clk;
    always #20 i_clk = ~i_clk;

    integer data;
    integer address;
    integer we;
    wire [31:0]o_data_rdt;

    Matrix_TOP #(
        .F_MATRIX_ROW_SIZE_MAX(F_MATRIX_ROW_SIZE_MAX),
        .F_MATRIX_COLUMN_SIZE_MAX(F_MATRIX_COLUMN_SIZE_MAX),
        .S_MATRIX_COLUMN_SIZE_MAX(S_MATRIX_COLUMN_SIZE_MAX)
    )MAT0(
        .i_clk(i_clk),
        .data(data),
        .address(address[10:0]),
        .we(we[0]),
        .o_data_rdt(o_data_rdt)
    );
    
    integer f, f_i, f_ii, total;
    
    initial begin    
        #1 total = 1;
        #1 we = 0;
        #1 i_clk = 0;
        for (f_i = 0; f_i <(f_matrix_row_size*f_matrix_column_size); f_i = f_i + 1) begin // first matrix
            #1 data = f_i;
            #1 address = {3'd1,f_i[7:0]};
            #45 we[0] = 1'b1;
            #120 we[0] = 1'b0;
        end
        for (f_i = 0; f_i <(s_matrix_column_size*f_matrix_column_size); f_i = f_i + 1) begin // first matrix
            #1 data = f_i;
            #1 address = {3'd2,f_i[7:0]};
            #45 we[0] = 1'b1;
            #120 we[0] = 1'b0;
        end

        #200;
        #80 we = 0;
        #1 data = {1'b1,s_matrix_column_size[7:0],f_matrix_column_size[7:0],f_matrix_row_size[7:0]};
        #1 address = {3'd0,8'd0};
        #45 we[0] = 1'b1;
        #120 we[0] = 1'b0;
        
        #80 we = 0;
        #1 data = {1'b0,s_matrix_column_size[7:0],f_matrix_column_size[7:0],f_matrix_row_size[7:0]};
        #1 address = {3'd0,8'd0};
        #45 we[0] = 1'b1;
        #120 we[0] = 1'b0;
        #10000;

        address = {3'd4,8'd0};
        #120;
        
        while(o_data_rdt != 1) begin
            #1 waiting = 1;
        end

        waiting <= 0;
        #120;

        for (f_i = 0; f_i <(f_matrix_row_size*s_matrix_column_size); f_i = f_i + 1) begin // first matrix
                #45 address = {3'd3,f_i[7:0]};
        end

        #200 $stop;
    end
endmodule
/*




    integer f_i;
    initial begin
        f_matrix_row_size = 3;
        f_matrix_column_size = 3;
        s_matrix_column_size = 3;
        i_clk = 0;

    #66 start = 0;
        for (f_i = 0; f_i <(f_matrix_row_size*f_matrix_column_size); f_i = f_i + 1) begin // first matrix
            #1first_matrix[f_i] = f_i;
        end
        for (f_i = 0; f_i <(s_matrix_column_size*f_matrix_column_size); f_i = f_i + 1) begin // first matrix
            #1second_matrix[f_i] = f_i;
        end
        #444 start = 1;
        #2100 start = 0;
        $stop;
    end









*/