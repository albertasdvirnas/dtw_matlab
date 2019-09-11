
% Input data 
% Length of overlap
N = 300;
% Predicted length of overlap
L = 300;
% Length of time series
Lq = 600;
% Length reference
Ld = 1200;
% Sakoe-Chiba band
R = 12;


% generate the overlapping sample time series
disp(strcat(['Generating and saving simulated time series']))
tic
[X1, X2, X,Y, Z1, Z2, flip, stPoint, issubseq] = gen_sample_overlap( N, L, Lq, Ld );
time = toc;
disp(strcat(['This took me ' num2str(time) ' seconds']))

% mex the c function     
mex 'OVERLAPPING_DTW_MEX.cpp';

% generate overlap scores
[ pos, scores ] = generate_overlap_scores( length(X1),L,R );





%[pos,score] = OVERLAPPING_DTW_MEX('data1.txt','query1.txt', 300,12);
