`include "defines.sv"
class apb_driver;
apb_transaction drv_trans;
mailbox #(apb_transaction)mbx_gd;
mailbox #(apb_transaction)mbx_dr;
virtual apb_if.DRV vif;
covergroup drv_cg;
trans: coverpoint drv_trans.transfer {
bins t={1};}
wr_rd: coverpoint drv_trans.write_read{
bins write={1};
bins read={0};
}
data: coverpoint drv_trans.wdata_in{
bins d={[0:255]};}
addr: coverpoint drv_trans.addr_in{
bins lowest={[0:10]};
bins highest={[100:255]};
bins middle={[11:99]};
bins invalid=default;
}
strb: coverpoint drv_trans.strb_in{
bins zero_strb={4'b0000};
bins all_ones_strb={4'b1111};
bins single_bit_strb={4'b1000,4'b0100,4'b0010,4'b0001};
bins mul_strb=default;
}
wr_addr: cross wr_rd, addr;
wr_strb: cross wr_rd, strb;
data_strb: cross data,strb;
tran_wr_rd: cross wr_rd,trans;
tran_addr: cross trans,addr;
endgroup
function new(mailbox #(apb_transaction) mbx_gd, mailbox #(apb_transaction)mbx_dr, virtual apb_if.DRV vif);
this.mbx_gd=mbx_gd;
this.mbx_dr=mbx_dr;
this.vif=vif;
drv_cg=new();
endfunction

task start();
repeat(3) @(vif.drv_cb);
for(int i=0;i<`no_of_trans;i++) begin
drv_trans=new();
mbx_gd.get(drv_trans);
if(vif.drv_cb.PRESETn==0)
repeat(1) @(vif.drv_cb) begin
vif.drv_cb.transfer<=0;
vif.drv_cb.write_read<=0;
vif.drv_cb.addr_in<=0;
  vif.drv_cb.wdata_in<=0;
vif.drv_cb.strb_in<=0;
vif.drv_cb.PRDATA<=0;
vif.drv_cb.PREADY<=0;
vif.drv_cb.PSLVERR<=0;
mbx_dr.put(drv_trans);
repeat(1) @(vif.drv_cb);
$display("DRIVER DRIVING DATA TO THE INTERFACE transfer=%d, write_read=%d addr_in=%d addr_in=%d wdata_in=%d strb_in=%d PRDATA=%d PREADY=%d PSLVERR=%d",vif.drv_cb.transfer,vif.drv_cb.write_read,vif.drv_cb.addr_in,vif.drv_cb.wdata_in,vif.drv_cb.strb_in,vif.drv_cb.PRDATA,vif.drv_cb.PREADY,vif.drv_cb.PSLVERR,$time);
end
else
repeat(1) @(vif.drv_cb) begin
vif.drv_cb.transfer<=drv_trans.transfer;
vif.drv_cb.write_read<=drv_trans.write_read;
vif.drv_cb.addr_in<=drv_trans.addr_in;
vif.drv_cb.wdata_in<=drv_trans.wdata_in;
vif.drv_cb.strb_in<=drv_trans.strb_in;
//wait(vif.drv_cb.PSEL && vif.drv_cb.PENABLE);
repeat(2)@(vif.drv_cb);
vif.drv_cb.PRDATA<=8'h55;
vif.drv_cb.PREADY<=1;
vif.drv_cb.PSLVERR<=0;
$display("Driver putting into mbx_dr at %0t", $time);
mbx_dr.put(drv_trans);

$display("Driver finished put");
$display("DRIVER DRIVING DATA TO THE INTERFACE transfer=%d, write_read=%d addr_in=%d addr_in=%d wdata_in=%d strb_in=%d PRDATA=%d PREADY=%d PSLVERR=%d",vif.drv_cb.transfer,vif.drv_cb.write_read,vif.drv_cb.addr_in,vif.drv_cb.wdata_in,vif.drv_cb.strb_in,vif.drv_cb.PRDATA,vif.drv_cb.PREADY,vif.drv_cb.PSLVERR,$time);
drv_cg.sample();
end
end
endtask
endclass
