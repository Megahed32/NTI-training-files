vlib work
vlog -sv transaction_pkg.sv driver_pkg.sv monitor_pkg.sv sequencer_pkg.sv scoreboard_pkg.sv agent_pkg.sv  subscriber_pkg.sv env_pkg.sv sequence_pkg.sv \
        test_pkg.sv mem.sv tb_top.sv

vsim -voptargs=+acc work.top -gui
add wave -position insertpoint sim:/top/intf1/*
add wave -position insertpoint  \
sim:/scoreboard_pkg::memory_simulation
add wave -position insertpoint  \
sim:/monitor_pkg::address_queue_count
run -all