% Length of query
N = 300;

% first simple unit test, time series will have identical middle part
% Query
X = imgaussfilt(rand(N,1),2);
Y = imgaussfilt(rand(N,1),2);
Z = imgaussfilt(rand(N,1),2);

X1 = [X; Y];
X2 = [Y;Z];

% save query
fname = strcat(['query1.txt']);
fileID = fopen(fname,'w');
fprintf(fileID,'%2.5f ',X1);
fclose(fileID);

% save data
fname = strcat(['data1.txt']);
fileID = fopen(fname,'w');
fprintf(fileID,'%2.5f ',X2);
fclose(fileID);
%     
mex 'OVERLAPPING_DTW_MEX.cpp';
 
[pos,score] = OVERLAPPING_DTW_MEX('data1.txt','query1.txt', 0.5,300);
