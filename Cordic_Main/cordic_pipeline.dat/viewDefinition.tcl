if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name SLOW\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow.lib]
create_library_set -name FAST\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast.lib]
create_rc_corner -name RC_CORNER\
   -cap_table ${::IMEX::libVar}/mmmc/capTable\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125\
   -qx_tech_file ${::IMEX::libVar}/mmmc/RC_CORNER/qrcTechFile
create_delay_corner -name MAX_DELAY\
   -library_set SLOW\
   -rc_corner RC_CORNER
create_delay_corner -name MIN_DELAY\
   -library_set FAST\
   -rc_corner RC_CORNER
create_constraint_mode -name CONSTRAINT\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/CONSTRAINT/CONSTRAINT.sdc]
create_analysis_view -name WORSTCASE -constraint_mode CONSTRAINT -delay_corner MAX_DELAY -latency_file ${::IMEX::dataVar}/mmmc/views/WORSTCASE/latency.sdc
create_analysis_view -name BESTCASE -constraint_mode CONSTRAINT -delay_corner MIN_DELAY -latency_file ${::IMEX::dataVar}/mmmc/views/BESTCASE/latency.sdc
set_analysis_view -setup [list WORSTCASE] -hold [list BESTCASE]
