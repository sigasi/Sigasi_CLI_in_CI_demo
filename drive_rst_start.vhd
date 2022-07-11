library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity drive_rst_start is
	port(
		rst   : out std_logic;
		start : out std_logic
	);
end entity drive_rst_start;

architecture RTL of drive_rst_start is
begin
	proc_stim : process
	begin
		rst   <= '1';
		start <= '0';
		wait for 17 ns;
		rst   <= '0';
		wait for 20 ns;
		start <= '1';
		wait for 10 ns;
		start <= '0';
		wait;
	end process;
end architecture RTL;
