module wrapper (
    input reset, clock_1, clock_2, data_1_en,
    input [15:0] data_1,
    output buffer_empty, buffer_full, 
    output reg data_2_valid,
    output reg [15:0] data_2
); 

reg [15:0] buffer_reg [0:7];
reg [2:0] buffer_wr, buffer_rd;
reg [2:0] counter_1, counter_2;

assign buffer_full = (counter_1 == 3'b110) ? 1 : 0;
assign buffer_empty = (counter_1 == 3'b000) ? 1 : 0;

// always @(posedge clock_1 or posedge reset) begin
//     if (reset) begin
//         buffer_wr <= 3'b0;
//         counter <= 3'b0;
//         buffer_full <= 1'b0;
//         buffer_empty <= 1'b1;
//     end
//     else begin
//         if (data_1_en && !buffer_full) begin
//             buffer_reg[buffer_wr] <= data_1;
//             buffer_wr <= buffer_wr + 1'b1;
//             counter <= counter + 1'b1;
//             buffer_empty <= 1'b0;
//             if (counter == 3'b110) begin
//                 buffer_full <= 1'b1;
//             end 
//         end
//         if (buffer_wr > 3'b111) begin
//             buffer_wr <= 3'b0;
//         end
//     end
// end

// always @(posedge clock_2 or posedge reset) begin
//     if (reset) begin
//         buffer_rd <= 3'b0;
//         data_2 <= 16'b0;
//         data_2_valid <= 1'b0;
//     end  
//     else begin
//         if (!buffer_empty) begin
//             data_2 <= buffer_reg[buffer_rd];
//             data_2_valid <= 1'b1;
//             buffer_rd <= buffer_rd + 1'b1;
//             counter <= counter - 1'b1;
//             buffer_full <= 1'b0;
//             if (counter == 3'b0) begin
//                 buffer_empty <= 1'b1;
//             end
//         end
//         else begin
//             data_2_valid <= 1'b0;
//         end
//         if (buffer_rd == 3'b111) begin
//             buffer_rd <= 3'b0;
//         end
//     end
// end

always @(posedge clock_1 or posedge reset) begin
    if (reset) begin
        buffer_wr <= 3'b0;
        counter_1 <= 3'b0;
    end
    else begin
        if (data_1_en && !buffer_full) begin
            buffer_reg[buffer_wr] <= data_1;
            buffer_wr <= buffer_wr + 1'b1;
            counter_1 <= counter_1 + 1'b1;
        end
        else if (!buffer_empty) begin
            counter_1 <= counter_1 - 1'b1;
        end
        if (buffer_wr > 3'b111) begin
            buffer_wr <= 3'b0;
        end
    end
end

always @(posedge clock_2 or posedge reset) begin
    if (reset) begin
        buffer_rd <= 3'b0;
        data_2 <= 16'b0;
        data_2_valid <= 1'b0;
    end  
    else begin
        if (!buffer_empty) begin
            data_2 <= buffer_reg[buffer_rd];
            data_2_valid <= 1'b1;
            buffer_rd <= buffer_rd + 1'b1;
        end
        else begin
            data_2_valid <= 1'b0;
        end
        if (buffer_rd == 3'b111) begin
            buffer_rd <= 3'b0;
        end
    end
end

endmodule