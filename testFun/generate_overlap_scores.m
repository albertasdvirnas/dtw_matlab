function [ pos, scores ] = generate_overlap_scores( N,L,R )
    % generate_overlap_scores
    %
    % input 
    % N - length of full query
    % L - length of overlap
    % R - Sakoe-Chiba band width
    % output 
    % pos - position matrix
    % scores - scores matrix
    
    % initialize data
    pos = zeros(3,2);
    scores = zeros(3,2);

    % these first two are just to see how the query places as a
    % subsequence, they're not comparable to the rest of the scores because
    % they are for different length.
    [pos(1,1), scores(1,1)] = OVERLAPPING_DTW_MEX('data1.txt','queryfull.txt', N, R);
    [pos(1,2), scores(1,2)] = OVERLAPPING_DTW_MEX('data1.txt','queryfullrev.txt', N, R);
    
    % note that the accuracy of these scores might depend on the complexity
    % of the region compared, so lower score does not mean that it's
    % necessarily better. Need to run a simulation to see what is the
    % rate of false positives here.
    
    [pos(2,1), scores(2,1)] = OVERLAPPING_DTW_MEX('data1.txt','queryL.txt', L, R);
    [pos(2,2), scores(2,2)] = OVERLAPPING_DTW_MEX('data1.txt','queryLrev.txt', L, R);
    [pos(3,1), scores(3,1)] = OVERLAPPING_DTW_MEX('data1.txt','queryR.txt', L, R);
    [pos(3,2), scores(3,2)] = OVERLAPPING_DTW_MEX('data1.txt','queryRrev.txt', L, R);
    
    % todo: write a function which converts these positions to the
    % positions of the original time series along the data. Though we
    % are only interested in the position of the overlap, and then which
    % way is the hanging part, to the left or to the right.
    
    
    
end

