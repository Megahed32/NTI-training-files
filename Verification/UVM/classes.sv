 `include "uvm_macros.svh"
 `include "interface.sv"
package classes_pkg;
                        import uvm_pkg::*;
                       

                    class my_sequence_item extends uvm_sequence_item ;
                        `uvm_object_utils(my_sequence_item);
                        function new(string name = "my_sequence_item");
                             super.new(name);
                        endfunction


                        randc logic [3:0] addr;
                        rand logic [31:0] data_in;
                        rand logic re;
                        rand logic en;
                        rand logic rst;
                        logic [31:0] data_out;
                        logic valid_out;
                        
                        
                        constraint rst_c     { rst dist {1 := 10 , 0 := 90}; }
                        constraint en_c      { en dist {1 := 50 , 0 := 50}; }
                        constraint re_c      { re != en; }
                        
                        constraint data_in_c {data_in dist {32'hFFFFFFFF := 10 , 32'h00000000 := 10 , [32'h00000001 : 32'hFFFFFFFE] :/ 80}; }

                    endclass

                class my_driver extends uvm_driver #(my_sequence_item);

                    `uvm_component_utils(my_driver);
                     virtual intf vif_driver;
                     my_sequence_item seq_item;

                    function new(string name = "my_driver" , uvm_component parent = null);
                     super.new(name , parent);
                    endfunction
                
                    function void build_phase(uvm_phase phase);
                        super.build_phase(phase);
                        if (!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_driver)))
                        `uvm_info("Getting VIF in driver", $sformatf("Failed"), UVM_LOW);
                        $display("driver build phase");
                    endfunction

                    function void connect_phase(uvm_phase phase);
                        super.connect_phase(phase);
                        $display("driver connect phase");
                    endfunction

                    task run_phase(uvm_phase phase);
                        super.run_phase(phase);

                        $display("driver run phase");
                        forever
                        begin
                        seq_item_port.get_next_item(seq_item);
                        // Drive signals to DUT
                        @(posedge vif_driver.clk);
                        vif_driver.rst      = seq_item.rst;
                        vif_driver.re       = seq_item.re;
                        vif_driver.en       = seq_item.en;
                        vif_driver.addr     = seq_item.addr;       
                        vif_driver.data_in  = seq_item.data_in;
                        seq_item_port.item_done();
                        end 
                    endtask
                endclass

                class my_sequencer extends uvm_sequencer #(my_sequence_item);

                    `uvm_component_utils(my_sequencer);

                    function new(string name = "my_sequencer" , uvm_component parent = null);
                     super.new(name , parent);
                    endfunction

                    function void build_phase(uvm_phase phase);
                        super.build_phase(phase);
                    
                        $display("sequencer build phase");
                    endfunction

                    function void connect_phase(uvm_phase phase);
                        super.connect_phase(phase);
                        $display("sequencer connect phase");
                    endfunction

                    task run_phase(uvm_phase phase);
                        super.run_phase(phase);
                        $display("sequencer run phase");
                    endtask
                endclass


                class my_monitor extends uvm_monitor;

                    `uvm_component_utils(my_monitor);
                    virtual intf vif_monitor;
                    my_sequence_item seq_item;
                    uvm_analysis_port #(my_sequence_item) monitor_ap;

                    function new(string name = "my_monitor" , uvm_component parent = null);
                    super.new(name , parent);
                    endfunction

                    function void build_phase(uvm_phase phase);
                        super.build_phase(phase);
                        if (!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_monitor)))
                        `uvm_info("Getting VIF in monitor", $sformatf("Failed"), UVM_LOW);
                        seq_item  = my_sequence_item::type_id::create("seq_item");
                        monitor_ap  = new("monitor_ap", this);

                        $display("monitor build phase");
                    endfunction

                    function void connect_phase(uvm_phase phase);
                        super.connect_phase(phase);
                        $display("monitor connect phase");
                    endfunction

                    task run_phase(uvm_phase phase);
                        super.run_phase(phase);
                        $display("monitor run phase");
                        forever
                        begin   
                            @(posedge vif_monitor.clk);
                            if(!vif_monitor.valid_out) begin
                            seq_item.rst       = vif_monitor.rst;
                            seq_item.re        = vif_monitor.re;
                            seq_item.en        = vif_monitor.en;
                            seq_item.addr      = vif_monitor.addr;       
                            seq_item.data_in   = vif_monitor.data_in;
                            monitor_ap.write(seq_item);
                            end else
                            begin
                            seq_item.re        = vif_monitor.re;
                            seq_item.data_out  = vif_monitor.data_out;
                            seq_item.valid_out = vif_monitor.valid_out;
                            monitor_ap.write(seq_item);
                            end
                                                      
                    
                            
                        end
                    endtask
                endclass


            class my_agent extends uvm_agent;
                `uvm_component_utils(my_agent);
                my_driver driver;
                my_sequencer sequencer;
                my_monitor monitor;

                virtual intf vif_agent;

                uvm_analysis_port #(my_sequence_item) agent_ap;

                function new(string name = "my_agent" , uvm_component parent = null);
                 super.new(name , parent);
                  agent_ap  = new("agent_ap", this);
                endfunction

                function void build_phase(uvm_phase phase);
                    super.build_phase(phase);
                    driver = my_driver::type_id::create("driver", this);
                    sequencer = my_sequencer::type_id::create("sequencer", this);
                    monitor = my_monitor::type_id::create("monitor", this);

                   

                    if (!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_agent)))
                    `uvm_info("Getting VIF in agent", $sformatf("Failed"), UVM_LOW);
                    uvm_config_db #(virtual intf)::set(this , "driver" , "my_vif" , vif_agent);
                    uvm_config_db #(virtual intf)::set(this , "monitor" , "my_vif" , vif_agent);

                    $display("agent build phase");
                endfunction

                function void connect_phase(uvm_phase phase);
                    super.connect_phase(phase);
                    monitor.monitor_ap.connect(agent_ap);
                    driver.seq_item_port.connect(sequencer.seq_item_export);
                    $display("agent connect phase");
                endfunction

                task run_phase(uvm_phase phase);
                    super.run_phase(phase);
                    $display("agent run phase");
                endtask
            endclass

            class my_subscriber extends uvm_subscriber #(my_sequence_item);
                `uvm_component_utils (my_subscriber);
                
                my_sequence_item seq_item;

                virtual function void write(T t);

                endfunction


                function new(string name = "my_subscriber" , uvm_component parent = null);
                 super.new(name , parent);
                endfunction

                function void build_phase(uvm_phase phase);
                    super.build_phase(phase);
                    seq_item  = my_sequence_item::type_id::create("seq_item");
                    $display("subscriber build phase");
                endfunction
                
                function void connect_phase(uvm_phase phase);
                    super.connect_phase(phase);
                    $display("subscriber connect phase");
                endfunction

                task run_phase(uvm_phase phase);
                    super.run_phase(phase);
                    
                    $display("subscriber run phase");
                endtask
            endclass


            class my_sb extends uvm_scoreboard;
                `uvm_component_utils (my_sb);
                
                uvm_tlm_analysis_fifo #(my_sequence_item) sb_fifo;
                uvm_analysis_export #(my_sequence_item) sb_aexport;
                my_sequence_item seq_item;

                function new(string name = "my_sb" , uvm_component parent = null);
                 super.new(name , parent);
                endfunction

                virtual function void write(my_sequence_item t);
                endfunction
                
                

                function void build_phase(uvm_phase phase);
                    super.build_phase(phase);
                    sb_fifo = new("sb_fifo", this);
                    sb_aexport = new("sb_aexport", this);
                    seq_item  = my_sequence_item::type_id::create("seq_item");
                    $display("scoreboard build phase");
                endfunction
                
                function void connect_phase(uvm_phase phase);
                    super.connect_phase(phase);
                    sb_aexport.connect(sb_fifo.analysis_export);
                    $display("scoreboard connect phase");
                endfunction

                task run_phase(uvm_phase phase);
                    super.run_phase(phase);
                    $display("scoreboard run phase");
                    forever begin
                    sb_fifo.get_peek_export.get(seq_item);
                    `uvm_info("Scoreboard", $sformatf("Scoreboard received item %p at time %t", seq_item, $time), UVM_LOW);
                    end
                
                endtask
            endclass

        
        class my_env extends uvm_env;
            `uvm_component_utils (my_env);
            my_subscriber subscriber ;
            my_agent agt1;
            my_sb scoreboard;
            virtual intf vif_env;

            function new(string name = "my_env" , uvm_component parent = null);
                super.new(name , parent);
            endfunction

           function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            subscriber = my_subscriber::type_id::create("subscriber", this);
            agt1 = my_agent::type_id::create("agt1", this);
            scoreboard = my_sb::type_id::create("scoreboard", this);

            if(!uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_env))
            `uvm_info("Getting VIF in env", $sformatf("Failed"), UVM_LOW);
            uvm_config_db #(virtual intf)::set(this , "agt1" , "my_vif" , vif_env);
            $display("env build phase");
           endfunction

           function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);


            agt1.agent_ap.connect(scoreboard.sb_fifo.analysis_export);
            agt1.agent_ap.connect(subscriber.analysis_export);
             $display("env connect phase");
           endfunction

            task run_phase(uvm_phase phase);
                super.run_phase(phase);
                $display("env run phase");
            endtask
        endclass


        class my_sequence extends uvm_sequence;
               `uvm_object_utils (my_sequence);
                my_sequence_item seq_item;

                function new(string name = "my_sequence");
                 super.new(name);
                endfunction

                task pre_body();
                    `uvm_info("Sequence", $sformatf("In pre_body"), UVM_LOW);
                    seq_item = my_sequence_item::type_id::create("seq_item");
                endtask

                task body();
                    `uvm_info("Sequence", $sformatf("In body"), UVM_LOW);

                    //reset task
                    repeat(4) begin
                        start_item(seq_item);
                    seq_item.randomize() with {
                        seq_item.rst == 0;
                    };
                    finish_item(seq_item);
                    end

                    // Generate 16 transactions for all address locations
                    repeat(16) begin
                        start_item(seq_item);
                        seq_item.randomize() with {
                            seq_item.rst == 1;
                            seq_item.en  == 1;
                        };
                        finish_item(seq_item);
                    end

                    repeat(16) begin
                        start_item(seq_item);
                        seq_item.randomize() with {
                            seq_item.rst == 1;
                            seq_item.en  == 0;
                        };
                        finish_item(seq_item);
                    end
                    
                    
                endtask
        endclass


            
    class my_test extends uvm_test;
        `uvm_component_utils (my_test);
        
        my_env env;
        my_sequence seq;

        virtual intf vif_test;
        
        function new(string name = "my_test" , uvm_component parent = null);
            super.new(name , parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = my_env::type_id::create("env", this);
            seq = my_sequence::type_id::create("sequence");

            if(!(uvm_config_db #(virtual intf)::get(this , "" , "my_vif" , vif_test)))
            `uvm_info("Getting VIF in test", $sformatf("Failed"), UVM_LOW);
            uvm_config_db #(virtual intf)::set(this , "env" , "my_vif" , vif_test);

            $display("test build phase");

        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
             $display("test connect phase");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            $display("test run phase");

            phase.raise_objection(this);
            seq.start(env.agt1.sequencer);
            phase.drop_objection(this);

        endtask

    endclass

endpackage

