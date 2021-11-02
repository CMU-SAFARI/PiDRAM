-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
-- Date        : Tue Sep  7 13:02:24 2021
-- Host        : jalapeno running 64-bit Ubuntu 18.04.5 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.srcs/sources_1/ip/rchip_axi4_xbar/rchip_axi4_xbar_sim_netlist.vhdl
-- Design      : rchip_axi4_xbar
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z045ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter is
  port (
    S_AXI_ARREADY : out STD_LOGIC_VECTOR ( 0 to 0 );
    aa_mi_arvalid : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.m_target_hot_i_reg[2]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_master_slots[2].r_issuing_cnt_reg[16]\ : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.m_target_hot_i_reg[1]_0\ : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]_1\ : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]_2\ : out STD_LOGIC;
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_axi.s_axi_rlast_i_reg\ : out STD_LOGIC;
    \m_axi_arqos[3]\ : out STD_LOGIC_VECTOR ( 62 downto 0 );
    \gen_single_issue.active_target_enc_reg[0]\ : out STD_LOGIC;
    \gen_master_slots[0].r_issuing_cnt_reg[0]\ : out STD_LOGIC;
    \gen_single_issue.active_target_hot_reg[0]\ : out STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]\ : out STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[1]\ : out STD_LOGIC;
    s_ready_i0 : in STD_LOGIC;
    aclk : in STD_LOGIC;
    m_axi_arready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mi_arready_2 : in STD_LOGIC;
    p_11_in : in STD_LOGIC;
    aresetn_d : in STD_LOGIC;
    \s_axi_arqos[3]\ : in STD_LOGIC_VECTOR ( 62 downto 0 );
    p_43_in : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_single_issue.accept_cnt_reg\ : in STD_LOGIC;
    \m_payload_i_reg[66]\ : in STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]_0\ : in STD_LOGIC;
    active_target_enc : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \m_payload_i_reg[66]_0\ : in STD_LOGIC;
    active_target_hot : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_valid_i_reg : in STD_LOGIC;
    p_25_in : in STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]_1\ : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter : entity is "axi_crossbar_v2_1_10_addr_arbiter";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter is
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^s_axi_arready\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal aa_mi_artarget_hot : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^aa_mi_arvalid\ : STD_LOGIC;
  signal \gen_axi.s_axi_rlast_i_i_4_n_0\ : STD_LOGIC;
  signal \^gen_master_slots[2].r_issuing_cnt_reg[16]\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.m_target_hot_i_reg[1]_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.m_target_hot_i_reg[2]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^gen_no_arbiter.m_target_hot_i_reg[2]_2\ : STD_LOGIC;
  signal \gen_no_arbiter.m_valid_i_i_1__0_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.m_valid_i_i_2_n_0\ : STD_LOGIC;
  signal \^m_axi_arqos[3]\ : STD_LOGIC_VECTOR ( 62 downto 0 );
  signal s_ready_i2 : STD_LOGIC;
  signal st_aa_artarget_hot : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_axi.s_axi_rid_i[5]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \gen_master_slots[0].r_issuing_cnt[0]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \gen_master_slots[1].r_issuing_cnt[8]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \gen_master_slots[2].r_issuing_cnt[16]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \gen_no_arbiter.m_target_hot_i[1]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \gen_no_arbiter.m_target_hot_i[2]_i_4\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \gen_no_arbiter.s_ready_i[0]_i_3__0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \gen_single_issue.active_target_enc[0]_i_1__0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \gen_single_issue.active_target_enc[1]_i_1__0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \gen_single_issue.active_target_hot[0]_i_1__0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axi_arvalid[0]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axi_arvalid[1]_INST_0\ : label is "soft_lutpair0";
begin
  SR(0) <= \^sr\(0);
  S_AXI_ARREADY(0) <= \^s_axi_arready\(0);
  aa_mi_arvalid <= \^aa_mi_arvalid\;
  \gen_master_slots[2].r_issuing_cnt_reg[16]\ <= \^gen_master_slots[2].r_issuing_cnt_reg[16]\;
  \gen_no_arbiter.m_target_hot_i_reg[1]_0\ <= \^gen_no_arbiter.m_target_hot_i_reg[1]_0\;
  \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0) <= \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0);
  \gen_no_arbiter.m_target_hot_i_reg[2]_2\ <= \^gen_no_arbiter.m_target_hot_i_reg[2]_2\;
  \m_axi_arqos[3]\(62 downto 0) <= \^m_axi_arqos[3]\(62 downto 0);
\gen_axi.s_axi_rid_i[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      I1 => mi_arready_2,
      I2 => \^aa_mi_arvalid\,
      I3 => p_11_in,
      O => E(0)
    );
\gen_axi.s_axi_rlast_i_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \gen_axi.s_axi_rlast_i_i_4_n_0\,
      I1 => p_11_in,
      I2 => \^m_axi_arqos[3]\(38),
      I3 => \^m_axi_arqos[3]\(39),
      O => \gen_axi.s_axi_rlast_i_reg\
    );
\gen_axi.s_axi_rlast_i_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \^m_axi_arqos[3]\(40),
      I1 => \^m_axi_arqos[3]\(41),
      I2 => \^m_axi_arqos[3]\(42),
      I3 => \^m_axi_arqos[3]\(43),
      I4 => \^m_axi_arqos[3]\(45),
      I5 => \^m_axi_arqos[3]\(44),
      O => \gen_axi.s_axi_rlast_i_i_4_n_0\
    );
\gen_master_slots[0].r_issuing_cnt[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"807F0080"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => m_axi_arready(0),
      I2 => aa_mi_artarget_hot(0),
      I3 => \m_payload_i_reg[66]_0\,
      I4 => p_43_in,
      O => \gen_master_slots[0].r_issuing_cnt_reg[0]\
    );
\gen_master_slots[1].r_issuing_cnt[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"95554000"
    )
        port map (
      I0 => m_valid_i_reg,
      I1 => aa_mi_artarget_hot(1),
      I2 => m_axi_arready(1),
      I3 => \^aa_mi_arvalid\,
      I4 => p_25_in,
      O => \gen_master_slots[1].r_issuing_cnt_reg[8]\
    );
\gen_master_slots[2].r_issuing_cnt[16]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => mi_arready_2,
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      O => \^gen_master_slots[2].r_issuing_cnt_reg[16]\
    );
\gen_no_arbiter.m_mesg_i[5]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn_d,
      O => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i[5]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      O => s_ready_i2
    );
\gen_no_arbiter.m_mesg_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(0),
      Q => \^m_axi_arqos[3]\(0),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(10),
      Q => \^m_axi_arqos[3]\(10),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(11),
      Q => \^m_axi_arqos[3]\(11),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(12),
      Q => \^m_axi_arqos[3]\(12),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(13),
      Q => \^m_axi_arqos[3]\(13),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(14),
      Q => \^m_axi_arqos[3]\(14),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(15),
      Q => \^m_axi_arqos[3]\(15),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(16),
      Q => \^m_axi_arqos[3]\(16),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(17),
      Q => \^m_axi_arqos[3]\(17),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(18),
      Q => \^m_axi_arqos[3]\(18),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(19),
      Q => \^m_axi_arqos[3]\(19),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(1),
      Q => \^m_axi_arqos[3]\(1),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(20),
      Q => \^m_axi_arqos[3]\(20),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(21),
      Q => \^m_axi_arqos[3]\(21),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(22),
      Q => \^m_axi_arqos[3]\(22),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(23),
      Q => \^m_axi_arqos[3]\(23),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(24),
      Q => \^m_axi_arqos[3]\(24),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(25),
      Q => \^m_axi_arqos[3]\(25),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(26),
      Q => \^m_axi_arqos[3]\(26),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(27),
      Q => \^m_axi_arqos[3]\(27),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(28),
      Q => \^m_axi_arqos[3]\(28),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(29),
      Q => \^m_axi_arqos[3]\(29),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(2),
      Q => \^m_axi_arqos[3]\(2),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(30),
      Q => \^m_axi_arqos[3]\(30),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(31),
      Q => \^m_axi_arqos[3]\(31),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(32),
      Q => \^m_axi_arqos[3]\(32),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(33),
      Q => \^m_axi_arqos[3]\(33),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(34),
      Q => \^m_axi_arqos[3]\(34),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(35),
      Q => \^m_axi_arqos[3]\(35),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(36),
      Q => \^m_axi_arqos[3]\(36),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(37),
      Q => \^m_axi_arqos[3]\(37),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(38),
      Q => \^m_axi_arqos[3]\(38),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(39),
      Q => \^m_axi_arqos[3]\(39),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(3),
      Q => \^m_axi_arqos[3]\(3),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(40),
      Q => \^m_axi_arqos[3]\(40),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(41),
      Q => \^m_axi_arqos[3]\(41),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(42),
      Q => \^m_axi_arqos[3]\(42),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(43),
      Q => \^m_axi_arqos[3]\(43),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(44),
      Q => \^m_axi_arqos[3]\(44),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(45),
      Q => \^m_axi_arqos[3]\(45),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(46),
      Q => \^m_axi_arqos[3]\(46),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(47),
      Q => \^m_axi_arqos[3]\(47),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(48),
      Q => \^m_axi_arqos[3]\(48),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(49),
      Q => \^m_axi_arqos[3]\(49),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(4),
      Q => \^m_axi_arqos[3]\(4),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(50),
      Q => \^m_axi_arqos[3]\(50),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(51),
      Q => \^m_axi_arqos[3]\(51),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(52),
      Q => \^m_axi_arqos[3]\(52),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(53),
      Q => \^m_axi_arqos[3]\(53),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(54),
      Q => \^m_axi_arqos[3]\(54),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(5),
      Q => \^m_axi_arqos[3]\(5),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(55),
      Q => \^m_axi_arqos[3]\(55),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(56),
      Q => \^m_axi_arqos[3]\(56),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(57),
      Q => \^m_axi_arqos[3]\(57),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(58),
      Q => \^m_axi_arqos[3]\(58),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(59),
      Q => \^m_axi_arqos[3]\(59),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(60),
      Q => \^m_axi_arqos[3]\(60),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(61),
      Q => \^m_axi_arqos[3]\(61),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(62),
      Q => \^m_axi_arqos[3]\(62),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(6),
      Q => \^m_axi_arqos[3]\(6),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(7),
      Q => \^m_axi_arqos[3]\(7),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(8),
      Q => \^m_axi_arqos[3]\(8),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_mesg_i_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => \s_axi_arqos[3]\(9),
      Q => \^m_axi_arqos[3]\(9),
      R => \^sr\(0)
    );
\gen_no_arbiter.m_target_hot_i[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFF80000000"
    )
        port map (
      I0 => st_aa_artarget_hot(0),
      I1 => \gen_single_issue.accept_cnt_reg\,
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_2\,
      I3 => \gen_master_slots[1].r_issuing_cnt_reg[8]_1\,
      I4 => aresetn_d,
      I5 => aa_mi_artarget_hot(0),
      O => \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i[0]_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \s_axi_arqos[3]\(36),
      I1 => \s_axi_arqos[3]\(37),
      O => st_aa_artarget_hot(0)
    );
\gen_no_arbiter.m_target_hot_i[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFF80000000"
    )
        port map (
      I0 => \^gen_no_arbiter.m_target_hot_i_reg[1]_0\,
      I1 => \gen_single_issue.accept_cnt_reg\,
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_2\,
      I3 => \gen_master_slots[1].r_issuing_cnt_reg[8]_1\,
      I4 => aresetn_d,
      I5 => aa_mi_artarget_hot(1),
      O => \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \s_axi_arqos[3]\(36),
      I1 => \s_axi_arqos[3]\(37),
      O => \^gen_no_arbiter.m_target_hot_i_reg[1]_0\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFF80000000"
    )
        port map (
      I0 => \s_axi_arqos[3]\(37),
      I1 => \gen_single_issue.accept_cnt_reg\,
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_2\,
      I3 => \gen_master_slots[1].r_issuing_cnt_reg[8]_1\,
      I4 => aresetn_d,
      I5 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      O => \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \s_axi_arqos[3]\(37),
      I1 => \s_axi_arqos[3]\(36),
      I2 => p_43_in,
      O => \gen_no_arbiter.m_target_hot_i_reg[2]_1\
    );
\gen_no_arbiter.m_target_hot_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\,
      Q => aa_mi_artarget_hot(0),
      R => '0'
    );
\gen_no_arbiter.m_target_hot_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\,
      Q => aa_mi_artarget_hot(1),
      R => '0'
    );
\gen_no_arbiter.m_target_hot_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\,
      Q => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      R => '0'
    );
\gen_no_arbiter.m_valid_i_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5D5D555C0C0C000"
    )
        port map (
      I0 => \gen_no_arbiter.m_valid_i_i_2_n_0\,
      I1 => \gen_single_issue.accept_cnt_reg\,
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_2\,
      I3 => \m_payload_i_reg[66]\,
      I4 => \gen_master_slots[1].r_issuing_cnt_reg[8]_0\,
      I5 => \^aa_mi_arvalid\,
      O => \gen_no_arbiter.m_valid_i_i_1__0_n_0\
    );
\gen_no_arbiter.m_valid_i_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFAA808080"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => m_axi_arready(1),
      I2 => aa_mi_artarget_hot(1),
      I3 => m_axi_arready(0),
      I4 => aa_mi_artarget_hot(0),
      I5 => \^gen_master_slots[2].r_issuing_cnt_reg[16]\,
      O => \gen_no_arbiter.m_valid_i_i_2_n_0\
    );
\gen_no_arbiter.m_valid_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_valid_i_i_1__0_n_0\,
      Q => \^aa_mi_arvalid\,
      R => \^sr\(0)
    );
\gen_no_arbiter.s_ready_i[0]_i_3__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => \^s_axi_arready\(0),
      I2 => s_axi_arvalid(0),
      O => \^gen_no_arbiter.m_target_hot_i_reg[2]_2\
    );
\gen_no_arbiter.s_ready_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => s_ready_i0,
      Q => \^s_axi_arready\(0),
      R => '0'
    );
\gen_single_issue.active_target_enc[0]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F20"
    )
        port map (
      I0 => \s_axi_arqos[3]\(36),
      I1 => \s_axi_arqos[3]\(37),
      I2 => \^s_axi_arready\(0),
      I3 => active_target_enc(0),
      O => \gen_single_issue.active_target_enc_reg[0]\
    );
\gen_single_issue.active_target_enc[1]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axi_arqos[3]\(37),
      I1 => \^s_axi_arready\(0),
      I2 => active_target_enc(1),
      O => \gen_single_issue.active_target_enc_reg[1]\
    );
\gen_single_issue.active_target_hot[0]_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1F10"
    )
        port map (
      I0 => \s_axi_arqos[3]\(36),
      I1 => \s_axi_arqos[3]\(37),
      I2 => \^s_axi_arready\(0),
      I3 => active_target_hot(0),
      O => \gen_single_issue.active_target_hot_reg[0]\
    );
\m_axi_arvalid[0]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => aa_mi_artarget_hot(0),
      O => m_axi_arvalid(0)
    );
\m_axi_arvalid[1]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^aa_mi_arvalid\,
      I1 => aa_mi_artarget_hot(1),
      O => m_axi_arvalid(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter_0 is
  port (
    ss_aa_awready : out STD_LOGIC;
    aa_sa_awvalid : out STD_LOGIC;
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \gen_no_arbiter.m_target_hot_i_reg[2]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_master_slots[2].w_issuing_cnt_reg[16]\ : out STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg_0\ : out STD_LOGIC;
    st_aa_awtarget_enc : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.s_ready_i_reg[0]_0\ : out STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg_1\ : out STD_LOGIC;
    \gen_master_slots[1].w_issuing_cnt_reg[8]\ : out STD_LOGIC;
    \gen_master_slots[0].w_issuing_cnt_reg[0]\ : out STD_LOGIC;
    \gen_master_slots[2].w_issuing_cnt_reg[16]_0\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 62 downto 0 );
    s_ready_i0 : in STD_LOGIC;
    aclk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_ready_d : in STD_LOGIC_VECTOR ( 1 downto 0 );
    p_1_in : in STD_LOGIC;
    m_axi_awready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    D : in STD_LOGIC_VECTOR ( 62 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_ready_d_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_single_issue.active_target_enc_reg[1]\ : in STD_LOGIC;
    \gen_master_slots[2].w_issuing_cnt_reg[16]_1\ : in STD_LOGIC;
    \gen_master_slots[1].w_issuing_cnt_reg[8]_0\ : in STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[0]\ : in STD_LOGIC;
    p_34_in : in STD_LOGIC;
    \gen_single_issue.active_target_hot_reg[0]\ : in STD_LOGIC;
    p_52_in : in STD_LOGIC;
    p_34_out : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    w_issuing_cnt : in STD_LOGIC_VECTOR ( 0 to 0 );
    aresetn_d : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter_0 : entity is "axi_crossbar_v2_1_10_addr_arbiter";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter_0;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter_0 is
  signal aa_mi_awtarget_hot : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^aa_sa_awvalid\ : STD_LOGIC;
  signal \^gen_master_slots[2].w_issuing_cnt_reg[16]\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.m_target_hot_i_reg[2]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \gen_no_arbiter.m_valid_i_i_1_n_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.m_valid_i_reg_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.m_valid_i_reg_1\ : STD_LOGIC;
  signal \m_ready_d[1]_i_4_n_0\ : STD_LOGIC;
  signal s_ready_i2 : STD_LOGIC;
  signal \^ss_aa_awready\ : STD_LOGIC;
  signal \^st_aa_awtarget_enc\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal st_aa_awtarget_hot : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_master_slots[2].w_issuing_cnt[16]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \gen_no_arbiter.m_target_hot_i[0]_i_2\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \gen_primitive_shifter.gen_srls[0].srl_inst_i_2\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \m_axi_awvalid[0]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_ready_d[1]_i_3\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \m_ready_d[1]_i_4\ : label is "soft_lutpair7";
begin
  aa_sa_awvalid <= \^aa_sa_awvalid\;
  \gen_master_slots[2].w_issuing_cnt_reg[16]\ <= \^gen_master_slots[2].w_issuing_cnt_reg[16]\;
  \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0) <= \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0);
  \gen_no_arbiter.m_valid_i_reg_0\ <= \^gen_no_arbiter.m_valid_i_reg_0\;
  \gen_no_arbiter.m_valid_i_reg_1\ <= \^gen_no_arbiter.m_valid_i_reg_1\;
  ss_aa_awready <= \^ss_aa_awready\;
  st_aa_awtarget_enc(0) <= \^st_aa_awtarget_enc\(0);
\gen_master_slots[0].w_issuing_cnt[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5955555504000000"
    )
        port map (
      I0 => \gen_single_issue.active_target_hot_reg[0]\,
      I1 => \^aa_sa_awvalid\,
      I2 => m_ready_d(1),
      I3 => m_axi_awready(0),
      I4 => aa_mi_awtarget_hot(0),
      I5 => p_52_in,
      O => \gen_master_slots[0].w_issuing_cnt_reg[0]\
    );
\gen_master_slots[1].w_issuing_cnt[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5955555504000000"
    )
        port map (
      I0 => \gen_single_issue.active_target_enc_reg[0]\,
      I1 => \^aa_sa_awvalid\,
      I2 => m_ready_d(1),
      I3 => m_axi_awready(1),
      I4 => aa_mi_awtarget_hot(1),
      I5 => p_34_in,
      O => \gen_master_slots[1].w_issuing_cnt_reg[8]\
    );
\gen_master_slots[2].w_issuing_cnt[16]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"95552AAA"
    )
        port map (
      I0 => \^gen_master_slots[2].w_issuing_cnt_reg[16]\,
      I1 => p_34_out,
      I2 => s_axi_bready(0),
      I3 => active_target_enc(0),
      I4 => w_issuing_cnt(0),
      O => \gen_master_slots[2].w_issuing_cnt_reg[16]_0\
    );
\gen_master_slots[2].w_issuing_cnt[16]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      I1 => p_1_in,
      I2 => m_ready_d(1),
      I3 => \^aa_sa_awvalid\,
      O => \^gen_master_slots[2].w_issuing_cnt_reg[16]\
    );
\gen_no_arbiter.m_mesg_i[5]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^aa_sa_awvalid\,
      O => s_ready_i2
    );
\gen_no_arbiter.m_mesg_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(0),
      Q => Q(0),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(10),
      Q => Q(10),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(11),
      Q => Q(11),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(12),
      Q => Q(12),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(13),
      Q => Q(13),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(14),
      Q => Q(14),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(15),
      Q => Q(15),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(16),
      Q => Q(16),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(17),
      Q => Q(17),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(18),
      Q => Q(18),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(19),
      Q => Q(19),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(1),
      Q => Q(1),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(20),
      Q => Q(20),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(21),
      Q => Q(21),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(22),
      Q => Q(22),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(23),
      Q => Q(23),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(24),
      Q => Q(24),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(25),
      Q => Q(25),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(26),
      Q => Q(26),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(27),
      Q => Q(27),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(28),
      Q => Q(28),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(29),
      Q => Q(29),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(2),
      Q => Q(2),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(30),
      Q => Q(30),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(31),
      Q => Q(31),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(32),
      Q => Q(32),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(33),
      Q => Q(33),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(34),
      Q => Q(34),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(35),
      Q => Q(35),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(36),
      Q => Q(36),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(37),
      Q => Q(37),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(38),
      Q => Q(38),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(39),
      Q => Q(39),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(3),
      Q => Q(3),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(40),
      Q => Q(40),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(41),
      Q => Q(41),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(42),
      Q => Q(42),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(43),
      Q => Q(43),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(44),
      Q => Q(44),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(45),
      Q => Q(45),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(46),
      Q => Q(46),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(47),
      Q => Q(47),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(48),
      Q => Q(48),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(49),
      Q => Q(49),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(4),
      Q => Q(4),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(50),
      Q => Q(50),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(51),
      Q => Q(51),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(52),
      Q => Q(52),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(53),
      Q => Q(53),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(54),
      Q => Q(54),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(5),
      Q => Q(5),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(55),
      Q => Q(55),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(56),
      Q => Q(56),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(57),
      Q => Q(57),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(58),
      Q => Q(58),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(59),
      Q => Q(59),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(60),
      Q => Q(60),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(61),
      Q => Q(61),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(62),
      Q => Q(62),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(6),
      Q => Q(6),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(7),
      Q => Q(7),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(8),
      Q => Q(8),
      R => SR(0)
    );
\gen_no_arbiter.m_mesg_i_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => s_ready_i2,
      D => D(9),
      Q => Q(9),
      R => SR(0)
    );
\gen_no_arbiter.m_target_hot_i[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEFFFFF22200000"
    )
        port map (
      I0 => st_aa_awtarget_hot(0),
      I1 => \gen_single_issue.active_target_enc_reg[1]\,
      I2 => \gen_master_slots[2].w_issuing_cnt_reg[16]_1\,
      I3 => \gen_master_slots[1].w_issuing_cnt_reg[8]_0\,
      I4 => aresetn_d,
      I5 => aa_mi_awtarget_hot(0),
      O => \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => D(36),
      I1 => D(37),
      O => st_aa_awtarget_hot(0)
    );
\gen_no_arbiter.m_target_hot_i[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEFFFFF22200000"
    )
        port map (
      I0 => \^st_aa_awtarget_enc\(0),
      I1 => \gen_single_issue.active_target_enc_reg[1]\,
      I2 => \gen_master_slots[2].w_issuing_cnt_reg[16]_1\,
      I3 => \gen_master_slots[1].w_issuing_cnt_reg[8]_0\,
      I4 => aresetn_d,
      I5 => aa_mi_awtarget_hot(1),
      O => \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEFFFFF22200000"
    )
        port map (
      I0 => D(37),
      I1 => \gen_single_issue.active_target_enc_reg[1]\,
      I2 => \gen_master_slots[2].w_issuing_cnt_reg[16]_1\,
      I3 => \gen_master_slots[1].w_issuing_cnt_reg[8]_0\,
      I4 => aresetn_d,
      I5 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      O => \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\
    );
\gen_no_arbiter.m_target_hot_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[0]_i_1_n_0\,
      Q => aa_mi_awtarget_hot(0),
      R => '0'
    );
\gen_no_arbiter.m_target_hot_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[1]_i_1_n_0\,
      Q => aa_mi_awtarget_hot(1),
      R => '0'
    );
\gen_no_arbiter.m_target_hot_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_target_hot_i[2]_i_1_n_0\,
      Q => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      R => '0'
    );
\gen_no_arbiter.m_valid_i_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C4FFC4FFC4FFC4C4"
    )
        port map (
      I0 => \^gen_no_arbiter.m_valid_i_reg_0\,
      I1 => \^aa_sa_awvalid\,
      I2 => \^gen_no_arbiter.m_valid_i_reg_1\,
      I3 => \gen_single_issue.active_target_enc_reg[1]\,
      I4 => \gen_master_slots[2].w_issuing_cnt_reg[16]_1\,
      I5 => \gen_master_slots[1].w_issuing_cnt_reg[8]_0\,
      O => \gen_no_arbiter.m_valid_i_i_1_n_0\
    );
\gen_no_arbiter.m_valid_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.m_valid_i_i_1_n_0\,
      Q => \^aa_sa_awvalid\,
      R => SR(0)
    );
\gen_no_arbiter.s_ready_i[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFD"
    )
        port map (
      I0 => s_axi_awvalid(0),
      I1 => \^aa_sa_awvalid\,
      I2 => m_ready_d_0(0),
      I3 => \^ss_aa_awready\,
      O => \gen_no_arbiter.s_ready_i_reg[0]_0\
    );
\gen_no_arbiter.s_ready_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => s_ready_i0,
      Q => \^ss_aa_awready\,
      R => '0'
    );
\gen_primitive_shifter.gen_srls[0].srl_inst_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => D(36),
      I1 => D(37),
      O => \^st_aa_awtarget_enc\(0)
    );
\m_axi_awvalid[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => aa_mi_awtarget_hot(0),
      I1 => m_ready_d(1),
      I2 => \^aa_sa_awvalid\,
      O => m_axi_awvalid(0)
    );
\m_axi_awvalid[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => aa_mi_awtarget_hot(1),
      I1 => m_ready_d(1),
      I2 => \^aa_sa_awvalid\,
      O => m_axi_awvalid(1)
    );
\m_ready_d[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFF888"
    )
        port map (
      I0 => p_1_in,
      I1 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      I2 => m_axi_awready(1),
      I3 => aa_mi_awtarget_hot(1),
      I4 => m_ready_d(1),
      I5 => \m_ready_d[1]_i_4_n_0\,
      O => \^gen_no_arbiter.m_valid_i_reg_0\
    );
\m_ready_d[1]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => aa_mi_awtarget_hot(0),
      I1 => m_ready_d(0),
      I2 => \^gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      I3 => aa_mi_awtarget_hot(1),
      O => \^gen_no_arbiter.m_valid_i_reg_1\
    );
