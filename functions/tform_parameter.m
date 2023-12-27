function [parameters, lookup_PC1] = tform_parameter(img, theta_0, heading_direction, lookup_PC1)

    threshold = 170;
    num_positive_pixels = 250;

    binary_img = img > threshold;

    if sum(binary_img,'all') > num_positive_pixels
            
        [cor_y,cor_x] = ind2sub(size(img),find(img));
            
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
        lookup_PC1 = compare_PCs(PC1,lookup_PC1);


         % heading direction is obtained from infrared videos. 
         % In case it is not available, we will turn to orientation
         % defined by PCA which does not work well for sparsely lablled
         % neurons
        if isnan(heading_direction)

            delta_theta = cart2pol(lookup_PC1(1,end),lookup_PC1(2,end)) - cart2pol(lookup_PC1(1,1),lookup_PC1(2,1));
            delta_theta = rad2deg(delta_theta);

        else

            delta_theta = heading_direction;

        end

         %initial rotation of the imagestack is given by theta_0,
         %defined as the angle between -x and the PC1 in the first
         %volume.

         %rotate the stack
        
        theta = theta_0 - delta_theta;

        normalized_delta_x = delta_x/X;
        normalized_delta_y = delta_y/Y;

        parameters = [normalized_delta_x normalized_delta_y theta];

    else

        disp('no worms can be found!')
        parameters = [];

    end

end



