function [theta, PC1] = check_first_volume(stack)

        stack = uint8(stack);
        threshold = 170;
        num_positive_pixels = 250;

        projection_dim = 3;

    % Calculate the MIP using max() function
        xy_MIP = max(stack, [], projection_dim);
        
   
    %- Apply a threshold to the MIP for highlighting specific features:
        %binary_red_xy_MIP = imbinarize(red_xy_MIP,'adaptive');
        binary_xy_MIP = xy_MIP > threshold;

        if sum(binary_xy_MIP,'all') > num_positive_pixels

            [cor_y,cor_x] = ind2sub(size(binary_xy_MIP),find(binary_xy_MIP));
            x_center = mean(cor_x);
            %x is the column index, namely it represents the horizontal coordinate in an image
            y_center = mean(cor_y);
            %y is the row index, namely it represents the vertical coordinate in an image
            
            delta_x = x_center - size(xy_MIP,2)/2;
            delta_y = y_center - size(xy_MIP,1)/2;
            cor_coef = pca([cor_x,cor_y]);

            translation = [delta_x delta_y];
            tform = rigidtform2d(0, -translation);
            sameAsInput = affineOutputView(size(xy_MIP),tform,"BoundsStyle","SameAsInput");
            xy_MIP = imwarp(xy_MIP,tform,"cubic","OutputView",sameAsInput);
             

            [theta1,~] = cart2pol(cor_coef(1,1),cor_coef(2,1));
            [theta2,~] = cart2pol(cor_coef(1,2),cor_coef(2,2));
            figure; imshow(xy_MIP);
            hold on; 
            annotation('arrow',[0.5, 0.5+0.1*cos(theta1)], [0.5, 0.5+0.1*sin(theta1)],'Color','r');
            fprintf('PC1 angle (red) = %2f \n', theta1/pi*180);
            annotation('arrow',[0.5, 0.5+0.05*cos(theta2)], [0.5, 0.5+0.05*sin(theta2)],'Color','g');
            fprintf('PC2 angle (green) = %2f \n', theta2/pi*180);

            prompt = {'Flip PC1 no/yes'};
            dlgtitle = 'PC1';
            dims = [1 40];
            definput = {'no'};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            PC1 = cor_coef(:,1);
            if strcmp(answer{1},'yes')
                PC1 = -PC1;
            end

            prompt = {'Enter the rotation angle \theta (in degrees) between PC1 and -x axis'};
            dlgtitle = 'Theta Value';
            dims = [1 60];
            suggested_angle = round(acos(dot(PC1,[-1;0]))/pi*180);
            definput = {num2str(suggested_angle)};
            opts.Interpreter = 'tex';
            answer = inputdlg(prompt,dlgtitle,dims,definput,opts);  
            
            theta = str2double(answer{1});
            
    

        else
            disp('find no worms!');
        end

        close all


end

