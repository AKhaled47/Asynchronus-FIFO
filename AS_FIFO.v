module AS_FIFO(data_in,wr_en,read_en,clk_read,clk_wr,w_resetn,r_resetn,data_out,full,empty);
parameter WIDTH=8;
parameter ADD_LINES=5;
input [WIDTH-1:0] data_in;
input clk_read,clk_wr,wr_en,read_en,w_resetn,r_resetn;
output reg [WIDTH-1:0] data_out;
output full,empty;
//RAM for memory storage
reg [WIDTH-1:0] ram_mem [(2**ADD_LINES)-1:0];
reg [ADD_LINES:0] wr_add,read_add;

//Read block with reset
always@(posedge clk_read or negedge r_resetn)
begin
  if(!r_resetn)
  read_add<=0;
  else if(!empty&&read_en)
  begin
    data_out<=ram_mem[read_add[ADD_LINES-1:0]];
    read_add<=read_add+1;
  end
end
//Write block with reset
always@(posedge clk_wr or negedge w_resetn)
begin
  if(!w_resetn)
  wr_add<=0;
  else if(!full&&wr_en)
  begin
    ram_mem[wr_add[ADD_LINES-1:0]]<=data_in;
    wr_add<=wr_add+1;
  end
end
//Flags assignment
assign full=({!wr_add[ADD_LINES],wr_add[ADD_LINES-1:0]}==read_add);
assign empty=(wr_add==read_add);
endmodule