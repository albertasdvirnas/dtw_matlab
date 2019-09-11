function [X1, X2, X,Y, Z1, Z2, flip, stPoint,issubseq, ontheLeft] = gen_sample_overlap( N, L, Lq, Ld,sigma )
    % gen_sample_overlap
    % input
    % N - lenght overlap, L - length predicted overlap, Lq - size query, 
    % Ld - size data 

    % first simple unit test, time series will have identical middle part
    
    % Non-overlapping part
    X = imgaussfilt(rand(Lq-N,1), sigma);
    % Overlapping part 
    Y = imgaussfilt(rand(N,1), sigma);
    
    % point where the overlap starts on the longer sequence
    issubseq = randi([0 1]);
    if issubseq
        stPoint = randi(Ld-N+1);
    else
        % if X is not a subsequence
        stPoint = 0;
    end
    
    % the other two components
    Z1 = imgaussfilt(rand(stPoint,1), sigma);
    Z2 = imgaussfilt(rand(Ld-stPoint-N,1), sigma);

	ontheLeft = randi([0 1]);
    if ontheLeft
        X1 = [Y;X];
    else
        X1 = [X;Y];
    end
    
    % if query is flipped
    flip = randi([0 1]);
    
    if  flip
        X1 = flipud(X1);
    end
    
    % data. No Z1 if X1 is not a subsequence. No Z2 is analogous ( but
    % should still be included in tests)
    X2 = [Z1; Y; Z2];

    
  
end

