function  compare_methods( )


    % Length of query
    N = 300;

    % Query
    X = imgaussfilt(rand(1,N),2);

    % number of values before query
    N1 = 10000;
    % and after
    N2 = 86000000;

    % noise level
    noiseLevel = 0.2;

    % data
    Y = [imgaussfilt(rand(1,N1)) X imgaussfilt(rand(1,N2))];
    Y = Y+noiseLevel*rand(1,length(Y));

    %plot for comparison
%     figure,plot(X)
%     hold on
%     plot(Y(N1+1:N1+N))

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
%     
%     mex 'UCR_DTW_MEX.cpp';
%     mex 'UCR_ED_MEX.cpp';
%     mex 'PCC_MEX.cpp';
    
    pos = [];
    score = [];
   
   tic
   [pos(1),score(1)] = PCC_MEX('data1.txt','query1.txt', N);
   toc
   
   tic
   [pos(2),score(2)] = UCR_ED_MEX('data1.txt','query1.txt', N);
   toc
   
   tic
   [pos(3),score(3)] = UCR_DTW_MEX('data1.txt','query1.txt', N,0.01);
   toc
   
    tic
    import SignalRegistration.unmasked_pcc_corr;
    xcorrs = unmasked_pcc_corr(X, Y, ones(1,length(X)));
    import CBT.Hca.UI.Helper.get_best_parameters;
    [coef,pos,orient] = get_best_parameters(xcorrs, 3 );
    toc

end

