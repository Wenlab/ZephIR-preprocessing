function lookup_PC1 = compare_PCs(PC1,lookup_PC1)

    if dot(PC1,lookup_PC1(:,end)) > 0
        lookup_PC1(:,end+1) = PC1;

    elseif dot(PC1,lookup_PC1(:,end)) < 0

         lookup_PC1(:,end+1) = -PC1;

    end

end

