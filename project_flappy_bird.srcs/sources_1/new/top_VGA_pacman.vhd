----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2024 09:41:51
-- Design Name: 
-- Module Name: top_VGA_pacman - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_VGA_pacman is
    Port ( clk_100MHz : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0));
end top_VGA_pacman;

architecture Behavioral of top_VGA_pacman is
component clk_25MHz
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component vga_sync is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : out std_logic; 
           vsync : out std_logic; 
           hc : out std_logic_vector(9 downto 0); 
           vc : out std_logic_vector(9 downto 0); 
           vidon : out std_logic );
end component vga_sync;

component vga_RGB is
    Port ( M : in STD_LOGIC_VECTOR (15 downto 0);
           hc : in STD_LOGIC_VECTOR (9 downto 0);
           vc : in STD_LOGIC_VECTOR (9 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           vidon : in STD_LOGIC;
           blue : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           rom_addr4 : out STD_LOGIC_VECTOR (4 downto 0));
end component vga_RGB;

component blk_mem_firstSprite
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

signal clk_25: std_logic;
signal addra: std_logic_vector (4 downto 0);
signal douta: std_logic_vector (15 downto 0);
signal hc :  std_logic_vector(9 downto 0);
signal vc :  std_logic_vector(9 downto 0);
signal vidon : STD_LOGIC;
signal sw :  STD_LOGIC_VECTOR (15 downto 0);

begin
CLK1 : clk_25MHz
port map ( 
  -- Clock out ports  
   clk_out1 => clk_25,
  -- Status and control signals                
   reset => clr,
   locked => open,
   -- Clock in ports
   clk_in1 => clk_100MHz);
   
SYNC : vga_sync 
    Port map( clk => clk_25,
           clr => clr,
           hsync => hsync, 
           vsync => vsync, 
           hc => hc, 
           vc => vc, 
           vidon => vidon ); 
           
RGB : vga_RGB 
    Port map ( M => douta,
           hc => hc,
           vc => vc,
           sw => sw,
           vidon => vidon,
           blue => vgaBlue,
           green => vgaGreen,
           red => vgaRed,
           rom_addr4 => addra);
           
SPRITE : blk_mem_firstSprite
  PORT MAP (
    clka => clk_100MHz,
    addra => addra,
    douta => douta
  );

end Behavioral;
