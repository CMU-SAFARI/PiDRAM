
O
Command: %s
53*	vivadotcl2

opt_design2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7z0452default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7z0452default:defaultZ17-349h px? 
?
?The version limit for your license is '%s' and will expire in %s days. A version limit expiration means that, although you may be able to continue to use the current version of tools or IP with this license, you will not be eligible for any updates or new releases.
519*common2
2017.062default:default2
-15312default:defaultZ17-1223h px? 
n
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_design2default:defaultZ4-22h px? 
R

Starting %s Task
103*constraints2
DRC2default:defaultZ18-103h px? 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px? 
U
DRC finished with %s
272*project2
0 Errors2default:defaultZ1-461h px? 
d
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462h px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:00.42 ; elapsed = 00:00:00.32 . Memory (MB): peak = 2199.160 ; gain = 64.031 ; free physical = 7175 ; free virtual = 239052default:defaulth px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
a

Starting %s Task
103*constraints2&
Logic Optimization2default:defaultZ18-103h px? 
?

Phase %s%s
101*constraints2
1 2default:default27
#Generate And Synthesize Debug Cores2default:defaultZ18-101h px? 
>
Refreshing IP repositories
234*coregenZ19-234h px? 
~
"Loaded Vivado IP repository '%s'.
1332*coregen25
!/opt/Xilinx/Vivado/2016.2/data/ip2default:defaultZ19-2313h px? 
?
Generating IP %s for %s.
1712*coregen2+
xilinx.com:ip:xsdbm:1.12default:default2

dbg_hub_CV2default:defaultZ19-3806h px? 
?
NRe-using generated and synthesized IP, "%s", from Vivado IP cache entry "%s".
146*	chipscope2+
xilinx.com:ip:xsdbm:1.12default:default2$
4a2db801f71c2eb12default:defaultZ16-220h px? 
?
Generating IP %s for %s.
1712*coregen2)
xilinx.com:ip:ila:6.12default:default2

u_ila_0_CV2default:defaultZ19-3806h px? 
?
NRe-using generated and synthesized IP, "%s", from Vivado IP cache entry "%s".
146*	chipscope2)
xilinx.com:ip:ila:6.12default:default2$
a090c7510bf3138f2default:defaultZ16-220h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.122default:default2
00:00:00.122default:default2
2199.1602default:default2
0.0002default:default2
71082default:default2
238562default:defaultZ17-722h px? 
W
BPhase 1 Generate And Synthesize Debug Cores | Checksum: 1afed58ed
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:41 ; elapsed = 00:00:44 . Memory (MB): peak = 2199.160 ; gain = 0.000 ; free physical = 7108 ; free virtual = 238562default:defaulth px? 
A
,Implement Debug Cores | Checksum: 1a71d7f5b
*commonh px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
i

Phase %s%s
101*constraints2
2 2default:default2
Retarget2default:defaultZ18-101h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
22default:default2
22default:defaultZ31-138h px? 
K
Retargeted %s cell(s).
49*opt2
02default:defaultZ31-49h px? 
<
'Phase 2 Retarget | Checksum: 112c76df4
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:51 ; elapsed = 00:00:51 . Memory (MB): peak = 2215.145 ; gain = 15.984 ; free physical = 7074 ; free virtual = 238222default:defaulth px? 
u

Phase %s%s
101*constraints2
3 2default:default2(
Constant Propagation2default:defaultZ18-101h px? 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
32default:default2
32default:defaultZ31-138h px? 
K
Eliminated %s cells.
10*opt2
1392default:defaultZ31-10h px? 
H
3Phase 3 Constant Propagation | Checksum: 195ff9975
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:55 ; elapsed = 00:00:55 . Memory (MB): peak = 2215.145 ; gain = 15.984 ; free physical = 7069 ; free virtual = 238172default:defaulth px? 
f

Phase %s%s
101*constraints2
4 2default:default2
Sweep2default:defaultZ18-101h px? 
W
 Eliminated %s unconnected nets.
12*opt2
62542default:defaultZ31-12h px? 
W
!Eliminated %s unconnected cells.
11*opt2
5542default:defaultZ31-11h px? 
9
$Phase 4 Sweep | Checksum: 177a10425
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:58 ; elapsed = 00:00:58 . Memory (MB): peak = 2215.145 ; gain = 15.984 ; free physical = 7068 ; free virtual = 238172default:defaulth px? 
a

Starting %s Task
103*constraints2&
Connectivity Check2default:defaultZ18-103h px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:00.15 ; elapsed = 00:00:00.15 . Memory (MB): peak = 2215.145 ; gain = 0.000 ; free physical = 7068 ; free virtual = 238172default:defaulth px? 
J
5Ending Logic Optimization Task | Checksum: 177a10425
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:59 ; elapsed = 00:00:59 . Memory (MB): peak = 2215.145 ; gain = 15.984 ; free physical = 7066 ; free virtual = 238142default:defaulth px? 
a

Starting %s Task
103*constraints2&
Power Optimization2default:defaultZ18-103h px? 
s
7Will skip clock gating for clocks with period < %s ns.
114*pwropt2
2.002default:defaultZ34-132h px? 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px? 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px? 
=
Applying IDT optimizations ...
9*pwroptZ34-9h px? 
?
Applying ODC optimizations ...
10*pwroptZ34-10h px? 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px? 


*pwropth px? 
e

Starting %s Task
103*constraints2*
PowerOpt Patch Enables2default:defaultZ18-103h px? 
?
?WRITE_MODE attribute of %s BRAM(s) out of a total of %s has been updated to save power.
    Run report_power_opt to get a complete listing of the BRAMs updated.
129*pwropt2
02default:default2
432default:defaultZ34-162h px? 
d
+Structural ODC has moved %s WE to EN ports
155*pwropt2
02default:defaultZ34-201h px? 
?
CNumber of BRAM Ports augmented: %s newly gated: %s Total Ports: %s
65*pwropt2
92default:default2
12default:default2
862default:defaultZ34-65h px? 
N
9Ending PowerOpt Patch Enables Task | Checksum: 1b61f392c
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:00.16 ; elapsed = 00:00:00.16 . Memory (MB): peak = 2787.215 ; gain = 0.000 ; free physical = 6630 ; free virtual = 233782default:defaulth px? 
J
5Ending Power Optimization Task | Checksum: 1b61f392c
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:31 ; elapsed = 00:00:16 . Memory (MB): peak = 2787.215 ; gain = 572.070 ; free physical = 6630 ; free virtual = 233782default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
502default:default2
332default:default2
22default:default2
02default:defaultZ4-41h px? 
\
%s completed successfully
29*	vivadotcl2

opt_design2default:defaultZ4-42h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2 
opt_design: 2default:default2
00:01:342default:default2
00:01:182default:default2
2787.2152default:default2
660.0902default:default2
66302default:default2
233782default:defaultZ17-722h px? 
D
Writing placer database...
1603*designutilsZ20-1893h px? 
=
Writing XDEF routing.
211*designutilsZ20-211h px? 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px? 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:00.252default:default2
00:00:00.062default:default2
2787.2152default:default2
0.0002default:default2
66272default:default2
233802default:defaultZ17-722h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2&
write_checkpoint: 2default:default2
00:00:152default:default2
00:00:112default:default2
2787.2152default:default2
0.0002default:default2
66152default:default2
233792default:defaultZ17-722h px? 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px? 
?
#The results of DRC are in file %s.
168*coretcl2?
q/home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.runs/impl_1/system_top_drc_opted.rptq/home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.runs/impl_1/system_top_drc_opted.rpt2default:default8Z2-168h px? 


End Record