\m_ready_d[1]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => m_axi_awready(0),
      I1 => aa_mi_awtarget_hot(0),
      O => \m_ready_d[1]_i_4_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_decerr_slave is
  port (
    p_1_in : out STD_LOGIC;
    wr_tmp_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    p_17_in : out STD_LOGIC;
    p_11_in : out STD_LOGIC;
    s_axi_rlast_i : out STD_LOGIC;
    \gen_axi.write_cs_reg[1]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    mi_arready_2 : out STD_LOGIC;
    m_valid_i_reg : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 5 downto 0 );
    \skid_buffer_reg[72]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    aa_sa_awvalid : in STD_LOGIC;
    m_ready_d : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.m_target_hot_i_reg[2]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    mi_rready_2 : in STD_LOGIC;
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    aa_mi_arvalid : in STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.m_mesg_i_reg[45]\ : in STD_LOGIC_VECTOR ( 13 downto 0 );
    mi_bready_2 : in STD_LOGIC;
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.m_target_hot_i_reg[2]_1\ : in STD_LOGIC;
    \storage_data1_reg[1]\ : in STD_LOGIC;
    \gen_axi.read_cs_reg[0]_0\ : in STD_LOGIC;
    aresetn_d : in STD_LOGIC;
    \gen_no_arbiter.m_mesg_i_reg[5]\ : in STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_decerr_slave : entity is "axi_crossbar_v2_1_10_decerr_slave";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_decerr_slave;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_decerr_slave is
  signal \gen_axi.read_cnt[6]_i_2_n_0\ : STD_LOGIC;
  signal \gen_axi.read_cnt[7]_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.read_cnt[7]_i_3_n_0\ : STD_LOGIC;
  signal \gen_axi.read_cnt_reg__0\ : STD_LOGIC_VECTOR ( 7 downto 1 );
  signal \gen_axi.read_cnt_reg__1\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \gen_axi.read_cs[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_arready_i_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_arready_i_i_2_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_awready_i_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_bid_i[5]_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_bvalid_i_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_rlast_i_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_rlast_i_i_3_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_rlast_i_i_5_n_0\ : STD_LOGIC;
  signal \gen_axi.s_axi_wready_i_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.write_cs[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_axi.write_cs[1]_i_1_n_0\ : STD_LOGIC;
  signal \^gen_axi.write_cs_reg[1]_0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^mi_arready_2\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^p_11_in\ : STD_LOGIC;
  signal \^p_17_in\ : STD_LOGIC;
  signal \^p_1_in\ : STD_LOGIC;
  signal \^s_axi_rlast_i\ : STD_LOGIC;
  signal \^wr_tmp_wready\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal write_cs : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_axi.read_cnt[0]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \gen_axi.read_cnt[1]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \gen_axi.read_cnt[7]_i_3\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \gen_axi.s_axi_arready_i_i_2\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \gen_axi.write_cs[0]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \gen_axi.write_cs[1]_i_1\ : label is "soft_lutpair9";
begin
  \gen_axi.write_cs_reg[1]_0\(0) <= \^gen_axi.write_cs_reg[1]_0\(0);
  mi_arready_2 <= \^mi_arready_2\;
  p_11_in <= \^p_11_in\;
  p_17_in <= \^p_17_in\;
  p_1_in <= \^p_1_in\;
  s_axi_rlast_i <= \^s_axi_rlast_i\;
  wr_tmp_wready(0) <= \^wr_tmp_wready\(0);
\gen_axi.read_cnt[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"74"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__1\(0),
      I1 => \^p_11_in\,
      I2 => \gen_no_arbiter.m_mesg_i_reg[45]\(6),
      O => p_0_in(0)
    );
\gen_axi.read_cnt[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E22E"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(7),
      I1 => \^p_11_in\,
      I2 => \gen_axi.read_cnt_reg__1\(0),
      I3 => \gen_axi.read_cnt_reg__0\(1),
      O => p_0_in(1)
    );
\gen_axi.read_cnt[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FC03AAAA"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(8),
      I1 => \gen_axi.read_cnt_reg__0\(1),
      I2 => \gen_axi.read_cnt_reg__1\(0),
      I3 => \gen_axi.read_cnt_reg__0\(2),
      I4 => \^p_11_in\,
      O => p_0_in(2)
    );
\gen_axi.read_cnt[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA9FFFFAAA90000"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__0\(3),
      I1 => \gen_axi.read_cnt_reg__0\(1),
      I2 => \gen_axi.read_cnt_reg__1\(0),
      I3 => \gen_axi.read_cnt_reg__0\(2),
      I4 => \^p_11_in\,
      I5 => \gen_no_arbiter.m_mesg_i_reg[45]\(9),
      O => p_0_in(3)
    );
\gen_axi.read_cnt[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"C3AA"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(10),
      I1 => \gen_axi.read_cnt_reg__0\(4),
      I2 => \gen_axi.read_cnt[6]_i_2_n_0\,
      I3 => \^p_11_in\,
      O => p_0_in(4)
    );
\gen_axi.read_cnt[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCAA03AA"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(11),
      I1 => \gen_axi.read_cnt_reg__0\(4),
      I2 => \gen_axi.read_cnt[6]_i_2_n_0\,
      I3 => \^p_11_in\,
      I4 => \gen_axi.read_cnt_reg__0\(5),
      O => p_0_in(5)
    );
\gen_axi.read_cnt[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFC0003AAAAAAAA"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(12),
      I1 => \gen_axi.read_cnt[6]_i_2_n_0\,
      I2 => \gen_axi.read_cnt_reg__0\(4),
      I3 => \gen_axi.read_cnt_reg__0\(5),
      I4 => \gen_axi.read_cnt_reg__0\(6),
      I5 => \^p_11_in\,
      O => p_0_in(6)
    );
\gen_axi.read_cnt[6]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__0\(2),
      I1 => \gen_axi.read_cnt_reg__1\(0),
      I2 => \gen_axi.read_cnt_reg__0\(1),
      I3 => \gen_axi.read_cnt_reg__0\(3),
      O => \gen_axi.read_cnt[6]_i_2_n_0\
    );
\gen_axi.read_cnt[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8F80808080808080"
    )
        port map (
      I0 => \gen_axi.s_axi_arready_i_i_2_n_0\,
      I1 => mi_rready_2,
      I2 => \^p_11_in\,
      I3 => aa_mi_arvalid,
      I4 => \^mi_arready_2\,
      I5 => \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      O => \gen_axi.read_cnt[7]_i_1_n_0\
    );
\gen_axi.read_cnt[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"CA3A"
    )
        port map (
      I0 => \gen_no_arbiter.m_mesg_i_reg[45]\(13),
      I1 => \gen_axi.read_cnt[7]_i_3_n_0\,
      I2 => \^p_11_in\,
      I3 => \gen_axi.read_cnt_reg__0\(7),
      O => p_0_in(7)
    );
\gen_axi.read_cnt[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \gen_axi.read_cnt[6]_i_2_n_0\,
      I1 => \gen_axi.read_cnt_reg__0\(4),
      I2 => \gen_axi.read_cnt_reg__0\(5),
      I3 => \gen_axi.read_cnt_reg__0\(6),
      O => \gen_axi.read_cnt[7]_i_3_n_0\
    );
\gen_axi.read_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(0),
      Q => \gen_axi.read_cnt_reg__1\(0),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(1),
      Q => \gen_axi.read_cnt_reg__0\(1),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(2),
      Q => \gen_axi.read_cnt_reg__0\(2),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(3),
      Q => \gen_axi.read_cnt_reg__0\(3),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(4),
      Q => \gen_axi.read_cnt_reg__0\(4),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(5),
      Q => \gen_axi.read_cnt_reg__0\(5),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(6),
      Q => \gen_axi.read_cnt_reg__0\(6),
      R => SR(0)
    );
\gen_axi.read_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.read_cnt[7]_i_1_n_0\,
      D => p_0_in(7),
      Q => \gen_axi.read_cnt_reg__0\(7),
      R => SR(0)
    );
\gen_axi.read_cs[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFB0B0B0B0B0B0B0"
    )
        port map (
      I0 => \gen_axi.s_axi_arready_i_i_2_n_0\,
      I1 => mi_rready_2,
      I2 => \^p_11_in\,
      I3 => aa_mi_arvalid,
      I4 => \^mi_arready_2\,
      I5 => \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0),
      O => \gen_axi.read_cs[0]_i_1_n_0\
    );
\gen_axi.read_cs_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.read_cs[0]_i_1_n_0\,
      Q => \^p_11_in\,
      R => SR(0)
    );
\gen_axi.s_axi_arready_i_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000BFBB0000"
    )
        port map (
      I0 => \^mi_arready_2\,
      I1 => \^p_11_in\,
      I2 => \gen_axi.s_axi_arready_i_i_2_n_0\,
      I3 => mi_rready_2,
      I4 => aresetn_d,
      I5 => E(0),
      O => \gen_axi.s_axi_arready_i_i_1_n_0\
    );
\gen_axi.s_axi_arready_i_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__0\(6),
      I1 => \gen_axi.read_cnt_reg__0\(5),
      I2 => \gen_axi.read_cnt_reg__0\(4),
      I3 => \gen_axi.read_cnt[6]_i_2_n_0\,
      I4 => \gen_axi.read_cnt_reg__0\(7),
      O => \gen_axi.s_axi_arready_i_i_2_n_0\
    );
\gen_axi.s_axi_arready_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_arready_i_i_1_n_0\,
      Q => \^mi_arready_2\,
      R => '0'
    );
\gen_axi.s_axi_awready_i_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FDFD0D01"
    )
        port map (
      I0 => \gen_no_arbiter.m_target_hot_i_reg[2]_1\,
      I1 => \^gen_axi.write_cs_reg[1]_0\(0),
      I2 => write_cs(0),
      I3 => mi_bready_2,
      I4 => \^p_1_in\,
      O => \gen_axi.s_axi_awready_i_i_1_n_0\
    );
\gen_axi.s_axi_awready_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_awready_i_i_1_n_0\,
      Q => \^p_1_in\,
      R => SR(0)
    );
\gen_axi.s_axi_bid_i[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010000000000000"
    )
        port map (
      I0 => \^gen_axi.write_cs_reg[1]_0\(0),
      I1 => write_cs(0),
      I2 => aa_sa_awvalid,
      I3 => m_ready_d(0),
      I4 => \^p_1_in\,
      I5 => \gen_no_arbiter.m_target_hot_i_reg[2]\(0),
      O => \gen_axi.s_axi_bid_i[5]_i_1_n_0\
    );
\gen_axi.s_axi_bid_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(0),
      Q => Q(0),
      R => SR(0)
    );
\gen_axi.s_axi_bid_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(1),
      Q => Q(1),
      R => SR(0)
    );
\gen_axi.s_axi_bid_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(2),
      Q => Q(2),
      R => SR(0)
    );
\gen_axi.s_axi_bid_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(3),
      Q => Q(3),
      R => SR(0)
    );
\gen_axi.s_axi_bid_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(4),
      Q => Q(4),
      R => SR(0)
    );
\gen_axi.s_axi_bid_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      D => \gen_no_arbiter.m_mesg_i_reg[5]\(5),
      Q => Q(5),
      R => SR(0)
    );
\gen_axi.s_axi_bvalid_i_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFFFA888"
    )
        port map (
      I0 => \storage_data1_reg[1]\,
      I1 => write_cs(0),
      I2 => mi_bready_2,
      I3 => \^gen_axi.write_cs_reg[1]_0\(0),
      I4 => \^p_17_in\,
      O => \gen_axi.s_axi_bvalid_i_i_1_n_0\
    );
\gen_axi.s_axi_bvalid_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_bvalid_i_i_1_n_0\,
      Q => \^p_17_in\,
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(0),
      Q => \skid_buffer_reg[72]\(0),
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(1),
      Q => \skid_buffer_reg[72]\(1),
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(2),
      Q => \skid_buffer_reg[72]\(2),
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(3),
      Q => \skid_buffer_reg[72]\(3),
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(4),
      Q => \skid_buffer_reg[72]\(4),
      R => SR(0)
    );
\gen_axi.s_axi_rid_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => \gen_no_arbiter.m_mesg_i_reg[45]\(5),
      Q => \skid_buffer_reg[72]\(5),
      R => SR(0)
    );
\gen_axi.s_axi_rlast_i_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F8FFF800"
    )
        port map (
      I0 => \^p_11_in\,
      I1 => \gen_axi.s_axi_arready_i_i_2_n_0\,
      I2 => \gen_axi.read_cs_reg[0]_0\,
      I3 => \gen_axi.s_axi_rlast_i_i_3_n_0\,
      I4 => \^s_axi_rlast_i\,
      O => \gen_axi.s_axi_rlast_i_i_1_n_0\
    );
\gen_axi.s_axi_rlast_i_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF1000"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__0\(2),
      I1 => \gen_axi.read_cnt_reg__0\(1),
      I2 => mi_rready_2,
      I3 => \gen_axi.s_axi_rlast_i_i_5_n_0\,
      I4 => E(0),
      O => \gen_axi.s_axi_rlast_i_i_3_n_0\
    );
\gen_axi.s_axi_rlast_i_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => \gen_axi.read_cnt_reg__0\(3),
      I1 => \gen_axi.read_cnt_reg__0\(4),
      I2 => \gen_axi.read_cnt_reg__0\(5),
      I3 => \gen_axi.read_cnt_reg__0\(6),
      I4 => \gen_axi.read_cnt_reg__0\(7),
      I5 => \^p_11_in\,
      O => \gen_axi.s_axi_rlast_i_i_5_n_0\
    );
\gen_axi.s_axi_rlast_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_rlast_i_i_1_n_0\,
      Q => \^s_axi_rlast_i\,
      R => SR(0)
    );
\gen_axi.s_axi_wready_i_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5F5F000C"
    )
        port map (
      I0 => \storage_data1_reg[1]\,
      I1 => \gen_no_arbiter.m_target_hot_i_reg[2]_1\,
      I2 => write_cs(0),
      I3 => \^gen_axi.write_cs_reg[1]_0\(0),
      I4 => \^wr_tmp_wready\(0),
      O => \gen_axi.s_axi_wready_i_i_1_n_0\
    );
\gen_axi.s_axi_wready_i_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_wready_i_i_1_n_0\,
      Q => \^wr_tmp_wready\(0),
      R => SR(0)
    );
\gen_axi.write_cs[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0252"
    )
        port map (
      I0 => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      I1 => \^gen_axi.write_cs_reg[1]_0\(0),
      I2 => write_cs(0),
      I3 => \storage_data1_reg[1]\,
      O => \gen_axi.write_cs[0]_i_1_n_0\
    );
\gen_axi.write_cs[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF04EE04"
    )
        port map (
      I0 => \gen_axi.s_axi_bid_i[5]_i_1_n_0\,
      I1 => \^gen_axi.write_cs_reg[1]_0\(0),
      I2 => mi_bready_2,
      I3 => write_cs(0),
      I4 => \storage_data1_reg[1]\,
      O => \gen_axi.write_cs[1]_i_1_n_0\
    );
\gen_axi.write_cs_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.write_cs[0]_i_1_n_0\,
      Q => write_cs(0),
      R => SR(0)
    );
\gen_axi.write_cs_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.write_cs[1]_i_1_n_0\,
      Q => \^gen_axi.write_cs_reg[1]_0\(0),
      R => SR(0)
    );
\m_valid_i_i_1__3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8BBB"
    )
        port map (
      I0 => \^p_17_in\,
      I1 => mi_bready_2,
      I2 => active_target_enc(0),
      I3 => s_axi_bready(0),
      O => m_valid_i_reg
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor is
  port (
    active_target_hot : out STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_ready_i0 : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]\ : out STD_LOGIC;
    \s_axi_rvalid[0]\ : out STD_LOGIC;
    \s_axi_rlast[0]\ : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_no_arbiter.s_ready_i_reg[0]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]_0\ : in STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]_1\ : in STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg\ : in STD_LOGIC;
    \m_payload_i_reg[66]\ : in STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]\ : in STD_LOGIC;
    aresetn_d : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_72_out : in STD_LOGIC;
    p_50_out : in STD_LOGIC;
    p_28_out : in STD_LOGIC;
    st_mr_rid : in STD_LOGIC_VECTOR ( 17 downto 0 );
    st_mr_rmesg : in STD_LOGIC_VECTOR ( 131 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \m_payload_i_reg[66]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \m_payload_i_reg[66]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_ARREADY : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor : entity is "axi_crossbar_v2_1_10_si_transactor";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor is
  signal accept_cnt : STD_LOGIC;
  signal \^active_target_enc\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^active_target_hot\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \gen_no_arbiter.s_ready_i[0]_i_2__0_n_0\ : STD_LOGIC;
  signal \gen_single_issue.accept_cnt_i_1_n_0\ : STD_LOGIC;
  signal \^s_axi_rlast[0]\ : STD_LOGIC;
  signal \^s_axi_rvalid[0]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_no_arbiter.m_target_hot_i[2]_i_2__0\ : label is "soft_lutpair87";
  attribute SOFT_HLUTNM of \gen_single_issue.accept_cnt_i_1\ : label is "soft_lutpair87";
begin
  active_target_enc(1 downto 0) <= \^active_target_enc\(1 downto 0);
  active_target_hot(0) <= \^active_target_hot\(0);
  \s_axi_rlast[0]\ <= \^s_axi_rlast[0]\;
  \s_axi_rvalid[0]\ <= \^s_axi_rvalid[0]\;
\gen_no_arbiter.m_target_hot_i[2]_i_2__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80FF"
    )
        port map (
      I0 => \^s_axi_rvalid[0]\,
      I1 => s_axi_rready(0),
      I2 => \^s_axi_rlast[0]\,
      I3 => accept_cnt,
      O => \gen_no_arbiter.m_target_hot_i_reg[2]\
    );
\gen_no_arbiter.s_ready_i[0]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B0B0B00000000000"
    )
        port map (
      I0 => \gen_no_arbiter.s_ready_i[0]_i_2__0_n_0\,
      I1 => accept_cnt,
      I2 => \gen_no_arbiter.m_valid_i_reg\,
      I3 => \m_payload_i_reg[66]\,
      I4 => \gen_master_slots[1].r_issuing_cnt_reg[8]\,
      I5 => aresetn_d,
      O => s_ready_i0
    );
\gen_no_arbiter.s_ready_i[0]_i_2__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^s_axi_rlast[0]\,
      I1 => s_axi_rready(0),
      I2 => \^s_axi_rvalid[0]\,
      O => \gen_no_arbiter.s_ready_i[0]_i_2__0_n_0\
    );
\gen_single_issue.accept_cnt_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF7FFF00"
    )
        port map (
      I0 => \^s_axi_rvalid[0]\,
      I1 => s_axi_rready(0),
      I2 => \^s_axi_rlast[0]\,
      I3 => S_AXI_ARREADY(0),
      I4 => accept_cnt,
      O => \gen_single_issue.accept_cnt_i_1_n_0\
    );
\gen_single_issue.accept_cnt_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.accept_cnt_i_1_n_0\,
      Q => accept_cnt,
      R => SR(0)
    );
\gen_single_issue.active_target_enc_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.s_ready_i_reg[0]_0\,
      Q => \^active_target_enc\(0),
      R => SR(0)
    );
\gen_single_issue.active_target_enc_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.s_ready_i_reg[0]_1\,
      Q => \^active_target_enc\(1),
      R => SR(0)
    );
\gen_single_issue.active_target_hot_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_no_arbiter.s_ready_i_reg[0]\,
      Q => \^active_target_hot\(0),
      R => SR(0)
    );
\s_axi_rdata[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(68),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(2),
      O => s_axi_rdata(0)
    );
\s_axi_rdata[10]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(78),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(12),
      O => s_axi_rdata(10)
    );
\s_axi_rdata[11]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(79),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(13),
      O => s_axi_rdata(11)
    );
\s_axi_rdata[12]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(80),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(14),
      O => s_axi_rdata(12)
    );
\s_axi_rdata[13]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(15),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(81),
      O => s_axi_rdata(13)
    );
\s_axi_rdata[14]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(16),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(82),
      O => s_axi_rdata(14)
    );
\s_axi_rdata[15]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(83),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(17),
      O => s_axi_rdata(15)
    );
\s_axi_rdata[16]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(18),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(84),
      O => s_axi_rdata(16)
    );
\s_axi_rdata[17]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(85),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(19),
      O => s_axi_rdata(17)
    );
\s_axi_rdata[18]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(86),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(20),
      O => s_axi_rdata(18)
    );
\s_axi_rdata[19]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(87),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(21),
      O => s_axi_rdata(19)
    );
\s_axi_rdata[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(69),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(3),
      O => s_axi_rdata(1)
    );
\s_axi_rdata[20]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(88),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(22),
      O => s_axi_rdata(20)
    );
\s_axi_rdata[21]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(89),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(23),
      O => s_axi_rdata(21)
    );
\s_axi_rdata[22]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(24),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(90),
      O => s_axi_rdata(22)
    );
\s_axi_rdata[23]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(25),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(91),
      O => s_axi_rdata(23)
    );
\s_axi_rdata[24]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(92),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(26),
      O => s_axi_rdata(24)
    );
\s_axi_rdata[25]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(27),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(93),
      O => s_axi_rdata(25)
    );
\s_axi_rdata[26]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(94),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(28),
      O => s_axi_rdata(26)
    );
\s_axi_rdata[27]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(95),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(29),
      O => s_axi_rdata(27)
    );
\s_axi_rdata[28]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(96),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(30),
      O => s_axi_rdata(28)
    );
\s_axi_rdata[29]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(31),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(97),
      O => s_axi_rdata(29)
    );
\s_axi_rdata[2]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(4),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(70),
      O => s_axi_rdata(2)
    );
\s_axi_rdata[30]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(98),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(32),
      O => s_axi_rdata(30)
    );
\s_axi_rdata[31]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(99),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(33),
      O => s_axi_rdata(31)
    );
\s_axi_rdata[32]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(100),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(34),
      O => s_axi_rdata(32)
    );
\s_axi_rdata[33]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(101),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(35),
      O => s_axi_rdata(33)
    );
\s_axi_rdata[34]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(36),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(102),
      O => s_axi_rdata(34)
    );
\s_axi_rdata[35]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(103),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(37),
      O => s_axi_rdata(35)
    );
\s_axi_rdata[36]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(38),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(104),
      O => s_axi_rdata(36)
    );
\s_axi_rdata[37]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(105),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(39),
      O => s_axi_rdata(37)
    );
\s_axi_rdata[38]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(106),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(40),
      O => s_axi_rdata(38)
    );
\s_axi_rdata[39]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(107),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(41),
      O => s_axi_rdata(39)
    );
\s_axi_rdata[3]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(71),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(5),
      O => s_axi_rdata(3)
    );
\s_axi_rdata[40]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(108),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(42),
      O => s_axi_rdata(40)
    );
\s_axi_rdata[41]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(109),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(43),
      O => s_axi_rdata(41)
    );
\s_axi_rdata[42]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(110),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(44),
      O => s_axi_rdata(42)
    );
\s_axi_rdata[43]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(111),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(45),
      O => s_axi_rdata(43)
    );
\s_axi_rdata[44]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(112),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(46),
      O => s_axi_rdata(44)
    );
\s_axi_rdata[45]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(47),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(113),
      O => s_axi_rdata(45)
    );
\s_axi_rdata[46]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(48),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(114),
      O => s_axi_rdata(46)
    );
\s_axi_rdata[47]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(115),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(49),
      O => s_axi_rdata(47)
    );
\s_axi_rdata[48]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(50),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(116),
      O => s_axi_rdata(48)
    );
\s_axi_rdata[49]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(117),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(51),
      O => s_axi_rdata(49)
    );
\s_axi_rdata[4]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(6),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(72),
      O => s_axi_rdata(4)
    );
\s_axi_rdata[50]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(118),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(52),
      O => s_axi_rdata(50)
    );
\s_axi_rdata[51]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(119),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(53),
      O => s_axi_rdata(51)
    );
\s_axi_rdata[52]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(120),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(54),
      O => s_axi_rdata(52)
    );
\s_axi_rdata[53]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(121),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(55),
      O => s_axi_rdata(53)
    );
\s_axi_rdata[54]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(56),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(122),
      O => s_axi_rdata(54)
    );
\s_axi_rdata[55]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(57),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(123),
      O => s_axi_rdata(55)
    );
\s_axi_rdata[56]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(124),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(58),
      O => s_axi_rdata(56)
    );
\s_axi_rdata[57]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(59),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(125),
      O => s_axi_rdata(57)
    );
\s_axi_rdata[58]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(126),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(60),
      O => s_axi_rdata(58)
    );
\s_axi_rdata[59]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(127),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(61),
      O => s_axi_rdata(59)
    );
\s_axi_rdata[5]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(73),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(7),
      O => s_axi_rdata(5)
    );
\s_axi_rdata[60]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(128),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(62),
      O => s_axi_rdata(60)
    );
\s_axi_rdata[61]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3202"
    )
        port map (
      I0 => st_mr_rmesg(63),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(129),
      O => s_axi_rdata(61)
    );
\s_axi_rdata[62]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(130),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(64),
      O => s_axi_rdata(62)
    );
\s_axi_rdata[63]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(131),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(65),
      O => s_axi_rdata(63)
    );
\s_axi_rdata[6]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(74),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(8),
      O => s_axi_rdata(6)
    );
\s_axi_rdata[7]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(75),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(9),
      O => s_axi_rdata(7)
    );
\s_axi_rdata[8]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(76),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(10),
      O => s_axi_rdata(8)
    );
\s_axi_rdata[9]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2320"
    )
        port map (
      I0 => st_mr_rmesg(77),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(11),
      O => s_axi_rdata(9)
    );
\s_axi_rid[0]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0CAF0CA0"
    )
        port map (
      I0 => st_mr_rid(12),
      I1 => st_mr_rid(6),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_rid(0),
      O => s_axi_rid(0)
    );
\s_axi_rid[1]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FAC00AC"
    )
        port map (
      I0 => st_mr_rid(13),
      I1 => st_mr_rid(1),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_rid(7),
      O => s_axi_rid(1)
    );
\s_axi_rid[2]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_rid(2),
      I1 => st_mr_rid(8),
      I2 => \^active_target_enc\(0),
      I3 => \^active_target_enc\(1),
      I4 => st_mr_rid(14),
      O => s_axi_rid(2)
    );
\s_axi_rid[3]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_rid(3),
      I1 => st_mr_rid(9),
      I2 => \^active_target_enc\(0),
      I3 => \^active_target_enc\(1),
      I4 => st_mr_rid(15),
      O => s_axi_rid(3)
    );
\s_axi_rid[4]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0CAF0CA0"
    )
        port map (
      I0 => st_mr_rid(16),
      I1 => st_mr_rid(10),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_rid(4),
      O => s_axi_rid(4)
    );
\s_axi_rid[5]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_rid(5),
      I1 => st_mr_rid(17),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_rid(11),
      O => s_axi_rid(5)
    );
\s_axi_rlast[0]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0ACF0AC0"
    )
        port map (
      I0 => Q(0),
      I1 => \m_payload_i_reg[66]_0\(0),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => \m_payload_i_reg[66]_1\(0),
      O => \^s_axi_rlast[0]\
    );
\s_axi_rresp[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0FCA"
    )
        port map (
      I0 => st_mr_rmesg(0),
      I1 => st_mr_rmesg(66),
      I2 => \^active_target_enc\(0),
      I3 => \^active_target_enc\(1),
      O => s_axi_rresp(0)
    );
\s_axi_rresp[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F2C"
    )
        port map (
      I0 => st_mr_rmesg(67),
      I1 => \^active_target_enc\(1),
      I2 => \^active_target_enc\(0),
      I3 => st_mr_rmesg(1),
      O => s_axi_rresp(1)
    );
\s_axi_rvalid[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF888F888F888"
    )
        port map (
      I0 => p_72_out,
      I1 => \^active_target_hot\(0),
      I2 => p_50_out,
      I3 => \^active_target_enc\(0),
      I4 => \^active_target_enc\(1),
      I5 => p_28_out,
      O => \^s_axi_rvalid[0]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor__parameterized0\ is
  port (
    active_target_hot : out STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_ready_i_reg : out STD_LOGIC;
    s_ready_i_reg_0 : out STD_LOGIC;
    s_ready_i0 : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]\ : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]_0\ : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]\ : out STD_LOGIC;
    \s_axi_bvalid[0]\ : out STD_LOGIC;
    \gen_master_slots[1].w_issuing_cnt_reg[8]\ : out STD_LOGIC;
    \gen_master_slots[0].w_issuing_cnt_reg[0]\ : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_single_issue.active_target_hot_reg[0]_0\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[0]_0\ : in STD_LOGIC;
    \m_ready_d_reg[1]\ : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_56_out : in STD_LOGIC;
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    p_78_out : in STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg\ : in STD_LOGIC;
    aresetn_d : in STD_LOGIC;
    p_34_in : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    p_34_out : in STD_LOGIC;
    w_issuing_cnt : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_52_in : in STD_LOGIC;
    st_mr_bid : in STD_LOGIC_VECTOR ( 17 downto 0 );
    st_mr_bmesg : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \m_ready_d_reg[1]_0\ : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor__parameterized0\ : entity is "axi_crossbar_v2_1_10_si_transactor";
end \rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor__parameterized0\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor__parameterized0\ is
  signal accept_cnt : STD_LOGIC;
  signal \^active_target_enc\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^active_target_hot\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^gen_master_slots[0].w_issuing_cnt_reg[0]\ : STD_LOGIC;
  signal \gen_no_arbiter.s_ready_i[0]_i_3_n_0\ : STD_LOGIC;
  signal \gen_no_arbiter.s_ready_i[0]_i_6_n_0\ : STD_LOGIC;
  signal \^gen_no_arbiter.s_ready_i_reg[0]\ : STD_LOGIC;
  signal \^gen_no_arbiter.s_ready_i_reg[0]_0\ : STD_LOGIC;
  signal \gen_single_issue.accept_cnt_i_1__0_n_0\ : STD_LOGIC;
  signal \^s_axi_bvalid[0]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_master_slots[0].w_issuing_cnt[0]_i_2\ : label is "soft_lutpair89";
  attribute SOFT_HLUTNM of \gen_master_slots[1].w_issuing_cnt[8]_i_2\ : label is "soft_lutpair88";
  attribute SOFT_HLUTNM of \gen_no_arbiter.s_ready_i[0]_i_3\ : label is "soft_lutpair90";
  attribute SOFT_HLUTNM of \gen_no_arbiter.s_ready_i[0]_i_6\ : label is "soft_lutpair90";
  attribute SOFT_HLUTNM of \s_ready_i_i_1__1\ : label is "soft_lutpair89";
  attribute SOFT_HLUTNM of \s_ready_i_i_2__0\ : label is "soft_lutpair88";
begin
  active_target_enc(1 downto 0) <= \^active_target_enc\(1 downto 0);
  active_target_hot(0) <= \^active_target_hot\(0);
  \gen_master_slots[0].w_issuing_cnt_reg[0]\ <= \^gen_master_slots[0].w_issuing_cnt_reg[0]\;
  \gen_no_arbiter.s_ready_i_reg[0]\ <= \^gen_no_arbiter.s_ready_i_reg[0]\;
  \gen_no_arbiter.s_ready_i_reg[0]_0\ <= \^gen_no_arbiter.s_ready_i_reg[0]_0\;
  \s_axi_bvalid[0]\ <= \^s_axi_bvalid[0]\;
\gen_master_slots[0].w_issuing_cnt[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^active_target_hot\(0),
      I1 => s_axi_bready(0),
      I2 => p_78_out,
      O => \^gen_master_slots[0].w_issuing_cnt_reg[0]\
    );
\gen_master_slots[1].w_issuing_cnt[8]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^active_target_enc\(0),
      I1 => s_axi_bready(0),
      I2 => p_56_out,
      O => \gen_master_slots[1].w_issuing_cnt_reg[8]\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFBFBFBFAAAAAAAA"
    )
        port map (
      I0 => \gen_no_arbiter.m_valid_i_reg\,
      I1 => \^s_axi_bvalid[0]\,
      I2 => s_axi_bready(0),
      I3 => \^active_target_enc\(1),
      I4 => \^active_target_enc\(0),
      I5 => accept_cnt,
      O => \gen_no_arbiter.m_target_hot_i_reg[2]\
    );
\gen_no_arbiter.s_ready_i[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4545450000000000"
    )
        port map (
      I0 => \gen_no_arbiter.m_valid_i_reg\,
      I1 => \gen_no_arbiter.s_ready_i[0]_i_3_n_0\,
      I2 => accept_cnt,
      I3 => \^gen_no_arbiter.s_ready_i_reg[0]\,
      I4 => \^gen_no_arbiter.s_ready_i_reg[0]_0\,
      I5 => aresetn_d,
      O => s_ready_i0
    );
\gen_no_arbiter.s_ready_i[0]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0888"
    )
        port map (
      I0 => \^s_axi_bvalid[0]\,
      I1 => s_axi_bready(0),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      O => \gen_no_arbiter.s_ready_i[0]_i_3_n_0\
    );
