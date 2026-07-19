include "defines.sv"
interface apb_if(input bit PCLK,PRESETn);
logic transfer, write_read;
logic [`ADDR_WIDTH-1:0]addr_in;
logic [`DATA_WIDTH-1:0]wdata_in;
logic [`DATA_WIDTH/8 -1:0]strb_in;
logic [`DATA_WIDTH-1:0]PRDATA;
logic PREADY;
logic PSLVERR;
logic [`ADDR_WIDTH-1:0]PADDR;
logic PSEL;
logic PENABLE;
logic [`DATA_WIDTH-1:0]PWDATA;
logic [`DATA_WIDTH/8 -1:0]PSTRB;
logic [`DATA_WIDTH-1:0]rdata_out;
logic transfer_done;
logic error;
logic PWRITE;
property p_reset;
@(posedge PCLK) !PRESETn |-> (PSEL==0 && PENABLE==0 && PWRITE==0 && PADDR==0 && PWDATA==0 && PSTRB==0 && rdata_out==0 && transfer_done==0 && error==0);
endproperty
a_reset: assert property(p_reset)
$display("Reset Assertion passed ", $time);
else
$error("Reset assertion failed",$time);
property p_idle;
@(posedge PCLK) !(PSEL) |-> !(PENABLE);
endproperty
a_idle: assert property(p_idle)
$display("Idle passed ", $time);
else
$error("Idle failed",$time);
property p_setup_access;
@(posedge PCLK) $rose(PSEL) |=> PENABLE;
endproperty
a_setup: assert property(p_setup_access)
$display("Setup_Access passed ", $time);
else
$error("Setup_Access failed",$time);

property p_enable;
@(posedge PCLK) PENABLE |-> PSEL;
endproperty
a_enable: assert property(p_enable)
$display("Enable passed ", $time);
else
$error("Enable failed",$time);

property p_setup;
@(posedge PCLK) (PSEL && !PENABLE) |-> 1;
endproperty
a_setup2: assert property(p_setup)
$display("Setup passed ", $time);
else
$error("Setup failed",$time);

property p_addr_stable;
@(posedge PCLK) (PSEL && PENABLE && !PREADY) |=> $stable(PADDR);
endproperty
a_addr_stable: assert property(p_addr_stable)
$display("Addr stable passed ", $time);
else
$error("Addr stable failed",$time);

property p_wdata;
@(posedge PCLK) (PSEL && PENABLE && PWRITE && !PREADY) |=> $stable(PWDATA);
endproperty
a_p_wdata: assert property(p_wdata)
$display("Write stable passed ", $time);
else
$error("Write stable failed",$time);

property p_pwrite;
@(posedge PCLK) (PSEL && PENABLE && !PREADY) |=> $stable(PWRITE);
endproperty
a_pwrite: assert property(p_pwrite)
$display("PWRITE stable passed ", $time);
else
$error("PWRITE stable failed",$time);

property p_done;
  @(posedge PCLK) !PREADY |=> !transfer_done;
endproperty
a_done: assert property(p_done)
$display("done passed ", $time);
else
$error("done failed",$time);

property p_error;
  @(posedge PCLK) error |-> $past(PREADY && PSLVERR);
endproperty
a_error: assert property(p_error)
$display("Error passed ", $time);
else
$error("Error failed",$time);

property p_wait_error;
@(posedge PCLK) (PSEL && PENABLE && !PREADY) |-> !error;
endproperty
a_wait_error: assert property(p_wait_error)
$display("Error  passed ", $time);
else
$error("Error failed",$time);



property p_idle_return;
@(posedge PCLK) (PSEL && PENABLE && PREADY && !transfer) |=> (!PSEL && !PENABLE);
endproperty
a_idle_return : assert property(p_idle_return)
$display("Idle return passed ", $time);
else
$error("Idle return failed",$time);

property p_psel;
@(posedge PCLK) (PSEL) |-> transfer;
endproperty
a_psel: assert property(p_psel)
$display("PSEL transfer passed ", $time);
else
$error("PSEL transfer failed",$time);

property p_idle_enable;
@(posedge PCLK) !PSEL |-> !PENABLE;
endproperty
a_idle_enable: assert property(p_idle_enable)
$display("Idle ENABLE passed ", $time);
else
$error("Idle ENABLE failed",$time);

property p_read_PWRITE;
  @(posedge PCLK) (PSEL && write_read==0) |=> !PWRITE;
endproperty
a_read_PWRITE: assert property(p_read_PWRITE)
$display("PWRITE read passed ", $time);
else
$error("PWRITE read failed",$time);

property p_write_PWRITE;
  @(posedge PCLK) (PSEL && write_read==1) |=> PWRITE;
endproperty
a_write_PWRITE: assert property(p_write_PWRITE)
$display("PWRITE write passed ", $time);
else
$error("PWRITE write failed",$time);
property p_wait_sig;
@(posedge PCLK) (PSEL && PENABLE &&!PREADY) |=> (PSEL && PENABLE);
endproperty
a_wait_sig: assert property(p_wait_sig)
$display("Wait PREADY passed ", $time);
else
$error("Wait PREADY failed",$time);

property p_setup_cycle;
@(posedge PCLK) (PSEL && !PENABLE) |=> (PSEL && PENABLE);
endproperty
a_setup_cycle: assert property(p_setup_cycle)
$display("Setup one cycle passed ", $time);
else
$error("Setup one cycle failed",$time);

property p_done_pulse;
@(posedge PCLK) $rose(transfer_done) |=> !transfer_done;
endproperty
a_done_pulse: assert property(p_done_pulse)
$display("Idle passed ", $time);
else
$error("Idle failed",$time);

property p_done_comp;
  @(posedge PCLK) transfer_done |-> $past( PSEL && PENABLE && PREADY);
endproperty
a_done_comp: assert property(p_done_comp)
$display("transfer_done passed ", $time);
else
$error("transfer_done failed",$time);
  
clocking drv_cb @(posedge PCLK);
default input #1 output #0;
output transfer, write_read, addr_in, wdata_in, strb_in, PRDATA, PREADY, PSLVERR;
input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;
input PRESETn;
endclocking

clocking mon_cb @(posedge PCLK);
default input #1 output #0;
input transfer, write_read, addr_in, wdata_in, strb_in, PRDATA, PREADY, PSLVERR;
input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB, rdata_out, transfer_done, error;
endclocking
modport DRV(clocking drv_cb);
modport MON(clocking mon_cb);
endinterface

  
