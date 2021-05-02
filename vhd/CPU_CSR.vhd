library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CSR is
    generic (
        INTERRUPT_VECTOR : waddr   := w32_zero;
        mutant           : integer := 0
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Interface de et vers la PO
        cmd         : in  PO_cs_cmd;
        it          : out std_logic;
        pc          : in  w32;
        rs1         : in  w32;
        imm         : in  W32;
        csr         : out w32;
        mtvec       : out w32;
        mepc        : out w32;

        -- Interface de et vers les IP d'interruption
        irq         : in  std_logic;
        meip        : in  std_logic;
        mtip        : in  std_logic;
        mie         : out w32;
        mip         : out w32;
        mcause      : in  w32
    );
end entity;

architecture RTL of CPU_CSR is
    -- Fonction retournant la valeur à écrire dans un csr en fonction
    -- du « mode » d'écriture, qui dépend de l'instruction

    signal mcause_d : w32;
    signal mcause_q : w32;
    signal mie_d : w32;
    signal mie_q : w32;
    signal mip_d : w32;
    signal mip_q : w32;
    signal mstatus_d : w32;
    signal mstatus_q : w32;
    signal mtvec_d : w32;
    signal mtvec_q : w32;
    signal mepc_d : w32;
    signal mepc_q : w32;
    signal tocsr : w32;
    signal mepc_m : w32;


    function CSR_write (CSR        : w32;
                         CSR_reg    : w32;
                         WRITE_mode : CSR_WRITE_mode_type)
        return w32 is
        variable res : w32;
    
    begin
        case WRITE_mode is
            when WRITE_mode_simple =>
                res := CSR;
            when WRITE_mode_set =>
                res := CSR_reg or CSR;
            when WRITE_mode_clear =>
                res := CSR_reg and (not CSR);
            when others => null;
        end case;
        return res;
    end CSR_write;

begin
    tocsr <= rs1 when cmd.TO_CSR_sel=TO_CSR_from_rs1 else imm when cmd.TO_CSR_sel=TO_CSR_from_imm else(others=>'U');

    mepc_m <= pc when cmd.MEPC_sel=MEPC_from_pc else tocsr when cmd.MEPC_sel=MEPC_from_csr else (others=>'U');

    csr <= mcause_q when cmd.CSR_sel=CSR_from_mcause else
           mip_q when cmd.CSR_sel=CSR_from_mip else
           mie_q when cmd.CSR_sel=CSR_from_mie else
           mstatus_q when cmd.CSR_sel=CSR_from_mstatus else
           mtvec_q when cmd.CSR_sel=CSR_from_mtvec else
           mepc_q when cmd.CSR_sel=CSR_from_mepc else (others => 'U');
    
    mcause_d <= CSR_write(mcause, mcause_q, cmd.CSR_WRITE_mode);
    mtvec_d <= CSR_write(tocsr, mtvec_q, cmd.CSR_WRITE_mode);
    mepc_d <= CSR_write(mepc_m, mepc_q, cmd.CSR_WRITE_mode);
    mie_d <= CSR_write(tocsr, mie_q, cmd.CSR_WRITE_mode);
    mstatus_d <= CSR_write(tocsr, mstatus_q, cmd.CSR_WRITE_mode);
    mip_d <= x"00000" & meip & "000"& mtip & "0000000";

    bascule : process(clk)
    begin
        if rising_edge(clk) then 
            if rst='1' then 
                mstatus_q <= (others => '0');
                mepc_q <= (others => '0');
                mie_q <= (others => '0');
                mtvec_q <= (others => '0');
                mcause_q <= (others => '0');
            else
                if irq='1' then mcause_q <= it & mcause_d(30 downto 0);
                end if;

                if cmd.MSTATUS_mie_set ='1' then mstatus_q <= mstatus_d(31 downto 4) & '1' & mstatus_d(2 downto 0);
                end if;

                if cmd.MSTATUS_mie_reset ='1' then mstatus_q <= mstatus_d(31 downto 4) & '0' & mstatus_d(2 downto 0);
                end if;

                case cmd.CSR_we is 
                    when CSR_mstatus => mstatus_q <= mstatus_d;
                    when CSR_mtvec => mtvec_q <= mtvec_d(31 downto 2) & b"00";
                    when CSR_mie => mie_q <= mie_d;
                    when CSR_mepc => mepc_q <= mepc_d(31 downto 2) & b"00";
                    when others =>
                end case;

                mip_q <= mip_d;

            end if;
        end if;
    end process bascule;

    mtvec <= mtvec_q;
    mepc <= mepc_q;
    mip <= mip_q;
    mie <= mie_q;
    it <= irq and mstatus_q(3);
end architecture;