\gen_no_arbiter.s_ready_i[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B0BFB0B0B0BFB0BF"
    )
        port map (
      I0 => \gen_no_arbiter.s_ready_i[0]_i_6_n_0\,
      I1 => w_issuing_cnt(0),
      I2 => s_axi_awaddr(1),
      I3 => s_axi_awaddr(0),
      I4 => \^gen_master_slots[0].w_issuing_cnt_reg[0]\,
      I5 => p_52_in,
      O => \^gen_no_arbiter.s_ready_i_reg[0]\
    );
\gen_no_arbiter.s_ready_i[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000D5550000"
    )
        port map (
      I0 => p_34_in,
      I1 => \^active_target_enc\(0),
      I2 => s_axi_bready(0),
      I3 => p_56_out,
      I4 => s_axi_awaddr(0),
      I5 => s_axi_awaddr(1),
      O => \^gen_no_arbiter.s_ready_i_reg[0]_0\
    );
\gen_no_arbiter.s_ready_i[0]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^active_target_enc\(1),
      I1 => s_axi_bready(0),
      I2 => p_34_out,
      O => \gen_no_arbiter.s_ready_i[0]_i_6_n_0\
    );
\gen_single_issue.accept_cnt_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF8FFFFFFF0000"
    )
        port map (
      I0 => \^active_target_enc\(0),
      I1 => \^active_target_enc\(1),
      I2 => s_axi_bready(0),
      I3 => \^s_axi_bvalid[0]\,
      I4 => \m_ready_d_reg[1]_0\,
      I5 => accept_cnt,
      O => \gen_single_issue.accept_cnt_i_1__0_n_0\
    );
\gen_single_issue.accept_cnt_reg\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.accept_cnt_i_1__0_n_0\,
      Q => accept_cnt,
      R => SR(0)
    );
\gen_single_issue.active_target_enc_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.active_target_enc_reg[0]_0\,
      Q => \^active_target_enc\(0),
      R => SR(0)
    );
\gen_single_issue.active_target_enc_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d_reg[1]\,
      Q => \^active_target_enc\(1),
      R => SR(0)
    );
\gen_single_issue.active_target_hot_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.active_target_hot_reg[0]_0\,
      Q => \^active_target_hot\(0),
      R => SR(0)
    );
\s_axi_bid[0]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_bid(0),
      I1 => st_mr_bid(12),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_bid(6),
      O => s_axi_bid(0)
    );
\s_axi_bid[1]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_bid(1),
      I1 => st_mr_bid(7),
      I2 => \^active_target_enc\(0),
      I3 => \^active_target_enc\(1),
      I4 => st_mr_bid(13),
      O => s_axi_bid(1)
    );
\s_axi_bid[2]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0ACF0AC0"
    )
        port map (
      I0 => st_mr_bid(8),
      I1 => st_mr_bid(14),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_bid(2),
      O => s_axi_bid(2)
    );
\s_axi_bid[3]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_bid(3),
      I1 => st_mr_bid(15),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_bid(9),
      O => s_axi_bid(3)
    );
\s_axi_bid[4]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCA00CA"
    )
        port map (
      I0 => st_mr_bid(4),
      I1 => st_mr_bid(10),
      I2 => \^active_target_enc\(0),
      I3 => \^active_target_enc\(1),
      I4 => st_mr_bid(16),
      O => s_axi_bid(4)
    );
\s_axi_bid[5]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FAC00AC"
    )
        port map (
      I0 => st_mr_bid(17),
      I1 => st_mr_bid(5),
      I2 => \^active_target_enc\(1),
      I3 => \^active_target_enc\(0),
      I4 => st_mr_bid(11),
      O => s_axi_bid(5)
    );
\s_axi_bresp[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"33B8"
    )
        port map (
      I0 => st_mr_bmesg(2),
      I1 => \^active_target_enc\(0),
      I2 => st_mr_bmesg(0),
      I3 => \^active_target_enc\(1),
      O => s_axi_bresp(0)
    );
\s_axi_bresp[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"33B8"
    )
        port map (
      I0 => st_mr_bmesg(3),
      I1 => \^active_target_enc\(0),
      I2 => st_mr_bmesg(1),
      I3 => \^active_target_enc\(1),
      O => s_axi_bresp(1)
    );
\s_axi_bvalid[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF888F888F888"
    )
        port map (
      I0 => p_56_out,
      I1 => \^active_target_enc\(0),
      I2 => p_78_out,
      I3 => \^active_target_hot\(0),
      I4 => \^active_target_enc\(1),
      I5 => p_34_out,
      O => \^s_axi_bvalid[0]\
    );
\s_ready_i_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"808FFFFF"
    )
        port map (
      I0 => \^active_target_hot\(0),
      I1 => s_axi_bready(0),
      I2 => p_78_out,
      I3 => m_axi_bvalid(0),
      I4 => \aresetn_d_reg[1]\,
      O => s_ready_i_reg_0
    );
\s_ready_i_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"808FFFFF"
    )
        port map (
      I0 => \^active_target_enc\(0),
      I1 => s_axi_bready(0),
      I2 => p_56_out,
      I3 => m_axi_bvalid(1),
      I4 => \aresetn_d_reg[1]\,
      O => s_ready_i_reg
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter is
  port (
    \s_axi_awready[0]\ : out STD_LOGIC;
    m_ready_d : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ss_wr_awvalid : out STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[0]\ : out STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[1]\ : out STD_LOGIC;
    \gen_single_issue.active_target_hot_reg[0]\ : out STD_LOGIC;
    ss_wr_awready : in STD_LOGIC;
    ss_aa_awready : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    active_target_enc : in STD_LOGIC_VECTOR ( 1 downto 0 );
    active_target_hot : in STD_LOGIC_VECTOR ( 0 to 0 );
    aresetn_d : in STD_LOGIC;
    aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter : entity is "axi_crossbar_v2_1_10_splitter";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter is
  signal \^m_ready_d\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \m_ready_d[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_ready_d[1]_i_1_n_0\ : STD_LOGIC;
  signal \^s_axi_awready[0]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \gen_single_issue.active_target_enc[0]_i_1\ : label is "soft_lutpair92";
  attribute SOFT_HLUTNM of \gen_single_issue.active_target_hot[0]_i_1\ : label is "soft_lutpair92";
  attribute SOFT_HLUTNM of \m_valid_i_i_2__0\ : label is "soft_lutpair91";
  attribute SOFT_HLUTNM of \s_axi_awready[0]_INST_0\ : label is "soft_lutpair91";
begin
  m_ready_d(1 downto 0) <= \^m_ready_d\(1 downto 0);
  \s_axi_awready[0]\ <= \^s_axi_awready[0]\;
\gen_single_issue.active_target_enc[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F20"
    )
        port map (
      I0 => s_axi_awaddr(0),
      I1 => s_axi_awaddr(1),
      I2 => \^s_axi_awready[0]\,
      I3 => active_target_enc(0),
      O => \gen_single_issue.active_target_enc_reg[0]\
    );
\gen_single_issue.active_target_enc[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ABABABFFA8A8A800"
    )
        port map (
      I0 => s_axi_awaddr(1),
      I1 => \^m_ready_d\(1),
      I2 => ss_wr_awready,
      I3 => ss_aa_awready,
      I4 => \^m_ready_d\(0),
      I5 => active_target_enc(1),
      O => \gen_single_issue.active_target_enc_reg[1]\
    );
\gen_single_issue.active_target_hot[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1F10"
    )
        port map (
      I0 => s_axi_awaddr(0),
      I1 => s_axi_awaddr(1),
      I2 => \^s_axi_awready[0]\,
      I3 => active_target_hot(0),
      O => \gen_single_issue.active_target_hot_reg[0]\
    );
\m_ready_d[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000C000C00080000"
    )
        port map (
      I0 => s_axi_awvalid(0),
      I1 => aresetn_d,
      I2 => \^m_ready_d\(1),
      I3 => ss_wr_awready,
      I4 => ss_aa_awready,
      I5 => \^m_ready_d\(0),
      O => \m_ready_d[0]_i_1_n_0\
    );
\m_ready_d[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000000C8C0"
    )
        port map (
      I0 => s_axi_awvalid(0),
      I1 => aresetn_d,
      I2 => \^m_ready_d\(1),
      I3 => ss_wr_awready,
      I4 => ss_aa_awready,
      I5 => \^m_ready_d\(0),
      O => \m_ready_d[1]_i_1_n_0\
    );
\m_ready_d_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[0]_i_1_n_0\,
      Q => \^m_ready_d\(0),
      R => '0'
    );
\m_ready_d_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[1]_i_1_n_0\,
      Q => \^m_ready_d\(1),
      R => '0'
    );
\m_valid_i_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_awvalid(0),
      I1 => \^m_ready_d\(1),
      O => ss_wr_awvalid
    );
\s_axi_awready[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EEE0"
    )
        port map (
      I0 => \^m_ready_d\(1),
      I1 => ss_wr_awready,
      I2 => ss_aa_awready,
      I3 => \^m_ready_d\(0),
      O => \^s_axi_awready[0]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter_3 is
  port (
    m_ready_d : out STD_LOGIC_VECTOR ( 1 downto 0 );
    aa_sa_awvalid : in STD_LOGIC;
    aresetn_d : in STD_LOGIC;
    \gen_axi.s_axi_awready_i_reg\ : in STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[0]\ : in STD_LOGIC;
    aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter_3 : entity is "axi_crossbar_v2_1_10_splitter";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter_3;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter_3 is
  signal \^m_ready_d\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \m_ready_d[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_ready_d[1]_i_1_n_0\ : STD_LOGIC;
begin
  m_ready_d(1 downto 0) <= \^m_ready_d\(1 downto 0);
\m_ready_d[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000E0"
    )
        port map (
      I0 => \^m_ready_d\(0),
      I1 => aa_sa_awvalid,
      I2 => aresetn_d,
      I3 => \gen_axi.s_axi_awready_i_reg\,
      I4 => \gen_no_arbiter.m_target_hot_i_reg[0]\,
      O => \m_ready_d[0]_i_1_n_0\
    );
\m_ready_d[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E0000000"
    )
        port map (
      I0 => \^m_ready_d\(1),
      I1 => aa_sa_awvalid,
      I2 => aresetn_d,
      I3 => \gen_axi.s_axi_awready_i_reg\,
      I4 => \gen_no_arbiter.m_target_hot_i_reg[0]\,
      O => \m_ready_d[1]_i_1_n_0\
    );
\m_ready_d_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[0]_i_1_n_0\,
      Q => \^m_ready_d\(0),
      R => '0'
    );
\m_ready_d_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[1]_i_1_n_0\,
      Q => \^m_ready_d\(1),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl is
  port (
    \storage_data1_reg[0]\ : out STD_LOGIC;
    push : in STD_LOGIC;
    st_aa_awtarget_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    fifoaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl : entity is "axi_data_fifo_v2_1_8_ndeep_srl";
end rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl;

architecture STRUCTURE of rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl is
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "SRLC32E";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "inst/\gen_samd.crossbar_samd/gen_slave_slots[0].gen_si_write.wdata_router_w/wrouter_aw_fifo/gen_srls[0].gen_rep[0].srl_nx1/gen_primitive_shifter.gen_srls ";
  attribute srl_name : string;
  attribute srl_name of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "inst/\gen_samd.crossbar_samd/gen_slave_slots[0].gen_si_write.wdata_router_w/wrouter_aw_fifo/gen_srls[0].gen_rep[0].srl_nx1/gen_primitive_shifter.gen_srls[0].srl_inst ";
begin
\gen_primitive_shifter.gen_srls[0].srl_inst\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => fifoaddr(0),
      A1 => fifoaddr(1),
      A2 => '0',
      A3 => '0',
      CE => push,
      CLK => aclk,
      D => st_aa_awtarget_enc(0),
      Q => \storage_data1_reg[0]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl_4 is
  port (
    p_2_out : out STD_LOGIC;
    push : out STD_LOGIC;
    s_ready_i_reg : out STD_LOGIC;
    s_ready_i_reg_0 : out STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 0 to 0 );
    fifoaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aclk : in STD_LOGIC;
    out0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_ready_i_reg_1 : in STD_LOGIC;
    ss_wr_awvalid : in STD_LOGIC;
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \storage_data1_reg[0]\ : in STD_LOGIC;
    \storage_data1_reg[1]\ : in STD_LOGIC;
    wr_tmp_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_avalid : in STD_LOGIC;
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl_4 : entity is "axi_data_fifo_v2_1_8_ndeep_srl";
end rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl_4;

architecture STRUCTURE of rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl_4 is
  signal \^push\ : STD_LOGIC;
  signal \^s_ready_i_reg\ : STD_LOGIC;
  signal \^s_ready_i_reg_0\ : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "SRLC32E";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "inst/\gen_samd.crossbar_samd/gen_slave_slots[0].gen_si_write.wdata_router_w/wrouter_aw_fifo/gen_srls[0].gen_rep[1].srl_nx1/gen_primitive_shifter.gen_srls ";
  attribute srl_name : string;
  attribute srl_name of \gen_primitive_shifter.gen_srls[0].srl_inst\ : label is "inst/\gen_samd.crossbar_samd/gen_slave_slots[0].gen_si_write.wdata_router_w/wrouter_aw_fifo/gen_srls[0].gen_rep[1].srl_nx1/gen_primitive_shifter.gen_srls[0].srl_inst ";
begin
  push <= \^push\;
  s_ready_i_reg <= \^s_ready_i_reg\;
  s_ready_i_reg_0 <= \^s_ready_i_reg_0\;
\gen_primitive_shifter.gen_srls[0].srl_inst\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => fifoaddr(0),
      A1 => fifoaddr(1),
      A2 => '0',
      A3 => '0',
      CE => \^push\,
      CLK => aclk,
      D => s_axi_awaddr(0),
      Q => p_2_out
    );
\gen_primitive_shifter.gen_srls[0].srl_inst_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFF8000088880000"
    )
        port map (
      I0 => out0(0),
      I1 => s_ready_i_reg_1,
      I2 => \^s_ready_i_reg\,
      I3 => \^s_ready_i_reg_0\,
      I4 => ss_wr_awvalid,
      I5 => out0(1),
      O => \^push\
    );
\gen_primitive_shifter.gen_srls[0].srl_inst_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => s_axi_wvalid(0),
      I1 => m_avalid,
      I2 => s_axi_wlast(0),
      O => \^s_ready_i_reg\
    );
\gen_primitive_shifter.gen_srls[0].srl_inst_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C1CDF1FD"
    )
        port map (
      I0 => m_axi_wready(0),
      I1 => \storage_data1_reg[0]\,
      I2 => \storage_data1_reg[1]\,
      I3 => m_axi_wready(1),
      I4 => wr_tmp_wready(0),
      O => \^s_ready_i_reg_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1\ is
  port (
    p_34_out : out STD_LOGIC;
    m_valid_i_reg_0 : out STD_LOGIC;
    mi_bready_2 : out STD_LOGIC;
    s_ready_i_reg_0 : out STD_LOGIC;
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    \gen_axi.s_axi_bvalid_i_reg\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    \aresetn_d_reg[0]_0\ : in STD_LOGIC;
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_17_in : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1\ is
  signal \m_payload_i[7]_i_1__1_n_0\ : STD_LOGIC;
  signal \^m_valid_i_reg_0\ : STD_LOGIC;
  signal \^p_34_out\ : STD_LOGIC;
  signal \s_ready_i_i_1__2_n_0\ : STD_LOGIC;
  signal \^s_ready_i_reg_0\ : STD_LOGIC;
begin
  m_valid_i_reg_0 <= \^m_valid_i_reg_0\;
  p_34_out <= \^p_34_out\;
  s_ready_i_reg_0 <= \^s_ready_i_reg_0\;
\aresetn_d_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => \aresetn_d_reg[0]_0\,
      Q => \^s_ready_i_reg_0\,
      R => '0'
    );
\m_payload_i[7]_i_1__1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^p_34_out\,
      O => \m_payload_i[7]_i_1__1_n_0\
    );
\m_payload_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(0),
      Q => \s_axi_bid[5]\(0),
      R => '0'
    );
\m_payload_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(1),
      Q => \s_axi_bid[5]\(1),
      R => '0'
    );
\m_payload_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(2),
      Q => \s_axi_bid[5]\(2),
      R => '0'
    );
\m_payload_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(3),
      Q => \s_axi_bid[5]\(3),
      R => '0'
    );
\m_payload_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(4),
      Q => \s_axi_bid[5]\(4),
      R => '0'
    );
\m_payload_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__1_n_0\,
      D => D(5),
      Q => \s_axi_bid[5]\(5),
      R => '0'
    );
\m_valid_i_i_1__5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^s_ready_i_reg_0\,
      O => \^m_valid_i_reg_0\
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_axi.s_axi_bvalid_i_reg\,
      Q => \^p_34_out\,
      R => \^m_valid_i_reg_0\
    );
\s_ready_i_i_1__2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"808FFFFF"
    )
        port map (
      I0 => active_target_enc(0),
      I1 => s_axi_bready(0),
      I2 => \^p_34_out\,
      I3 => p_17_in,
      I4 => \^s_ready_i_reg_0\,
      O => \s_ready_i_i_1__2_n_0\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \s_ready_i_i_1__2_n_0\,
      Q => mi_bready_2,
      R => \aresetn_d_reg[0]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_5\ is
  port (
    p_56_out : out STD_LOGIC;
    m_axi_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_ready_i_reg_0 : out STD_LOGIC;
    \aresetn_d_reg[1]\ : out STD_LOGIC;
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \aresetn_d_reg[1]_0\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[0]\ : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_5\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_5\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_5\ is
  signal \aresetn_d_reg_n_0_[0]\ : STD_LOGIC;
  signal \^m_axi_bready\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \m_payload_i[7]_i_1__0_n_0\ : STD_LOGIC;
  signal m_valid_i_i_1_n_0 : STD_LOGIC;
  signal \^p_56_out\ : STD_LOGIC;
  signal \^s_ready_i_reg_0\ : STD_LOGIC;
begin
  m_axi_bready(0) <= \^m_axi_bready\(0);
  p_56_out <= \^p_56_out\;
  s_ready_i_reg_0 <= \^s_ready_i_reg_0\;
\aresetn_d[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \aresetn_d_reg_n_0_[0]\,
      I1 => aresetn,
      O => \aresetn_d_reg[1]\
    );
\aresetn_d_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => aresetn,
      Q => \aresetn_d_reg_n_0_[0]\,
      R => '0'
    );
\m_payload_i[7]_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^p_56_out\,
      O => \m_payload_i[7]_i_1__0_n_0\
    );
\m_payload_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(0),
      Q => \s_axi_bid[5]\(0),
      R => '0'
    );
\m_payload_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(1),
      Q => \s_axi_bid[5]\(1),
      R => '0'
    );
\m_payload_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(2),
      Q => \s_axi_bid[5]\(2),
      R => '0'
    );
\m_payload_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(3),
      Q => \s_axi_bid[5]\(3),
      R => '0'
    );
\m_payload_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(4),
      Q => \s_axi_bid[5]\(4),
      R => '0'
    );
\m_payload_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(5),
      Q => \s_axi_bid[5]\(5),
      R => '0'
    );
\m_payload_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(6),
      Q => \s_axi_bid[5]\(6),
      R => '0'
    );
\m_payload_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1__0_n_0\,
      D => D(7),
      Q => \s_axi_bid[5]\(7),
      R => '0'
    );
m_valid_i_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8BBB"
    )
        port map (
      I0 => m_axi_bvalid(0),
      I1 => \^m_axi_bready\(0),
      I2 => active_target_enc_0(0),
      I3 => s_axi_bready(0),
      O => m_valid_i_i_1_n_0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => m_valid_i_i_1_n_0,
      Q => \^p_56_out\,
      R => \aresetn_d_reg[1]_0\
    );
s_ready_i_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \aresetn_d_reg_n_0_[0]\,
      O => \^s_ready_i_reg_0\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.active_target_enc_reg[0]\,
      Q => \^m_axi_bready\(0),
      R => \^s_ready_i_reg_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_7\ is
  port (
    p_78_out : out STD_LOGIC;
    m_axi_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    \gen_single_issue.active_target_hot_reg[0]\ : in STD_LOGIC;
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_hot_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_7\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_7\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_7\ is
  signal \^m_axi_bready\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \m_payload_i[7]_i_1_n_0\ : STD_LOGIC;
  signal m_valid_i_i_2_n_0 : STD_LOGIC;
  signal \^p_78_out\ : STD_LOGIC;
begin
  m_axi_bready(0) <= \^m_axi_bready\(0);
  p_78_out <= \^p_78_out\;
\m_payload_i[7]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^p_78_out\,
      O => \m_payload_i[7]_i_1_n_0\
    );
\m_payload_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(0),
      Q => \s_axi_bid[5]\(0),
      R => '0'
    );
\m_payload_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(1),
      Q => \s_axi_bid[5]\(1),
      R => '0'
    );
\m_payload_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(2),
      Q => \s_axi_bid[5]\(2),
      R => '0'
    );
\m_payload_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(3),
      Q => \s_axi_bid[5]\(3),
      R => '0'
    );
\m_payload_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(4),
      Q => \s_axi_bid[5]\(4),
      R => '0'
    );
\m_payload_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(5),
      Q => \s_axi_bid[5]\(5),
      R => '0'
    );
\m_payload_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(6),
      Q => \s_axi_bid[5]\(6),
      R => '0'
    );
\m_payload_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_payload_i[7]_i_1_n_0\,
      D => D(7),
      Q => \s_axi_bid[5]\(7),
      R => '0'
    );
m_valid_i_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8BBB"
    )
        port map (
      I0 => m_axi_bvalid(0),
      I1 => \^m_axi_bready\(0),
      I2 => active_target_hot_0(0),
      I3 => s_axi_bready(0),
      O => m_valid_i_i_2_n_0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => m_valid_i_i_2_n_0,
      Q => \^p_78_out\,
      R => \aresetn_d_reg[1]\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_single_issue.active_target_hot_reg[0]\,
      Q => \^m_axi_bready\(0),
      R => \aresetn_d_reg[0]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2\ is
  port (
    m_valid_i_reg_0 : out STD_LOGIC;
    \skid_buffer_reg[66]_0\ : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 6 downto 0 );
    \gen_master_slots[2].r_issuing_cnt_reg[16]\ : out STD_LOGIC;
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    p_11_in : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    r_issuing_cnt : in STD_LOGIC_VECTOR ( 0 to 0 );
    \s_axi_araddr[31]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.s_axi_rid_i_reg[5]\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rlast_i : in STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg\ : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2\ is
  signal \^q\ : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal \m_payload_i[66]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[67]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[68]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[69]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[70]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[71]_i_1__1_n_0\ : STD_LOGIC;
  signal \m_payload_i[72]_i_2__1_n_0\ : STD_LOGIC;
  signal m_valid_i0 : STD_LOGIC;
  signal \^m_valid_i_reg_0\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal \s_ready_i_i_1__5_n_0\ : STD_LOGIC;
  signal \^skid_buffer_reg[66]_0\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[66]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[67]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[68]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[69]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[70]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[71]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[72]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_payload_i[67]_i_1__1\ : label is "soft_lutpair86";
  attribute SOFT_HLUTNM of \m_payload_i[68]_i_1__1\ : label is "soft_lutpair86";
  attribute SOFT_HLUTNM of \m_payload_i[69]_i_1__1\ : label is "soft_lutpair85";
  attribute SOFT_HLUTNM of \m_payload_i[70]_i_1__1\ : label is "soft_lutpair85";
  attribute SOFT_HLUTNM of \m_payload_i[71]_i_1__1\ : label is "soft_lutpair84";
  attribute SOFT_HLUTNM of \m_payload_i[72]_i_2__1\ : label is "soft_lutpair84";
begin
  Q(6 downto 0) <= \^q\(6 downto 0);
  m_valid_i_reg_0 <= \^m_valid_i_reg_0\;
  \skid_buffer_reg[66]_0\ <= \^skid_buffer_reg[66]_0\;
\gen_master_slots[2].r_issuing_cnt[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"955555552AAAAAAA"
    )
        port map (
      I0 => \gen_no_arbiter.m_valid_i_reg\,
      I1 => \^m_valid_i_reg_0\,
      I2 => active_target_enc_0(0),
      I3 => s_axi_rready(0),
      I4 => \^q\(0),
      I5 => r_issuing_cnt(0),
      O => \gen_master_slots[2].r_issuing_cnt_reg[16]\
    );
\gen_no_arbiter.s_ready_i[0]_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000FFFF00000000"
    )
        port map (
      I0 => \^q\(0),
      I1 => s_axi_rready(0),
      I2 => active_target_enc_0(0),
      I3 => \^m_valid_i_reg_0\,
      I4 => r_issuing_cnt(0),
      I5 => \s_axi_araddr[31]\(0),
      O => \gen_no_arbiter.s_ready_i_reg[0]\
    );
\m_payload_i[66]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => s_axi_rlast_i,
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[66]\,
      O => \m_payload_i[66]_i_1__1_n_0\
    );
\m_payload_i[67]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(0),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[67]\,
      O => \m_payload_i[67]_i_1__1_n_0\
    );
\m_payload_i[68]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(1),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[68]\,
      O => \m_payload_i[68]_i_1__1_n_0\
    );
\m_payload_i[69]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(2),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[69]\,
      O => \m_payload_i[69]_i_1__1_n_0\
    );
\m_payload_i[70]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(3),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[70]\,
      O => \m_payload_i[70]_i_1__1_n_0\
    );
\m_payload_i[71]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(4),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[71]\,
      O => \m_payload_i[71]_i_1__1_n_0\
    );
\m_payload_i[72]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D5"
    )
        port map (
      I0 => \^m_valid_i_reg_0\,
      I1 => s_axi_rready(0),
      I2 => active_target_enc_0(0),
      O => p_1_in
    );
\m_payload_i[72]_i_2__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \gen_axi.s_axi_rid_i_reg[5]\(5),
      I1 => \^skid_buffer_reg[66]_0\,
      I2 => \skid_buffer_reg_n_0_[72]\,
      O => \m_payload_i[72]_i_2__1_n_0\
    );
\m_payload_i_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[66]_i_1__1_n_0\,
      Q => \^q\(0),
      R => '0'
    );
\m_payload_i_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[67]_i_1__1_n_0\,
      Q => \^q\(1),
      R => '0'
    );
\m_payload_i_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[68]_i_1__1_n_0\,
      Q => \^q\(2),
      R => '0'
    );
\m_payload_i_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[69]_i_1__1_n_0\,
      Q => \^q\(3),
      R => '0'
    );
\m_payload_i_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[70]_i_1__1_n_0\,
      Q => \^q\(4),
      R => '0'
    );
\m_payload_i_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[71]_i_1__1_n_0\,
      Q => \^q\(5),
      R => '0'
    );
\m_payload_i_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[72]_i_2__1_n_0\,
      Q => \^q\(6),
      R => '0'
    );
\m_valid_i_i_1__4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDFDFDFD"
    )
        port map (
      I0 => \^skid_buffer_reg[66]_0\,
      I1 => p_11_in,
      I2 => \^m_valid_i_reg_0\,
      I3 => s_axi_rready(0),
      I4 => active_target_enc_0(0),
      O => m_valid_i0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => m_valid_i0,
      Q => \^m_valid_i_reg_0\,
      R => \aresetn_d_reg[1]\
    );
\s_ready_i_i_1__5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF2F2F2F"
    )
        port map (
      I0 => \^skid_buffer_reg[66]_0\,
      I1 => p_11_in,
      I2 => \^m_valid_i_reg_0\,
      I3 => s_axi_rready(0),
      I4 => active_target_enc_0(0),
      O => \s_ready_i_i_1__5_n_0\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \s_ready_i_i_1__5_n_0\,
      Q => \^skid_buffer_reg[66]_0\,
      R => \aresetn_d_reg[0]\
    );
\skid_buffer_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => s_axi_rlast_i,
      Q => \skid_buffer_reg_n_0_[66]\,
      R => '0'
    );
\skid_buffer_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(0),
      Q => \skid_buffer_reg_n_0_[67]\,
      R => '0'
    );
\skid_buffer_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(1),
      Q => \skid_buffer_reg_n_0_[68]\,
      R => '0'
    );
\skid_buffer_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(2),
      Q => \skid_buffer_reg_n_0_[69]\,
      R => '0'
    );
\skid_buffer_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(3),
      Q => \skid_buffer_reg_n_0_[70]\,
      R => '0'
    );
\skid_buffer_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(4),
      Q => \skid_buffer_reg_n_0_[71]\,
      R => '0'
    );
