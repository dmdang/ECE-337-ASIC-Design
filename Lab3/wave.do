onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold /tb_adder_16bit/tb_test_case
add wave -noupdate -color Gold /tb_adder_16bit/tb_test_case_err
add wave -noupdate -color Gold /tb_adder_16bit/tb_test_case_num
add wave -noupdate -color Gold /tb_adder_16bit/tb_test_case_stage
add wave -noupdate -divider {DUT Signals}
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_a
add wave -noupdate -radix unsigned /tb_adder_16bit/tb_b
add wave -noupdate /tb_adder_16bit/tb_carry_in
add wave -noupdate -expand -group Sum -color Magenta /tb_adder_16bit/tb_sum
add wave -noupdate -expand -group Sum -color Cyan /tb_adder_16bit/tb_expected_sum
add wave -noupdate -expand -group Overflow -color Cyan /tb_adder_16bit/tb_expected_overflow
add wave -noupdate -expand -group Overflow -color Magenta /tb_adder_16bit/tb_overflow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {102580870 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 78
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
WaveRestoreZoom {18178 ps} {74893 ps}
