function removeLumericalSignatures(filePath)
    fid = fopen(filePath,'rt') ;
    S = textscan(fid,'%s','delimiter','\n');
    fclose(fid);

    %remove Lumerical Signature lines
    S=S{1};
    idx = contains(S,"Lumerical");
    S(idx)=[];
    
    %write to file
    fid = fopen(filePath,'wt') ;
    fprintf(fid,'%s\n',S{:});
    fclose(fid) ;
end