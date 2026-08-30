onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -radix unsigned /ClkDiv_test/DUT/i_div_ratio
add wave -noupdate -color {Violet Red} /ClkDiv_test/DUT/i_ref_clk
add wave -noupdate -color {Orange Red} /ClkDiv_test/DUT/o_div_clk
add wave -noupdate /ClkDiv_test/DUT/i_clk_en
add wave -noupdate /ClkDiv_test/DUT/enable
add wave -noupdate /ClkDiv_test/DUT/is_even
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4448871 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4404720 ps} {4524144 ps}