\skid_buffer_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^skid_buffer_reg[66]_0\,
      D => \gen_axi.s_axi_rid_i_reg[5]\(5),
      Q => \skid_buffer_reg_n_0_[72]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_6\ is
  port (
    m_valid_i_reg_0 : out STD_LOGIC;
    \m_axi_rready[1]\ : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]\ : out STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 72 downto 0 );
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_25_in : in STD_LOGIC;
    \s_axi_araddr[31]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \m_payload_i_reg[66]_0\ : in STD_LOGIC;
    p_43_in : in STD_LOGIC;
    m_axi_rid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_6\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_6\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_6\ is
  signal \^q\ : STD_LOGIC_VECTOR ( 72 downto 0 );
  signal \^gen_master_slots[1].r_issuing_cnt_reg[8]\ : STD_LOGIC;
  signal \^m_axi_rready[1]\ : STD_LOGIC;
  signal \m_payload_i[0]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[10]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[11]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[12]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[13]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[14]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[15]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[16]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[17]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[18]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[19]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[20]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[21]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[22]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[23]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[24]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[25]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[26]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[27]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[28]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[29]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[30]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[31]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[32]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[33]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[34]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[35]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[36]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[37]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[38]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[39]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[40]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[41]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[42]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[43]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[44]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[45]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[46]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[47]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[48]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[49]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[4]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[50]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[51]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[52]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[53]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[54]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[55]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[56]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[57]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[58]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[59]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[5]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[60]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[61]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[62]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[63]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[64]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[65]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[66]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[67]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[68]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[69]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[6]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[70]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[71]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[72]_i_2__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[7]_i_1__3_n_0\ : STD_LOGIC;
  signal \m_payload_i[8]_i_1__0_n_0\ : STD_LOGIC;
  signal \m_payload_i[9]_i_1__0_n_0\ : STD_LOGIC;
  signal m_valid_i0 : STD_LOGIC;
  signal \^m_valid_i_reg_0\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal \s_ready_i_i_1__4_n_0\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[0]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[10]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[11]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[12]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[13]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[14]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[15]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[16]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[17]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[18]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[19]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[1]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[20]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[21]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[22]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[23]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[24]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[25]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[26]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[27]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[28]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[29]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[2]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[30]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[31]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[32]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[33]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[34]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[35]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[36]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[37]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[38]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[39]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[3]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[40]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[41]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[42]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[43]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[44]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[45]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[46]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[47]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[48]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[49]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[4]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[50]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[51]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[52]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[53]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[54]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[55]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[56]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[57]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[58]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[59]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[5]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[60]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[61]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[62]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[63]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[64]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[65]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[66]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[67]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[68]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[69]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[6]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[70]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[71]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[72]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[7]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[8]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[9]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_payload_i[10]_i_1__0\ : label is "soft_lutpair79";
  attribute SOFT_HLUTNM of \m_payload_i[11]_i_1__0\ : label is "soft_lutpair78";
  attribute SOFT_HLUTNM of \m_payload_i[12]_i_1__0\ : label is "soft_lutpair78";
  attribute SOFT_HLUTNM of \m_payload_i[13]_i_1__0\ : label is "soft_lutpair77";
  attribute SOFT_HLUTNM of \m_payload_i[14]_i_1__0\ : label is "soft_lutpair77";
  attribute SOFT_HLUTNM of \m_payload_i[15]_i_1__0\ : label is "soft_lutpair76";
  attribute SOFT_HLUTNM of \m_payload_i[16]_i_1__0\ : label is "soft_lutpair76";
  attribute SOFT_HLUTNM of \m_payload_i[17]_i_1__0\ : label is "soft_lutpair75";
  attribute SOFT_HLUTNM of \m_payload_i[18]_i_1__0\ : label is "soft_lutpair75";
  attribute SOFT_HLUTNM of \m_payload_i[19]_i_1__0\ : label is "soft_lutpair74";
  attribute SOFT_HLUTNM of \m_payload_i[1]_i_1__0\ : label is "soft_lutpair83";
  attribute SOFT_HLUTNM of \m_payload_i[20]_i_1__0\ : label is "soft_lutpair74";
  attribute SOFT_HLUTNM of \m_payload_i[21]_i_1__0\ : label is "soft_lutpair73";
  attribute SOFT_HLUTNM of \m_payload_i[22]_i_1__0\ : label is "soft_lutpair73";
  attribute SOFT_HLUTNM of \m_payload_i[23]_i_1__0\ : label is "soft_lutpair72";
  attribute SOFT_HLUTNM of \m_payload_i[24]_i_1__0\ : label is "soft_lutpair72";
  attribute SOFT_HLUTNM of \m_payload_i[25]_i_1__0\ : label is "soft_lutpair71";
  attribute SOFT_HLUTNM of \m_payload_i[26]_i_1__0\ : label is "soft_lutpair71";
  attribute SOFT_HLUTNM of \m_payload_i[27]_i_1__0\ : label is "soft_lutpair70";
  attribute SOFT_HLUTNM of \m_payload_i[28]_i_1__0\ : label is "soft_lutpair70";
  attribute SOFT_HLUTNM of \m_payload_i[29]_i_1__0\ : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of \m_payload_i[2]_i_1__0\ : label is "soft_lutpair83";
  attribute SOFT_HLUTNM of \m_payload_i[30]_i_1__0\ : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of \m_payload_i[31]_i_1__0\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \m_payload_i[32]_i_1__0\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \m_payload_i[33]_i_1__0\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \m_payload_i[34]_i_1__0\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \m_payload_i[35]_i_1__0\ : label is "soft_lutpair66";
  attribute SOFT_HLUTNM of \m_payload_i[36]_i_1__0\ : label is "soft_lutpair66";
  attribute SOFT_HLUTNM of \m_payload_i[37]_i_1__0\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \m_payload_i[38]_i_1__0\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \m_payload_i[39]_i_1__0\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \m_payload_i[3]_i_1__0\ : label is "soft_lutpair82";
  attribute SOFT_HLUTNM of \m_payload_i[40]_i_1__0\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \m_payload_i[41]_i_1__0\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \m_payload_i[42]_i_1__0\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \m_payload_i[43]_i_1__0\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \m_payload_i[44]_i_1__0\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \m_payload_i[45]_i_1__0\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \m_payload_i[46]_i_1__0\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \m_payload_i[47]_i_1__0\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \m_payload_i[48]_i_1__0\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \m_payload_i[49]_i_1__0\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \m_payload_i[4]_i_1__0\ : label is "soft_lutpair82";
  attribute SOFT_HLUTNM of \m_payload_i[50]_i_1__0\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \m_payload_i[51]_i_1__0\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \m_payload_i[52]_i_1__0\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \m_payload_i[53]_i_1__0\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \m_payload_i[54]_i_1__0\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \m_payload_i[55]_i_1__0\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \m_payload_i[56]_i_1__0\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \m_payload_i[57]_i_1__0\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \m_payload_i[58]_i_1__0\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \m_payload_i[59]_i_1__0\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \m_payload_i[5]_i_1__0\ : label is "soft_lutpair81";
  attribute SOFT_HLUTNM of \m_payload_i[60]_i_1__0\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \m_payload_i[61]_i_1__0\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \m_payload_i[62]_i_1__0\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \m_payload_i[63]_i_1__0\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \m_payload_i[64]_i_1__0\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \m_payload_i[65]_i_1__0\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \m_payload_i[66]_i_1__0\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \m_payload_i[67]_i_1__0\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \m_payload_i[68]_i_1__0\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \m_payload_i[69]_i_1__0\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \m_payload_i[6]_i_1__0\ : label is "soft_lutpair81";
  attribute SOFT_HLUTNM of \m_payload_i[70]_i_1__0\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \m_payload_i[71]_i_1__0\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \m_payload_i[72]_i_2__0\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \m_payload_i[7]_i_1__3\ : label is "soft_lutpair80";
  attribute SOFT_HLUTNM of \m_payload_i[8]_i_1__0\ : label is "soft_lutpair80";
  attribute SOFT_HLUTNM of \m_payload_i[9]_i_1__0\ : label is "soft_lutpair79";
begin
  Q(72 downto 0) <= \^q\(72 downto 0);
  \gen_master_slots[1].r_issuing_cnt_reg[8]\ <= \^gen_master_slots[1].r_issuing_cnt_reg[8]\;
  \m_axi_rready[1]\ <= \^m_axi_rready[1]\;
  m_valid_i_reg_0 <= \^m_valid_i_reg_0\;
\gen_master_slots[1].r_issuing_cnt[8]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \^m_valid_i_reg_0\,
      I1 => \^q\(66),
      I2 => s_axi_rready(0),
      I3 => active_target_enc(0),
      O => \^gen_master_slots[1].r_issuing_cnt_reg[8]\
    );
\gen_no_arbiter.s_ready_i[0]_i_5__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0B0F0B000B0F0B0F"
    )
        port map (
      I0 => \^gen_master_slots[1].r_issuing_cnt_reg[8]\,
      I1 => p_25_in,
      I2 => \s_axi_araddr[31]\(1),
      I3 => \s_axi_araddr[31]\(0),
      I4 => \m_payload_i_reg[66]_0\,
      I5 => p_43_in,
      O => \gen_no_arbiter.s_ready_i_reg[0]\
    );
\m_payload_i[0]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(0),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[0]\,
      O => \m_payload_i[0]_i_1__0_n_0\
    );
\m_payload_i[10]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(10),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[10]\,
      O => \m_payload_i[10]_i_1__0_n_0\
    );
\m_payload_i[11]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(11),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[11]\,
      O => \m_payload_i[11]_i_1__0_n_0\
    );
\m_payload_i[12]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(12),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[12]\,
      O => \m_payload_i[12]_i_1__0_n_0\
    );
\m_payload_i[13]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(13),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[13]\,
      O => \m_payload_i[13]_i_1__0_n_0\
    );
\m_payload_i[14]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(14),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[14]\,
      O => \m_payload_i[14]_i_1__0_n_0\
    );
\m_payload_i[15]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(15),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[15]\,
      O => \m_payload_i[15]_i_1__0_n_0\
    );
\m_payload_i[16]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(16),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[16]\,
      O => \m_payload_i[16]_i_1__0_n_0\
    );
\m_payload_i[17]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(17),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[17]\,
      O => \m_payload_i[17]_i_1__0_n_0\
    );
\m_payload_i[18]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(18),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[18]\,
      O => \m_payload_i[18]_i_1__0_n_0\
    );
\m_payload_i[19]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(19),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[19]\,
      O => \m_payload_i[19]_i_1__0_n_0\
    );
\m_payload_i[1]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(1),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[1]\,
      O => \m_payload_i[1]_i_1__0_n_0\
    );
\m_payload_i[20]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(20),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[20]\,
      O => \m_payload_i[20]_i_1__0_n_0\
    );
\m_payload_i[21]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(21),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[21]\,
      O => \m_payload_i[21]_i_1__0_n_0\
    );
\m_payload_i[22]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(22),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[22]\,
      O => \m_payload_i[22]_i_1__0_n_0\
    );
\m_payload_i[23]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(23),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[23]\,
      O => \m_payload_i[23]_i_1__0_n_0\
    );
\m_payload_i[24]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(24),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[24]\,
      O => \m_payload_i[24]_i_1__0_n_0\
    );
\m_payload_i[25]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(25),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[25]\,
      O => \m_payload_i[25]_i_1__0_n_0\
    );
\m_payload_i[26]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(26),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[26]\,
      O => \m_payload_i[26]_i_1__0_n_0\
    );
\m_payload_i[27]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(27),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[27]\,
      O => \m_payload_i[27]_i_1__0_n_0\
    );
\m_payload_i[28]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(28),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[28]\,
      O => \m_payload_i[28]_i_1__0_n_0\
    );
\m_payload_i[29]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(29),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[29]\,
      O => \m_payload_i[29]_i_1__0_n_0\
    );
\m_payload_i[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(2),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[2]\,
      O => \m_payload_i[2]_i_1__0_n_0\
    );
\m_payload_i[30]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(30),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[30]\,
      O => \m_payload_i[30]_i_1__0_n_0\
    );
\m_payload_i[31]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(31),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[31]\,
      O => \m_payload_i[31]_i_1__0_n_0\
    );
\m_payload_i[32]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(32),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[32]\,
      O => \m_payload_i[32]_i_1__0_n_0\
    );
\m_payload_i[33]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(33),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[33]\,
      O => \m_payload_i[33]_i_1__0_n_0\
    );
\m_payload_i[34]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(34),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[34]\,
      O => \m_payload_i[34]_i_1__0_n_0\
    );
\m_payload_i[35]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(35),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[35]\,
      O => \m_payload_i[35]_i_1__0_n_0\
    );
\m_payload_i[36]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(36),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[36]\,
      O => \m_payload_i[36]_i_1__0_n_0\
    );
\m_payload_i[37]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(37),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[37]\,
      O => \m_payload_i[37]_i_1__0_n_0\
    );
\m_payload_i[38]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(38),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[38]\,
      O => \m_payload_i[38]_i_1__0_n_0\
    );
\m_payload_i[39]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(39),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[39]\,
      O => \m_payload_i[39]_i_1__0_n_0\
    );
\m_payload_i[3]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(3),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[3]\,
      O => \m_payload_i[3]_i_1__0_n_0\
    );
\m_payload_i[40]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(40),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[40]\,
      O => \m_payload_i[40]_i_1__0_n_0\
    );
\m_payload_i[41]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(41),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[41]\,
      O => \m_payload_i[41]_i_1__0_n_0\
    );
\m_payload_i[42]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(42),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[42]\,
      O => \m_payload_i[42]_i_1__0_n_0\
    );
\m_payload_i[43]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(43),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[43]\,
      O => \m_payload_i[43]_i_1__0_n_0\
    );
\m_payload_i[44]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(44),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[44]\,
      O => \m_payload_i[44]_i_1__0_n_0\
    );
\m_payload_i[45]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(45),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[45]\,
      O => \m_payload_i[45]_i_1__0_n_0\
    );
\m_payload_i[46]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(46),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[46]\,
      O => \m_payload_i[46]_i_1__0_n_0\
    );
\m_payload_i[47]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(47),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[47]\,
      O => \m_payload_i[47]_i_1__0_n_0\
    );
\m_payload_i[48]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(48),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[48]\,
      O => \m_payload_i[48]_i_1__0_n_0\
    );
\m_payload_i[49]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(49),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[49]\,
      O => \m_payload_i[49]_i_1__0_n_0\
    );
\m_payload_i[4]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(4),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[4]\,
      O => \m_payload_i[4]_i_1__0_n_0\
    );
\m_payload_i[50]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(50),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[50]\,
      O => \m_payload_i[50]_i_1__0_n_0\
    );
\m_payload_i[51]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(51),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[51]\,
      O => \m_payload_i[51]_i_1__0_n_0\
    );
\m_payload_i[52]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(52),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[52]\,
      O => \m_payload_i[52]_i_1__0_n_0\
    );
\m_payload_i[53]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(53),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[53]\,
      O => \m_payload_i[53]_i_1__0_n_0\
    );
\m_payload_i[54]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(54),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[54]\,
      O => \m_payload_i[54]_i_1__0_n_0\
    );
\m_payload_i[55]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(55),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[55]\,
      O => \m_payload_i[55]_i_1__0_n_0\
    );
\m_payload_i[56]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(56),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[56]\,
      O => \m_payload_i[56]_i_1__0_n_0\
    );
\m_payload_i[57]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(57),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[57]\,
      O => \m_payload_i[57]_i_1__0_n_0\
    );
\m_payload_i[58]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(58),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[58]\,
      O => \m_payload_i[58]_i_1__0_n_0\
    );
\m_payload_i[59]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(59),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[59]\,
      O => \m_payload_i[59]_i_1__0_n_0\
    );
\m_payload_i[5]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(5),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[5]\,
      O => \m_payload_i[5]_i_1__0_n_0\
    );
\m_payload_i[60]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(60),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[60]\,
      O => \m_payload_i[60]_i_1__0_n_0\
    );
\m_payload_i[61]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(61),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[61]\,
      O => \m_payload_i[61]_i_1__0_n_0\
    );
\m_payload_i[62]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(62),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[62]\,
      O => \m_payload_i[62]_i_1__0_n_0\
    );
\m_payload_i[63]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(63),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[63]\,
      O => \m_payload_i[63]_i_1__0_n_0\
    );
\m_payload_i[64]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rresp(0),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[64]\,
      O => \m_payload_i[64]_i_1__0_n_0\
    );
\m_payload_i[65]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rresp(1),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[65]\,
      O => \m_payload_i[65]_i_1__0_n_0\
    );
\m_payload_i[66]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rlast(0),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[66]\,
      O => \m_payload_i[66]_i_1__0_n_0\
    );
\m_payload_i[67]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(0),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[67]\,
      O => \m_payload_i[67]_i_1__0_n_0\
    );
\m_payload_i[68]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(1),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[68]\,
      O => \m_payload_i[68]_i_1__0_n_0\
    );
\m_payload_i[69]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(2),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[69]\,
      O => \m_payload_i[69]_i_1__0_n_0\
    );
\m_payload_i[6]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(6),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[6]\,
      O => \m_payload_i[6]_i_1__0_n_0\
    );
\m_payload_i[70]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(3),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[70]\,
      O => \m_payload_i[70]_i_1__0_n_0\
    );
\m_payload_i[71]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(4),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[71]\,
      O => \m_payload_i[71]_i_1__0_n_0\
    );
\m_payload_i[72]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D5"
    )
        port map (
      I0 => \^m_valid_i_reg_0\,
      I1 => active_target_enc(0),
      I2 => s_axi_rready(0),
      O => p_1_in
    );
\m_payload_i[72]_i_2__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(5),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[72]\,
      O => \m_payload_i[72]_i_2__0_n_0\
    );
\m_payload_i[7]_i_1__3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(7),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[7]\,
      O => \m_payload_i[7]_i_1__3_n_0\
    );
\m_payload_i[8]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(8),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[8]\,
      O => \m_payload_i[8]_i_1__0_n_0\
    );
\m_payload_i[9]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(9),
      I1 => \^m_axi_rready[1]\,
      I2 => \skid_buffer_reg_n_0_[9]\,
      O => \m_payload_i[9]_i_1__0_n_0\
    );
\m_payload_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[0]_i_1__0_n_0\,
      Q => \^q\(0),
      R => '0'
    );
\m_payload_i_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[10]_i_1__0_n_0\,
      Q => \^q\(10),
      R => '0'
    );
\m_payload_i_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[11]_i_1__0_n_0\,
      Q => \^q\(11),
      R => '0'
    );
\m_payload_i_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[12]_i_1__0_n_0\,
      Q => \^q\(12),
      R => '0'
    );
\m_payload_i_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[13]_i_1__0_n_0\,
      Q => \^q\(13),
      R => '0'
    );
\m_payload_i_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[14]_i_1__0_n_0\,
      Q => \^q\(14),
      R => '0'
    );
\m_payload_i_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[15]_i_1__0_n_0\,
      Q => \^q\(15),
      R => '0'
    );
\m_payload_i_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[16]_i_1__0_n_0\,
      Q => \^q\(16),
      R => '0'
    );
\m_payload_i_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[17]_i_1__0_n_0\,
      Q => \^q\(17),
      R => '0'
    );
\m_payload_i_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[18]_i_1__0_n_0\,
      Q => \^q\(18),
      R => '0'
    );
\m_payload_i_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[19]_i_1__0_n_0\,
      Q => \^q\(19),
      R => '0'
    );
\m_payload_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[1]_i_1__0_n_0\,
      Q => \^q\(1),
      R => '0'
    );
\m_payload_i_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[20]_i_1__0_n_0\,
      Q => \^q\(20),
      R => '0'
    );
\m_payload_i_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[21]_i_1__0_n_0\,
      Q => \^q\(21),
      R => '0'
    );
\m_payload_i_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[22]_i_1__0_n_0\,
      Q => \^q\(22),
      R => '0'
    );
\m_payload_i_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[23]_i_1__0_n_0\,
      Q => \^q\(23),
      R => '0'
    );
\m_payload_i_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[24]_i_1__0_n_0\,
      Q => \^q\(24),
      R => '0'
    );
\m_payload_i_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[25]_i_1__0_n_0\,
      Q => \^q\(25),
      R => '0'
    );
\m_payload_i_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[26]_i_1__0_n_0\,
      Q => \^q\(26),
      R => '0'
    );
\m_payload_i_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[27]_i_1__0_n_0\,
      Q => \^q\(27),
      R => '0'
    );
\m_payload_i_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[28]_i_1__0_n_0\,
      Q => \^q\(28),
      R => '0'
    );
\m_payload_i_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[29]_i_1__0_n_0\,
      Q => \^q\(29),
      R => '0'
    );
\m_payload_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[2]_i_1__0_n_0\,
      Q => \^q\(2),
      R => '0'
    );
\m_payload_i_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[30]_i_1__0_n_0\,
      Q => \^q\(30),
      R => '0'
    );
\m_payload_i_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[31]_i_1__0_n_0\,
      Q => \^q\(31),
      R => '0'
    );
\m_payload_i_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[32]_i_1__0_n_0\,
      Q => \^q\(32),
      R => '0'
    );
\m_payload_i_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[33]_i_1__0_n_0\,
      Q => \^q\(33),
      R => '0'
    );
\m_payload_i_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[34]_i_1__0_n_0\,
      Q => \^q\(34),
      R => '0'
    );
\m_payload_i_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[35]_i_1__0_n_0\,
      Q => \^q\(35),
      R => '0'
    );
\m_payload_i_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[36]_i_1__0_n_0\,
      Q => \^q\(36),
      R => '0'
    );
\m_payload_i_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[37]_i_1__0_n_0\,
      Q => \^q\(37),
      R => '0'
    );
\m_payload_i_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[38]_i_1__0_n_0\,
      Q => \^q\(38),
      R => '0'
    );
\m_payload_i_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[39]_i_1__0_n_0\,
      Q => \^q\(39),
      R => '0'
    );
\m_payload_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[3]_i_1__0_n_0\,
      Q => \^q\(3),
      R => '0'
    );
\m_payload_i_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[40]_i_1__0_n_0\,
      Q => \^q\(40),
      R => '0'
    );
\m_payload_i_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[41]_i_1__0_n_0\,
      Q => \^q\(41),
      R => '0'
    );
\m_payload_i_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[42]_i_1__0_n_0\,
      Q => \^q\(42),
      R => '0'
    );
\m_payload_i_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[43]_i_1__0_n_0\,
      Q => \^q\(43),
      R => '0'
    );
\m_payload_i_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[44]_i_1__0_n_0\,
      Q => \^q\(44),
      R => '0'
    );
\m_payload_i_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[45]_i_1__0_n_0\,
      Q => \^q\(45),
      R => '0'
    );
\m_payload_i_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[46]_i_1__0_n_0\,
      Q => \^q\(46),
      R => '0'
    );
\m_payload_i_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[47]_i_1__0_n_0\,
      Q => \^q\(47),
      R => '0'
    );
\m_payload_i_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[48]_i_1__0_n_0\,
      Q => \^q\(48),
      R => '0'
    );
\m_payload_i_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[49]_i_1__0_n_0\,
      Q => \^q\(49),
      R => '0'
    );
\m_payload_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[4]_i_1__0_n_0\,
      Q => \^q\(4),
      R => '0'
    );
\m_payload_i_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[50]_i_1__0_n_0\,
      Q => \^q\(50),
      R => '0'
    );
\m_payload_i_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[51]_i_1__0_n_0\,
      Q => \^q\(51),
      R => '0'
    );
\m_payload_i_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[52]_i_1__0_n_0\,
      Q => \^q\(52),
      R => '0'
    );
\m_payload_i_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[53]_i_1__0_n_0\,
      Q => \^q\(53),
      R => '0'
    );
\m_payload_i_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[54]_i_1__0_n_0\,
      Q => \^q\(54),
      R => '0'
    );
\m_payload_i_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[55]_i_1__0_n_0\,
      Q => \^q\(55),
      R => '0'
    );
\m_payload_i_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[56]_i_1__0_n_0\,
      Q => \^q\(56),
      R => '0'
    );
\m_payload_i_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[57]_i_1__0_n_0\,
      Q => \^q\(57),
      R => '0'
    );
\m_payload_i_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[58]_i_1__0_n_0\,
      Q => \^q\(58),
      R => '0'
    );
\m_payload_i_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[59]_i_1__0_n_0\,
      Q => \^q\(59),
      R => '0'
    );
\m_payload_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[5]_i_1__0_n_0\,
      Q => \^q\(5),
      R => '0'
    );
\m_payload_i_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[60]_i_1__0_n_0\,
      Q => \^q\(60),
      R => '0'
    );
\m_payload_i_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[61]_i_1__0_n_0\,
      Q => \^q\(61),
      R => '0'
    );
\m_payload_i_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[62]_i_1__0_n_0\,
      Q => \^q\(62),
      R => '0'
    );
\m_payload_i_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[63]_i_1__0_n_0\,
      Q => \^q\(63),
      R => '0'
    );
\m_payload_i_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[64]_i_1__0_n_0\,
      Q => \^q\(64),
      R => '0'
    );
\m_payload_i_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[65]_i_1__0_n_0\,
      Q => \^q\(65),
      R => '0'
    );
\m_payload_i_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[66]_i_1__0_n_0\,
      Q => \^q\(66),
      R => '0'
    );
\m_payload_i_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[67]_i_1__0_n_0\,
      Q => \^q\(67),
      R => '0'
    );
\m_payload_i_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[68]_i_1__0_n_0\,
      Q => \^q\(68),
      R => '0'
    );
\m_payload_i_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[69]_i_1__0_n_0\,
      Q => \^q\(69),
      R => '0'
    );
\m_payload_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[6]_i_1__0_n_0\,
      Q => \^q\(6),
      R => '0'
    );
\m_payload_i_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[70]_i_1__0_n_0\,
      Q => \^q\(70),
      R => '0'
    );
\m_payload_i_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[71]_i_1__0_n_0\,
      Q => \^q\(71),
      R => '0'
    );
\m_payload_i_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[72]_i_2__0_n_0\,
      Q => \^q\(72),
      R => '0'
    );
\m_payload_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[7]_i_1__3_n_0\,
      Q => \^q\(7),
      R => '0'
    );
\m_payload_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[8]_i_1__0_n_0\,
      Q => \^q\(8),
      R => '0'
    );
\m_payload_i_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => \m_payload_i[9]_i_1__0_n_0\,
      Q => \^q\(9),
      R => '0'
    );
\m_valid_i_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDFDFDFD"
    )
        port map (
      I0 => \^m_axi_rready[1]\,
      I1 => m_axi_rvalid(0),
      I2 => \^m_valid_i_reg_0\,
      I3 => active_target_enc(0),
      I4 => s_axi_rready(0),
      O => m_valid_i0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => m_valid_i0,
      Q => \^m_valid_i_reg_0\,
      R => \aresetn_d_reg[1]\
    );
\s_ready_i_i_1__4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF2F2F2F"
    )
        port map (
      I0 => \^m_axi_rready[1]\,
      I1 => m_axi_rvalid(0),
      I2 => \^m_valid_i_reg_0\,
      I3 => active_target_enc(0),
      I4 => s_axi_rready(0),
      O => \s_ready_i_i_1__4_n_0\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \s_ready_i_i_1__4_n_0\,
      Q => \^m_axi_rready[1]\,
      R => \aresetn_d_reg[0]\
    );
\skid_buffer_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(0),
      Q => \skid_buffer_reg_n_0_[0]\,
      R => '0'
    );
\skid_buffer_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(10),
      Q => \skid_buffer_reg_n_0_[10]\,
      R => '0'
    );
\skid_buffer_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(11),
      Q => \skid_buffer_reg_n_0_[11]\,
      R => '0'
    );
\skid_buffer_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(12),
      Q => \skid_buffer_reg_n_0_[12]\,
      R => '0'
    );
\skid_buffer_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(13),
      Q => \skid_buffer_reg_n_0_[13]\,
      R => '0'
    );
\skid_buffer_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(14),
      Q => \skid_buffer_reg_n_0_[14]\,
      R => '0'
    );
\skid_buffer_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(15),
      Q => \skid_buffer_reg_n_0_[15]\,
      R => '0'
    );
\skid_buffer_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(16),
      Q => \skid_buffer_reg_n_0_[16]\,
      R => '0'
    );
\skid_buffer_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(17),
      Q => \skid_buffer_reg_n_0_[17]\,
      R => '0'
    );
\skid_buffer_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(18),
      Q => \skid_buffer_reg_n_0_[18]\,
      R => '0'
    );
\skid_buffer_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(19),
      Q => \skid_buffer_reg_n_0_[19]\,
      R => '0'
    );
\skid_buffer_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(1),
      Q => \skid_buffer_reg_n_0_[1]\,
      R => '0'
    );
\skid_buffer_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(20),
      Q => \skid_buffer_reg_n_0_[20]\,
      R => '0'
    );
\skid_buffer_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(21),
      Q => \skid_buffer_reg_n_0_[21]\,
      R => '0'
    );
\skid_buffer_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(22),
      Q => \skid_buffer_reg_n_0_[22]\,
      R => '0'
    );
\skid_buffer_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(23),
      Q => \skid_buffer_reg_n_0_[23]\,
      R => '0'
    );
\skid_buffer_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(24),
      Q => \skid_buffer_reg_n_0_[24]\,
      R => '0'
    );
\skid_buffer_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(25),
      Q => \skid_buffer_reg_n_0_[25]\,
      R => '0'
    );
\skid_buffer_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(26),
      Q => \skid_buffer_reg_n_0_[26]\,
      R => '0'
    );
\skid_buffer_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(27),
      Q => \skid_buffer_reg_n_0_[27]\,
      R => '0'
    );
\skid_buffer_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(28),
      Q => \skid_buffer_reg_n_0_[28]\,
      R => '0'
    );
\skid_buffer_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(29),
      Q => \skid_buffer_reg_n_0_[29]\,
      R => '0'
    );
\skid_buffer_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(2),
      Q => \skid_buffer_reg_n_0_[2]\,
      R => '0'
    );
\skid_buffer_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(30),
      Q => \skid_buffer_reg_n_0_[30]\,
      R => '0'
    );
\skid_buffer_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(31),
      Q => \skid_buffer_reg_n_0_[31]\,
      R => '0'
    );
\skid_buffer_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(32),
      Q => \skid_buffer_reg_n_0_[32]\,
      R => '0'
    );
\skid_buffer_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(33),
      Q => \skid_buffer_reg_n_0_[33]\,
      R => '0'
    );
\skid_buffer_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(34),
      Q => \skid_buffer_reg_n_0_[34]\,
      R => '0'
    );
\skid_buffer_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(35),
      Q => \skid_buffer_reg_n_0_[35]\,
      R => '0'
    );
\skid_buffer_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(36),
      Q => \skid_buffer_reg_n_0_[36]\,
      R => '0'
    );
\skid_buffer_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(37),
      Q => \skid_buffer_reg_n_0_[37]\,
      R => '0'
    );
\skid_buffer_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(38),
      Q => \skid_buffer_reg_n_0_[38]\,
      R => '0'
    );
\skid_buffer_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(39),
      Q => \skid_buffer_reg_n_0_[39]\,
      R => '0'
    );
\skid_buffer_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(3),
      Q => \skid_buffer_reg_n_0_[3]\,
      R => '0'
    );
\skid_buffer_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(40),
      Q => \skid_buffer_reg_n_0_[40]\,
      R => '0'
    );
\skid_buffer_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(41),
      Q => \skid_buffer_reg_n_0_[41]\,
      R => '0'
    );
