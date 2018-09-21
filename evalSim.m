function [ error ] = evalSim( funcString, targetFunc, x,y )
%EVALSIM Summary of this function goes here
%   Detailed explanation goes here

%% Calculate the difference between a guessed function by CGP and the target function.

error = abs(eval(cell2mat(funcString))-eval(targetFunc));





end

