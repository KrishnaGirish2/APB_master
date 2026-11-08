class apb_output_monitor;
          apb_transaction mon_trans;
          mailbox #(apb_transaction) mbx_om;
          virtual apb_if.OUT_MON vif;
          covergroup out_mon_cg;
	  
          write_data: coverpoint mon_trans.PWDATA{
                    bins data={[0:255]};}
          wr_rd: coverpoint mon_trans.PWRITE{
                    bins read={0};
                    bins write={1};
          }
          addr: coverpoint mon_trans.PADDR{
                    bins address={[0:255]};
          }
          str: coverpoint mon_trans.PSTRB{
                    bins zero_strb1={4'b0000};
                    bins ones_strb1={4'b0001, 4'b0010, 4'b0100, 4'b1000};
                    bins mul_strb1=default;
          }
          wr_str: cross wr_rd, str{
                    bins write_strobe=binsof(wr_rd.write) && binsof(str);
          }

          read_data: coverpoint mon_trans.rdata_out{
                    bins rd_data={[0:255]};
          }
          endgroup

          function new(virtual apb_if.OUT_MON vif, mailbox #(apb_transaction) mbx_om);
                    this.vif=vif;
                    this.mbx_om=mbx_om;
                    out_mon_cg=new();
          endfunction
          task start();
                    for(int i=0;i<`no_of_trans;i++) begin
                              @(vif.out_mon_cb);
                              wait(vif.out_mon_cb.PSEL && !vif.out_mon_cb.PENABLE);
                              mon_trans=new();
                              @(vif.out_mon_cb);
		                while(vif.out_mon_cb.PSEL && vif.out_mon_cb.PENABLE && !vif.out_mon_cb.PREADY) begin
				                      @(vif.out_mon_cb);
			              end
                              mon_trans.PADDR=vif.out_mon_cb.PADDR;
                              mon_trans.PSEL=vif.out_mon_cb.PSEL;
                              mon_trans.PENABLE=vif.out_mon_cb.PENABLE;
                              mon_trans.PWRITE=vif.out_mon_cb.PWRITE;
                              mon_trans.PWDATA=vif.out_mon_cb.PWDATA;
                              mon_trans.PSTRB=vif.out_mon_cb.PSTRB;
                              mon_trans.rdata_out=vif.out_mon_cb.rdata_out;
                              mon_trans.transfer_done=vif.out_mon_cb.transfer_done;
                              mon_trans.error=vif.out_mon_cb.error;
                              mbx_om.put(mon_trans.copy());
                              out_mon_cg.sample();

                              $display("Output MONITOR PASSING THE DATA TO SCOREBOARD PWRITE=%d PADDR=%d PSEL=%d PENABLE=%d PWDATA=%d PSTRB=%d rdata_out=%d transfer_done=%d error=%d ",mon_trans.PWRITE, mon_trans.PADDR, mon_trans.PSEL, mon_trans.PENABLE, mon_trans.PWDATA, mon_trans.PSTRB, mon_trans.rdata_out, mon_trans.transfer_done, mon_trans.error);
                              $display("OUTPUT FUNCTIONAL COVERAGE=%0d", out_mon_cg.get_coverage());
                             
                    end
          endtask
endclass
          
