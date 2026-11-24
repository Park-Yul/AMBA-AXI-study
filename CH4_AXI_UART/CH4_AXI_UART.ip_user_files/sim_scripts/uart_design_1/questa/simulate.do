onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib uart_design_1_opt

do {wave.do}

view wave
view structure
view signals

do {uart_design_1.udo}

run -all

quit -force
