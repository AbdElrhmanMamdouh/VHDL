library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reg is
    Port (
        clk : in STD_LOGIC;
        regWrite : in STD_LOGIC;
        readReg1, readReg2, writeReg : in STD_LOGIC_VECTOR(4 downto 0);
        writeData : in STD_LOGIC_VECTOR(31 downto 0);
        readData1, readData2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Reg;

architecture Behavioral of Reg is
    type RegisterArray is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0); -- Array of register
    signal registers : RegisterArray;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if regWrite = '1' then 
                registers(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
    end process;

    readData1 <= registers(to_integer(unsigned(readReg1)));
    readData2 <= registers(to_integer(unsigned(readReg2)));

end Behavioral;
