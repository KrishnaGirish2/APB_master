class apb_monitor;
apb_transaction mon_trans;
mailbox #(apb_transaction) mbx_ms;
virtual apb_if.MON vif;

covergroup mon_cg;
wait_cycle: coverpoint mon_trans.wait_acc{
bins no_wait={0};
bins wait1={1};
bins wait_many=default;
}
write_data: coverpoint mon_trans.PWDATA{
bins data={[0:255]};}
wr_rd: coverpoint mon_trans.PWRITE{
bins read={0};
bins write={1};
}
enable: coverpoint mon_trans.PENABLE{
bins zero={0};
bins one={1};
}
addr: coverpoint mon_trans.PADDR{
bins address={[0:255]};
}
str: coverpoint mon_trans.PSTRB{
bins zero_strb1={4'b0000};
bins ones_strb1={4'b0001, 4'b0010, 4'b0100, 4'b1000};
bins mul_strb1=default;
}
err: coverpoint mon_trans.error{
bins no_error={0};
bins error1={1};
}
complete: coverpoint mon_trans.transfer_done{
bins comp={1};
bins not_complete={0};
}
slave_select: coverpoint mon_trans.PSEL{
bins select={1};
bins not_select={0};
}
wr_str: cross wr_rd, str{
bins write_strobe=binsof(wr_rd.write) && binsof(str);
}
wr_rd_err: cross wr_rd , err;
wr_rd_comp: cross wr_rd, complete;
read_data: coverpoint mon_trans.rdata_out{
bins rd_data={[0:255]};
}
endgroup
function new(virtual apb_if.MON vif, mailbox #(apb_transaction) mbx_ms);
this.vif=vif;
this.mbx_ms=mbx_ms;
mon_cg=new();
endfunction
task start();
for(int i=0;i<`no_of_trans;i++) begin
@(vif.mon_cb);
wait(vif.mon_cb.PSEL && !vif.mon_cb.PENABLE);
mon_trans=new();

mon_trans.transfer=vif.mon_cb.transfer;
mon_trans.write_read=vif.mon_cb.write_read;
mon_trans.addr_in=vif.mon_cb.addr_in;
mon_trans.wdata_in=vif.mon_cb.wdata_in;
mon_trans.strb_in=vif.mon_cb.strb_in;

@(vif.mon_cb);
mon_trans.wait_acc=0;
while(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && !vif.mon_cb.PREADY) begin
mon_trans.wait_acc++;
@(vif.mon_cb);
end

mon_trans.PRDATA=vif.mon_cb.PRDATA;
mon_trans.PREADY=vif.mon_cb.PREADY;
mon_trans.PSLVERR=vif.mon_cb.PSLVERR;
mon_trans.PADDR=vif.mon_cb.PADDR;
mon_trans.PSEL=vif.mon_cb.PSEL;
mon_trans.PENABLE=vif.mon_cb.PENABLE;
mon_trans.PWRITE=vif.mon_cb.PWRITE;
mon_trans.PWDATA=vif.mon_cb.PWDATA;
mon_trans.PSTRB=vif.mon_cb.PSTRB;
mon_trans.rdata_out=vif.mon_cb.rdata_out;
mon_trans.transfer_done=vif.mon_cb.transfer_done;
mon_trans.error=vif.mon_cb.error;
$display("MON : PSEL=%0d PENABLE=%0d time=%0t",
          mon_trans.PSEL,
          mon_trans.PENABLE,
          $time);
mbx_ms.put(mon_trans);
mon_cg.sample();

$display("MONITOR PASSING THE DATA TO SCOREBOARD PWRITE=%d PADDR=%d PSEL=%d PENABLE=%d PWDATA=%d PSTRB=%d rdata_out=%d transfer_done=%d error=%d ",mon_trans.PWRITE, mon_trans.PADDR, mon_trans.PSEL, mon_trans.PENABLE, mon_trans.PWDATA, mon_trans.PSTRB, mon_trans.rdata_out, mon_trans.transfer_done, mon_trans.error);
$display("OUTPUT FUNCTIONAL COVERAGE=%0d", mon_cg.get_coverage());
repeat(1) @(vif.mon_cb);
end
endtask
endclass
