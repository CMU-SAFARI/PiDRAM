
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px? 
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
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px? 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px? 
?
Rule violation (%s) %s - %s
20*drc2
PLIO-72default:default2B
.Placement Constraints Check for IO constraints2default:default2?
?An IO Bus FIXED_IO_mio[53:0] with more than one IO standard is found. Components associated with this bus are: HSTL_I_18 (FIXED_IO_mio[27], FIXED_IO_mio[26], FIXED_IO_mio[25], FIXED_IO_mio[24], FIXED_IO_mio[23], FIXED_IO_mio[22], FIXED_IO_mio[21], FIXED_IO_mio[20], FIXED_IO_mio[19], FIXED_IO_mio[18], FIXED_IO_mio[17], FIXED_IO_mio[16]); LVCMOS18 (FIXED_IO_mio[53], FIXED_IO_mio[52], FIXED_IO_mio[51], FIXED_IO_mio[50], FIXED_IO_mio[49], FIXED_IO_mio[48], FIXED_IO_mio[47], FIXED_IO_mio[46], FIXED_IO_mio[45], FIXED_IO_mio[44], FIXED_IO_mio[43], FIXED_IO_mio[42], FIXED_IO_mio[41], FIXED_IO_mio[40], FIXED_IO_mio[39] (the first 15 of 42 listed)); 2default:defaultZ23-20h px? 
b
DRC finished with %s
79*	vivadotcl2(
0 Errors, 1 Warnings2default:defaultZ4-198h px? 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px? 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px? 
y
BMultithreading enabled for route_design using a maximum of %s CPUs97*route2
82default:defaultZ35-254h px? 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px? 
C
.Phase 1 Build RT Design | Checksum: 1823bbc44
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:50 ; elapsed = 00:00:35 . Memory (MB): peak = 2787.215 ; gain = 0.000 ; free physical = 6469 ; free virtual = 232562default:defaulth px? 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px? 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px? 
B
-Phase 2.1 Create Timer | Checksum: 1823bbc44
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:51 ; elapsed = 00:00:36 . Memory (MB): peak = 2787.215 ; gain = 0.000 ; free physical = 6469 ; free virtual = 232562default:defaulth px? 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px? 
N
9Phase 2.2 Fix Topology Constraints | Checksum: 1823bbc44
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:52 ; elapsed = 00:00:36 . Memory (MB): peak = 2802.762 ; gain = 15.547 ; free physical = 6431 ; free virtual = 232192default:defaulth px? 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px? 
G
2Phase 2.3 Pre Route Cleanup | Checksum: 1823bbc44
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:00:52 ; elapsed = 00:00:37 . Memory (MB): peak = 2802.762 ; gain = 15.547 ; free physical = 6431 ; free virtual = 232192default:defaulth px? 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px? 
C
.Phase 2.4 Update Timing | Checksum: 1fa82fa1a
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:01:23 ; elapsed = 00:00:48 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6338 ; free virtual = 231262default:defaulth px? 
?
Intermediate Timing Summary %s164*route2L
8| WNS=0.167  | TNS=0.000  | WHS=-0.474 | THS=-3378.979|
2default:defaultZ35-416h px? 
I
4Phase 2 Router Initialization | Checksum: 140590ba1
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:01:44 ; elapsed = 00:00:52 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6338 ; free virtual = 231252default:defaulth px? 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px? 
C
.Phase 3 Initial Routing | Checksum: 244bc9136
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:02:20 ; elapsed = 00:00:58 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6328 ; free virtual = 231152default:defaulth px? 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px? 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
4.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 4.1.1 Update Timing | Checksum: 167f3d5a9
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:03 ; elapsed = 00:01:24 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
?
Intermediate Timing Summary %s164*route2J
6| WNS=0.151  | TNS=0.000  | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
H
3Phase 4.1 Global Iteration 0 | Checksum: 175b0735f
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:03 ; elapsed = 00:01:25 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
F
1Phase 4 Rip-up And Reroute | Checksum: 175b0735f
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:03 ; elapsed = 00:01:25 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
E
0Phase 5.1.1 Update Timing | Checksum: 132f4d96d
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:08 ; elapsed = 00:01:26 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
?
Intermediate Timing Summary %s164*route2J
6| WNS=0.194  | TNS=0.000  | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px? 
C
.Phase 5.1 Delay CleanUp | Checksum: 132f4d96d
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:09 ; elapsed = 00:01:26 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px? 
M
8Phase 5.2 Clock Skew Optimization | Checksum: 132f4d96d
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:09 ; elapsed = 00:01:26 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
O
:Phase 5 Delay and Skew Optimization | Checksum: 132f4d96d
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:09 ; elapsed = 00:01:26 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px? 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px? 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px? 
D
/Phase 6.1.1 Update Timing | Checksum: e4472ca0
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:15 ; elapsed = 00:01:28 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
?
Intermediate Timing Summary %s164*route2J
6| WNS=0.194  | TNS=0.000  | WHS=0.033  | THS=0.000  |
2default:defaultZ35-416h px? 
C
.Phase 6.1 Hold Fix Iter | Checksum: 1203bd404
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:16 ; elapsed = 00:01:28 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
A
,Phase 6 Post Hold Fix | Checksum: 1203bd404
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:16 ; elapsed = 00:01:28 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px? 
B
-Phase 7 Route finalize | Checksum: 14ee51a68
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:17 ; elapsed = 00:01:29 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6330 ; free virtual = 231172default:defaulth px? 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px? 
I
4Phase 8 Verifying routed nets | Checksum: 14ee51a68
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:17 ; elapsed = 00:01:29 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6329 ; free virtual = 231162default:defaulth px? 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px? 
E
0Phase 9 Depositing Routes | Checksum: 1578a09ce
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:20 ; elapsed = 00:01:32 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6329 ; free virtual = 231162default:defaulth px? 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px? 
?
Estimated Timing Summary %s
57*route2J
6| WNS=0.194  | TNS=0.000  | WHS=0.033  | THS=0.000  |
2default:defaultZ35-57h px? 
?
?The final timing numbers are based on the router estimated timing analysis. For a complete and accurate timing signoff, please run report_timing_summary.
127*routeZ35-327h px? 
G
2Phase 10 Post Router Timing | Checksum: 1578a09ce
*commonh px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:20 ; elapsed = 00:01:32 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6329 ; free virtual = 231162default:defaulth px? 
=
Router Completed Successfully
16*routeZ35-16h px? 
?

%s
*constraints2?
?Time (s): cpu = 00:05:21 ; elapsed = 00:01:33 . Memory (MB): peak = 2877.168 ; gain = 89.953 ; free physical = 6329 ; free virtual = 231162default:defaulth px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
822default:default2
732default:default2
22default:default2
02default:defaultZ4-41h px? 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
route_design: 2default:default2
00:05:272default:default2
00:01:372default:default2
2877.1682default:default2
89.9532default:default2
63292default:default2
231162default:defaultZ17-722h px? 
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
00:00:092default:default2
00:00:032default:default2
2904.3242default:default2
0.0002default:default2
62122default:default2
231172default:defaultZ17-722h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2&
write_checkpoint: 2default:default2
00:00:202default:default2
00:00:132default:default2
2904.3242default:default2
27.1562default:default2
62992default:default2
231162default:defaultZ17-722h px? 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px? 
?
#The results of DRC are in file %s.
168*coretcl2?
r/home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.runs/impl_1/system_top_drc_routed.rptr/home/ataberk/EasyDRAM/controller-hardware/ZC706/Vivado_Project/E2E_RowClone.runs/impl_1/system_top_drc_routed.rpt2default:default8Z2-168h px? 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -2, Delay Type: min_max2default:defaultZ38-91h px? 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
82default:defaultZ38-191h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2+
report_timing_summary: 2default:default2
00:00:292default:default2
00:00:082default:default2
2968.2772default:default2
0.0002default:default2
62592default:default2
230892default:defaultZ17-722h px? 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px? 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px? 
?
?Detected over-assertion of set/reset/preset/clear net with high fanouts, power estimation might not be accurate. Please run Tool - Power Constraint Wizard to set proper switching activities for control signals.282*powerZ33-332h px? 
?
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
report_power: 2default:default2
00:00:232default:default2
00:00:062default:default2
3060.3522default:default2
92.0742default:default2
61862default:default2
230262default:defaultZ17-722h px? 


End Record