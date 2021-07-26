library IEEE;
use IEEE.std_logic_1164.all;
use work.sm16_types.all;

-- datapath Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity datapath is
    port( CLK   : in std_logic;
          RESET : in std_logic;
          
          -- I/O with Data Memory
          DATA_IN   : out sm16_data;
          DATA_OUT  : in  sm16_data;
          DATA_ADDR : out sm16_address;
          
          -- I/O with Instruction Memory
          INSTR_OUT  : in  sm16_data;
          INSTR_ADDR : out sm16_address;
          
          
          -- Control Signals to the ALU
          ALU_OP : in std_logic_vector(1 downto 0);
          B_INV  : in std_logic;
          CIN    : in std_logic;
          
          
          -- ALU Multiplexer Select Signals
          A_SEL  : in std_logic;
          B_SEL  : in std_logic;
        
          -- Enable Signals for all registers
          EN_PC : in std_logic;
          
 ---------- I ADDED THESE
          --OP Signals
          OP2 : out std_logic_vector (3 downto 0);
          OP3 : out std_logic_vector (3 downto 0);
          
          -- Enable Signals
          EN_INSTR : in std_logic;
          EN_IMM : in std_logic;
          EN_OP : in std_logic;
          EN_DATA : in std_logic;
          EN_RV : in std_logic;
          EN_B2R : in std_logic;
          EN_ABCD : in std_logic
         
          
          );
end datapath;

-- datapath Architecture Description
architecture structural of datapath is
    
    -- declare all components and their ports 
    component address_reg is
        port( CLK : in std_logic;
              RESET : in std_logic;
              EN : in std_logic;
              D : in sm16_address;
              Q : out sm16_address);
    end component;
    
    component data_reg is
        port( CLK : in std_logic;
              RESET : in std_logic;
              EN : in std_logic;
              D : in sm16_data;
              Q : out sm16_data);
    end component;
    
    component alu is
        port( A : in sm16_data;
              B : in sm16_data;
              OP : in std_logic_vector(1 downto 0);
              D : out sm16_data;
              CIN : in std_logic;
              B_INV : in std_logic);
    end component;
    
    component adder is
        port( A : in sm16_address;
              B : in sm16_address;
              D : out sm16_address);
    end component;
    
    component mux2_addr is
        port( IN0 : in sm16_address;
              IN1 : in sm16_address;
              SEL : in std_logic;
              DOUT : out sm16_address);
    end component;
    
    component mux2_data is
        port( IN0 : in sm16_data;
              IN1 : in sm16_data;
              SEL : in std_logic;
              DOUT : out sm16_data);
    end component;
    
   component zero_extend is
        port(
             A: in sm16_address;
             Z: out sm16_data
            );
    end component;
    ----------------------------------------------------
    component opcode_reg is
        port( CLK : in std_logic;
            RESET : in std_logic;
            EN : in std_logic;
            D : in sm16_opcode;
            Q : out sm16_opcode);
        end component;
        
        component bit2_reg is
            port( CLK : in std_logic;
            RESET : in std_logic;
            EN : in std_logic;
            D : in std_logic_vector(1 downto 0);
            Q : out std_logic_vector(1 downto 0));
        end component;
        
       component ABCDRegFile is
          port( CLK : in std_logic;
                RESET : in std_logic;
          
                RD_REG : in std_logic_vector(1 downto 0);  -- Which register to read and output
                REG_OUT : out sm16_data;
          
                ABCD_WE : in std_logic; -- Write enable signal
                WR_REG : in std_logic_vector(1 downto 0);  -- Which register to write to
                REG_IN : in sm16_data);
        end component;
        
        
    
    signal zero_16 : sm16_data := "0000000000000000";
    signal alu_a, alu_b, alu_out : sm16_data;
    signal pc_out, pc_in : sm16_address;
    signal a_out, immediate_zero_extend_out : sm16_data;
    signal adderout : std_logic_vector(9 downto 0);
    signal instrwrdout, signexout,abcdregout, dataregout : std_logic_vector (15 downto 0); -- I added this
    signal bit2regout : std_logic_vector (1 downto 0);
    
    
begin

        SignEx: zero_extend port map(
        A=> instrwrdout(9 downto 0),
        Z=> signexout
        );
        
        Immediate:data_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN => EN_IMM,
           D => signexout,
           Q => immediate_zero_extend_out
        
        );

        DataReg:data_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN => EN_DATA,
           D => DATA_OUT,
           Q => dataregout
        
        );
        InstrWord:data_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN => EN_INSTR,
           D => INSTR_OUT,
           Q => instrwrdout
        
        );

    OpcodeReg:opcode_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN => EN_OP,
           D => instrwrdout(15 downto 12),
           Q => OP3
             );
    
    Bit2Reg:bit2_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN =>  EN_B2R,
           D => instrwrdout(11 downto 10),
           Q => bit2regout
    );
    
    RegValue:data_reg port map(
           CLK => CLK,
           RESET => RESET,
           EN => EN_RV,
           D => abcdregout,
           Q => a_out
    
    );
    
    ABCDReg:ABCDRegFile port map(
               CLK => CLK,
               RESET => RESET,
               RD_REG => instrwrdout(11 downto 10),
               REG_OUT => abcdregout,
               ABCD_WE => EN_ABCD, 
               WR_REG => bit2regout, 
               REG_IN => alu_out
    );
    
    TheAlu: alu port map (
        A     => alu_a,
        B     => alu_b,
        OP    => ALU_OP,
        D     => alu_out,
        CIN   => CIN,
        B_INV => B_INV
        );
    
    PCadder: adder port map (
        A => pc_out,
        B => "0000000001",
        D => adderout
        );
    
    Amux: mux2_data port map (
        IN0  => zero_16,  -- 00
        IN1  => a_out,  -- 01
        SEL  => A_SEL,
        DOUT => alu_a
        );
    
    Bmux: mux2_data port map (
        IN0  => dataregout,  -- 00
        IN1  => immediate_zero_extend_out,  -- 01
        SEL  => B_SEL,
        DOUT => alu_b
        );
 	
    
    ProgramCounter: address_reg port map (
        CLK   => CLK,
        RESET => RESET,
        EN    => EN_PC,
        D     => pc_in,
        Q     => pc_out
        );
    
    

    OP2 <= instrwrdout(15 downto 12);
    DATA_IN   <= abcdregout;
    DATA_ADDR <= instrwrdout(9 downto 0);
    INSTR_ADDR <= pc_out;
    
end structural;
