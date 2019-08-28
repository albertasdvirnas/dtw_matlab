% run UCR DTW from matlab
% original is https://www.ijcai.org/Proceedings/13/Papers/454.pdf

addpath(genpath(pwd));

% run mex on the cpp code
mex 'UCR_DTW_MEX.cpp';

M = 100; % length of subsequence
R = 0.5; % allowed stretching

tic
[pos,score] = UCR_DTW_MEX('Data.txt','Query.txt', M, R);
toc

fileID = fopen('Data.txt','r');
data = textscan(fileID,'%f');
fclose(fileID);

fileID = fopen('Query.txt','r');
query = textscan(fileID,'%f ');
fclose(fileID);

figure,plot(zscore(query{1}))
hold on
plot(zscore(data{1}(pos:pos+length(query{1}))))


%% An example with some simulated data

% Length of query
N = 300;

% Query
X = imgaussfilt(rand(1,N),2);

% number of values before query
N1 = 100000;
% and after
N2 = 300000;

% noise level
noiseLevel = 1.2;

% data
Y = [imgaussfilt(rand(1,N1)) X imgaussfilt(rand(1,N2))];
Y = Y+noiseLevel*rand(1,length(Y));

% plot for comparison
% figure,plot(X)
% hold on
% plot(Y(N1+1:N1+N))

% save query
fname = strcat(['query1.txt']);
fileID = fopen(fname,'w');
fprintf(fileID,'%2.5f ',X);
fclose(fileID);

% save data
fname = strcat(['data1.txt']);
fileID = fopen(fname,'w');
fprintf(fileID,'%2.5f ',Y);
fclose(fileID);

% run ucr dtw
tic
[pos,score]  = UCR_DTW_MEX('data1.txt','query1.txt', length(X),0);
toc
if pos == N1
    display('correct place found');
end

% plot for comparison
figure,plot(zscore(X))
hold on
plot(zscore(Y(pos+1:pos+1+length(X))))


