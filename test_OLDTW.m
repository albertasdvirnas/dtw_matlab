function test_OLDTW( N, L, Lq, Ld, R, noise, sgm )

    if nargin < 1
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
        
        % noise to add to barcodes
        noise = 0.3;
        % variance
        sgm = 2;
    end
    
	% mex the c function     
    mex 'OVERLAPPING_DTW_MEX.cpp';


    % generate the overlapping sample time series
    disp(strcat(['Generating and saving simulated time series']))
    tic
    [X1, X2, X, Y, Z1, Z2, flip, stPoint, issubseq, ontheLeft] = gen_sample_overlap( N, L, Lq, Ld, sgm );
    time = toc;
    disp(strcat(['This took me ' num2str(time) ' seconds']));

	% save the time series into txt files;
    save_sample_overlap( X1, X2, L,noise,sgm );
    
    
    % from this we know that the correct position is for 
    corPos = [~ontheLeft+2,flip+1];
    %and row



    disp('Generating scores...');
    %% generate overlap scores
    tic
    [ pos, scores ] = generate_overlap_scores( Lq,L,R );
    time = toc;
    disp(strcat(['This took me ' num2str(time) ' seconds']));
    sc = sort(scores(:));
    minimum = sc(1);
    minimum2 = sc(2);

    [foundPos(1),foundPos(2)]=find(scores==minimum);
    disp(strcat(['The best score is ' num2str(scores(foundPos(1),foundPos(2)))]));
    disp(strcat(['The second best score is ' num2str(minimum2)]));

    if    isequal(foundPos,corPos)
        disp('ok');
    end


    %[pos,score] = OVERLAPPING_DTW_MEX('data1.txt','query1.txt', 300,12);




end

