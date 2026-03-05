module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

initial begin
    tx = 1'b1;
    tx_done = 1'b0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
parameter baud_rate=27;//baud rate=3125000/115200=27.1267
parameter IDLE=1'b1;
parameter start=1'b0;
parameter stop=1'b1;
parameter data_bit=8;

reg [3:0]bit_counter=0;
reg [5:0]baud_counter=0;
reg parity_op_bit;
reg transmitting=0;

always @(posedge clk_3125)
begin
tx_done<=0;
if(!transmitting  && tx_start)//check for a new transmission request
begin
tx<=start;
transmitting<=1;//set the transmission flag
bit_counter<=0;
baud_counter<=0;
parity_op_bit<=parity_type?~^data:^data;//calculate parity bit(start,8 data bit, parity ,stop)
end

else if(transmitting)begin //active transmission
if(baud_counter<baud_rate-1)//count clk cycles for the current bit
begin
baud_counter<=baud_counter +1;
if(bit_counter==4'd10 && baud_counter == 25)
begin
tx_done<=1;
end
end
else begin// baud rate period is complete so transmit next bit
baud_counter<=0;// reset baud counter
if(bit_counter==4'd10)//after transmitting the stop bit
begin
tx<=IDLE;
transmitting<=0;
bit_counter<=0;
end
else begin

case(bit_counter)//select next bit to transmit
4'd0:tx<=data[7];// first sent msb
4'd1:tx<=data[6];
4'd2:tx<=data[5];
4'd3:tx<=data[4];
4'd4:tx<=data[3];
4'd5:tx<=data[2];
4'd6:tx<=data[1];
4'd7:tx<=data[0];
4'd8:tx<=parity_op_bit;
4'd9:tx<=stop;

endcase
bit_counter<=bit_counter +1;//next bit
end
end
end

else begin
tx<=IDLE;
baud_counter<=0;
bit_counter<=0;
end
end
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