\skid_buffer_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(42),
      Q => \skid_buffer_reg_n_0_[42]\,
      R => '0'
    );
\skid_buffer_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(43),
      Q => \skid_buffer_reg_n_0_[43]\,
      R => '0'
    );
\skid_buffer_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(44),
      Q => \skid_buffer_reg_n_0_[44]\,
      R => '0'
    );
\skid_buffer_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(45),
      Q => \skid_buffer_reg_n_0_[45]\,
      R => '0'
    );
\skid_buffer_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(46),
      Q => \skid_buffer_reg_n_0_[46]\,
      R => '0'
    );
\skid_buffer_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(47),
      Q => \skid_buffer_reg_n_0_[47]\,
      R => '0'
    );
\skid_buffer_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(48),
      Q => \skid_buffer_reg_n_0_[48]\,
      R => '0'
    );
\skid_buffer_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(49),
      Q => \skid_buffer_reg_n_0_[49]\,
      R => '0'
    );
\skid_buffer_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(4),
      Q => \skid_buffer_reg_n_0_[4]\,
      R => '0'
    );
\skid_buffer_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(50),
      Q => \skid_buffer_reg_n_0_[50]\,
      R => '0'
    );
\skid_buffer_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(51),
      Q => \skid_buffer_reg_n_0_[51]\,
      R => '0'
    );
\skid_buffer_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(52),
      Q => \skid_buffer_reg_n_0_[52]\,
      R => '0'
    );
\skid_buffer_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(53),
      Q => \skid_buffer_reg_n_0_[53]\,
      R => '0'
    );
\skid_buffer_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(54),
      Q => \skid_buffer_reg_n_0_[54]\,
      R => '0'
    );
\skid_buffer_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(55),
      Q => \skid_buffer_reg_n_0_[55]\,
      R => '0'
    );
\skid_buffer_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(56),
      Q => \skid_buffer_reg_n_0_[56]\,
      R => '0'
    );
\skid_buffer_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(57),
      Q => \skid_buffer_reg_n_0_[57]\,
      R => '0'
    );
\skid_buffer_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(58),
      Q => \skid_buffer_reg_n_0_[58]\,
      R => '0'
    );
\skid_buffer_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(59),
      Q => \skid_buffer_reg_n_0_[59]\,
      R => '0'
    );
\skid_buffer_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(5),
      Q => \skid_buffer_reg_n_0_[5]\,
      R => '0'
    );
\skid_buffer_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(60),
      Q => \skid_buffer_reg_n_0_[60]\,
      R => '0'
    );
\skid_buffer_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(61),
      Q => \skid_buffer_reg_n_0_[61]\,
      R => '0'
    );
\skid_buffer_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(62),
      Q => \skid_buffer_reg_n_0_[62]\,
      R => '0'
    );
\skid_buffer_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(63),
      Q => \skid_buffer_reg_n_0_[63]\,
      R => '0'
    );
\skid_buffer_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rresp(0),
      Q => \skid_buffer_reg_n_0_[64]\,
      R => '0'
    );
\skid_buffer_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rresp(1),
      Q => \skid_buffer_reg_n_0_[65]\,
      R => '0'
    );
\skid_buffer_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rlast(0),
      Q => \skid_buffer_reg_n_0_[66]\,
      R => '0'
    );
\skid_buffer_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(0),
      Q => \skid_buffer_reg_n_0_[67]\,
      R => '0'
    );
\skid_buffer_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(1),
      Q => \skid_buffer_reg_n_0_[68]\,
      R => '0'
    );
\skid_buffer_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(2),
      Q => \skid_buffer_reg_n_0_[69]\,
      R => '0'
    );
\skid_buffer_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(6),
      Q => \skid_buffer_reg_n_0_[6]\,
      R => '0'
    );
\skid_buffer_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(3),
      Q => \skid_buffer_reg_n_0_[70]\,
      R => '0'
    );
\skid_buffer_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(4),
      Q => \skid_buffer_reg_n_0_[71]\,
      R => '0'
    );
\skid_buffer_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rid(5),
      Q => \skid_buffer_reg_n_0_[72]\,
      R => '0'
    );
\skid_buffer_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(7),
      Q => \skid_buffer_reg_n_0_[7]\,
      R => '0'
    );
\skid_buffer_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(8),
      Q => \skid_buffer_reg_n_0_[8]\,
      R => '0'
    );
\skid_buffer_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[1]\,
      D => m_axi_rdata(9),
      Q => \skid_buffer_reg_n_0_[9]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_8\ is
  port (
    m_valid_i_reg_0 : out STD_LOGIC;
    \m_axi_rready[0]\ : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 72 downto 0 );
    \gen_master_slots[0].r_issuing_cnt_reg[0]\ : out STD_LOGIC;
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_hot : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_master_slots[0].r_issuing_cnt_reg[0]_0\ : in STD_LOGIC;
    p_25_in : in STD_LOGIC;
    m_valid_i_reg_1 : in STD_LOGIC;
    \s_axi_araddr[31]\ : in STD_LOGIC;
    \m_payload_i_reg[66]_0\ : in STD_LOGIC;
    \s_axi_araddr[31]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_8\ : entity is "axi_register_slice_v2_1_9_axic_register_slice";
end \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_8\;

architecture STRUCTURE of \rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_8\ is
  signal \^q\ : STD_LOGIC_VECTOR ( 72 downto 0 );
  signal \gen_no_arbiter.m_target_hot_i[2]_i_5_n_0\ : STD_LOGIC;
  signal \^m_axi_rready[0]\ : STD_LOGIC;
  signal m_valid_i0 : STD_LOGIC;
  signal \^m_valid_i_reg_0\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal \s_ready_i_i_1__3_n_0\ : STD_LOGIC;
  signal skid_buffer : STD_LOGIC_VECTOR ( 72 downto 0 );
  signal \skid_buffer_reg_n_0_[0]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[10]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[11]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[12]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[13]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[14]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[15]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[16]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[17]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[18]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[19]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[1]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[20]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[21]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[22]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[23]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[24]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[25]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[26]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[27]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[28]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[29]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[2]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[30]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[31]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[32]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[33]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[34]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[35]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[36]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[37]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[38]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[39]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[3]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[40]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[41]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[42]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[43]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[44]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[45]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[46]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[47]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[48]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[49]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[4]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[50]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[51]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[52]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[53]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[54]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[55]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[56]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[57]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[58]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[59]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[5]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[60]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[61]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[62]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[63]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[64]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[65]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[66]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[67]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[68]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[69]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[6]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[70]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[71]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[72]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[7]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[8]\ : STD_LOGIC;
  signal \skid_buffer_reg_n_0_[9]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_payload_i[10]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \m_payload_i[11]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \m_payload_i[12]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \m_payload_i[13]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \m_payload_i[14]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \m_payload_i[15]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \m_payload_i[16]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \m_payload_i[17]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \m_payload_i[18]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \m_payload_i[19]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \m_payload_i[1]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \m_payload_i[20]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \m_payload_i[21]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \m_payload_i[22]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \m_payload_i[23]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \m_payload_i[24]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \m_payload_i[25]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \m_payload_i[26]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \m_payload_i[27]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \m_payload_i[28]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \m_payload_i[29]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \m_payload_i[2]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \m_payload_i[30]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \m_payload_i[31]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \m_payload_i[32]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \m_payload_i[33]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \m_payload_i[34]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \m_payload_i[35]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \m_payload_i[36]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \m_payload_i[37]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \m_payload_i[38]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \m_payload_i[39]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \m_payload_i[3]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \m_payload_i[40]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \m_payload_i[41]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \m_payload_i[42]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \m_payload_i[43]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \m_payload_i[44]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \m_payload_i[45]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \m_payload_i[46]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \m_payload_i[47]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \m_payload_i[48]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \m_payload_i[49]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \m_payload_i[4]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \m_payload_i[50]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \m_payload_i[51]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \m_payload_i[52]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \m_payload_i[53]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \m_payload_i[54]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \m_payload_i[55]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \m_payload_i[56]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \m_payload_i[57]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \m_payload_i[58]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \m_payload_i[59]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \m_payload_i[5]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \m_payload_i[60]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \m_payload_i[61]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \m_payload_i[62]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \m_payload_i[63]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \m_payload_i[64]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \m_payload_i[65]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \m_payload_i[66]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \m_payload_i[67]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \m_payload_i[68]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \m_payload_i[69]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \m_payload_i[6]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \m_payload_i[70]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \m_payload_i[71]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \m_payload_i[72]_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \m_payload_i[7]_i_1__2\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \m_payload_i[8]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \m_payload_i[9]_i_1\ : label is "soft_lutpair43";
begin
  Q(72 downto 0) <= \^q\(72 downto 0);
  \m_axi_rready[0]\ <= \^m_axi_rready[0]\;
  m_valid_i_reg_0 <= \^m_valid_i_reg_0\;
\gen_master_slots[0].r_issuing_cnt[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \^q\(66),
      I1 => \^m_valid_i_reg_0\,
      I2 => active_target_hot(0),
      I3 => s_axi_rready(0),
      O => \gen_master_slots[0].r_issuing_cnt_reg[0]\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFEFEEEE"
    )
        port map (
      I0 => \gen_master_slots[0].r_issuing_cnt_reg[0]_0\,
      I1 => \gen_no_arbiter.m_target_hot_i[2]_i_5_n_0\,
      I2 => p_25_in,
      I3 => m_valid_i_reg_1,
      I4 => \s_axi_araddr[31]\,
      I5 => \m_payload_i_reg[66]_0\,
      O => \gen_no_arbiter.m_target_hot_i_reg[2]\
    );
\gen_no_arbiter.m_target_hot_i[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1000000000000000"
    )
        port map (
      I0 => \s_axi_araddr[31]_0\(1),
      I1 => \s_axi_araddr[31]_0\(0),
      I2 => s_axi_rready(0),
      I3 => active_target_hot(0),
      I4 => \^m_valid_i_reg_0\,
      I5 => \^q\(66),
      O => \gen_no_arbiter.m_target_hot_i[2]_i_5_n_0\
    );
\m_payload_i[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(0),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[0]\,
      O => skid_buffer(0)
    );
\m_payload_i[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(10),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[10]\,
      O => skid_buffer(10)
    );
\m_payload_i[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(11),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[11]\,
      O => skid_buffer(11)
    );
\m_payload_i[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(12),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[12]\,
      O => skid_buffer(12)
    );
\m_payload_i[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(13),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[13]\,
      O => skid_buffer(13)
    );
\m_payload_i[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(14),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[14]\,
      O => skid_buffer(14)
    );
\m_payload_i[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(15),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[15]\,
      O => skid_buffer(15)
    );
\m_payload_i[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(16),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[16]\,
      O => skid_buffer(16)
    );
\m_payload_i[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(17),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[17]\,
      O => skid_buffer(17)
    );
\m_payload_i[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(18),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[18]\,
      O => skid_buffer(18)
    );
\m_payload_i[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(19),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[19]\,
      O => skid_buffer(19)
    );
\m_payload_i[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(1),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[1]\,
      O => skid_buffer(1)
    );
\m_payload_i[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(20),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[20]\,
      O => skid_buffer(20)
    );
\m_payload_i[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(21),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[21]\,
      O => skid_buffer(21)
    );
\m_payload_i[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(22),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[22]\,
      O => skid_buffer(22)
    );
\m_payload_i[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(23),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[23]\,
      O => skid_buffer(23)
    );
\m_payload_i[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(24),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[24]\,
      O => skid_buffer(24)
    );
\m_payload_i[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(25),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[25]\,
      O => skid_buffer(25)
    );
\m_payload_i[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(26),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[26]\,
      O => skid_buffer(26)
    );
\m_payload_i[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(27),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[27]\,
      O => skid_buffer(27)
    );
\m_payload_i[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(28),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[28]\,
      O => skid_buffer(28)
    );
\m_payload_i[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(29),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[29]\,
      O => skid_buffer(29)
    );
\m_payload_i[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(2),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[2]\,
      O => skid_buffer(2)
    );
\m_payload_i[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(30),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[30]\,
      O => skid_buffer(30)
    );
\m_payload_i[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(31),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[31]\,
      O => skid_buffer(31)
    );
\m_payload_i[32]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(32),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[32]\,
      O => skid_buffer(32)
    );
\m_payload_i[33]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(33),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[33]\,
      O => skid_buffer(33)
    );
\m_payload_i[34]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(34),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[34]\,
      O => skid_buffer(34)
    );
\m_payload_i[35]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(35),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[35]\,
      O => skid_buffer(35)
    );
\m_payload_i[36]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(36),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[36]\,
      O => skid_buffer(36)
    );
\m_payload_i[37]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(37),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[37]\,
      O => skid_buffer(37)
    );
\m_payload_i[38]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(38),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[38]\,
      O => skid_buffer(38)
    );
\m_payload_i[39]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(39),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[39]\,
      O => skid_buffer(39)
    );
\m_payload_i[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(3),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[3]\,
      O => skid_buffer(3)
    );
\m_payload_i[40]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(40),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[40]\,
      O => skid_buffer(40)
    );
\m_payload_i[41]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(41),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[41]\,
      O => skid_buffer(41)
    );
\m_payload_i[42]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(42),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[42]\,
      O => skid_buffer(42)
    );
\m_payload_i[43]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(43),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[43]\,
      O => skid_buffer(43)
    );
\m_payload_i[44]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(44),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[44]\,
      O => skid_buffer(44)
    );
\m_payload_i[45]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(45),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[45]\,
      O => skid_buffer(45)
    );
\m_payload_i[46]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(46),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[46]\,
      O => skid_buffer(46)
    );
\m_payload_i[47]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(47),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[47]\,
      O => skid_buffer(47)
    );
\m_payload_i[48]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(48),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[48]\,
      O => skid_buffer(48)
    );
\m_payload_i[49]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(49),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[49]\,
      O => skid_buffer(49)
    );
\m_payload_i[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(4),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[4]\,
      O => skid_buffer(4)
    );
\m_payload_i[50]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(50),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[50]\,
      O => skid_buffer(50)
    );
\m_payload_i[51]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(51),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[51]\,
      O => skid_buffer(51)
    );
\m_payload_i[52]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(52),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[52]\,
      O => skid_buffer(52)
    );
\m_payload_i[53]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(53),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[53]\,
      O => skid_buffer(53)
    );
\m_payload_i[54]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(54),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[54]\,
      O => skid_buffer(54)
    );
\m_payload_i[55]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(55),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[55]\,
      O => skid_buffer(55)
    );
\m_payload_i[56]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(56),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[56]\,
      O => skid_buffer(56)
    );
\m_payload_i[57]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(57),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[57]\,
      O => skid_buffer(57)
    );
\m_payload_i[58]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(58),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[58]\,
      O => skid_buffer(58)
    );
\m_payload_i[59]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(59),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[59]\,
      O => skid_buffer(59)
    );
\m_payload_i[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(5),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[5]\,
      O => skid_buffer(5)
    );
\m_payload_i[60]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(60),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[60]\,
      O => skid_buffer(60)
    );
\m_payload_i[61]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(61),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[61]\,
      O => skid_buffer(61)
    );
\m_payload_i[62]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(62),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[62]\,
      O => skid_buffer(62)
    );
\m_payload_i[63]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(63),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[63]\,
      O => skid_buffer(63)
    );
\m_payload_i[64]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rresp(0),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[64]\,
      O => skid_buffer(64)
    );
\m_payload_i[65]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rresp(1),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[65]\,
      O => skid_buffer(65)
    );
\m_payload_i[66]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rlast(0),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[66]\,
      O => skid_buffer(66)
    );
\m_payload_i[67]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(0),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[67]\,
      O => skid_buffer(67)
    );
\m_payload_i[68]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(1),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[68]\,
      O => skid_buffer(68)
    );
\m_payload_i[69]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(2),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[69]\,
      O => skid_buffer(69)
    );
\m_payload_i[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(6),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[6]\,
      O => skid_buffer(6)
    );
\m_payload_i[70]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(3),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[70]\,
      O => skid_buffer(70)
    );
\m_payload_i[71]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(4),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[71]\,
      O => skid_buffer(71)
    );
\m_payload_i[72]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D5"
    )
        port map (
      I0 => \^m_valid_i_reg_0\,
      I1 => s_axi_rready(0),
      I2 => active_target_hot(0),
      O => p_1_in
    );
\m_payload_i[72]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rid(5),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[72]\,
      O => skid_buffer(72)
    );
\m_payload_i[7]_i_1__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(7),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[7]\,
      O => skid_buffer(7)
    );
\m_payload_i[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(8),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[8]\,
      O => skid_buffer(8)
    );
\m_payload_i[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => m_axi_rdata(9),
      I1 => \^m_axi_rready[0]\,
      I2 => \skid_buffer_reg_n_0_[9]\,
      O => skid_buffer(9)
    );
\m_payload_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(0),
      Q => \^q\(0),
      R => '0'
    );
\m_payload_i_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(10),
      Q => \^q\(10),
      R => '0'
    );
\m_payload_i_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(11),
      Q => \^q\(11),
      R => '0'
    );
\m_payload_i_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(12),
      Q => \^q\(12),
      R => '0'
    );
\m_payload_i_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(13),
      Q => \^q\(13),
      R => '0'
    );
\m_payload_i_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(14),
      Q => \^q\(14),
      R => '0'
    );
\m_payload_i_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(15),
      Q => \^q\(15),
      R => '0'
    );
\m_payload_i_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(16),
      Q => \^q\(16),
      R => '0'
    );
\m_payload_i_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(17),
      Q => \^q\(17),
      R => '0'
    );
\m_payload_i_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(18),
      Q => \^q\(18),
      R => '0'
    );
\m_payload_i_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(19),
      Q => \^q\(19),
      R => '0'
    );
\m_payload_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(1),
      Q => \^q\(1),
      R => '0'
    );
\m_payload_i_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(20),
      Q => \^q\(20),
      R => '0'
    );
\m_payload_i_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(21),
      Q => \^q\(21),
      R => '0'
    );
\m_payload_i_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(22),
      Q => \^q\(22),
      R => '0'
    );
\m_payload_i_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(23),
      Q => \^q\(23),
      R => '0'
    );
\m_payload_i_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(24),
      Q => \^q\(24),
      R => '0'
    );
\m_payload_i_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(25),
      Q => \^q\(25),
      R => '0'
    );
\m_payload_i_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(26),
      Q => \^q\(26),
      R => '0'
    );
\m_payload_i_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(27),
      Q => \^q\(27),
      R => '0'
    );
\m_payload_i_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(28),
      Q => \^q\(28),
      R => '0'
    );
\m_payload_i_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(29),
      Q => \^q\(29),
      R => '0'
    );
\m_payload_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(2),
      Q => \^q\(2),
      R => '0'
    );
\m_payload_i_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(30),
      Q => \^q\(30),
      R => '0'
    );
\m_payload_i_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(31),
      Q => \^q\(31),
      R => '0'
    );
\m_payload_i_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(32),
      Q => \^q\(32),
      R => '0'
    );
\m_payload_i_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(33),
      Q => \^q\(33),
      R => '0'
    );
\m_payload_i_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(34),
      Q => \^q\(34),
      R => '0'
    );
\m_payload_i_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(35),
      Q => \^q\(35),
      R => '0'
    );
\m_payload_i_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(36),
      Q => \^q\(36),
      R => '0'
    );
\m_payload_i_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(37),
      Q => \^q\(37),
      R => '0'
    );
\m_payload_i_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(38),
      Q => \^q\(38),
      R => '0'
    );
\m_payload_i_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(39),
      Q => \^q\(39),
      R => '0'
    );
\m_payload_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(3),
      Q => \^q\(3),
      R => '0'
    );
\m_payload_i_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(40),
      Q => \^q\(40),
      R => '0'
    );
\m_payload_i_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(41),
      Q => \^q\(41),
      R => '0'
    );
\m_payload_i_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(42),
      Q => \^q\(42),
      R => '0'
    );
\m_payload_i_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(43),
      Q => \^q\(43),
      R => '0'
    );
\m_payload_i_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(44),
      Q => \^q\(44),
      R => '0'
    );
\m_payload_i_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(45),
      Q => \^q\(45),
      R => '0'
    );
\m_payload_i_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(46),
      Q => \^q\(46),
      R => '0'
    );
\m_payload_i_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(47),
      Q => \^q\(47),
      R => '0'
    );
\m_payload_i_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(48),
      Q => \^q\(48),
      R => '0'
    );
\m_payload_i_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(49),
      Q => \^q\(49),
      R => '0'
    );
\m_payload_i_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(4),
      Q => \^q\(4),
      R => '0'
    );
\m_payload_i_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(50),
      Q => \^q\(50),
      R => '0'
    );
\m_payload_i_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(51),
      Q => \^q\(51),
      R => '0'
    );
\m_payload_i_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(52),
      Q => \^q\(52),
      R => '0'
    );
\m_payload_i_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(53),
      Q => \^q\(53),
      R => '0'
    );
\m_payload_i_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(54),
      Q => \^q\(54),
      R => '0'
    );
\m_payload_i_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(55),
      Q => \^q\(55),
      R => '0'
    );
\m_payload_i_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(56),
      Q => \^q\(56),
      R => '0'
    );
\m_payload_i_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(57),
      Q => \^q\(57),
      R => '0'
    );
\m_payload_i_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(58),
      Q => \^q\(58),
      R => '0'
    );
\m_payload_i_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(59),
      Q => \^q\(59),
      R => '0'
    );
\m_payload_i_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(5),
      Q => \^q\(5),
      R => '0'
    );
\m_payload_i_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(60),
      Q => \^q\(60),
      R => '0'
    );
\m_payload_i_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(61),
      Q => \^q\(61),
      R => '0'
    );
\m_payload_i_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(62),
      Q => \^q\(62),
      R => '0'
    );
\m_payload_i_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(63),
      Q => \^q\(63),
      R => '0'
    );
\m_payload_i_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(64),
      Q => \^q\(64),
      R => '0'
    );
\m_payload_i_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(65),
      Q => \^q\(65),
      R => '0'
    );
\m_payload_i_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(66),
      Q => \^q\(66),
      R => '0'
    );
\m_payload_i_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(67),
      Q => \^q\(67),
      R => '0'
    );
\m_payload_i_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(68),
      Q => \^q\(68),
      R => '0'
    );
\m_payload_i_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(69),
      Q => \^q\(69),
      R => '0'
    );
\m_payload_i_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(6),
      Q => \^q\(6),
      R => '0'
    );
\m_payload_i_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(70),
      Q => \^q\(70),
      R => '0'
    );
\m_payload_i_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(71),
      Q => \^q\(71),
      R => '0'
    );
\m_payload_i_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(72),
      Q => \^q\(72),
      R => '0'
    );
\m_payload_i_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(7),
      Q => \^q\(7),
      R => '0'
    );
\m_payload_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(8),
      Q => \^q\(8),
      R => '0'
    );
\m_payload_i_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => p_1_in,
      D => skid_buffer(9),
      Q => \^q\(9),
      R => '0'
    );
\m_valid_i_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DDFDFDFD"
    )
        port map (
      I0 => \^m_axi_rready[0]\,
      I1 => m_axi_rvalid(0),
      I2 => \^m_valid_i_reg_0\,
      I3 => s_axi_rready(0),
      I4 => active_target_hot(0),
      O => m_valid_i0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => m_valid_i0,
      Q => \^m_valid_i_reg_0\,
      R => \aresetn_d_reg[1]\
    );
\s_ready_i_i_1__3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF2F2F2F"
    )
        port map (
      I0 => \^m_axi_rready[0]\,
      I1 => m_axi_rvalid(0),
      I2 => \^m_valid_i_reg_0\,
      I3 => s_axi_rready(0),
      I4 => active_target_hot(0),
      O => \s_ready_i_i_1__3_n_0\
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \s_ready_i_i_1__3_n_0\,
      Q => \^m_axi_rready[0]\,
      R => \aresetn_d_reg[0]\
    );
\skid_buffer_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(0),
      Q => \skid_buffer_reg_n_0_[0]\,
      R => '0'
    );
\skid_buffer_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(10),
      Q => \skid_buffer_reg_n_0_[10]\,
      R => '0'
    );
\skid_buffer_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(11),
      Q => \skid_buffer_reg_n_0_[11]\,
      R => '0'
    );
\skid_buffer_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(12),
      Q => \skid_buffer_reg_n_0_[12]\,
      R => '0'
    );
\skid_buffer_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(13),
      Q => \skid_buffer_reg_n_0_[13]\,
      R => '0'
    );
\skid_buffer_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(14),
      Q => \skid_buffer_reg_n_0_[14]\,
      R => '0'
    );
\skid_buffer_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(15),
      Q => \skid_buffer_reg_n_0_[15]\,
      R => '0'
    );
\skid_buffer_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(16),
      Q => \skid_buffer_reg_n_0_[16]\,
      R => '0'
    );
\skid_buffer_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(17),
      Q => \skid_buffer_reg_n_0_[17]\,
      R => '0'
    );
\skid_buffer_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(18),
      Q => \skid_buffer_reg_n_0_[18]\,
      R => '0'
    );
\skid_buffer_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(19),
      Q => \skid_buffer_reg_n_0_[19]\,
      R => '0'
    );
\skid_buffer_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(1),
      Q => \skid_buffer_reg_n_0_[1]\,
      R => '0'
    );
\skid_buffer_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(20),
      Q => \skid_buffer_reg_n_0_[20]\,
      R => '0'
    );
\skid_buffer_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(21),
      Q => \skid_buffer_reg_n_0_[21]\,
      R => '0'
    );
\skid_buffer_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(22),
      Q => \skid_buffer_reg_n_0_[22]\,
      R => '0'
    );
\skid_buffer_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(23),
      Q => \skid_buffer_reg_n_0_[23]\,
      R => '0'
    );
\skid_buffer_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(24),
      Q => \skid_buffer_reg_n_0_[24]\,
      R => '0'
    );
\skid_buffer_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(25),
      Q => \skid_buffer_reg_n_0_[25]\,
      R => '0'
    );
\skid_buffer_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(26),
      Q => \skid_buffer_reg_n_0_[26]\,
      R => '0'
    );
\skid_buffer_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(27),
      Q => \skid_buffer_reg_n_0_[27]\,
      R => '0'
    );
\skid_buffer_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(28),
      Q => \skid_buffer_reg_n_0_[28]\,
      R => '0'
    );
\skid_buffer_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(29),
      Q => \skid_buffer_reg_n_0_[29]\,
      R => '0'
    );
\skid_buffer_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(2),
      Q => \skid_buffer_reg_n_0_[2]\,
      R => '0'
    );
\skid_buffer_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(30),
      Q => \skid_buffer_reg_n_0_[30]\,
      R => '0'
    );
\skid_buffer_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(31),
      Q => \skid_buffer_reg_n_0_[31]\,
      R => '0'
    );
\skid_buffer_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(32),
      Q => \skid_buffer_reg_n_0_[32]\,
      R => '0'
    );
\skid_buffer_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(33),
      Q => \skid_buffer_reg_n_0_[33]\,
      R => '0'
    );
\skid_buffer_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(34),
      Q => \skid_buffer_reg_n_0_[34]\,
      R => '0'
    );
\skid_buffer_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(35),
      Q => \skid_buffer_reg_n_0_[35]\,
      R => '0'
    );
\skid_buffer_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(36),
      Q => \skid_buffer_reg_n_0_[36]\,
      R => '0'
    );
\skid_buffer_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(37),
      Q => \skid_buffer_reg_n_0_[37]\,
      R => '0'
    );
\skid_buffer_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(38),
      Q => \skid_buffer_reg_n_0_[38]\,
      R => '0'
    );
\skid_buffer_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(39),
      Q => \skid_buffer_reg_n_0_[39]\,
      R => '0'
    );
\skid_buffer_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(3),
      Q => \skid_buffer_reg_n_0_[3]\,
      R => '0'
    );
\skid_buffer_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(40),
      Q => \skid_buffer_reg_n_0_[40]\,
      R => '0'
    );
\skid_buffer_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(41),
      Q => \skid_buffer_reg_n_0_[41]\,
      R => '0'
    );
\skid_buffer_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(42),
      Q => \skid_buffer_reg_n_0_[42]\,
      R => '0'
    );
\skid_buffer_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(43),
      Q => \skid_buffer_reg_n_0_[43]\,
      R => '0'
    );
\skid_buffer_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(44),
      Q => \skid_buffer_reg_n_0_[44]\,
      R => '0'
    );
\skid_buffer_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(45),
      Q => \skid_buffer_reg_n_0_[45]\,
      R => '0'
    );
\skid_buffer_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(46),
      Q => \skid_buffer_reg_n_0_[46]\,
      R => '0'
    );
\skid_buffer_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(47),
      Q => \skid_buffer_reg_n_0_[47]\,
      R => '0'
    );
\skid_buffer_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(48),
      Q => \skid_buffer_reg_n_0_[48]\,
      R => '0'
    );
\skid_buffer_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(49),
      Q => \skid_buffer_reg_n_0_[49]\,
      R => '0'
    );
\skid_buffer_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(4),
      Q => \skid_buffer_reg_n_0_[4]\,
      R => '0'
    );
\skid_buffer_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(50),
      Q => \skid_buffer_reg_n_0_[50]\,
      R => '0'
    );
\skid_buffer_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(51),
      Q => \skid_buffer_reg_n_0_[51]\,
      R => '0'
    );
\skid_buffer_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(52),
      Q => \skid_buffer_reg_n_0_[52]\,
      R => '0'
    );
\skid_buffer_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(53),
      Q => \skid_buffer_reg_n_0_[53]\,
      R => '0'
    );
\skid_buffer_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(54),
      Q => \skid_buffer_reg_n_0_[54]\,
      R => '0'
    );
\skid_buffer_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(55),
      Q => \skid_buffer_reg_n_0_[55]\,
      R => '0'
    );
\skid_buffer_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(56),
      Q => \skid_buffer_reg_n_0_[56]\,
      R => '0'
    );
\skid_buffer_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(57),
      Q => \skid_buffer_reg_n_0_[57]\,
      R => '0'
    );
