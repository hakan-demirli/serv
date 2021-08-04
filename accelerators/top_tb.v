module top_tb();

    parameter CORE_COUNT = 1;
    parameter SIZE_ROW_MAX = 3;
    parameter SIZE_COLUMN_MAX = 3;
    // 2x5    5x2
    integer f_matrix_row_size = 3;
    integer f_matrix_column_size = 3;
    integer s_matrix_column_size = 3;
    integer waiting;
    reg CLOCK_25;
    always #20 CLOCK_25 = ~CLOCK_25;

    integer data;
    integer address;
    integer we;
    wire [31:0]o_data_rdt;
    // [address[9:5]][address[4:0]]
    // [[row][column]]
    
    Matrix_TOP #(
        .CORE_COUNT(CORE_COUNT),
        .SIZE_ROW_MAX(SIZE_ROW_MAX),
        .SIZE_COLUMN_MAX(SIZE_COLUMN_MAX)
    ) MAT0(
        .CLOCK_25(CLOCK_25),
        .data(data),
        .address(address),
        .we(we[0]),
        .o_data_rdt(o_data_rdt)
    );
    
    integer f, f_i, f_ii, total;
    
    initial begin
        f = $fopen("output.txt","w");
    
        #1 total = 1;
        #1 we = 0;
        #1 CLOCK_25 = 0;
        $fwrite(f,"initialize first matrix\n");
        for (f_i = 0; f_i <f_matrix_row_size; f_i = f_i + 1) begin // first matrix
            for (f_ii = 0; f_ii <f_matrix_column_size; f_ii = f_ii + 1) begin
                #1 data = f_ii + total;
                #1 address = {3'd1,f_i[4:0],f_ii[4:0]};
                $fwrite(f,"%h\n",address<<2);
                #45 we[0] = 1'b1;
                #120 we[0] = 1'b0;
            end
                total = total + f_ii;
        end
        $fwrite(f,"initialize second matrix\n");
        total = 1;
        for (f_i = 0; f_i < f_matrix_column_size; f_i = f_i + 1) begin // second matrix
            for (f_ii = 0; f_ii < s_matrix_column_size; f_ii = f_ii + 1) begin
                #1 data = f_ii + total;
                #1 address = {3'd2,f_i[4:0],f_ii[4:0]};
                $fwrite(f,"%h\n",address<<2);
                #45 we[0] = 1'b1;
                #120 we[0] = 1'b0;
            end
                total = total + f_ii;
        end
        $fwrite(f,"start_stop_config\n");
        #200;
        #80 we = 0;
        #1 data = {1'b1,s_matrix_column_size[7:0],f_matrix_column_size[7:0],f_matrix_row_size[7:0]};
        $fwrite(f,"d:%h\n",data);
        #1 address = {3'd0,10'd0};
        $fwrite(f,"a:%h\n",address<<2);
        #45 we[0] = 1'b1;
        #120 we[0] = 1'b0;
        
        #80 we = 0;
        #1 data = {1'b0,s_matrix_column_size[7:0],f_matrix_column_size[7:0],f_matrix_row_size[7:0]};
        $fwrite(f,"d:%h\n",data);
        #1 address = {3'd0,10'd0};
        $fwrite(f,"a:%h\n",address<<2);
        #45 we[0] = 1'b1;
        #120 we[0] = 1'b0;
        #10000;
        
        address = {3'd4,10'd0};
        $fwrite(f,"f_a:%h\n",address<<2);
        #120;
        
        while(o_data_rdt != 1) begin
            waiting = 1;
        end
        waiting <= 0;
        #120;
        $fwrite(f,"read third matrix\n");

        for (f_i = 0; f_i < f_matrix_row_size; f_i = f_i + 1) begin // second matrix
            for (f_ii = 0; f_ii < s_matrix_column_size; f_ii = f_ii + 1) begin
                #45 address = {3'd3,f_i[4:0],f_ii[4:0]};
                $fwrite(f,"%h\n",address<<2);
            end
        end
        
        $fclose(f);  
        #20000 $stop;
    end
endmodule