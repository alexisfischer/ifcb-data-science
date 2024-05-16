function [ classnum ] = convert_classnum_UCSC2NWFSC( Z )
%function [ UCSCclass ] = convert_classnum_UCSC2NWFSC( NWFSCclass )
% replace old UCSC classnums with new NWFSC classnums
% to merge training set
% Z input: any UCSC classlist
% classnum output: conversion to NWFSC classlist
%  Alexis D. Fischer, NWFSC, February 2022

% %test
%Z=[63;33];

% %no groupings 08Feb2023
% UCSC_num=[	33	71	73	34	72	49	85	70	65	2	63	3	54	35	58	24	31	36	86	4	94	64	82	67	37	5	62	80	26	74	77	25	55	38	95	52	59	6	76	7	8	53	9	27	39	40	75	10	11	60	12	13	66	28	14	90	84	61	68	15	41	16	51	17	93	32	83	42	78	18	81	43	44	92	45	19	46	47	30	50	20	56	29	89	21	22	91	87	88	48	23	69	1	79	96	57];
% NWFSC_num=[	4	5	5	5	5	1	1	1	1	13	14	16	1	18	1	1	1	22	57	23	1	1	1	28	29	30	32	1	1	1	1	1	1	39	40	1	43	45	1	47	48	1	1	1	55	56	1	58	59	25	65	66	67	1	69	72	1	1	74	1	77	78	1	80	1	81	1	82	1	85	1	87	89	90	92	93	1	1	1	1	99	1	1	102	103	1	106	107	108	109	110	1	1	111	1	1];

% %grouped Scrip/Heterocapsa and Rhiz/Prob 09Feb2023
% UCSC_num=	[33	71	73	34	72	49	85	70	65	2	63	3	54	35	58	24	31	36	86	4	94	64	82	67	37	5	62	80	26	74	77	25	55	38	95	52	59	6	76	7	8	53	9	27	39	40	75	10	11	60	12	13	66	28	14	90	84	61	68	15	41	16	51	17	93	32	83	42	78	18	81	43	44	92	45	19	46	47	30	50	20	56	29	89	21	22	91	87	88	48	23	69	1	79	96	57];
% NWFSC_num=	[4	5	5	5	5	1	1	1	1	13	14	16	1	18	1	1	1	22	57	23	1	1	1	28	29	30	32	1	1	1	1	1	1	39	40	1	43	45	1	47	48	1	1	1	55	56	1	58	59	25	65	66	67	1	69	72	1	1	74	1	77	78	1	80	1	81	1	82	1	85	1	87	89	90	92	93	1	1	96	97	99	1	1	102	103	1	106	107	108	109	110	1	1	111	1	1];

%only select UCSC classes: Gymnodinium, Heterocapsa, Scrippsiella, Eucampia, Prorocentrum, Margalefidinium
UCSC_num=	[33	71	73	34	72	49	85	70	65	2	63	3	54	35	58	24	31	36	86	4	94	64	82	67	37	5	62	80	26	74	77	25	55	38	95	52	59	6	76	7	8	53	9	27	39	40	75	10	11	60	12	13	66	28	14	90	84	61	68	15	41	16	51	17	93	32	83	42	78	18	81	43	44	92	45	19	46	47	30	50	20	56	29	89	21	22	91	87	88	48	23	69	1	79	96	57];
NWFSC_num=	[1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	29	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	48	1	1	1	55	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	89	1	1	1	1	1	1	97	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1];

classnum=changem(Z,NWFSC_num,UCSC_num);

end