\skid_buffer_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(58),
      Q => \skid_buffer_reg_n_0_[58]\,
      R => '0'
    );
\skid_buffer_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(59),
      Q => \skid_buffer_reg_n_0_[59]\,
      R => '0'
    );
\skid_buffer_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(5),
      Q => \skid_buffer_reg_n_0_[5]\,
      R => '0'
    );
\skid_buffer_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(60),
      Q => \skid_buffer_reg_n_0_[60]\,
      R => '0'
    );
\skid_buffer_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(61),
      Q => \skid_buffer_reg_n_0_[61]\,
      R => '0'
    );
\skid_buffer_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(62),
      Q => \skid_buffer_reg_n_0_[62]\,
      R => '0'
    );
\skid_buffer_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(63),
      Q => \skid_buffer_reg_n_0_[63]\,
      R => '0'
    );
\skid_buffer_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rresp(0),
      Q => \skid_buffer_reg_n_0_[64]\,
      R => '0'
    );
\skid_buffer_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rresp(1),
      Q => \skid_buffer_reg_n_0_[65]\,
      R => '0'
    );
\skid_buffer_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rlast(0),
      Q => \skid_buffer_reg_n_0_[66]\,
      R => '0'
    );
\skid_buffer_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(0),
      Q => \skid_buffer_reg_n_0_[67]\,
      R => '0'
    );
\skid_buffer_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(1),
      Q => \skid_buffer_reg_n_0_[68]\,
      R => '0'
    );
\skid_buffer_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(2),
      Q => \skid_buffer_reg_n_0_[69]\,
      R => '0'
    );
\skid_buffer_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(6),
      Q => \skid_buffer_reg_n_0_[6]\,
      R => '0'
    );
\skid_buffer_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(3),
      Q => \skid_buffer_reg_n_0_[70]\,
      R => '0'
    );
\skid_buffer_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(4),
      Q => \skid_buffer_reg_n_0_[71]\,
      R => '0'
    );
\skid_buffer_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rid(5),
      Q => \skid_buffer_reg_n_0_[72]\,
      R => '0'
    );
\skid_buffer_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(7),
      Q => \skid_buffer_reg_n_0_[7]\,
      R => '0'
    );
\skid_buffer_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(8),
      Q => \skid_buffer_reg_n_0_[8]\,
      R => '0'
    );
\skid_buffer_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^m_axi_rready[0]\,
      D => m_axi_rdata(9),
      Q => \skid_buffer_reg_n_0_[9]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_data_fifo_v2_1_8_axic_reg_srl_fifo is
  port (
    s_ready_i_reg_0 : out STD_LOGIC;
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.write_cs_reg[1]\ : out STD_LOGIC;
    st_aa_awtarget_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    ss_wr_awvalid : in STD_LOGIC;
    m_ready_d : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    wr_tmp_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.write_cs_reg[1]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_data_fifo_v2_1_8_axic_reg_srl_fifo : entity is "axi_data_fifo_v2_1_8_axic_reg_srl_fifo";
end rchip_axi4_xbar_axi_data_fifo_v2_1_8_axic_reg_srl_fifo;

architecture STRUCTURE of rchip_axi4_xbar_axi_data_fifo_v2_1_8_axic_reg_srl_fifo is
  signal \FSM_onehot_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[3]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[2]\ : STD_LOGIC;
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of \FSM_onehot_state_reg_n_0_[2]\ : signal is "yes";
  signal \FSM_onehot_state_reg_n_0_[3]\ : STD_LOGIC;
  attribute RTL_KEEP of \FSM_onehot_state_reg_n_0_[3]\ : signal is "yes";
  signal areset_d1 : STD_LOGIC;
  signal fifoaddr : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \gen_rep[0].fifoaddr[0]_i_1_n_0\ : STD_LOGIC;
  signal \gen_rep[0].fifoaddr[1]_i_1_n_0\ : STD_LOGIC;
  signal \gen_srls[0].gen_rep[0].srl_nx1_n_0\ : STD_LOGIC;
  signal \gen_srls[0].gen_rep[1].srl_nx1_n_2\ : STD_LOGIC;
  signal \gen_srls[0].gen_rep[1].srl_nx1_n_3\ : STD_LOGIC;
  signal load_s1 : STD_LOGIC;
  signal m_avalid : STD_LOGIC;
  signal \m_valid_i__0\ : STD_LOGIC;
  signal \m_valid_i_i_1__2_n_0\ : STD_LOGIC;
  signal m_valid_i_i_4_n_0 : STD_LOGIC;
  signal m_valid_i_n_0 : STD_LOGIC;
  signal p_0_in5_out : STD_LOGIC;
  signal p_0_in8_in : STD_LOGIC;
  attribute RTL_KEEP of p_0_in8_in : signal is "yes";
  signal p_2_out : STD_LOGIC;
  signal p_9_in : STD_LOGIC;
  attribute RTL_KEEP of p_9_in : signal is "yes";
  signal push : STD_LOGIC;
  signal \s_ready_i_i_1__0_n_0\ : STD_LOGIC;
  signal s_ready_i_i_2_n_0 : STD_LOGIC;
  signal \^s_ready_i_reg_0\ : STD_LOGIC;
  signal \storage_data1[0]_i_1_n_0\ : STD_LOGIC;
  signal \storage_data1[1]_i_1_n_0\ : STD_LOGIC;
  signal \storage_data1_reg_n_0_[0]\ : STD_LOGIC;
  signal \storage_data1_reg_n_0_[1]\ : STD_LOGIC;
  attribute KEEP : string;
  attribute KEEP of \FSM_onehot_state_reg[0]\ : label is "yes";
  attribute KEEP of \FSM_onehot_state_reg[1]\ : label is "yes";
  attribute KEEP of \FSM_onehot_state_reg[2]\ : label is "yes";
  attribute KEEP of \FSM_onehot_state_reg[3]\ : label is "yes";
  attribute syn_keep : string;
  attribute syn_keep of \gen_rep[0].fifoaddr_reg[0]\ : label is "1";
  attribute syn_keep of \gen_rep[0].fifoaddr_reg[1]\ : label is "1";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_axi_wvalid[0]_INST_0\ : label is "soft_lutpair93";
  attribute SOFT_HLUTNM of \m_axi_wvalid[1]_INST_0\ : label is "soft_lutpair93";
begin
  s_ready_i_reg_0 <= \^s_ready_i_reg_0\;
\FSM_onehot_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10110000"
    )
        port map (
      I0 => p_9_in,
      I1 => \m_valid_i_i_1__2_n_0\,
      I2 => m_ready_d(0),
      I3 => s_axi_awvalid(0),
      I4 => p_0_in8_in,
      O => \FSM_onehot_state[0]_i_1_n_0\
    );
\FSM_onehot_state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"20202F20"
    )
        port map (
      I0 => s_axi_awvalid(0),
      I1 => m_ready_d(0),
      I2 => p_9_in,
      I3 => p_0_in5_out,
      I4 => p_0_in8_in,
      O => \FSM_onehot_state[1]_i_1_n_0\
    );
\FSM_onehot_state[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B0B0B0BF"
    )
        port map (
      I0 => m_ready_d(0),
      I1 => s_axi_awvalid(0),
      I2 => p_9_in,
      I3 => p_0_in5_out,
      I4 => p_0_in8_in,
      O => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF844F844F844"
    )
        port map (
      I0 => \m_valid_i_i_1__2_n_0\,
      I1 => p_0_in8_in,
      I2 => p_9_in,
      I3 => ss_wr_awvalid,
      I4 => \FSM_onehot_state_reg_n_0_[3]\,
      I5 => p_0_in5_out,
      O => \m_valid_i__0\
    );
\FSM_onehot_state[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008A88"
    )
        port map (
      I0 => p_0_in8_in,
      I1 => \m_valid_i_i_1__2_n_0\,
      I2 => m_ready_d(0),
      I3 => s_axi_awvalid(0),
      I4 => p_9_in,
      O => \FSM_onehot_state[3]_i_2_n_0\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => aclk,
      CE => \m_valid_i__0\,
      D => \FSM_onehot_state[0]_i_1_n_0\,
      Q => p_9_in,
      S => areset_d1
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => \m_valid_i__0\,
      D => \FSM_onehot_state[1]_i_1_n_0\,
      Q => p_0_in8_in,
      R => areset_d1
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => \m_valid_i__0\,
      D => \FSM_onehot_state[2]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[2]\,
      R => areset_d1
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => \m_valid_i__0\,
      D => \FSM_onehot_state[3]_i_2_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[3]\,
      R => areset_d1
    );
areset_d1_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => SR(0),
      Q => areset_d1,
      R => '0'
    );
\gen_axi.write_cs[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0020000000000000"
    )
        port map (
      I0 => \storage_data1_reg_n_0_[1]\,
      I1 => \gen_axi.write_cs_reg[1]_0\(0),
      I2 => s_axi_wlast(0),
      I3 => \storage_data1_reg_n_0_[0]\,
      I4 => s_axi_wvalid(0),
      I5 => m_avalid,
      O => \gen_axi.write_cs_reg[1]\
    );
\gen_rep[0].fifoaddr[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0DF57DF5F20A820A"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \^s_ready_i_reg_0\,
      I2 => \m_valid_i_i_1__2_n_0\,
      I3 => ss_wr_awvalid,
      I4 => p_0_in8_in,
      I5 => fifoaddr(0),
      O => \gen_rep[0].fifoaddr[0]_i_1_n_0\
    );
\gen_rep[0].fifoaddr[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"75EF8A10"
    )
        port map (
      I0 => fifoaddr(0),
      I1 => \m_valid_i_i_1__2_n_0\,
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      I3 => push,
      I4 => fifoaddr(1),
      O => \gen_rep[0].fifoaddr[1]_i_1_n_0\
    );
\gen_rep[0].fifoaddr_reg[0]\: unisim.vcomponents.FDSE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_rep[0].fifoaddr[0]_i_1_n_0\,
      Q => fifoaddr(0),
      S => SR(0)
    );
\gen_rep[0].fifoaddr_reg[1]\: unisim.vcomponents.FDSE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_rep[0].fifoaddr[1]_i_1_n_0\,
      Q => fifoaddr(1),
      S => SR(0)
    );
\gen_srls[0].gen_rep[0].srl_nx1\: entity work.rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl
     port map (
      aclk => aclk,
      fifoaddr(1 downto 0) => fifoaddr(1 downto 0),
      push => push,
      st_aa_awtarget_enc(0) => st_aa_awtarget_enc(0),
      \storage_data1_reg[0]\ => \gen_srls[0].gen_rep[0].srl_nx1_n_0\
    );
\gen_srls[0].gen_rep[1].srl_nx1\: entity work.rchip_axi4_xbar_axi_data_fifo_v2_1_8_ndeep_srl_4
     port map (
      aclk => aclk,
      fifoaddr(1 downto 0) => fifoaddr(1 downto 0),
      m_avalid => m_avalid,
      m_axi_wready(1 downto 0) => m_axi_wready(1 downto 0),
      out0(1) => p_0_in8_in,
      out0(0) => \FSM_onehot_state_reg_n_0_[3]\,
      p_2_out => p_2_out,
      push => push,
      s_axi_awaddr(0) => s_axi_awaddr(1),
      s_axi_wlast(0) => s_axi_wlast(0),
      s_axi_wvalid(0) => s_axi_wvalid(0),
      s_ready_i_reg => \gen_srls[0].gen_rep[1].srl_nx1_n_2\,
      s_ready_i_reg_0 => \gen_srls[0].gen_rep[1].srl_nx1_n_3\,
      s_ready_i_reg_1 => \^s_ready_i_reg_0\,
      ss_wr_awvalid => ss_wr_awvalid,
      \storage_data1_reg[0]\ => \storage_data1_reg_n_0_[0]\,
      \storage_data1_reg[1]\ => \storage_data1_reg_n_0_[1]\,
      wr_tmp_wready(0) => wr_tmp_wready(0)
    );
\m_axi_wvalid[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1000"
    )
        port map (
      I0 => \storage_data1_reg_n_0_[1]\,
      I1 => \storage_data1_reg_n_0_[0]\,
      I2 => s_axi_wvalid(0),
      I3 => m_avalid,
      O => m_axi_wvalid(0)
    );
\m_axi_wvalid[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => \storage_data1_reg_n_0_[0]\,
      I1 => \storage_data1_reg_n_0_[1]\,
      I2 => s_axi_wvalid(0),
      I3 => m_avalid,
      O => m_axi_wvalid(1)
    );
m_valid_i: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF800F800F800"
    )
        port map (
      I0 => \m_valid_i_i_1__2_n_0\,
      I1 => p_0_in8_in,
      I2 => p_9_in,
      I3 => ss_wr_awvalid,
      I4 => \FSM_onehot_state_reg_n_0_[3]\,
      I5 => p_0_in5_out,
      O => m_valid_i_n_0
    );
\m_valid_i_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => s_axi_wlast(0),
      I1 => m_avalid,
      I2 => s_axi_wvalid(0),
      I3 => \gen_srls[0].gen_rep[1].srl_nx1_n_3\,
      O => \m_valid_i_i_1__2_n_0\
    );
m_valid_i_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000010"
    )
        port map (
      I0 => fifoaddr(0),
      I1 => fifoaddr(1),
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      I3 => \gen_srls[0].gen_rep[1].srl_nx1_n_3\,
      I4 => \gen_srls[0].gen_rep[1].srl_nx1_n_2\,
      I5 => m_valid_i_i_4_n_0,
      O => p_0_in5_out
    );
m_valid_i_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => \^s_ready_i_reg_0\,
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => m_ready_d(0),
      I3 => s_axi_awvalid(0),
      O => m_valid_i_i_4_n_0
    );
m_valid_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \m_valid_i__0\,
      D => m_valid_i_n_0,
      Q => m_avalid,
      R => areset_d1
    );
\s_axi_wready[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00A088AA00A08800"
    )
        port map (
      I0 => m_avalid,
      I1 => wr_tmp_wready(0),
      I2 => m_axi_wready(1),
      I3 => \storage_data1_reg_n_0_[1]\,
      I4 => \storage_data1_reg_n_0_[0]\,
      I5 => m_axi_wready(0),
      O => s_axi_wready(0)
    );
\s_ready_i_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEFFFEEEEEEEE"
    )
        port map (
      I0 => s_ready_i_i_2_n_0,
      I1 => areset_d1,
      I2 => push,
      I3 => fifoaddr(1),
      I4 => fifoaddr(0),
      I5 => \^s_ready_i_reg_0\,
      O => \s_ready_i_i_1__0_n_0\
    );
s_ready_i_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"20000000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \gen_srls[0].gen_rep[1].srl_nx1_n_3\,
      I2 => s_axi_wvalid(0),
      I3 => m_avalid,
      I4 => s_axi_wlast(0),
      O => s_ready_i_i_2_n_0
    );
s_ready_i_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \s_ready_i_i_1__0_n_0\,
      Q => \^s_ready_i_reg_0\,
      R => SR(0)
    );
\storage_data1[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"88B8FFFF88B80000"
    )
        port map (
      I0 => \gen_srls[0].gen_rep[0].srl_nx1_n_0\,
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => s_axi_awaddr(0),
      I3 => s_axi_awaddr(1),
      I4 => load_s1,
      I5 => \storage_data1_reg_n_0_[0]\,
      O => \storage_data1[0]_i_1_n_0\
    );
\storage_data1[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => p_2_out,
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => s_axi_awaddr(1),
      I3 => load_s1,
      I4 => \storage_data1_reg_n_0_[1]\,
      O => \storage_data1[1]_i_1_n_0\
    );
\storage_data1[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCCF000ACCCE000A"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => p_9_in,
      I2 => \gen_srls[0].gen_rep[1].srl_nx1_n_2\,
      I3 => \gen_srls[0].gen_rep[1].srl_nx1_n_3\,
      I4 => ss_wr_awvalid,
      I5 => p_0_in8_in,
      O => load_s1
    );
\storage_data1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \storage_data1[0]_i_1_n_0\,
      Q => \storage_data1_reg_n_0_[0]\,
      R => '0'
    );
\storage_data1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \storage_data1[1]_i_1_n_0\,
      Q => \storage_data1_reg_n_0_[1]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice is
  port (
    p_78_out : out STD_LOGIC;
    m_axi_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    p_72_out : out STD_LOGIC;
    \m_axi_rready[0]\ : out STD_LOGIC;
    \gen_no_arbiter.m_target_hot_i_reg[2]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 72 downto 0 );
    \gen_master_slots[0].r_issuing_cnt_reg[0]\ : out STD_LOGIC;
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \aresetn_d_reg[1]\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    \gen_single_issue.active_target_hot_reg[0]\ : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_hot : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_hot_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_master_slots[0].r_issuing_cnt_reg[0]_0\ : in STD_LOGIC;
    p_25_in : in STD_LOGIC;
    m_valid_i_reg : in STD_LOGIC;
    \s_axi_araddr[31]\ : in STD_LOGIC;
    \m_payload_i_reg[66]\ : in STD_LOGIC;
    \s_axi_araddr[31]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    D : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice : entity is "axi_register_slice_v2_1_9_axi_register_slice";
end rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice;

architecture STRUCTURE of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice is
begin
b_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_7\
     port map (
      D(7 downto 0) => D(7 downto 0),
      aclk => aclk,
      active_target_hot_0(0) => active_target_hot_0(0),
      \aresetn_d_reg[0]\ => \aresetn_d_reg[0]\,
      \aresetn_d_reg[1]\ => \aresetn_d_reg[1]\,
      \gen_single_issue.active_target_hot_reg[0]\ => \gen_single_issue.active_target_hot_reg[0]\,
      m_axi_bready(0) => m_axi_bready(0),
      m_axi_bvalid(0) => m_axi_bvalid(0),
      p_78_out => p_78_out,
      \s_axi_bid[5]\(7 downto 0) => \s_axi_bid[5]\(7 downto 0),
      s_axi_bready(0) => s_axi_bready(0)
    );
