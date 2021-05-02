library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
    generic(
        mutant: integer := 0
    );
    Port (
        -- Clock/Reset
        clk    : in  std_logic ;
        rst    : in  std_logic ;

        -- Interface PC to PO
        cmd    : out PO_cmd ;
        status : in  PO_status
    );
end entity;

architecture RTL of CPU_PC is
    type State_type is (
        S_Error,
        S_Init,
        S_Pre_Fetch,
        S_Fetch,
        S_Decode,
        S_LUI,
        S_ADDI,
        S_ADD,
        S_AND,
        S_SUB,
        S_OR,
        S_ORI,
        S_ANDI,
        S_XOR,
        S_XORI,
        S_SRL,
        S_SRA,
        S_SLL,
        S_SRAI,
        S_SLLI,
        S_SRLI,
        S_AUIPC,
        S_JUMP,
        S_SLT,
        S_SLTI,
        S_JAL,
        S_JALR,
        S_LB,
        S_LB_sel,
        S_LB_we,
        S_LH,
        S_LH_sel,
        S_LH_we,
        S_LW,
        S_LW_sel,
        S_LW_we,
        S_LBU,
        S_LBU_sel,
        S_LBU_we,
        S_LHU,
        S_LHU_sel,
        S_LHU_we,
        S_SB,
        S_SB_2,
        S_SB_3,
        S_SH,
        S_SH_2,
        S_SH_3,
        S_SW,
        S_SW_2,
        S_SW_3
    );

    signal state_d, state_q : State_type;


begin

    FSM_synchrone : process(clk)
    begin
        if clk'event and clk='1' then
            if rst='1' then
                state_q <= S_Init;
            else
                state_q <= state_d;
            end if;
        end if;
    end process FSM_synchrone;

    FSM_comb : process (state_q, status)
    begin

        -- Valeurs par défaut de cmd à définir selon les préférences de chacun
        cmd.ALU_op            <= ALU_plus;
        cmd.LOGICAL_op        <= LOGICAL_and;
        cmd.ALU_Y_sel         <= UNDEFINED;

        cmd.SHIFTER_op        <= SHIFT_ll;
        cmd.SHIFTER_Y_sel     <= SHIFTER_Y_rs2;

        cmd.RF_we             <= '0';
        cmd.RF_SIZE_sel       <= RF_SIZE_word;
        cmd.RF_SIGN_enable    <= '1';
        cmd.DATA_sel          <= DATA_from_pc;

        cmd.PC_we             <= '0';
        cmd.PC_sel            <= PC_from_pc;

        cmd.PC_X_sel          <= PC_X_cst_x00;
        cmd.PC_Y_sel          <= PC_Y_cst_x04;

        cmd.TO_PC_Y_sel       <= TO_PC_Y_cst_x04;

        cmd.AD_we             <= '0';
        cmd.AD_Y_sel          <= UNDEFINED;

        cmd.IR_we             <= '0';

        cmd.ADDR_sel          <= ADDR_from_pc;
        cmd.mem_we            <= '0';
        cmd.mem_ce            <= '1';

        cmd.cs.CSR_we            <= UNDEFINED;

        cmd.cs.TO_CSR_sel        <= UNDEFINED;
        cmd.cs.CSR_sel           <= UNDEFINED;
        cmd.cs.MEPC_sel          <= UNDEFINED;

        cmd.cs.MSTATUS_mie_set   <= 'U';
        cmd.cs.MSTATUS_mie_reset <= 'U';

        cmd.cs.CSR_WRITE_mode    <= UNDEFINED;

        state_d <= state_q;

        case state_q is
            when S_Error =>
                -- Etat transitoire en cas d'instruction non reconnue 
                -- Aucune action
                state_d <= S_Init;

            when S_Init =>
                -- PC <- RESET_VECTOR
                cmd.PC_we <= '1';
                cmd.PC_sel <= PC_rstvec;
                state_d <= S_Pre_Fetch;

            when S_Pre_Fetch =>
                -- mem[PC]
                cmd.mem_we   <= '0';
                cmd.mem_ce   <= '1';
                cmd.ADDR_sel <= ADDR_from_pc;
                state_d      <= S_Fetch;

            when S_Fetch =>
                -- IR <- mem_datain
                cmd.IR_we <= '1';
                state_d <= S_Decode;

            when S_Decode =>

                if status.IR(6 downto 0) = "0110111" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_LUI;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ADDI;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "000" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ADD;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "111" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_AND;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "111" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ANDI;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "110" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_OR;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "110" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ORI;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "100" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_XOR;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "100" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_XORI;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "000" and status.IR(31 downto 25) = "0100000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SUB;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "001" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLL;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "101" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRL;
                elsif status.IR(6 downto 0) = "0110011" and status.IR(14 downto 12) = "101" and status.IR(31 downto 25) = "0100000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRA;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "101" and status.IR(31 downto 25) = "0100000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRAI;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "001" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLLI;
                elsif status.IR(6 downto 0) = "0010011" and status.IR(14 downto 12) = "101" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRLI;
                elsif status.IR(6 downto 0) = "0010111" then
                    cmd.PC_we <= '0';
                    state_d <= S_AUIPC;
                elsif status.IR(6 downto 0) = "1100011" then
                    cmd.PC_we <= '0';
                    state_d <= S_JUMP;
                elsif status.IR(6 downto 0)= "0110011" and status.IR(31 downto 25) = "0000000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLT;
                elsif status.IR(6 downto 0)= "0010011" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLTI;
                elsif status.IR(6 downto 0)="1101111" then
                    cmd.PC_we<='0';
                    state_d <= S_JAL;
                elsif status.IR(6 downto 0)="1100111" and status.IR(14 downto 12) ="000" then
                    cmd.PC_we<='0';
                    state_d <= S_JALR;
                elsif status.IR(6 downto 0)="0000011" and status.IR(14 downto 12) = "000" then 
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_LB;
                elsif status.IR(6 downto 0)="0000011" and status.IR(14 downto 12) = "001" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_LH;
                elsif status.IR(6 downto 0)="0000011" and status.IR(14 downto 12) = "010" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_LW;
                elsif status.IR(6 downto 0)="0000011" and status.IR(14 downto 12) = "101" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_LHU;
                elsif status.IR(6 downto 0)="0000011" and status.IR(14 downto 12) = "100" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_LBU;
                elsif status.IR(6 downto 0)="0100011" and status.IR(14 downto 12) = "000" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_SB;
                elsif status.IR(6 downto 0)="0100011" and status.IR(14 downto 12) = "001" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_SH;
                elsif status.IR(6 downto 0)="0100011" and status.IR(14 downto 12) = "010" then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we<='1';
                    state_d <= S_SW;
                else 
                    state_d <= S_Error;
                -- au cas où il y a une erreur 
                end if;

