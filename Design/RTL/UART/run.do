vlog *.v
vsim -voptargs=+acc -gui work.UART_rx_tb
add wave -position insertpoint sim:/UART_rx_tb/*
add wave -position insertpoint  \
sim:/UART_rx_tb/DUT/cs \
sim:/UART_rx_tb/DUT/ns
add wave -position insertpoint  \
sim:/UART_rx_tb/DUT/baud_counter
run -all
