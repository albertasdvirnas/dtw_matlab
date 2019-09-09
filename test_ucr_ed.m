function = test_ucr_ed()


    addpath(genpath(pwd));

    % run mex on the cpp code
    mex 'UCR_ED_MEX.cpp';

    
    M = 600; % length of subsequence

    
    [pos,score] = UCR_ED_MEX('Data.txt','Query.txt', M);
        
    %%

    % Length of query
    N = 300;

    % Query
    X = imgaussfilt(rand(1,N),2);

    % number of values before query
    N1 = 10000;
    % and after
    N2 = 30000;

    % noise level
    noiseLevel = 0.2;

    % data
    Y = [imgaussfilt(rand(1,N1)) X imgaussfilt(rand(1,N2))];
    Y = Y+noiseLevel*rand(1,length(Y));

    %plot for comparison
    figure,plot(X)
    hold on
    plot(Y(N1+1:N1+N))

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
    
    %%
    [pos,score] = UCR_ED_MEX('data1.txt','query1.txt', N);

    seq1=zscore(X,1);
    seq2=zscore(Y(N1+1:N1+N),1);
    score2 = sqrt((seq1-seq2)*(seq1-seq2)');
    
        % save query
    fname = strcat(['data2.txt']);
    fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',Y(N1+1:N1+N));
    fclose(fileID);
    [pos,score] = UCR_ED_MEX('data2.txt','query1.txt', N);

end