r_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_8\
     port map (
      Q(72 downto 0) => Q(72 downto 0),
      aclk => aclk,
      active_target_hot(0) => active_target_hot(0),
      \aresetn_d_reg[0]\ => \aresetn_d_reg[0]\,
      \aresetn_d_reg[1]\ => \aresetn_d_reg[1]\,
      \gen_master_slots[0].r_issuing_cnt_reg[0]\ => \gen_master_slots[0].r_issuing_cnt_reg[0]\,
      \gen_master_slots[0].r_issuing_cnt_reg[0]_0\ => \gen_master_slots[0].r_issuing_cnt_reg[0]_0\,
      \gen_no_arbiter.m_target_hot_i_reg[2]\ => \gen_no_arbiter.m_target_hot_i_reg[2]\,
      m_axi_rdata(63 downto 0) => m_axi_rdata(63 downto 0),
      m_axi_rid(5 downto 0) => m_axi_rid(5 downto 0),
      m_axi_rlast(0) => m_axi_rlast(0),
      \m_axi_rready[0]\ => \m_axi_rready[0]\,
      m_axi_rresp(1 downto 0) => m_axi_rresp(1 downto 0),
      m_axi_rvalid(0) => m_axi_rvalid(0),
      \m_payload_i_reg[66]_0\ => \m_payload_i_reg[66]\,
      m_valid_i_reg_0 => p_72_out,
      m_valid_i_reg_1 => m_valid_i_reg,
      p_25_in => p_25_in,
      \s_axi_araddr[31]\ => \s_axi_araddr[31]\,
      \s_axi_araddr[31]_0\(1 downto 0) => \s_axi_araddr[31]_0\(1 downto 0),
      s_axi_rready(0) => s_axi_rready(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_1 is
  port (
    p_56_out : out STD_LOGIC;
    m_axi_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_ready_i_reg : out STD_LOGIC;
    p_50_out : out STD_LOGIC;
    \m_axi_rready[1]\ : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]\ : out STD_LOGIC;
    \gen_master_slots[1].r_issuing_cnt_reg[8]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 72 downto 0 );
    \aresetn_d_reg[1]\ : out STD_LOGIC;
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \aresetn_d_reg[1]_0\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \gen_single_issue.active_target_enc_reg[0]\ : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_25_in : in STD_LOGIC;
    \s_axi_araddr[31]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \m_payload_i_reg[66]\ : in STD_LOGIC;
    p_43_in : in STD_LOGIC;
    m_axi_rid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    D : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_1 : entity is "axi_register_slice_v2_1_9_axi_register_slice";
end rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_1;

architecture STRUCTURE of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_1 is
  signal \^s_ready_i_reg\ : STD_LOGIC;
begin
  s_ready_i_reg <= \^s_ready_i_reg\;
b_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1_5\
     port map (
      D(7 downto 0) => D(7 downto 0),
      aclk => aclk,
      active_target_enc_0(0) => active_target_enc_0(0),
      aresetn => aresetn,
      \aresetn_d_reg[1]\ => \aresetn_d_reg[1]\,
      \aresetn_d_reg[1]_0\ => \aresetn_d_reg[1]_0\,
      \gen_single_issue.active_target_enc_reg[0]\ => \gen_single_issue.active_target_enc_reg[0]\,
      m_axi_bready(0) => m_axi_bready(0),
      m_axi_bvalid(0) => m_axi_bvalid(0),
      p_56_out => p_56_out,
      \s_axi_bid[5]\(7 downto 0) => \s_axi_bid[5]\(7 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_ready_i_reg_0 => \^s_ready_i_reg\
    );
r_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2_6\
     port map (
      Q(72 downto 0) => Q(72 downto 0),
      aclk => aclk,
      active_target_enc(0) => active_target_enc(0),
      \aresetn_d_reg[0]\ => \^s_ready_i_reg\,
      \aresetn_d_reg[1]\ => \aresetn_d_reg[1]_0\,
      \gen_master_slots[1].r_issuing_cnt_reg[8]\ => \gen_master_slots[1].r_issuing_cnt_reg[8]\,
      \gen_no_arbiter.s_ready_i_reg[0]\ => \gen_no_arbiter.s_ready_i_reg[0]\,
      m_axi_rdata(63 downto 0) => m_axi_rdata(63 downto 0),
      m_axi_rid(5 downto 0) => m_axi_rid(5 downto 0),
      m_axi_rlast(0) => m_axi_rlast(0),
      \m_axi_rready[1]\ => \m_axi_rready[1]\,
      m_axi_rresp(1 downto 0) => m_axi_rresp(1 downto 0),
      m_axi_rvalid(0) => m_axi_rvalid(0),
      \m_payload_i_reg[66]_0\ => \m_payload_i_reg[66]\,
      m_valid_i_reg_0 => p_50_out,
      p_25_in => p_25_in,
      p_43_in => p_43_in,
      \s_axi_araddr[31]\(1 downto 0) => \s_axi_araddr[31]\(1 downto 0),
      s_axi_rready(0) => s_axi_rready(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_2 is
  port (
    p_34_out : out STD_LOGIC;
    m_valid_i_reg : out STD_LOGIC;
    p_28_out : out STD_LOGIC;
    mi_rready_2 : out STD_LOGIC;
    mi_bready_2 : out STD_LOGIC;
    s_ready_i_reg : out STD_LOGIC;
    \gen_no_arbiter.s_ready_i_reg[0]\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 6 downto 0 );
    \gen_master_slots[2].r_issuing_cnt_reg[16]\ : out STD_LOGIC;
    \s_axi_bid[5]\ : out STD_LOGIC_VECTOR ( 5 downto 0 );
    \gen_axi.s_axi_bvalid_i_reg\ : in STD_LOGIC;
    aclk : in STD_LOGIC;
    \aresetn_d_reg[0]\ : in STD_LOGIC;
    \aresetn_d_reg[0]_0\ : in STD_LOGIC;
    active_target_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_17_in : in STD_LOGIC;
    p_11_in : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    active_target_enc_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    r_issuing_cnt : in STD_LOGIC_VECTOR ( 0 to 0 );
    \s_axi_araddr[31]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.s_axi_rid_i_reg[5]\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rlast_i : in STD_LOGIC;
    \gen_no_arbiter.m_valid_i_reg\ : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_2 : entity is "axi_register_slice_v2_1_9_axi_register_slice";
end rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_2;

architecture STRUCTURE of rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_2 is
  signal \^m_valid_i_reg\ : STD_LOGIC;
begin
  m_valid_i_reg <= \^m_valid_i_reg\;
b_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized1\
     port map (
      D(5 downto 0) => D(5 downto 0),
      aclk => aclk,
      active_target_enc(0) => active_target_enc(0),
      \aresetn_d_reg[0]\ => \aresetn_d_reg[0]\,
      \aresetn_d_reg[0]_0\ => \aresetn_d_reg[0]_0\,
      \gen_axi.s_axi_bvalid_i_reg\ => \gen_axi.s_axi_bvalid_i_reg\,
      m_valid_i_reg_0 => \^m_valid_i_reg\,
      mi_bready_2 => mi_bready_2,
      p_17_in => p_17_in,
      p_34_out => p_34_out,
      \s_axi_bid[5]\(5 downto 0) => \s_axi_bid[5]\(5 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_ready_i_reg_0 => s_ready_i_reg
    );
r_pipe: entity work.\rchip_axi4_xbar_axi_register_slice_v2_1_9_axic_register_slice__parameterized2\
     port map (
      Q(6 downto 0) => Q(6 downto 0),
      aclk => aclk,
      active_target_enc_0(0) => active_target_enc_0(0),
      \aresetn_d_reg[0]\ => \aresetn_d_reg[0]\,
      \aresetn_d_reg[1]\ => \^m_valid_i_reg\,
      \gen_axi.s_axi_rid_i_reg[5]\(5 downto 0) => \gen_axi.s_axi_rid_i_reg[5]\(5 downto 0),
      \gen_master_slots[2].r_issuing_cnt_reg[16]\ => \gen_master_slots[2].r_issuing_cnt_reg[16]\,
      \gen_no_arbiter.m_valid_i_reg\ => \gen_no_arbiter.m_valid_i_reg\,
      \gen_no_arbiter.s_ready_i_reg[0]\ => \gen_no_arbiter.s_ready_i_reg[0]\,
      m_valid_i_reg_0 => p_28_out,
      p_11_in => p_11_in,
      r_issuing_cnt(0) => r_issuing_cnt(0),
      \s_axi_araddr[31]\(0) => \s_axi_araddr[31]\(0),
      s_axi_rlast_i => s_axi_rlast_i,
      s_axi_rready(0) => s_axi_rready(0),
      \skid_buffer_reg[66]_0\ => mi_rready_2
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_wdata_router is
  port (
    ss_wr_awready : out STD_LOGIC;
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.write_cs_reg[1]\ : out STD_LOGIC;
    st_aa_awtarget_enc : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    ss_wr_awvalid : in STD_LOGIC;
    m_ready_d : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    wr_tmp_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    \gen_axi.write_cs_reg[1]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_wdata_router : entity is "axi_crossbar_v2_1_10_wdata_router";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_wdata_router;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_wdata_router is
begin
wrouter_aw_fifo: entity work.rchip_axi4_xbar_axi_data_fifo_v2_1_8_axic_reg_srl_fifo
     port map (
      SR(0) => SR(0),
      aclk => aclk,
      \gen_axi.write_cs_reg[1]\ => \gen_axi.write_cs_reg[1]\,
      \gen_axi.write_cs_reg[1]_0\(0) => \gen_axi.write_cs_reg[1]_0\(0),
      m_axi_wready(1 downto 0) => m_axi_wready(1 downto 0),
      m_axi_wvalid(1 downto 0) => m_axi_wvalid(1 downto 0),
      m_ready_d(0) => m_ready_d(0),
      s_axi_awaddr(1 downto 0) => s_axi_awaddr(1 downto 0),
      s_axi_awvalid(0) => s_axi_awvalid(0),
      s_axi_wlast(0) => s_axi_wlast(0),
      s_axi_wready(0) => s_axi_wready(0),
      s_axi_wvalid(0) => s_axi_wvalid(0),
      s_ready_i_reg_0 => ss_wr_awready,
      ss_wr_awvalid => ss_wr_awvalid,
      st_aa_awtarget_enc(0) => st_aa_awtarget_enc(0),
      wr_tmp_wready(0) => wr_tmp_wready(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_crossbar is
  port (
    M_AXI_RREADY : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 62 downto 0 );
    \m_axi_arqos[3]\ : out STD_LOGIC_VECTOR ( 62 downto 0 );
    S_AXI_ARREADY : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \s_axi_bvalid[0]\ : out STD_LOGIC;
    \s_axi_awready[0]\ : out STD_LOGIC;
    \s_axi_rvalid[0]\ : out STD_LOGIC;
    \s_axi_rlast[0]\ : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    aresetn : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 30 downto 0 );
    \s_axi_arqos[3]\ : in STD_LOGIC_VECTOR ( 62 downto 0 );
    m_axi_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_crossbar : entity is "axi_crossbar_v2_1_10_crossbar";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_crossbar;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_crossbar is
  signal \^q\ : STD_LOGIC_VECTOR ( 62 downto 0 );
  signal \^s_axi_arready\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal aa_mi_artarget_hot : STD_LOGIC_VECTOR ( 2 to 2 );
  signal aa_mi_arvalid : STD_LOGIC;
  signal aa_mi_awtarget_hot : STD_LOGIC_VECTOR ( 2 to 2 );
  signal aa_sa_awvalid : STD_LOGIC;
  signal active_target_enc : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal active_target_enc_1 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal active_target_hot : STD_LOGIC_VECTOR ( 0 to 0 );
  signal active_target_hot_2 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal addr_arbiter_ar_n_11 : STD_LOGIC;
  signal addr_arbiter_ar_n_4 : STD_LOGIC;
  signal addr_arbiter_ar_n_5 : STD_LOGIC;
  signal addr_arbiter_ar_n_6 : STD_LOGIC;
  signal addr_arbiter_ar_n_7 : STD_LOGIC;
  signal addr_arbiter_ar_n_75 : STD_LOGIC;
  signal addr_arbiter_ar_n_76 : STD_LOGIC;
  signal addr_arbiter_ar_n_77 : STD_LOGIC;
  signal addr_arbiter_ar_n_78 : STD_LOGIC;
  signal addr_arbiter_ar_n_79 : STD_LOGIC;
  signal addr_arbiter_ar_n_8 : STD_LOGIC;
  signal addr_arbiter_aw_n_10 : STD_LOGIC;
  signal addr_arbiter_aw_n_11 : STD_LOGIC;
  signal addr_arbiter_aw_n_12 : STD_LOGIC;
  signal addr_arbiter_aw_n_5 : STD_LOGIC;
  signal addr_arbiter_aw_n_6 : STD_LOGIC;
  signal addr_arbiter_aw_n_8 : STD_LOGIC;
  signal addr_arbiter_aw_n_9 : STD_LOGIC;
  signal aresetn_d : STD_LOGIC;
  signal \gen_decerr_slave.decerr_slave_inst_n_7\ : STD_LOGIC;
  signal \gen_master_slots[0].reg_slice_mi_n_4\ : STD_LOGIC;
  signal \gen_master_slots[0].reg_slice_mi_n_78\ : STD_LOGIC;
  signal \gen_master_slots[1].reg_slice_mi_n_2\ : STD_LOGIC;
  signal \gen_master_slots[1].reg_slice_mi_n_5\ : STD_LOGIC;
  signal \gen_master_slots[1].reg_slice_mi_n_6\ : STD_LOGIC;
  signal \gen_master_slots[1].reg_slice_mi_n_80\ : STD_LOGIC;
  signal \gen_master_slots[2].reg_slice_mi_n_1\ : STD_LOGIC;
  signal \gen_master_slots[2].reg_slice_mi_n_14\ : STD_LOGIC;
  signal \gen_master_slots[2].reg_slice_mi_n_5\ : STD_LOGIC;
  signal \gen_master_slots[2].reg_slice_mi_n_6\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_read.si_transactor_ar_n_4\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_10\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_11\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_3\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_4\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_6\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_7\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_8\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_4\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_5\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_6\ : STD_LOGIC;
  signal \gen_slave_slots[0].gen_si_write.wdata_router_w_n_4\ : STD_LOGIC;
  signal \^m_axi_arqos[3]\ : STD_LOGIC_VECTOR ( 62 downto 0 );
  signal m_ready_d : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m_ready_d_3 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal mi_arready_2 : STD_LOGIC;
  signal mi_bready_2 : STD_LOGIC;
  signal mi_rready_2 : STD_LOGIC;
  signal p_11_in : STD_LOGIC;
  signal p_17_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal p_25_in : STD_LOGIC;
  signal p_28_out : STD_LOGIC;
  signal p_30_out : STD_LOGIC;
  signal p_34_in : STD_LOGIC;
  signal p_34_out : STD_LOGIC;
  signal p_43_in : STD_LOGIC;
  signal p_50_out : STD_LOGIC;
  signal p_52_in : STD_LOGIC;
  signal p_52_out : STD_LOGIC;
  signal p_56_out : STD_LOGIC;
  signal p_72_out : STD_LOGIC;
  signal p_74_out : STD_LOGIC;
  signal p_78_out : STD_LOGIC;
  signal r_issuing_cnt : STD_LOGIC_VECTOR ( 16 to 16 );
  signal reset : STD_LOGIC;
  signal \^s_axi_awready[0]\ : STD_LOGIC;
  signal s_axi_bid_i : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal s_axi_rid_i : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal s_axi_rlast_i : STD_LOGIC;
  signal s_ready_i0 : STD_LOGIC;
  signal s_ready_i0_0 : STD_LOGIC;
  signal ss_aa_awready : STD_LOGIC;
  signal ss_wr_awready : STD_LOGIC;
  signal ss_wr_awvalid : STD_LOGIC;
  signal st_aa_awtarget_enc : STD_LOGIC_VECTOR ( 0 to 0 );
  signal st_mr_bid : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal st_mr_bmesg : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal st_mr_rid : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal st_mr_rmesg : STD_LOGIC_VECTOR ( 133 downto 0 );
  signal w_issuing_cnt : STD_LOGIC_VECTOR ( 16 to 16 );
  signal wr_tmp_wready : STD_LOGIC_VECTOR ( 2 to 2 );
  signal write_cs : STD_LOGIC_VECTOR ( 1 to 1 );
begin
  Q(62 downto 0) <= \^q\(62 downto 0);
  S_AXI_ARREADY(0) <= \^s_axi_arready\(0);
  \m_axi_arqos[3]\(62 downto 0) <= \^m_axi_arqos[3]\(62 downto 0);
  \s_axi_awready[0]\ <= \^s_axi_awready[0]\;
addr_arbiter_ar: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter
     port map (
      E(0) => addr_arbiter_ar_n_5,
      SR(0) => reset,
      S_AXI_ARREADY(0) => \^s_axi_arready\(0),
      aa_mi_arvalid => aa_mi_arvalid,
      aclk => aclk,
      active_target_enc(1 downto 0) => active_target_enc(1 downto 0),
      active_target_hot(0) => active_target_hot(0),
      aresetn_d => aresetn_d,
      \gen_axi.s_axi_rlast_i_reg\ => addr_arbiter_ar_n_11,
      \gen_master_slots[0].r_issuing_cnt_reg[0]\ => addr_arbiter_ar_n_76,
      \gen_master_slots[1].r_issuing_cnt_reg[8]\ => addr_arbiter_ar_n_78,
      \gen_master_slots[1].r_issuing_cnt_reg[8]_0\ => \gen_master_slots[1].reg_slice_mi_n_5\,
      \gen_master_slots[1].r_issuing_cnt_reg[8]_1\ => \gen_master_slots[0].reg_slice_mi_n_4\,
      \gen_master_slots[2].r_issuing_cnt_reg[16]\ => addr_arbiter_ar_n_4,
      \gen_no_arbiter.m_target_hot_i_reg[1]_0\ => addr_arbiter_ar_n_6,
      \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0) => aa_mi_artarget_hot(2),
      \gen_no_arbiter.m_target_hot_i_reg[2]_1\ => addr_arbiter_ar_n_7,
      \gen_no_arbiter.m_target_hot_i_reg[2]_2\ => addr_arbiter_ar_n_8,
      \gen_single_issue.accept_cnt_reg\ => \gen_slave_slots[0].gen_si_read.si_transactor_ar_n_4\,
      \gen_single_issue.active_target_enc_reg[0]\ => addr_arbiter_ar_n_75,
      \gen_single_issue.active_target_enc_reg[1]\ => addr_arbiter_ar_n_79,
      \gen_single_issue.active_target_hot_reg[0]\ => addr_arbiter_ar_n_77,
      \m_axi_arqos[3]\(62 downto 0) => \^m_axi_arqos[3]\(62 downto 0),
      m_axi_arready(1 downto 0) => m_axi_arready(1 downto 0),
      m_axi_arvalid(1 downto 0) => m_axi_arvalid(1 downto 0),
      \m_payload_i_reg[66]\ => \gen_master_slots[2].reg_slice_mi_n_6\,
      \m_payload_i_reg[66]_0\ => \gen_master_slots[0].reg_slice_mi_n_78\,
      m_valid_i_reg => \gen_master_slots[1].reg_slice_mi_n_6\,
      mi_arready_2 => mi_arready_2,
      p_11_in => p_11_in,
      p_25_in => p_25_in,
      p_43_in => p_43_in,
      \s_axi_arqos[3]\(62 downto 0) => \s_axi_arqos[3]\(62 downto 0),
      s_axi_arvalid(0) => s_axi_arvalid(0),
      s_ready_i0 => s_ready_i0
    );
addr_arbiter_aw: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_addr_arbiter_0
     port map (
      D(62 downto 38) => D(30 downto 6),
      D(37 downto 6) => s_axi_awaddr(31 downto 0),
      D(5 downto 0) => D(5 downto 0),
      Q(62 downto 0) => \^q\(62 downto 0),
      SR(0) => reset,
      aa_sa_awvalid => aa_sa_awvalid,
      aclk => aclk,
      active_target_enc(0) => active_target_enc_1(1),
      aresetn_d => aresetn_d,
      \gen_master_slots[0].w_issuing_cnt_reg[0]\ => addr_arbiter_aw_n_11,
      \gen_master_slots[1].w_issuing_cnt_reg[8]\ => addr_arbiter_aw_n_10,
      \gen_master_slots[1].w_issuing_cnt_reg[8]_0\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_7\,
      \gen_master_slots[2].w_issuing_cnt_reg[16]\ => addr_arbiter_aw_n_5,
      \gen_master_slots[2].w_issuing_cnt_reg[16]_0\ => addr_arbiter_aw_n_12,
      \gen_master_slots[2].w_issuing_cnt_reg[16]_1\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_6\,
      \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0) => aa_mi_awtarget_hot(2),
      \gen_no_arbiter.m_valid_i_reg_0\ => addr_arbiter_aw_n_6,
      \gen_no_arbiter.m_valid_i_reg_1\ => addr_arbiter_aw_n_9,
      \gen_no_arbiter.s_ready_i_reg[0]_0\ => addr_arbiter_aw_n_8,
      \gen_single_issue.active_target_enc_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_10\,
      \gen_single_issue.active_target_enc_reg[1]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_8\,
      \gen_single_issue.active_target_hot_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_11\,
      m_axi_awready(1 downto 0) => m_axi_awready(1 downto 0),
      m_axi_awvalid(1 downto 0) => m_axi_awvalid(1 downto 0),
      m_ready_d(1 downto 0) => m_ready_d_3(1 downto 0),
      m_ready_d_0(0) => m_ready_d(0),
      p_1_in => p_1_in,
      p_34_in => p_34_in,
      p_34_out => p_34_out,
      p_52_in => p_52_in,
      s_axi_awvalid(0) => s_axi_awvalid(0),
      s_axi_bready(0) => s_axi_bready(0),
      s_ready_i0 => s_ready_i0_0,
      ss_aa_awready => ss_aa_awready,
      st_aa_awtarget_enc(0) => st_aa_awtarget_enc(0),
      w_issuing_cnt(0) => w_issuing_cnt(16)
    );
aresetn_d_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => aclk,
      CE => '1',
      D => aresetn,
      Q => aresetn_d,
      R => '0'
    );
\gen_decerr_slave.decerr_slave_inst\: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_decerr_slave
     port map (
      E(0) => addr_arbiter_ar_n_5,
      Q(5 downto 0) => s_axi_bid_i(5 downto 0),
      SR(0) => reset,
      aa_mi_arvalid => aa_mi_arvalid,
      aa_sa_awvalid => aa_sa_awvalid,
      aclk => aclk,
      active_target_enc(0) => active_target_enc_1(1),
      aresetn_d => aresetn_d,
      \gen_axi.read_cs_reg[0]_0\ => addr_arbiter_ar_n_11,
      \gen_axi.write_cs_reg[1]_0\(0) => write_cs(1),
      \gen_no_arbiter.m_mesg_i_reg[45]\(13 downto 6) => \^m_axi_arqos[3]\(45 downto 38),
      \gen_no_arbiter.m_mesg_i_reg[45]\(5 downto 0) => \^m_axi_arqos[3]\(5 downto 0),
      \gen_no_arbiter.m_mesg_i_reg[5]\(5 downto 0) => \^q\(5 downto 0),
      \gen_no_arbiter.m_target_hot_i_reg[2]\(0) => aa_mi_awtarget_hot(2),
      \gen_no_arbiter.m_target_hot_i_reg[2]_0\(0) => aa_mi_artarget_hot(2),
      \gen_no_arbiter.m_target_hot_i_reg[2]_1\ => addr_arbiter_aw_n_5,
      m_ready_d(0) => m_ready_d_3(1),
      m_valid_i_reg => \gen_decerr_slave.decerr_slave_inst_n_7\,
      mi_arready_2 => mi_arready_2,
      mi_bready_2 => mi_bready_2,
      mi_rready_2 => mi_rready_2,
      p_11_in => p_11_in,
      p_17_in => p_17_in,
      p_1_in => p_1_in,
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_rlast_i => s_axi_rlast_i,
      \skid_buffer_reg[72]\(5 downto 0) => s_axi_rid_i(5 downto 0),
      \storage_data1_reg[1]\ => \gen_slave_slots[0].gen_si_write.wdata_router_w_n_4\,
      wr_tmp_wready(0) => wr_tmp_wready(2)
    );
\gen_master_slots[0].r_issuing_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => addr_arbiter_ar_n_76,
      Q => p_43_in,
      R => reset
    );
\gen_master_slots[0].reg_slice_mi\: entity work.rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice
     port map (
      D(7 downto 2) => m_axi_bid(5 downto 0),
      D(1 downto 0) => m_axi_bresp(1 downto 0),
      Q(72 downto 67) => st_mr_rid(5 downto 0),
      Q(66) => p_74_out,
      Q(65 downto 64) => st_mr_rmesg(1 downto 0),
      Q(63 downto 0) => st_mr_rmesg(66 downto 3),
      aclk => aclk,
      active_target_hot(0) => active_target_hot(0),
      active_target_hot_0(0) => active_target_hot_2(0),
      \aresetn_d_reg[0]\ => \gen_master_slots[1].reg_slice_mi_n_2\,
      \aresetn_d_reg[1]\ => \gen_master_slots[2].reg_slice_mi_n_1\,
      \gen_master_slots[0].r_issuing_cnt_reg[0]\ => \gen_master_slots[0].reg_slice_mi_n_78\,
      \gen_master_slots[0].r_issuing_cnt_reg[0]_0\ => addr_arbiter_ar_n_7,
      \gen_no_arbiter.m_target_hot_i_reg[2]\ => \gen_master_slots[0].reg_slice_mi_n_4\,
      \gen_single_issue.active_target_hot_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_4\,
      m_axi_bready(0) => m_axi_bready(0),
      m_axi_bvalid(0) => m_axi_bvalid(0),
      m_axi_rdata(63 downto 0) => m_axi_rdata(63 downto 0),
      m_axi_rid(5 downto 0) => m_axi_rid(5 downto 0),
      m_axi_rlast(0) => m_axi_rlast(0),
      \m_axi_rready[0]\ => M_AXI_RREADY(0),
      m_axi_rresp(1 downto 0) => m_axi_rresp(1 downto 0),
      m_axi_rvalid(0) => m_axi_rvalid(0),
      \m_payload_i_reg[66]\ => \gen_master_slots[2].reg_slice_mi_n_6\,
      m_valid_i_reg => \gen_master_slots[1].reg_slice_mi_n_6\,
      p_25_in => p_25_in,
      p_72_out => p_72_out,
      p_78_out => p_78_out,
      \s_axi_araddr[31]\ => addr_arbiter_ar_n_6,
      \s_axi_araddr[31]_0\(1 downto 0) => \s_axi_arqos[3]\(37 downto 36),
      \s_axi_bid[5]\(7 downto 2) => st_mr_bid(5 downto 0),
      \s_axi_bid[5]\(1 downto 0) => st_mr_bmesg(1 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_rready(0) => s_axi_rready(0)
    );
\gen_master_slots[0].w_issuing_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => addr_arbiter_aw_n_11,
      Q => p_52_in,
      R => reset
    );
\gen_master_slots[1].r_issuing_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => addr_arbiter_ar_n_78,
      Q => p_25_in,
      R => reset
    );
\gen_master_slots[1].reg_slice_mi\: entity work.rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_1
     port map (
      D(7 downto 2) => m_axi_bid(11 downto 6),
      D(1 downto 0) => m_axi_bresp(3 downto 2),
      Q(72 downto 67) => st_mr_rid(11 downto 6),
      Q(66) => p_52_out,
      Q(65 downto 64) => st_mr_rmesg(68 downto 67),
      Q(63 downto 0) => st_mr_rmesg(133 downto 70),
      aclk => aclk,
      active_target_enc(0) => active_target_enc(0),
      active_target_enc_0(0) => active_target_enc_1(0),
      aresetn => aresetn,
      \aresetn_d_reg[1]\ => \gen_master_slots[1].reg_slice_mi_n_80\,
      \aresetn_d_reg[1]_0\ => \gen_master_slots[2].reg_slice_mi_n_1\,
      \gen_master_slots[1].r_issuing_cnt_reg[8]\ => \gen_master_slots[1].reg_slice_mi_n_6\,
      \gen_no_arbiter.s_ready_i_reg[0]\ => \gen_master_slots[1].reg_slice_mi_n_5\,
      \gen_single_issue.active_target_enc_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_3\,
      m_axi_bready(0) => m_axi_bready(1),
      m_axi_bvalid(0) => m_axi_bvalid(1),
      m_axi_rdata(63 downto 0) => m_axi_rdata(127 downto 64),
      m_axi_rid(5 downto 0) => m_axi_rid(11 downto 6),
      m_axi_rlast(0) => m_axi_rlast(1),
      \m_axi_rready[1]\ => M_AXI_RREADY(1),
      m_axi_rresp(1 downto 0) => m_axi_rresp(3 downto 2),
      m_axi_rvalid(0) => m_axi_rvalid(1),
      \m_payload_i_reg[66]\ => \gen_master_slots[0].reg_slice_mi_n_78\,
      p_25_in => p_25_in,
      p_43_in => p_43_in,
      p_50_out => p_50_out,
      p_56_out => p_56_out,
      \s_axi_araddr[31]\(1 downto 0) => \s_axi_arqos[3]\(37 downto 36),
      \s_axi_bid[5]\(7 downto 2) => st_mr_bid(11 downto 6),
      \s_axi_bid[5]\(1 downto 0) => st_mr_bmesg(4 downto 3),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_rready(0) => s_axi_rready(0),
      s_ready_i_reg => \gen_master_slots[1].reg_slice_mi_n_2\
    );
\gen_master_slots[1].w_issuing_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => addr_arbiter_aw_n_10,
      Q => p_34_in,
      R => reset
    );
\gen_master_slots[2].r_issuing_cnt_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \gen_master_slots[2].reg_slice_mi_n_14\,
      Q => r_issuing_cnt(16),
      R => reset
    );
\gen_master_slots[2].reg_slice_mi\: entity work.rchip_axi4_xbar_axi_register_slice_v2_1_9_axi_register_slice_2
     port map (
      D(5 downto 0) => s_axi_bid_i(5 downto 0),
      Q(6 downto 1) => st_mr_rid(17 downto 12),
      Q(0) => p_30_out,
      aclk => aclk,
      active_target_enc(0) => active_target_enc_1(1),
      active_target_enc_0(0) => active_target_enc(1),
      \aresetn_d_reg[0]\ => \gen_master_slots[1].reg_slice_mi_n_2\,
      \aresetn_d_reg[0]_0\ => \gen_master_slots[1].reg_slice_mi_n_80\,
      \gen_axi.s_axi_bvalid_i_reg\ => \gen_decerr_slave.decerr_slave_inst_n_7\,
      \gen_axi.s_axi_rid_i_reg[5]\(5 downto 0) => s_axi_rid_i(5 downto 0),
      \gen_master_slots[2].r_issuing_cnt_reg[16]\ => \gen_master_slots[2].reg_slice_mi_n_14\,
      \gen_no_arbiter.m_valid_i_reg\ => addr_arbiter_ar_n_4,
      \gen_no_arbiter.s_ready_i_reg[0]\ => \gen_master_slots[2].reg_slice_mi_n_6\,
      m_valid_i_reg => \gen_master_slots[2].reg_slice_mi_n_1\,
      mi_bready_2 => mi_bready_2,
      mi_rready_2 => mi_rready_2,
      p_11_in => p_11_in,
      p_17_in => p_17_in,
      p_28_out => p_28_out,
      p_34_out => p_34_out,
      r_issuing_cnt(0) => r_issuing_cnt(16),
      \s_axi_araddr[31]\(0) => \s_axi_arqos[3]\(37),
      \s_axi_bid[5]\(5 downto 0) => st_mr_bid(17 downto 12),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_rlast_i => s_axi_rlast_i,
      s_axi_rready(0) => s_axi_rready(0),
      s_ready_i_reg => \gen_master_slots[2].reg_slice_mi_n_5\
    );
\gen_master_slots[2].w_issuing_cnt_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => addr_arbiter_aw_n_12,
      Q => w_issuing_cnt(16),
      R => reset
    );
\gen_slave_slots[0].gen_si_read.si_transactor_ar\: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor
     port map (
      Q(0) => p_52_out,
      SR(0) => reset,
      S_AXI_ARREADY(0) => \^s_axi_arready\(0),
      aclk => aclk,
      active_target_enc(1 downto 0) => active_target_enc(1 downto 0),
      active_target_hot(0) => active_target_hot(0),
      aresetn_d => aresetn_d,
      \gen_master_slots[1].r_issuing_cnt_reg[8]\ => \gen_master_slots[1].reg_slice_mi_n_5\,
      \gen_no_arbiter.m_target_hot_i_reg[2]\ => \gen_slave_slots[0].gen_si_read.si_transactor_ar_n_4\,
      \gen_no_arbiter.m_valid_i_reg\ => addr_arbiter_ar_n_8,
      \gen_no_arbiter.s_ready_i_reg[0]\ => addr_arbiter_ar_n_77,
      \gen_no_arbiter.s_ready_i_reg[0]_0\ => addr_arbiter_ar_n_75,
      \gen_no_arbiter.s_ready_i_reg[0]_1\ => addr_arbiter_ar_n_79,
      \m_payload_i_reg[66]\ => \gen_master_slots[2].reg_slice_mi_n_6\,
      \m_payload_i_reg[66]_0\(0) => p_30_out,
      \m_payload_i_reg[66]_1\(0) => p_74_out,
      p_28_out => p_28_out,
      p_50_out => p_50_out,
      p_72_out => p_72_out,
      s_axi_rdata(63 downto 0) => s_axi_rdata(63 downto 0),
      s_axi_rid(5 downto 0) => s_axi_rid(5 downto 0),
      \s_axi_rlast[0]\ => \s_axi_rlast[0]\,
      s_axi_rready(0) => s_axi_rready(0),
      s_axi_rresp(1 downto 0) => s_axi_rresp(1 downto 0),
      \s_axi_rvalid[0]\ => \s_axi_rvalid[0]\,
      s_ready_i0 => s_ready_i0,
      st_mr_rid(17 downto 0) => st_mr_rid(17 downto 0),
      st_mr_rmesg(131 downto 68) => st_mr_rmesg(133 downto 70),
      st_mr_rmesg(67 downto 2) => st_mr_rmesg(68 downto 3),
      st_mr_rmesg(1 downto 0) => st_mr_rmesg(1 downto 0)
    );
