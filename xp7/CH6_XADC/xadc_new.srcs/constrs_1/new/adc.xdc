set_property -dict { PACKAGE_PIN U18    IOSTANDARD LVCMOS33 } [get_ports {clk}];
set_property -dict { PACKAGE_PIN T19    IOSTANDARD LVCMOS33 } [get_ports {txd}];

set_property -dict { PACKAGE_PIN M19  IOSTANDARD LVCMOS33 } [get_ports {vauxp2}]; 
set_property -dict { PACKAGE_PIN M20  IOSTANDARD LVCMOS33 } [get_ports {vauxn2}]; 
set_property -dict { PACKAGE_PIN M17  IOSTANDARD LVCMOS33 } [get_ports {vauxp10}];	 
set_property -dict { PACKAGE_PIN M18  IOSTANDARD LVCMOS33 } [get_ports {vauxn10}];

set_property -dict { PACKAGE_PIN W20 IOSTANDARD LVCMOS33 } [get_ports {data[0]}];
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports {data[1]}];
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports {data[2]}];
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {data[3]}];
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {data[4]}];
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {data[5]}];
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports {data[6]}];
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {data[7]}];
set_property -dict { PACKAGE_PIN V20 IOSTANDARD LVCMOS33 } [get_ports {lcd_e}];
set_property -dict { PACKAGE_PIN U20 IOSTANDARD LVCMOS33 } [get_ports {lcd_rs}];

