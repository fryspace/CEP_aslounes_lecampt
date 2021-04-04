library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        rs1         : in w32;
        alu_y       : in w32;
        IR          : in w32;
        slt         : out std_logic;
        jcond       : out std_logic
    );
end entity;

architecture RTL of CPU_CND is

    signal resul: signed(32 downto 0);
    signal s : std_logic;
    signal z : std_logic;
    signal e : std_logic;

begin

    e <= ( NOT IR(12) AND NOT IR(6)) OR (IR(6) AND NOT IR(13));
    resul <= signed( rs1(31) & rs1) - signed(alu_y(31) & alu_y) when e = '1'
    else signed('0' & rs1) - signed('0' & alu_y);
    z <= '1' when resul = 0
    else '0';
    s <= resul(32);
    slt <= s;
    jcond <= (NOT IR(14) AND (IR(12) XOR z )) OR ((IR(12) XOR s) AND IR(14));
end architecture;
