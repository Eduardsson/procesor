# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/VLSI/procesor/procesor.cache/wt [current_project]
set_property parent.project_path D:/VLSI/procesor/procesor.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo d:/VLSI/procesor/procesor.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib D:/VLSI/procesor/procesor.srcs/sources_1/imports/new/program_counter.vhd
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top program_counter -part xc7a35tcpg236-1


write_checkpoint -force -noxdef program_counter.dcp

catch { report_utilization -file program_counter_utilization_synth.rpt -pb program_counter_utilization_synth.pb }