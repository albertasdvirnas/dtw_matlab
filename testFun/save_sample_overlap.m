function [] = save_sample_overlap( X1, X2, L,noise,sgm)
    % save_sample_overlap
    X1 = X1 + noise*imgaussfilt(rand(length(X1),1), sgm);
    % original
    fname = strcat(['queryfull.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',X1); fclose(fileID);
    % reversed
    fname = strcat(['queryfullrev.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',flipud(X1)); fclose(fileID);
    
    %% These we could move to a separate functio since this depends on L, and we
    % might want to have different L for different time series
    % left side
    fname = strcat(['queryL.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',X1(1:L)); fclose(fileID);
    % reversed right side
    fname = strcat(['queryRrev.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',flipud(X1(1:L))); fclose(fileID);
    % right side
    fname = strcat(['queryR.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',X1(end-L+1:end)); fclose(fileID);
    % reversed left side
    fname = strcat(['queryLrev.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',flipud(X1(end-L+1:end))); fclose(fileID);
    % data
    fname = strcat(['data1.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',X2); fclose(fileID);

    

end

