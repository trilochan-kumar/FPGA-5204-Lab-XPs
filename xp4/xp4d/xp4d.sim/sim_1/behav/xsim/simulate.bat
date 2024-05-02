@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.2.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : AMD Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Thu May 02 14:47:39 +0530 2024
REM SW Build 4126759 on Thu Feb  8 23:53:51 MST 2024
REM
REM Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
REM Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim xp4d_behav -key {Behavioral:sim_1:Functional:xp4d} -tclbatch xp4d.tcl -log simulate.log"
call xsim  xp4d_behav -key {Behavioral:sim_1:Functional:xp4d} -tclbatch xp4d.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
