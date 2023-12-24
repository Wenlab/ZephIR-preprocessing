function heading_angles = head_orientation(centerlines)
    N = length(centerlines);
    angles = zeros(N,1);
    for n=1:N
        df2 = diff(centerlines{n},1,1);
        theta =  unwrap(atan2(-df2(:,2), df2(:,1)));
        angles(n) = mean(theta(1:20));
    end
    heading_angles = unwrap(angles);
    heading_angles = heading_angles - heading_angles(1);
    heading_angles = heading_angles/pi*180;
   

end

