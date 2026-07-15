`include "defines.sv"
class apb_generator;
apb_transaction blueprint;
mailbox #(apb_transaction)mbx_gd;
function new(mailbox #(apb_transaction)mbx_gd);
this.mbx_gd=mbx_gd;
blueprint=new();
endfunction

task start();


blueprint.transfer=0;
blueprint.write_read=1;
blueprint.wdata_in=8'd98;
blueprint.strb_in=4'b1000;
blueprint.PSLVERR=1;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());

blueprint.transfer=1;
blueprint.write_read=0;
blueprint.rdata_out=32'h0;
blueprint.strb_in=0;
blueprint.PSLVERR=0;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());
blueprint.transfer=1;
blueprint.write_read=0;
blueprint.rdata_out=32'hFFFFFFFF;
blueprint.strb_in=0;
blueprint.PSLVERR=0;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());
blueprint.transfer=1;
blueprint.write_read=0;
blueprint.rdata_out=32'hFFFFFF55;
blueprint.strb_in=0;
blueprint.PSLVERR=0;
blueprint.PREADY=0;
mbx_gd.put(blueprint.copy());
blueprint.transfer=1;
blueprint.write_read=0;
blueprint.rdata_out=32'h1234ABAA;
blueprint.strb_in=0;
blueprint.PSLVERR=0;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());

blueprint.transfer=0;
blueprint.write_read=1;
blueprint.wdata_in=8'd98;
blueprint.strb_in=4'b1111;
blueprint.PSLVERR=1;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());

blueprint.transfer=1;
blueprint.write_read=1;
blueprint.wdata_in=8'd98;
blueprint.strb_in=0;
blueprint.PSLVERR=1;
blueprint.PREADY=0;
mbx_gd.put(blueprint.copy());

blueprint.transfer=1;
blueprint.write_read=1;
blueprint.wdata_in=8'd88;
blueprint.PSLVERR=0;
blueprint.PREADY=1;
mbx_gd.put(blueprint.copy());

for(int i=0;i<`no_of_trans;i++) begin
blueprint.randomize();
mbx_gd.put(blueprint.copy());
$display("Generator Randomized transaction %0d",i+1);
$display("transfer=%d write_read=%d addr_in=%d wdata_in=%d strb_in=%d time=%0d",blueprint.transfer, blueprint.write_read,blueprint.addr_in, blueprint.wdata_in, blueprint.strb_in, $time);
end
endtask
endclass

