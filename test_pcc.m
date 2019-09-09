function = test_pcc()


    addpath(genpath(pwd));

    % run mex on the cpp code
    mex 'PCC_MEX.cpp';

    
    M = 400; % length of subsequence

    
    [pos,score] = PCC_MEX('Data.txt','Query.txt', M);
        
    %%

    % Length of query
    N = 300;

    % Query
    X = imgaussfilt(rand(1,N),2);

    % number of values before query
    N1 = 10000;
    % and after
    N2 = 300000;

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
    [pos,score] = PCC_MEX('data1.txt','query1.txt', N);

    seq1=zscore(X,1);
    seq2=zscore(Y(N1+1:N1+N),1);
    seq1*seq2'/(N-1)
%     score2 = sqrt((seq1-seq2)*(seq1-seq2)');
    
        % save query
    fname = strcat(['data2.txt']);
    fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',Y(N1+1:N1+N));
    fclose(fileID);
    
	mex 'PCC_MEX.cpp';
	[pos,score] = PCC_MEX('data2.txt','query1.txt', N);
    
    
    import SignalRegistration.unmasked_pcc_corr;
    xcorrs = unmasked_pcc_corr(X, Y, ones(1,length(X)));
    import CBT.Hca.UI.Helper.get_best_parameters;
    [coef,pos,orient] = get_best_parameters(xcorrs, 3 );


end


