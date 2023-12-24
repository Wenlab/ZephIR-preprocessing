function [red_stack, green_stack, lookup_PC1] = stack_transformation(red_stack,green_stack,heading_direction, lookup_PC1, theta_0)
        
        red_stack = uint8(red_stack);
        green_stack = uint8(green_stack);

        threshold = 170;
        num_positive_pixels = 250;

    % Choose the dimension along which you want to project the maximum intensity
    % 1 for x-axis, 2 for y-axis, 3 for z-axis
        projection_dim = 3;
        depth = size(red_stack,3);

    % Calculate the MIP using max() function
        red_xy_MIP = max(red_stack, [], projection_dim);
        
   
    %- Apply a threshold to the MIP for highlighting specific features:
        %binary_red_xy_MIP = imbinarize(red_xy_MIP,'adaptive');
        binary_red_xy_MIP = red_xy_MIP > threshold;

    if sum(binary_red_xy_MIP,'all') > num_positive_pixels
            
        [cor_y,cor_x] = ind2sub(size(binary_red_xy_MIP),find(binary_red_xy_MIP));
            x_center = mean(cor_x);
            %x is the column index, namely it represents the horizontal coordinate in an image
            y_center = mean(cor_y);
            %y is the row index, namely it represents the vertical coordinate in an image
            
            delta_x = x_center - size(red_xy_MIP,2)/2;
            delta_y = y_center - size(red_xy_MIP,1)/2;
           

            % translate the image
           
            translation = [delta_x delta_y];
            tform = rigidtform2d(0, -translation);
            sameAsInput = affineOutputView(size(red_xy_MIP),tform,"BoundsStyle","SameAsInput");
            
            for z=1:depth
                red_stack(:,:,z) = imwarp(red_stack(:,:,z),tform,"cubic","OutputView",sameAsInput);
                green_stack(:,:,z) = imwarp(green_stack(:,:,z),tform,"cubic","OutputView",sameAsInput);
            end
            
            % use PCA to compute the main axis of head orientation
            cor_coef = pca([cor_x,cor_y]);
            PC1 = cor_coef(:,1);
            lookup_PC1 = compare_PCs(PC1,lookup_PC1);

            %imshow(max(red_stack,[],3));
            %hold on; 
            %annotation('arrow',[0.5, 0.5+0.1*lookup_PC1(1,end)], [0.5, 0.5+0.1*lookup_PC1(2,end)],'Color','r');
            


            % heading direction is obtained from infrared videos. 
            % In case it is not available, we will turn to orientation
            % defined by PCA which does not work well for sparsely lablled
            % neurons
            if isnan(heading_direction)

                delta_theta = cart2pol(lookup_PC1(1,end),lookup_PC1(2,end)) - cart2pol(lookup_PC1(1,1),lookup_PC1(2,1));
                delta_theta = delta_theta/pi*180;

            else

                delta_theta = heading_direction;

            end

            %initial rotation of the imagestack is given by theta_0,
            %defined as the angle between -x and the PC1 in the first
            %volume.

            %rotate the stack
           
            theta = theta_0 - delta_theta;

            for z=1:depth
                red_stack(:,:,z) = imrotate(red_stack(:,:,z), theta,"bicubic","crop");
                green_stack(:,:,z) = imrotate(green_stack(:,:,z), theta,"bicubic","crop");
            end

    
    end


end