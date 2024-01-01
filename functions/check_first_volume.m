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
            fprintf('red arrow angle = %2f \n', theta1/pi*180);
            annotation('arrow',[0.5, 0.5+0.1*cos(theta2)], [0.5, 0.5+0.1*sin(theta2)],'Color','g');
            fprintf('green arrow angle = %2f \n', theta2/pi*180);
            filename = fullfile('MIP_of_first_stack.png');
            exportgraphics(gca,filename);

            fprintf('Check %s in the current directory \n', filename);

            reply = input('Is the head direction in parallel with the red or green arrow? Input red/green [red]:', 's');

            if strcmp(reply,'red')
                PC1 = cor_coef(:,1);
                fprintf('red arrow (PC1) indicates head direction \n');
            else
                PC1 = cor_coef(:,2);
                fprintf('green arrow (PC1) indicates head direction \n');
            end

            flip = input('Flip PC1 to better represent head direction? Y/N [N]:','s');
            
            if isempty(flip)
                flip = 'N';
            end
            
            if strcmp(flip,'Y')
                PC1 = -PC1;
            end

            suggested_angle = acos(dot(PC1,[-1;0]))/pi*180;

            fprintf('The rotation angle between PC1 and -x axis is about %d degrees \n', round(suggested_angle));

            reply = input('Enter the rotation angle (in degrees) between PC1 and -x axis [Return to use suggested angle]: ','s');
            
            if isempty(reply)              
                theta = round(suggested_angle);
                fprintf('use suggested angle %d \n', theta);
            else
                theta = str2double(reply);
            end
            
    

        else
            disp('find no worms!');
        end

        close all


end

