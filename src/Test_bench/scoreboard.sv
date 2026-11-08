`include "defines.sv"
class apb_scoreboard;
  apb_transaction exp_trans, act_trans;
  mailbox #(apb_transaction) mbx_im;
  mailbox #(apb_transaction) mbx_om;
  int pass=0;
  int fail=0;
  function new(mailbox #(apb_transaction) mbx_im, mailbox #(apb_transaction)mbx_om);
    this.mbx_im=mbx_im;
    this.mbx_om=mbx_om;
  endfunction
  task start();
    for(int i=0;i<`no_of_trans;i++) begin
      exp_trans=new();
      act_trans=new();
      mbx_im.get(exp_trans);
      mbx_om.get(act_trans);
      compare_report();
    end
  endtask
  task compare_report();
    if(exp_trans.write_read==1 && act_trans.PWRITE==1) begin
      if((exp_trans.addr_in ==act_trans.PADDR)&&
        (exp_trans.wdata_in ==act_trans.PWDATA)&&
        (exp_trans.strb_in==act_trans.PSTRB)&&
        (exp_trans.PSLVERR==act_trans.error)) begin
          pass++;
          $display("Pass");  
        end
      else begin
        fail++;
        $display("Fail: scoreboard data: PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",exp_trans.PSEL,exp_trans.PENABLE,exp_trans.PWRITE,exp_trans.PADDR,exp_trans.PWDATA,exp_trans.PSTRB,exp_trans.rdata_out,exp_trans.transfer_done,exp_trans.error);
        $display("monitor data : PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",act_trans.PSEL,act_trans.PENABLE,act_trans.PWRITE,act_trans.PADDR,act_trans.PWDATA,act_trans.PSTRB,act_trans.PRDATA,act_trans.transfer_done,act_trans.error);
      end
    end
    else if(exp_trans.write_read==0 && act_trans.PWRITE==0) begin
      if((exp_trans.addr_in ==act_trans.PADDR)&&
          (exp_trans.PRDATA==act_trans.rdata_out)&&
          (exp_trans.PSLVERR==act_trans.error)) begin
        pass++;
        $display("Pass");
      end
      else begin
        fail++;
        $display("Fail: scoreboard data: PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",exp_trans.PSEL,exp_trans.PENABLE,exp_trans.PWRITE,exp_trans.PADDR,exp_trans.PWDATA,exp_trans.PSTRB,exp_trans.rdata_out,exp_trans.transfer_done,exp_trans.error);
        $display("monitor data : PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",act_trans.PSEL,act_trans.PENABLE,act_trans.PWRITE,act_trans.PADDR,act_trans.PWDATA,act_trans.PSTRB,act_trans.PRDATA,act_trans.transfer_done,act_trans.error);
      end
    end
    else begin
      fail++;
      $display("Fail case: write_read incorrect");
    end
    $display("Pass:%0d ",pass);
    $display("Fail: %0d ",fail);
  endtask
endclass

  
