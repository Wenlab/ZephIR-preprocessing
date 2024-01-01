function lookup_direction = compare_PCs(PC1,PC2, lookup_direction)

    %acos(\delta_theta) < 45 degree

    if dot(PC1,lookup_direction(:,end)) > 0.707 
        lookup_direction(:,end+1) = PC1;

    end

    if dot(PC1,lookup_direction(:,end)) < -0.707

         lookup_direction(:,end+1) = -PC1;
    end

    if dot(PC2,lookup_direction(:,end)) > 0.707

        lookup_direction(:,end+1) = PC2;

    end

    if dot(PC2,lookup_direction(:,end)) < - 0.707

        lookup_direction(:,end+1) = -PC2;

    end

end

