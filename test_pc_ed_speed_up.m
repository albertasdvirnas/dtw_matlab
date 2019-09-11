    mex 'UCR_ED_MEX.cpp';
    mex 'PCC_MEX.cpp';


% unit test 1: 

% Generate a short time series and a long time series, where the short time
% series is a subsequence. Add noise to the long time series (this will
% depend on parameter mu). Check how often is the correct position found
% with ED, and how often with PCC, and if they match. 


    %%
    N = 300; % subsequence length
    numRuns = 10; % number runs
    corPos = 10000; % correct position
    
    % found positions
    pos = zeros(numRuns,2);
    % found scores
    scores = zeros(numRuns,2);

    tic
    for i=1:numRuns
        % N, N1, N2, filtPar,noiseLevel
        gen_sample_data(N,corPos,20000,2,1.2,0);

        [pos(i,1),scores(i,1)] = PCC_MEX('data1.txt','query1.txt', N);
        [pos(i,2),scores(i,2)] = UCR_ED_MEX('data1.txt','query1.txt', N);
    end
    [ sum(pos(:,1)==pos(:,2))/numRuns sum(pos(:,1)==corPos)/numRuns ] 
    toc
    %%


%% unit test 2:
% test the speed of ed 
    tic
    for i=1:numRuns
        % N, N1, N2, filtPar,noiseLevel
        gen_sample_data(N,corPos,20000,2,1.2,0);
        [pos(i,2),scores(i,2)] = UCR_ED_MEX('data1.txt','query1.txt', N);
    end
    toc


% unit test 2:
% run the first test on more specific time series, resembling experiments
% and theory of competitive binding.