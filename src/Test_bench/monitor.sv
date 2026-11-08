class apb_monitor;
          apb_transaction mon_trans;
          mailbox #(apb_transaction) mbx_im;
          virtual apb_if.MON vif;
          covergroup mon_cg;
          wait_cycle: coverpoint mon_trans.wait_acc{
                    bins no_wait={0};
                    bins wait1={1};
                    bins wait_many=default;
          }
                    endgroup

          function new(virtual apb_if.MON vif, mailbox #(apb_transaction) mbx_im);
                    this.vif=vif;
                    this.mbx_im=mbx_im;
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
                                                           
                              mbx_im.put(mon_trans.copy());
                              mon_cg.sample();

                              $display("INPUT MONITOR PASSING THE DATA TO SCOREBOARD ");                              
			      $display("OUTPUT FUNCTIONAL COVERAGE=%0d", mon_cg.get_coverage());
                              
                    end
          endtask
endclass
          
