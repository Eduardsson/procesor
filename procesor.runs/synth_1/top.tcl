# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /media/psf/Home/Documents/VLSI/procesor/procesor.cache/wt [current_project]
set_property parent.project_path /media/psf/Home/Documents/VLSI/procesor/procesor.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo /media/psf/Home/Documents/VLSI/procesor/procesor.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/rom.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/register.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/program_counter.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/gpio.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/decoder.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/alu.vhd
  /media/psf/Home/Documents/VLSI/procesor/procesor.srcs/sources_1/new/top.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top top -part xc7a35tcpg236-1


write_checkpoint -force -noxdef top.dcp

catch { report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb }