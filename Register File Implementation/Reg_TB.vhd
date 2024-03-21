library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reg_TB is
end Reg_TB;

architecture Behavioral of Reg_TB is
    component Reg is
        port (
            clk : in STD_LOGIC;
            regWrite : in STD_LOGIC;
            readReg1, readReg2, writeReg : in STD_LOGIC_VECTOR(4 downto 0);
            writeData : in STD_LOGIC_VECTOR(31 downto 0);
            readData1, readData2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
    End component;

    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    constant undefined: std_logic_vector(31 downto 0) := (others => 'U');


    -- Signals
    signal clk : std_logic := '0';
    signal regWrite : std_logic := '0';
    signal readReg1, readReg2, writeReg : std_logic_vector(4 downto 0);
    signal writeData : std_logic_vector(31 downto 0);
    signal dataOut1, dataOut2 : std_logic_vector(31 downto 0);

begin
    -- Instantiate the RegisterFile component
    Reg_TB: Reg

    port map(
        clk => clk,
        regWrite => regWrite,
        readReg1 => readReg1,
        readReg2 => readReg2,
        writeReg => writeReg,
        writeData => writeData,
        readData1 => dataOut1,
        readData2 => dataOut2
    );

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test cases
    test_process: process
    begin
        -- Case 1: Writing data to a register and reading it back
        writeReg <= "00001";
        writeData <= "10101010101010101010101010101010";
        regWrite <= '1';
        wait for CLK_PERIOD;
        regWrite <= '0';
        readReg1 <= "00001";
        readReg2 <= "00000";
        wait for CLK_PERIOD;
        assert dataOut1 = writeData
            report "Test Case 1 failed: Incorrect data read from register"
            severity error;

        -- Case 2: Writing data with regWrite=0, no change expected
        writeReg <= "00010";
        writeData <= "11111111111111111111111111111111";
        regWrite <= '0';
        wait for CLK_PERIOD;
        readReg1 <= "00010";
        readReg2 <= "00000";
        wait for CLK_PERIOD;
        assert dataOut1 = undefined and dataOut2 = undefined
            report "Test Case 2 failed: Unexpected data read from register"
            severity error;

        -- Case 3: Writing and reading from the same register in the same clock cycle
        writeReg <= "00011";
        writeData <= "01010101010101010101010101010101";
        regWrite <= '1';
        readReg1 <= "00011";
        readReg2 <= "00000";
        wait for CLK_PERIOD;
        assert dataOut1 = writeData
            report "Test Case 3 failed: Incorrect data read from register"
            severity error;

        -- Case 4: Multiple Write and Read
		writeReg <= "00000";
		writeData <= "11110000111100001111000011110000"; -- Data to be written
		regWrite <= '1';
		wait for CLK_PERIOD;
		regWrite <= '0';

		writeReg <= "00001";
		writeData <= "11111111111111111111111111111111"; -- Different data for another register
		regWrite <= '1';
		wait for CLK_PERIOD;
		regWrite <= '0';

		-- Read data from the written registers
		readReg1 <= "00000";
		readReg2 <= "00001";
		wait for CLK_PERIOD;

		-- Assert the read data matches the written data
		assert dataOut1 = "11110000111100001111000011110000" and dataOut2 = "11111111111111111111111111111111"
			report "Test Case 4 failed: Incorrect data read from register(s)"
			severity error;

        -- End of test cases
        wait;
    end process;

end Behavioral;
