module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

initial begin
    rx_msg = 8'b0;
    rx_parity = 1'b0;
    rx_complete = 1'b0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////


reg [5:0] baud_count;
reg [3:0] bit_count;
reg [8:0] result;

initial begin
    baud_count = 6'b0;
    bit_count = 4'b0;
    result = 9'b0;
end

always @(posedge clk_3125) begin

    // start bit
    if(bit_count == 4'b0000 && !rx) begin
    rx_complete<=0;
        baud_count <= baud_count + 1;
        if((baud_count == 13 && rx != 0) || (baud_count == 26)) begin
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0001) begin
        result[0] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count == 13 && rx != result[0]) || (baud_count == 26)) begin
        result[0]<=result[0];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0010) begin
        result[1] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count==13 && rx != result[1]) || (baud_count == 26)) begin
        result[1]<=result[1];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0011) begin
        result[2] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count ==13 && rx != result[2]) || (baud_count == 26)) begin
        result[2]<=result[2];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0100) begin
        result[3] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count ==13 && rx != result[3]) || (baud_count == 26)) begin
        result[3]<=result[3];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0101) begin
        result[4] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count==13 && rx != result[4]) || (baud_count == 26)) begin
        result[4]<=result[4];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0110) begin
        result[5] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count ==13 && rx != result[5]) || (baud_count == 26)) begin
        result[5]<=result[5];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b0111) begin
        result[6] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count==13 && rx != result[6]) || (baud_count == 26)) begin
        result[6]<=result[6];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b1000) begin
        result[7] <= rx;
        baud_count <= baud_count + 1;
        if((baud_count ==13 && rx != result[7]) || (baud_count == 26)) begin
        result[7]<=result[7];
            bit_count <= bit_count + 1;
            baud_count <= 0;
        end
    end
    else if (bit_count == 4'b1001) begin
        baud_count <= baud_count + 1;
        if (baud_count>0)
            result[8] <= rx; // parity bit
        if((baud_count ==13 && rx != result[8]) || (baud_count == 26)) begin
            result[8]<=result[8];
            bit_count <= bit_count + 1;
            baud_count <= 0;
            if((result[0] + result[1]+ result[2]+ result[3]+ result[4]+ result[5]+ result[6]+ result[7] + result[8])%3'b010==3'b001) begin
			result <= 9'b111111100;
			result[8] <= rx;
		end

        end
    end
    else if (bit_count == 4'b1010) begin
        baud_count <= baud_count + 1;
        if((baud_count ==13 && rx != 1) || (baud_count == 27)) begin
            bit_count <= 4'b0000;
            baud_count <= 1;
            rx_parity <= result[8];
            rx_msg[0] <= result[7];
            rx_msg[1] <= result[6];
            rx_msg[2] <= result[5];
            rx_msg[3] <= result[4];
            rx_msg[4] <= result[3];
            rx_msg[5] <= result[2];
            rx_msg[6] <= result[1];
            rx_msg[7] <= result[0];
            rx_complete <= 1'b1;
        end
    end
    else begin
        baud_count <= 0;
    end
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////
endmodule
