function [parameters, lookup_direction] = tform_parameter(img, theta_0, heading_direction, lookup_direction)

    %threshold = 170;
    num_positive_pixels = 150;

    binary_img = imbinarize(img,'adaptive','Sensitivity',0.3);

    %binary_img = img > threshold;

   % if sum(binary_img,'all') > num_positive_pixels
            
        [cor_y,cor_x] = ind2sub(size(binary_img),find(binary_img));
            
        x_centroid = mean(cor_x);
        %x is the column index, namely it represents the horizontal coordinate in an image
        y_centroid = mean(cor_y);
        %y is the row index, namely it represents the vertical coordinate in an image
            
        Y = size(img,1);
        X = size(img,2);
            
        delta_x = x_centroid - X/2;
        delta_y = y_centroid - Y/2;

        % use PCA to compute the main axis of head orientation
        cor_coef = pca([cor_x,cor_y]);
        PC1 = cor_coef(:,1);
        PC2 = cor_coef(:,2);
        lookup_direction = compare_PCs(PC1,PC2,lookup_direction);


         % heading direction is obtained from infrared videos. 
         % In case it is not available, we will turn to orientation
         % defined by PCA, which also works well if many neurons can be identified 
        if isnan(heading_direction)

            delta_theta = cart2pol(lookup_direction(1,end),lookup_direction(2,end)) - cart2pol(lookup_direction(1,1),lookup_direction(2,1));
            delta_theta = wrapTo180(rad2deg(delta_theta));

        else

            delta_theta = heading_direction;

        end

         %initial rotation of the imagestack is given by theta_0,
         %defined as the angle between -x and the PC1 in the first
         %volume.

         %rotate the stack
        
        theta = wrapTo180(theta_0 - delta_theta);

        normalized_delta_x = delta_x/X;
        normalized_delta_y = delta_y/Y;

        parameters = [normalized_delta_x normalized_delta_y theta];

   % else

%        disp('no worms can be found!')
 %       parameters = [];

%    end

end



