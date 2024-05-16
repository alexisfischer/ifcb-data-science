function [ classnum ] = convert_classnum_OSU2NWFSC( Z )
%function [ OSUclass ] = convert_classnum_OSU2NWFSC( NWFSCclass )
% replace old OSU classnums with new NWFSC classnums
% to merge training set
% Z input: any OSU classlist
% classnum output: conversion to NWFSC classlist
%  Alexis D. Fischer, NWFSC, February 2022

% %test
%Z=[63;33];

%NCC classifier
%OSU_num=[	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72	73	74	75	76	77	78	79	80	81	82	83	84	85	86	87	88	89	90];
%NWFSC_num=[	1	5	13	10	15	78	22	1	57	1	1	28	29	30	31	1	1	39	43	45	28	49	53	1	55	56	59	60	25	1	1	72	1	73	1	78	79	1	82	26	85	87	1	1	92	89	92	1	93	52	52	28	1	33	97	1	26	102	103	104	1	107	1	1	1	26	20	20	1	81	81	1	1	1	1	48	1	1	16	1	1	76	1	1	1	100	64	95	1	71];

%BI classifier (only Thalassiosira)
OSU_num	= [1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72	73	74	75	76	77	78	79	80	81	82	83	84	85	86	87	88	89	90];
NWFSC_num = [	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	104	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1];
classnum=changem(Z,NWFSC_num,OSU_num);

end