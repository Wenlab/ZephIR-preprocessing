function lookup_direction = compare_PCs(PC1,PC2,lookup_direction)

    end_frame = size(lookup_direction,2);

    time_window = 2;

    start_frame = max(1,end_frame-time_window);

    vec = mean(lookup_direction(:,start_frame:end_frame),2);

    vec = vec/norm(vec,2);

    dotproduct1 = dot(PC1,vec);
    dotproduct2 = dot(PC2,vec);

    if abs(dotproduct1) >  abs(dotproduct2)
        
        lookup_direction(:,end+1) = sign(dotproduct1)*PC1;

    else
        
        lookup_direction(:,end+1) = sign(dotproduct2)*PC2;

    end


end