---------- Instructions avec immediat de type U ----------

            when S_LUI =>
                -- rd <- ImmU + 0
                cmd.PC_X_sel <= PC_X_cst_x00;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_pc;
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_ADDI =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.ALU_op <= ALU_plus;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_alu;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_ANDI =>
                -- ajout registre rd
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_and;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_ORI =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_or;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_XORI =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_xor;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SLLI =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_ll;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SRLI =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_rl;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SRAI =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_ra;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;
            
            when S_AUIPC =>
                -- ajout au registre rd
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.PC_X_sel <= PC_X_pc;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_pc;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- état suivant
                state_d <= S_Pre_Fetch;

---------- Instructions arithmétiques et logiques ----------

            when S_ADD =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.ALU_op <= ALU_plus;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_alu;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SUB =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.ALU_op <= ALU_minus;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_alu;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_AND =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_and;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;
            
            when S_OR =>

                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_or;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_XOR =>
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_xor;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_logical;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SLL =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_ll;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- llecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SRL =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_rl;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_SRA =>
                -- ajout au registre rd
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_ra;
                cmd.RF_we <= '1';
                cmd.DATA_sel <= DATA_from_shifter;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

---------- Instructions de saut ----------

            when S_JUMP =>
                -- test
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                if status.JCOND then
                    cmd.PC_sel <= PC_from_pc;
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
                    cmd.PC_we <= '1';
                else
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                end if;
                -- lecture de la mémoire
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Pre_Fetch;
            
            when S_SLT => 
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Pre_Fetch;
        
            when S_SLTI => 
                -- ajout au registre rd
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Pre_Fetch;
                    
            when S_JAL => 
                -- ajout au registre rd
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.PC_X_sel <= PC_X_pc;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- création de la constante
                -- ajout à PC
                cmd.TO_PC_Y_sel <= TO_PC_Y_immJ;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Pre_Fetch;

            when S_JALR => 
                -- ajout au registre rd
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- création de la constante
                -- ajout à PC
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.ALU_op <= ALU_plus;
                cmd.PC_sel <= PC_from_alu;
                cmd.PC_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Pre_Fetch;



---------- Instructions de chargement à partir de la mémoire ----------
           
            when S_LB =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                state_d <= S_LB_sel;
            
            when S_LB_sel =>
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_LB_we;

            when S_LB_we =>
                cmd.RF_SIGN_enable <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;

            when S_LH =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                state_d <= S_LH_sel;
            
            when S_LH_sel =>
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_LH_we;

            when S_LH_we =>
                cmd.RF_SIGN_enable <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant Fetch
                state_d <= S_Fetch;   

            when S_LW =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                state_d <= S_LW_sel;
            
            when S_LW_sel =>
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_LW_we;

            when S_LW_we =>
                cmd.RF_SIGN_enable <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_word;
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch; 
            
            when S_LHU =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                state_d <= S_LHU_sel;
            
            when S_LHU_sel =>
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_LHU_we;

            when S_LHU_we =>
                cmd.RF_SIGN_enable <= '0';
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;  
            
            when S_LBU =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                state_d <= S_LBU_sel;
            
            when S_LBU_sel =>
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_LBU_we;

            when S_LBU_we =>
                cmd.RF_SIGN_enable <= '0';
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- lecture de la mémoire 
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;


---------- Instructions de sauvegarde en mémoire ----------
            
            when S_SB =>
                cmd.AD_Y_sel <= AD_Y_immS;
                cmd.AD_we <= '1';
                state_d <= S_SB_2;
            
            when S_SB_2 =>
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_we <= '1';
                cmd.mem_ce <= '1';
                state_d <= S_SB_3;
            
            when S_SB_3 =>
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;
            
            when S_SH =>
                cmd.AD_Y_sel <= AD_Y_immS;
                cmd.AD_we <= '1';
                state_d <= S_SH_2;
        
            when S_SH_2 =>
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_we <= '1';
                cmd.mem_ce <= '1';
                state_d <= S_SH_3;
            
            when S_SH_3 =>
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;   
            
            when S_SW =>
                cmd.AD_Y_sel <= AD_Y_immS;
                cmd.AD_we <= '1';
                state_d <= S_SW_2;
        
            when S_SW_2 =>
                cmd.RF_SIZE_sel <= RF_SIZE_word;
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_we <= '1';
                cmd.mem_ce <= '1';
                state_d <= S_SW_3;
            
            when S_SW_3 =>
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- état suivant
                state_d <= S_Fetch;  
            

---------- Instructions d'accès aux CSR ----------

            when others => null;
        end case;

    end process FSM_comb;

end architecture;

