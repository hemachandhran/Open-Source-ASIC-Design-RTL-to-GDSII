`timescale 1ns/1ps

module housekeeping_spi_tb;

    // Inputs
    reg reset;
    reg SCK;
    reg SDI;
    reg CSB;
    reg [7:0] idata;

    // Outputs
    wire SDO;
    wire sdoenb;
    wire [7:0] odata;
    wire [7:0] oaddr;
    wire rdstb;
    wire wrstb;
    wire pass_thru_mgmt;
    wire pass_thru_mgmt_delay;
    wire pass_thru_user;
    wire pass_thru_user_delay;
    wire pass_thru_mgmt_reset;
    wire pass_thru_user_reset;

    //-------------------------------------------------------
    // DUT
    //-------------------------------------------------------

    housekeeping_spi dut (
        .reset(reset),
        .SCK(SCK),
        .SDI(SDI),
        .CSB(CSB),
        .SDO(SDO),
        .sdoenb(sdoenb),
        .idata(idata),
        .odata(odata),
        .oaddr(oaddr),
        .rdstb(rdstb),
        .wrstb(wrstb),
        .pass_thru_mgmt(pass_thru_mgmt),
        .pass_thru_mgmt_delay(pass_thru_mgmt_delay),
        .pass_thru_user(pass_thru_user),
        .pass_thru_user_delay(pass_thru_user_delay),
        .pass_thru_mgmt_reset(pass_thru_mgmt_reset),
        .pass_thru_user_reset(pass_thru_user_reset)
    );

    //-------------------------------------------------------
    // Clock Generation
    //-------------------------------------------------------

    initial
        SCK = 0;

    always #5 SCK = ~SCK;

    //-------------------------------------------------------
    // Send one SPI byte (MSB first)
    //-------------------------------------------------------

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            for(i=7;i>=0;i=i-1)
            begin
                @(negedge SCK);
                SDI = data[i];
            end
        end
    endtask

    //-------------------------------------------------------
    // SPI Transaction
    //-------------------------------------------------------

    task spi_transaction;
        input [7:0] cmd;
        input [7:0] addr;
        input [7:0] data;
        begin

            @(negedge SCK);
            CSB = 0;

            send_byte(cmd);
            send_byte(addr);
            send_byte(data);

            @(negedge SCK);
            CSB = 1;

            repeat(4) @(posedge SCK);

        end
    endtask

    //-------------------------------------------------------
    // Waveform
    //-------------------------------------------------------

    initial begin
        $dumpfile("housekeeping_spi.vcd");
        $dumpvars(0,housekeeping_spi_tb);
    end

    //-------------------------------------------------------
    // Test Sequence
    //-------------------------------------------------------

    initial begin

        reset = 1;
        CSB   = 1;
        SDI   = 0;
        idata = 8'hA5;

        #20;
        reset = 0;

        //---------------------------------------------------
        $display("\n========== TEST 1 : WRITE ==========");
        //---------------------------------------------------

        spi_transaction(8'h80,8'h10,8'h55);

        //---------------------------------------------------
        $display("\n========== TEST 2 : READ ==========");
        //---------------------------------------------------

        spi_transaction(8'h40,8'h10,8'h00);

        //---------------------------------------------------
        $display("\n========== TEST 3 : MGMT PASS ==========");
        //---------------------------------------------------

        spi_transaction(8'hC4,8'h00,8'h00);

        //---------------------------------------------------
        $display("\n========== TEST 4 : USER PASS ==========");
        //---------------------------------------------------

        spi_transaction(8'hC2,8'h00,8'h00);

        #100;

        $display("\n========== SIMULATION COMPLETED ==========");

        $finish;

    end

    //-------------------------------------------------------
    // Monitors
    //-------------------------------------------------------

    always @(posedge wrstb)
        $display("[%0t] WRITE  Addr=%h Data=%h",
                 $time,oaddr,odata);

    always @(posedge rdstb)
        $display("[%0t] READ   Addr=%h",
                 $time,oaddr);

    always @(posedge pass_thru_mgmt)
        $display("[%0t] Management Pass Enabled",$time);

    always @(posedge pass_thru_user)
        $display("[%0t] User Pass Enabled",$time);

endmodule
