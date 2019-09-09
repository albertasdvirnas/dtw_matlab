function [] = gen_sample_data( N, N1, N2, filtPar,noiseLevel,ifplot)
    % gen_sample_data
    % simple generation of correlated data

    if nargin < 1
        % Length of query
        N = 300;
        % filter parameter
        filtPar = 2;

        % number of values before query
        N1 = 10000;
        % and after
        N2 = 300000;

        % noise level
        noiseLevel = 0.2;
        
        ifplot = 0;
    end
    
    % Query
    X = imgaussfilt(rand(1,N),filtPar);

    % data
    Y = [imgaussfilt(rand(1,N1)) X imgaussfilt(rand(1,N2))];
    Y = Y+noiseLevel*rand(1,length(Y));

    
    if ifplot == 1
%     %plot for comparison
        figure,plot(X)
        hold on
        plot(Y(N1+1:N1+N))
    end
    
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

end

