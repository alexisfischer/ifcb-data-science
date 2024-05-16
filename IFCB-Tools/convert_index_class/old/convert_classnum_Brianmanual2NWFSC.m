function [ classnum ] = convert_classnum_Brianmanual2NWFSC( Z )
%function [ UCSCclass ] = convert_classnum_Brianmanual2NWFSC( NWFSCclass )
% replace Brian_manual temporary classnums with new NWFSC classnums
% to merge training set
% Z input:  Brian_manual classlist
% classnum output: conversion to NWFSC classlist
%  Alexis D. Fischer, NWFSC, February 2023

Brian_num = [1	2	3	4	5	6	7	8	9	10	11	12];
NWFSC_num =     [1	113	127	128	130	132	134	1	1	1	1	1];

classnum=changem(Z,NWFSC_num,Brian_num);

end