\gen_slave_slots[0].gen_si_write.si_transactor_aw\: entity work.\rchip_axi4_xbar_axi_crossbar_v2_1_10_si_transactor__parameterized0\
     port map (
      SR(0) => reset,
      aclk => aclk,
      active_target_enc(1 downto 0) => active_target_enc_1(1 downto 0),
      active_target_hot(0) => active_target_hot_2(0),
      aresetn_d => aresetn_d,
      \aresetn_d_reg[1]\ => \gen_master_slots[2].reg_slice_mi_n_5\,
      \gen_master_slots[0].w_issuing_cnt_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_11\,
      \gen_master_slots[1].w_issuing_cnt_reg[8]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_10\,
      \gen_no_arbiter.m_target_hot_i_reg[2]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_8\,
      \gen_no_arbiter.m_valid_i_reg\ => addr_arbiter_aw_n_8,
      \gen_no_arbiter.s_ready_i_reg[0]\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_6\,
      \gen_no_arbiter.s_ready_i_reg[0]_0\ => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_7\,
      \gen_single_issue.active_target_enc_reg[0]_0\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_4\,
      \gen_single_issue.active_target_hot_reg[0]_0\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_6\,
      m_axi_bvalid(1 downto 0) => m_axi_bvalid(1 downto 0),
      \m_ready_d_reg[1]\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_5\,
      \m_ready_d_reg[1]_0\ => \^s_axi_awready[0]\,
      p_34_in => p_34_in,
      p_34_out => p_34_out,
      p_52_in => p_52_in,
      p_56_out => p_56_out,
      p_78_out => p_78_out,
      s_axi_awaddr(1 downto 0) => s_axi_awaddr(31 downto 30),
      s_axi_bid(5 downto 0) => s_axi_bid(5 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_bresp(1 downto 0) => s_axi_bresp(1 downto 0),
      \s_axi_bvalid[0]\ => \s_axi_bvalid[0]\,
      s_ready_i0 => s_ready_i0_0,
      s_ready_i_reg => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_3\,
      s_ready_i_reg_0 => \gen_slave_slots[0].gen_si_write.si_transactor_aw_n_4\,
      st_mr_bid(17 downto 0) => st_mr_bid(17 downto 0),
      st_mr_bmesg(3 downto 2) => st_mr_bmesg(4 downto 3),
      st_mr_bmesg(1 downto 0) => st_mr_bmesg(1 downto 0),
      w_issuing_cnt(0) => w_issuing_cnt(16)
    );
\gen_slave_slots[0].gen_si_write.splitter_aw_si\: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter
     port map (
      aclk => aclk,
      active_target_enc(1 downto 0) => active_target_enc_1(1 downto 0),
      active_target_hot(0) => active_target_hot_2(0),
      aresetn_d => aresetn_d,
      \gen_single_issue.active_target_enc_reg[0]\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_4\,
      \gen_single_issue.active_target_enc_reg[1]\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_5\,
      \gen_single_issue.active_target_hot_reg[0]\ => \gen_slave_slots[0].gen_si_write.splitter_aw_si_n_6\,
      m_ready_d(1 downto 0) => m_ready_d(1 downto 0),
      s_axi_awaddr(1 downto 0) => s_axi_awaddr(31 downto 30),
      \s_axi_awready[0]\ => \^s_axi_awready[0]\,
      s_axi_awvalid(0) => s_axi_awvalid(0),
      ss_aa_awready => ss_aa_awready,
      ss_wr_awready => ss_wr_awready,
      ss_wr_awvalid => ss_wr_awvalid
    );
\gen_slave_slots[0].gen_si_write.wdata_router_w\: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_wdata_router
     port map (
      SR(0) => reset,
      aclk => aclk,
      \gen_axi.write_cs_reg[1]\ => \gen_slave_slots[0].gen_si_write.wdata_router_w_n_4\,
      \gen_axi.write_cs_reg[1]_0\(0) => write_cs(1),
      m_axi_wready(1 downto 0) => m_axi_wready(1 downto 0),
      m_axi_wvalid(1 downto 0) => m_axi_wvalid(1 downto 0),
      m_ready_d(0) => m_ready_d(1),
      s_axi_awaddr(1 downto 0) => s_axi_awaddr(31 downto 30),
      s_axi_awvalid(0) => s_axi_awvalid(0),
      s_axi_wlast(0) => s_axi_wlast(0),
      s_axi_wready(0) => s_axi_wready(0),
      s_axi_wvalid(0) => s_axi_wvalid(0),
      ss_wr_awready => ss_wr_awready,
      ss_wr_awvalid => ss_wr_awvalid,
      st_aa_awtarget_enc(0) => st_aa_awtarget_enc(0),
      wr_tmp_wready(0) => wr_tmp_wready(2)
    );
splitter_aw_mi: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_splitter_3
     port map (
      aa_sa_awvalid => aa_sa_awvalid,
      aclk => aclk,
      aresetn_d => aresetn_d,
      \gen_axi.s_axi_awready_i_reg\ => addr_arbiter_aw_n_6,
      \gen_no_arbiter.m_target_hot_i_reg[0]\ => addr_arbiter_aw_n_9,
      m_ready_d(1 downto 0) => m_ready_d_3(1 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_buser : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_aruser : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_ruser : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_awlen : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_awsize : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_awburst : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awcache : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_awregion : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awqos : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awuser : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_wlast : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wuser : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_buser : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_araddr : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_arlen : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_arsize : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_arburst : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arcache : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_arregion : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arqos : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_aruser : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_ruser : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rready : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute C_AXI_ADDR_WIDTH : integer;
  attribute C_AXI_ADDR_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 32;
  attribute C_AXI_ARUSER_WIDTH : integer;
  attribute C_AXI_ARUSER_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_AXI_AWUSER_WIDTH : integer;
  attribute C_AXI_AWUSER_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_AXI_BUSER_WIDTH : integer;
  attribute C_AXI_BUSER_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_AXI_DATA_WIDTH : integer;
  attribute C_AXI_DATA_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 64;
  attribute C_AXI_ID_WIDTH : integer;
  attribute C_AXI_ID_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 6;
  attribute C_AXI_PROTOCOL : integer;
  attribute C_AXI_PROTOCOL of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute C_AXI_RUSER_WIDTH : integer;
  attribute C_AXI_RUSER_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_AXI_SUPPORTS_USER_SIGNALS : integer;
  attribute C_AXI_SUPPORTS_USER_SIGNALS of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute C_AXI_WUSER_WIDTH : integer;
  attribute C_AXI_WUSER_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_CONNECTIVITY_MODE : integer;
  attribute C_CONNECTIVITY_MODE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_DEBUG : integer;
  attribute C_DEBUG of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "zynq";
  attribute C_M_AXI_ADDR_WIDTH : string;
  attribute C_M_AXI_ADDR_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000001111000000000000000000000000000011110";
  attribute C_M_AXI_BASE_ADDR : string;
  attribute C_M_AXI_BASE_ADDR of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "128'b00000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  attribute C_M_AXI_READ_CONNECTIVITY : string;
  attribute C_M_AXI_READ_CONNECTIVITY of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b1111111111111111111111111111111111111111111111111111111111111111";
  attribute C_M_AXI_READ_ISSUING : string;
  attribute C_M_AXI_READ_ISSUING of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000100000000000000000000000000000001";
  attribute C_M_AXI_SECURE : string;
  attribute C_M_AXI_SECURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute C_M_AXI_WRITE_CONNECTIVITY : string;
  attribute C_M_AXI_WRITE_CONNECTIVITY of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b1111111111111111111111111111111111111111111111111111111111111111";
  attribute C_M_AXI_WRITE_ISSUING : string;
  attribute C_M_AXI_WRITE_ISSUING of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000100000000000000000000000000000001";
  attribute C_NUM_ADDR_RANGES : integer;
  attribute C_NUM_ADDR_RANGES of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_NUM_MASTER_SLOTS : integer;
  attribute C_NUM_MASTER_SLOTS of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 2;
  attribute C_NUM_SLAVE_SLOTS : integer;
  attribute C_NUM_SLAVE_SLOTS of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_R_REGISTER : integer;
  attribute C_R_REGISTER of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute C_S_AXI_ARB_PRIORITY : integer;
  attribute C_S_AXI_ARB_PRIORITY of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute C_S_AXI_BASE_ID : integer;
  attribute C_S_AXI_BASE_ID of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute C_S_AXI_READ_ACCEPTANCE : integer;
  attribute C_S_AXI_READ_ACCEPTANCE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_S_AXI_SINGLE_THREAD : integer;
  attribute C_S_AXI_SINGLE_THREAD of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute C_S_AXI_THREAD_ID_WIDTH : integer;
  attribute C_S_AXI_THREAD_ID_WIDTH of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 6;
  attribute C_S_AXI_WRITE_ACCEPTANCE : integer;
  attribute C_S_AXI_WRITE_ACCEPTANCE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "yes";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "axi_crossbar_v2_1_10_axi_crossbar";
  attribute P_ADDR_DECODE : integer;
  attribute P_ADDR_DECODE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute P_AXI3 : integer;
  attribute P_AXI3 of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute P_AXI4 : integer;
  attribute P_AXI4 of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 0;
  attribute P_AXILITE : integer;
  attribute P_AXILITE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 2;
  attribute P_AXILITE_SIZE : string;
  attribute P_AXILITE_SIZE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "3'b010";
  attribute P_FAMILY : string;
  attribute P_FAMILY of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "zynq";
  attribute P_INCR : string;
  attribute P_INCR of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "2'b01";
  attribute P_LEN : integer;
  attribute P_LEN of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 8;
  attribute P_LOCK : integer;
  attribute P_LOCK of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute P_M_AXI_ERR_MODE : string;
  attribute P_M_AXI_ERR_MODE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute P_M_AXI_SUPPORTS_READ : string;
  attribute P_M_AXI_SUPPORTS_READ of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "2'b11";
  attribute P_M_AXI_SUPPORTS_WRITE : string;
  attribute P_M_AXI_SUPPORTS_WRITE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "2'b11";
  attribute P_ONES : string;
  attribute P_ONES of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "65'b11111111111111111111111111111111111111111111111111111111111111111";
  attribute P_RANGE_CHECK : integer;
  attribute P_RANGE_CHECK of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is 1;
  attribute P_S_AXI_BASE_ID : string;
  attribute P_S_AXI_BASE_ID of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute P_S_AXI_HIGH_ID : string;
  attribute P_S_AXI_HIGH_ID of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "64'b0000000000000000000000000000000000000000000000000000000000111111";
  attribute P_S_AXI_SUPPORTS_READ : string;
  attribute P_S_AXI_SUPPORTS_READ of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "1'b1";
  attribute P_S_AXI_SUPPORTS_WRITE : string;
  attribute P_S_AXI_SUPPORTS_WRITE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar : entity is "1'b1";
end rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar;

architecture STRUCTURE of rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar is
  signal \<const0>\ : STD_LOGIC;
  signal \^m_axi_araddr\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^m_axi_arburst\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^m_axi_arcache\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_arid\ : STD_LOGIC_VECTOR ( 11 downto 6 );
  signal \^m_axi_arlen\ : STD_LOGIC_VECTOR ( 15 downto 8 );
  signal \^m_axi_arlock\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^m_axi_arprot\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^m_axi_arqos\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_arsize\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^m_axi_awaddr\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^m_axi_awburst\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^m_axi_awcache\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_awid\ : STD_LOGIC_VECTOR ( 11 downto 6 );
  signal \^m_axi_awlen\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^m_axi_awlock\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^m_axi_awprot\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^m_axi_awqos\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^m_axi_awsize\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s_axi_wdata\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \^s_axi_wlast\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^s_axi_wstrb\ : STD_LOGIC_VECTOR ( 7 downto 0 );
begin
  \^s_axi_wdata\(63 downto 0) <= s_axi_wdata(63 downto 0);
  \^s_axi_wlast\(0) <= s_axi_wlast(0);
  \^s_axi_wstrb\(7 downto 0) <= s_axi_wstrb(7 downto 0);
  m_axi_araddr(63 downto 32) <= \^m_axi_araddr\(31 downto 0);
  m_axi_araddr(31 downto 0) <= \^m_axi_araddr\(31 downto 0);
  m_axi_arburst(3 downto 2) <= \^m_axi_arburst\(1 downto 0);
  m_axi_arburst(1 downto 0) <= \^m_axi_arburst\(1 downto 0);
  m_axi_arcache(7 downto 4) <= \^m_axi_arcache\(3 downto 0);
  m_axi_arcache(3 downto 0) <= \^m_axi_arcache\(3 downto 0);
  m_axi_arid(11 downto 6) <= \^m_axi_arid\(11 downto 6);
  m_axi_arid(5 downto 0) <= \^m_axi_arid\(11 downto 6);
  m_axi_arlen(15 downto 8) <= \^m_axi_arlen\(15 downto 8);
  m_axi_arlen(7 downto 0) <= \^m_axi_arlen\(15 downto 8);
  m_axi_arlock(1) <= \^m_axi_arlock\(0);
  m_axi_arlock(0) <= \^m_axi_arlock\(0);
  m_axi_arprot(5 downto 3) <= \^m_axi_arprot\(2 downto 0);
  m_axi_arprot(2 downto 0) <= \^m_axi_arprot\(2 downto 0);
  m_axi_arqos(7 downto 4) <= \^m_axi_arqos\(3 downto 0);
  m_axi_arqos(3 downto 0) <= \^m_axi_arqos\(3 downto 0);
  m_axi_arregion(7) <= \<const0>\;
  m_axi_arregion(6) <= \<const0>\;
  m_axi_arregion(5) <= \<const0>\;
  m_axi_arregion(4) <= \<const0>\;
  m_axi_arregion(3) <= \<const0>\;
  m_axi_arregion(2) <= \<const0>\;
  m_axi_arregion(1) <= \<const0>\;
  m_axi_arregion(0) <= \<const0>\;
  m_axi_arsize(5 downto 3) <= \^m_axi_arsize\(2 downto 0);
  m_axi_arsize(2 downto 0) <= \^m_axi_arsize\(2 downto 0);
  m_axi_aruser(1) <= \<const0>\;
  m_axi_aruser(0) <= \<const0>\;
  m_axi_awaddr(63 downto 32) <= \^m_axi_awaddr\(31 downto 0);
  m_axi_awaddr(31 downto 0) <= \^m_axi_awaddr\(31 downto 0);
  m_axi_awburst(3 downto 2) <= \^m_axi_awburst\(1 downto 0);
  m_axi_awburst(1 downto 0) <= \^m_axi_awburst\(1 downto 0);
  m_axi_awcache(7 downto 4) <= \^m_axi_awcache\(3 downto 0);
  m_axi_awcache(3 downto 0) <= \^m_axi_awcache\(3 downto 0);
  m_axi_awid(11 downto 6) <= \^m_axi_awid\(11 downto 6);
  m_axi_awid(5 downto 0) <= \^m_axi_awid\(11 downto 6);
  m_axi_awlen(15 downto 8) <= \^m_axi_awlen\(7 downto 0);
  m_axi_awlen(7 downto 0) <= \^m_axi_awlen\(7 downto 0);
  m_axi_awlock(1) <= \^m_axi_awlock\(0);
  m_axi_awlock(0) <= \^m_axi_awlock\(0);
  m_axi_awprot(5 downto 3) <= \^m_axi_awprot\(2 downto 0);
  m_axi_awprot(2 downto 0) <= \^m_axi_awprot\(2 downto 0);
  m_axi_awqos(7 downto 4) <= \^m_axi_awqos\(3 downto 0);
  m_axi_awqos(3 downto 0) <= \^m_axi_awqos\(3 downto 0);
  m_axi_awregion(7) <= \<const0>\;
  m_axi_awregion(6) <= \<const0>\;
  m_axi_awregion(5) <= \<const0>\;
  m_axi_awregion(4) <= \<const0>\;
  m_axi_awregion(3) <= \<const0>\;
  m_axi_awregion(2) <= \<const0>\;
  m_axi_awregion(1) <= \<const0>\;
  m_axi_awregion(0) <= \<const0>\;
  m_axi_awsize(5 downto 3) <= \^m_axi_awsize\(2 downto 0);
  m_axi_awsize(2 downto 0) <= \^m_axi_awsize\(2 downto 0);
  m_axi_awuser(1) <= \<const0>\;
  m_axi_awuser(0) <= \<const0>\;
  m_axi_wdata(127 downto 64) <= \^s_axi_wdata\(63 downto 0);
  m_axi_wdata(63 downto 0) <= \^s_axi_wdata\(63 downto 0);
  m_axi_wid(11) <= \<const0>\;
  m_axi_wid(10) <= \<const0>\;
  m_axi_wid(9) <= \<const0>\;
  m_axi_wid(8) <= \<const0>\;
  m_axi_wid(7) <= \<const0>\;
  m_axi_wid(6) <= \<const0>\;
  m_axi_wid(5) <= \<const0>\;
  m_axi_wid(4) <= \<const0>\;
  m_axi_wid(3) <= \<const0>\;
  m_axi_wid(2) <= \<const0>\;
  m_axi_wid(1) <= \<const0>\;
  m_axi_wid(0) <= \<const0>\;
  m_axi_wlast(1) <= \^s_axi_wlast\(0);
  m_axi_wlast(0) <= \^s_axi_wlast\(0);
  m_axi_wstrb(15 downto 8) <= \^s_axi_wstrb\(7 downto 0);
  m_axi_wstrb(7 downto 0) <= \^s_axi_wstrb\(7 downto 0);
  m_axi_wuser(1) <= \<const0>\;
  m_axi_wuser(0) <= \<const0>\;
  s_axi_buser(0) <= \<const0>\;
  s_axi_ruser(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\gen_samd.crossbar_samd\: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_crossbar
     port map (
      D(30 downto 27) => s_axi_awqos(3 downto 0),
      D(26 downto 23) => s_axi_awcache(3 downto 0),
      D(22 downto 21) => s_axi_awburst(1 downto 0),
      D(20 downto 18) => s_axi_awprot(2 downto 0),
      D(17) => s_axi_awlock(0),
      D(16 downto 14) => s_axi_awsize(2 downto 0),
      D(13 downto 6) => s_axi_awlen(7 downto 0),
      D(5 downto 0) => s_axi_awid(5 downto 0),
      M_AXI_RREADY(1 downto 0) => m_axi_rready(1 downto 0),
      Q(62 downto 59) => \^m_axi_awqos\(3 downto 0),
      Q(58 downto 55) => \^m_axi_awcache\(3 downto 0),
      Q(54 downto 53) => \^m_axi_awburst\(1 downto 0),
      Q(52 downto 50) => \^m_axi_awprot\(2 downto 0),
      Q(49) => \^m_axi_awlock\(0),
      Q(48 downto 46) => \^m_axi_awsize\(2 downto 0),
      Q(45 downto 38) => \^m_axi_awlen\(7 downto 0),
      Q(37 downto 6) => \^m_axi_awaddr\(31 downto 0),
      Q(5 downto 0) => \^m_axi_awid\(11 downto 6),
      S_AXI_ARREADY(0) => s_axi_arready(0),
      aclk => aclk,
      aresetn => aresetn,
      \m_axi_arqos[3]\(62 downto 59) => \^m_axi_arqos\(3 downto 0),
      \m_axi_arqos[3]\(58 downto 55) => \^m_axi_arcache\(3 downto 0),
      \m_axi_arqos[3]\(54 downto 53) => \^m_axi_arburst\(1 downto 0),
      \m_axi_arqos[3]\(52 downto 50) => \^m_axi_arprot\(2 downto 0),
      \m_axi_arqos[3]\(49) => \^m_axi_arlock\(0),
      \m_axi_arqos[3]\(48 downto 46) => \^m_axi_arsize\(2 downto 0),
      \m_axi_arqos[3]\(45 downto 38) => \^m_axi_arlen\(15 downto 8),
      \m_axi_arqos[3]\(37 downto 6) => \^m_axi_araddr\(31 downto 0),
      \m_axi_arqos[3]\(5 downto 0) => \^m_axi_arid\(11 downto 6),
      m_axi_arready(1 downto 0) => m_axi_arready(1 downto 0),
      m_axi_arvalid(1 downto 0) => m_axi_arvalid(1 downto 0),
      m_axi_awready(1 downto 0) => m_axi_awready(1 downto 0),
      m_axi_awvalid(1 downto 0) => m_axi_awvalid(1 downto 0),
      m_axi_bid(11 downto 0) => m_axi_bid(11 downto 0),
      m_axi_bready(1 downto 0) => m_axi_bready(1 downto 0),
      m_axi_bresp(3 downto 0) => m_axi_bresp(3 downto 0),
      m_axi_bvalid(1 downto 0) => m_axi_bvalid(1 downto 0),
      m_axi_rdata(127 downto 0) => m_axi_rdata(127 downto 0),
      m_axi_rid(11 downto 0) => m_axi_rid(11 downto 0),
      m_axi_rlast(1 downto 0) => m_axi_rlast(1 downto 0),
      m_axi_rresp(3 downto 0) => m_axi_rresp(3 downto 0),
      m_axi_rvalid(1 downto 0) => m_axi_rvalid(1 downto 0),
      m_axi_wready(1 downto 0) => m_axi_wready(1 downto 0),
      m_axi_wvalid(1 downto 0) => m_axi_wvalid(1 downto 0),
      \s_axi_arqos[3]\(62 downto 59) => s_axi_arqos(3 downto 0),
      \s_axi_arqos[3]\(58 downto 55) => s_axi_arcache(3 downto 0),
      \s_axi_arqos[3]\(54 downto 53) => s_axi_arburst(1 downto 0),
      \s_axi_arqos[3]\(52 downto 50) => s_axi_arprot(2 downto 0),
      \s_axi_arqos[3]\(49) => s_axi_arlock(0),
      \s_axi_arqos[3]\(48 downto 46) => s_axi_arsize(2 downto 0),
      \s_axi_arqos[3]\(45 downto 38) => s_axi_arlen(7 downto 0),
      \s_axi_arqos[3]\(37 downto 6) => s_axi_araddr(31 downto 0),
      \s_axi_arqos[3]\(5 downto 0) => s_axi_arid(5 downto 0),
      s_axi_arvalid(0) => s_axi_arvalid(0),
      s_axi_awaddr(31 downto 0) => s_axi_awaddr(31 downto 0),
      \s_axi_awready[0]\ => s_axi_awready(0),
      s_axi_awvalid(0) => s_axi_awvalid(0),
      s_axi_bid(5 downto 0) => s_axi_bid(5 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_bresp(1 downto 0) => s_axi_bresp(1 downto 0),
      \s_axi_bvalid[0]\ => s_axi_bvalid(0),
      s_axi_rdata(63 downto 0) => s_axi_rdata(63 downto 0),
      s_axi_rid(5 downto 0) => s_axi_rid(5 downto 0),
      \s_axi_rlast[0]\ => s_axi_rlast(0),
      s_axi_rready(0) => s_axi_rready(0),
      s_axi_rresp(1 downto 0) => s_axi_rresp(1 downto 0),
      \s_axi_rvalid[0]\ => s_axi_rvalid(0),
      s_axi_wlast(0) => \^s_axi_wlast\(0),
      s_axi_wready(0) => s_axi_wready(0),
      s_axi_wvalid(0) => s_axi_wvalid(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rchip_axi4_xbar is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_awlen : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_awsize : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_awburst : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_awlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awcache : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_awregion : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awqos : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_wlast : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_araddr : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axi_arlen : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axi_arsize : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_arburst : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_arlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arcache : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_axi_arregion : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arqos : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_rlast : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rready : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of rchip_axi4_xbar : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of rchip_axi4_xbar : entity is "rchip_axi4_xbar,axi_crossbar_v2_1_10_axi_crossbar,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of rchip_axi4_xbar : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of rchip_axi4_xbar : entity is "axi_crossbar_v2_1_10_axi_crossbar,Vivado 2016.2";
end rchip_axi4_xbar;

architecture STRUCTURE of rchip_axi4_xbar is
  signal NLW_inst_m_axi_aruser_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axi_awuser_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_m_axi_wid_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_inst_m_axi_wuser_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_inst_s_axi_buser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_inst_s_axi_ruser_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute C_AXI_ADDR_WIDTH : integer;
  attribute C_AXI_ADDR_WIDTH of inst : label is 32;
  attribute C_AXI_ARUSER_WIDTH : integer;
  attribute C_AXI_ARUSER_WIDTH of inst : label is 1;
  attribute C_AXI_AWUSER_WIDTH : integer;
  attribute C_AXI_AWUSER_WIDTH of inst : label is 1;
  attribute C_AXI_BUSER_WIDTH : integer;
  attribute C_AXI_BUSER_WIDTH of inst : label is 1;
  attribute C_AXI_DATA_WIDTH : integer;
  attribute C_AXI_DATA_WIDTH of inst : label is 64;
  attribute C_AXI_ID_WIDTH : integer;
  attribute C_AXI_ID_WIDTH of inst : label is 6;
  attribute C_AXI_PROTOCOL : integer;
  attribute C_AXI_PROTOCOL of inst : label is 0;
  attribute C_AXI_RUSER_WIDTH : integer;
  attribute C_AXI_RUSER_WIDTH of inst : label is 1;
  attribute C_AXI_SUPPORTS_USER_SIGNALS : integer;
  attribute C_AXI_SUPPORTS_USER_SIGNALS of inst : label is 0;
  attribute C_AXI_WUSER_WIDTH : integer;
  attribute C_AXI_WUSER_WIDTH of inst : label is 1;
  attribute C_CONNECTIVITY_MODE : integer;
  attribute C_CONNECTIVITY_MODE of inst : label is 1;
  attribute C_DEBUG : integer;
  attribute C_DEBUG of inst : label is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of inst : label is "zynq";
  attribute C_M_AXI_ADDR_WIDTH : string;
  attribute C_M_AXI_ADDR_WIDTH of inst : label is "64'b0000000000000000000000000001111000000000000000000000000000011110";
  attribute C_M_AXI_BASE_ADDR : string;
  attribute C_M_AXI_BASE_ADDR of inst : label is "128'b00000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  attribute C_M_AXI_READ_CONNECTIVITY : string;
  attribute C_M_AXI_READ_CONNECTIVITY of inst : label is "64'b1111111111111111111111111111111111111111111111111111111111111111";
  attribute C_M_AXI_READ_ISSUING : string;
  attribute C_M_AXI_READ_ISSUING of inst : label is "64'b0000000000000000000000000000000100000000000000000000000000000001";
  attribute C_M_AXI_SECURE : string;
  attribute C_M_AXI_SECURE of inst : label is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute C_M_AXI_WRITE_CONNECTIVITY : string;
  attribute C_M_AXI_WRITE_CONNECTIVITY of inst : label is "64'b1111111111111111111111111111111111111111111111111111111111111111";
  attribute C_M_AXI_WRITE_ISSUING : string;
  attribute C_M_AXI_WRITE_ISSUING of inst : label is "64'b0000000000000000000000000000000100000000000000000000000000000001";
  attribute C_NUM_ADDR_RANGES : integer;
  attribute C_NUM_ADDR_RANGES of inst : label is 1;
  attribute C_NUM_MASTER_SLOTS : integer;
  attribute C_NUM_MASTER_SLOTS of inst : label is 2;
  attribute C_NUM_SLAVE_SLOTS : integer;
  attribute C_NUM_SLAVE_SLOTS of inst : label is 1;
  attribute C_R_REGISTER : integer;
  attribute C_R_REGISTER of inst : label is 0;
  attribute C_S_AXI_ARB_PRIORITY : integer;
  attribute C_S_AXI_ARB_PRIORITY of inst : label is 0;
  attribute C_S_AXI_BASE_ID : integer;
  attribute C_S_AXI_BASE_ID of inst : label is 0;
  attribute C_S_AXI_READ_ACCEPTANCE : integer;
  attribute C_S_AXI_READ_ACCEPTANCE of inst : label is 1;
  attribute C_S_AXI_SINGLE_THREAD : integer;
  attribute C_S_AXI_SINGLE_THREAD of inst : label is 1;
  attribute C_S_AXI_THREAD_ID_WIDTH : integer;
  attribute C_S_AXI_THREAD_ID_WIDTH of inst : label is 6;
  attribute C_S_AXI_WRITE_ACCEPTANCE : integer;
  attribute C_S_AXI_WRITE_ACCEPTANCE of inst : label is 1;
  attribute DowngradeIPIdentifiedWarnings of inst : label is "yes";
  attribute P_ADDR_DECODE : integer;
  attribute P_ADDR_DECODE of inst : label is 1;
  attribute P_AXI3 : integer;
  attribute P_AXI3 of inst : label is 1;
  attribute P_AXI4 : integer;
  attribute P_AXI4 of inst : label is 0;
  attribute P_AXILITE : integer;
  attribute P_AXILITE of inst : label is 2;
  attribute P_AXILITE_SIZE : string;
  attribute P_AXILITE_SIZE of inst : label is "3'b010";
  attribute P_FAMILY : string;
  attribute P_FAMILY of inst : label is "zynq";
  attribute P_INCR : string;
  attribute P_INCR of inst : label is "2'b01";
  attribute P_LEN : integer;
  attribute P_LEN of inst : label is 8;
  attribute P_LOCK : integer;
  attribute P_LOCK of inst : label is 1;
  attribute P_M_AXI_ERR_MODE : string;
  attribute P_M_AXI_ERR_MODE of inst : label is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute P_M_AXI_SUPPORTS_READ : string;
  attribute P_M_AXI_SUPPORTS_READ of inst : label is "2'b11";
  attribute P_M_AXI_SUPPORTS_WRITE : string;
  attribute P_M_AXI_SUPPORTS_WRITE of inst : label is "2'b11";
  attribute P_ONES : string;
  attribute P_ONES of inst : label is "65'b11111111111111111111111111111111111111111111111111111111111111111";
  attribute P_RANGE_CHECK : integer;
  attribute P_RANGE_CHECK of inst : label is 1;
  attribute P_S_AXI_BASE_ID : string;
  attribute P_S_AXI_BASE_ID of inst : label is "64'b0000000000000000000000000000000000000000000000000000000000000000";
  attribute P_S_AXI_HIGH_ID : string;
  attribute P_S_AXI_HIGH_ID of inst : label is "64'b0000000000000000000000000000000000000000000000000000000000111111";
  attribute P_S_AXI_SUPPORTS_READ : string;
  attribute P_S_AXI_SUPPORTS_READ of inst : label is "1'b1";
  attribute P_S_AXI_SUPPORTS_WRITE : string;
  attribute P_S_AXI_SUPPORTS_WRITE of inst : label is "1'b1";
begin
inst: entity work.rchip_axi4_xbar_axi_crossbar_v2_1_10_axi_crossbar
     port map (
      aclk => aclk,
      aresetn => aresetn,
      m_axi_araddr(63 downto 0) => m_axi_araddr(63 downto 0),
      m_axi_arburst(3 downto 0) => m_axi_arburst(3 downto 0),
      m_axi_arcache(7 downto 0) => m_axi_arcache(7 downto 0),
      m_axi_arid(11 downto 0) => m_axi_arid(11 downto 0),
      m_axi_arlen(15 downto 0) => m_axi_arlen(15 downto 0),
      m_axi_arlock(1 downto 0) => m_axi_arlock(1 downto 0),
      m_axi_arprot(5 downto 0) => m_axi_arprot(5 downto 0),
      m_axi_arqos(7 downto 0) => m_axi_arqos(7 downto 0),
      m_axi_arready(1 downto 0) => m_axi_arready(1 downto 0),
      m_axi_arregion(7 downto 0) => m_axi_arregion(7 downto 0),
      m_axi_arsize(5 downto 0) => m_axi_arsize(5 downto 0),
      m_axi_aruser(1 downto 0) => NLW_inst_m_axi_aruser_UNCONNECTED(1 downto 0),
      m_axi_arvalid(1 downto 0) => m_axi_arvalid(1 downto 0),
      m_axi_awaddr(63 downto 0) => m_axi_awaddr(63 downto 0),
      m_axi_awburst(3 downto 0) => m_axi_awburst(3 downto 0),
      m_axi_awcache(7 downto 0) => m_axi_awcache(7 downto 0),
      m_axi_awid(11 downto 0) => m_axi_awid(11 downto 0),
      m_axi_awlen(15 downto 0) => m_axi_awlen(15 downto 0),
      m_axi_awlock(1 downto 0) => m_axi_awlock(1 downto 0),
      m_axi_awprot(5 downto 0) => m_axi_awprot(5 downto 0),
      m_axi_awqos(7 downto 0) => m_axi_awqos(7 downto 0),
      m_axi_awready(1 downto 0) => m_axi_awready(1 downto 0),
      m_axi_awregion(7 downto 0) => m_axi_awregion(7 downto 0),
      m_axi_awsize(5 downto 0) => m_axi_awsize(5 downto 0),
      m_axi_awuser(1 downto 0) => NLW_inst_m_axi_awuser_UNCONNECTED(1 downto 0),
      m_axi_awvalid(1 downto 0) => m_axi_awvalid(1 downto 0),
      m_axi_bid(11 downto 0) => m_axi_bid(11 downto 0),
      m_axi_bready(1 downto 0) => m_axi_bready(1 downto 0),
      m_axi_bresp(3 downto 0) => m_axi_bresp(3 downto 0),
      m_axi_buser(1 downto 0) => B"00",
      m_axi_bvalid(1 downto 0) => m_axi_bvalid(1 downto 0),
      m_axi_rdata(127 downto 0) => m_axi_rdata(127 downto 0),
      m_axi_rid(11 downto 0) => m_axi_rid(11 downto 0),
      m_axi_rlast(1 downto 0) => m_axi_rlast(1 downto 0),
      m_axi_rready(1 downto 0) => m_axi_rready(1 downto 0),
      m_axi_rresp(3 downto 0) => m_axi_rresp(3 downto 0),
      m_axi_ruser(1 downto 0) => B"00",
      m_axi_rvalid(1 downto 0) => m_axi_rvalid(1 downto 0),
      m_axi_wdata(127 downto 0) => m_axi_wdata(127 downto 0),
      m_axi_wid(11 downto 0) => NLW_inst_m_axi_wid_UNCONNECTED(11 downto 0),
      m_axi_wlast(1 downto 0) => m_axi_wlast(1 downto 0),
      m_axi_wready(1 downto 0) => m_axi_wready(1 downto 0),
      m_axi_wstrb(15 downto 0) => m_axi_wstrb(15 downto 0),
      m_axi_wuser(1 downto 0) => NLW_inst_m_axi_wuser_UNCONNECTED(1 downto 0),
      m_axi_wvalid(1 downto 0) => m_axi_wvalid(1 downto 0),
      s_axi_araddr(31 downto 0) => s_axi_araddr(31 downto 0),
      s_axi_arburst(1 downto 0) => s_axi_arburst(1 downto 0),
      s_axi_arcache(3 downto 0) => s_axi_arcache(3 downto 0),
      s_axi_arid(5 downto 0) => s_axi_arid(5 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arlock(0) => s_axi_arlock(0),
      s_axi_arprot(2 downto 0) => s_axi_arprot(2 downto 0),
      s_axi_arqos(3 downto 0) => s_axi_arqos(3 downto 0),
      s_axi_arready(0) => s_axi_arready(0),
      s_axi_arsize(2 downto 0) => s_axi_arsize(2 downto 0),
      s_axi_aruser(0) => '0',
      s_axi_arvalid(0) => s_axi_arvalid(0),
      s_axi_awaddr(31 downto 0) => s_axi_awaddr(31 downto 0),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awcache(3 downto 0) => s_axi_awcache(3 downto 0),
      s_axi_awid(5 downto 0) => s_axi_awid(5 downto 0),
      s_axi_awlen(7 downto 0) => s_axi_awlen(7 downto 0),
      s_axi_awlock(0) => s_axi_awlock(0),
      s_axi_awprot(2 downto 0) => s_axi_awprot(2 downto 0),
      s_axi_awqos(3 downto 0) => s_axi_awqos(3 downto 0),
      s_axi_awready(0) => s_axi_awready(0),
      s_axi_awsize(2 downto 0) => s_axi_awsize(2 downto 0),
      s_axi_awuser(0) => '0',
      s_axi_awvalid(0) => s_axi_awvalid(0),
      s_axi_bid(5 downto 0) => s_axi_bid(5 downto 0),
      s_axi_bready(0) => s_axi_bready(0),
      s_axi_bresp(1 downto 0) => s_axi_bresp(1 downto 0),
      s_axi_buser(0) => NLW_inst_s_axi_buser_UNCONNECTED(0),
      s_axi_bvalid(0) => s_axi_bvalid(0),
      s_axi_rdata(63 downto 0) => s_axi_rdata(63 downto 0),
      s_axi_rid(5 downto 0) => s_axi_rid(5 downto 0),
      s_axi_rlast(0) => s_axi_rlast(0),
      s_axi_rready(0) => s_axi_rready(0),
      s_axi_rresp(1 downto 0) => s_axi_rresp(1 downto 0),
      s_axi_ruser(0) => NLW_inst_s_axi_ruser_UNCONNECTED(0),
      s_axi_rvalid(0) => s_axi_rvalid(0),
      s_axi_wdata(63 downto 0) => s_axi_wdata(63 downto 0),
      s_axi_wid(5 downto 0) => B"000000",
      s_axi_wlast(0) => s_axi_wlast(0),
      s_axi_wready(0) => s_axi_wready(0),
      s_axi_wstrb(7 downto 0) => s_axi_wstrb(7 downto 0),
      s_axi_wuser(0) => '0',
      s_axi_wvalid(0) => s_axi_wvalid(0)
    );
end STRUCTURE;
