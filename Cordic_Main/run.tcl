read_hdl /home/vlsi/Cordic/cordic.v
read_libs /home/install/FOUNDRY/digital/45nm/dig/lib/slow.lib
elaborate cordic_pipeline
syn_generic
syn_map
read_sdc cordic.sdc
syn_opt
# gui_show
# gui_hide
check_design
check_timing_intent
report_qor > cordic_qor.rep
report_timing > cordic_timing.rep
report_power > cordic_power.rep
report_area > cordic_area.rep
write_netlist cordic_pipeline > cordic_synth.v
write_sdc > cordic_sdc.sdc
