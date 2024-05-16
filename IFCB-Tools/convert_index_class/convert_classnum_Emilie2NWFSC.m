function [ classnum ] = convert_classnum_Emilie2NWFSC( Z )
%function [ UCSCclass ] = convert_classnum_Emilie2NWFSC( NWFSCclass )
% replace Emilie_manual temporary classnums with new NWFSC classnums
% to merge training set
% Z input:  Emilie's Discrete/Alternate classlists or LabExpt classlist
% classnum output: conversion to NWFSC classlist
%  Alexis D. Fischer, NWFSC, February 2023

%Discrete and Alternate classlist
NWFSC_num = [1	43	117	118	119	120	121	122	123	124	125	43	43	43	43	43	139	139	117	140	137	137	118	138	141	141	119	142	143	143	122	144	43	43	43	43	43	43	43	43	43];
Emilie_num = [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41];

% %LabExpt classlist
% NWFSC_num =  [1	72	117	1	1	1	1	1	1];
% Emilie_num = [1	2	3	4	5	6	7	8	9];

classnum=changem(Z,NWFSC_num,Emilie_num);

%delete
%D20220913T203940_IFCB150
%D20220913T201542_IFCB150
%D20220927T071328_IFCB150
%D20220927T073933_IFCB150

end