function parameters = tform_parameter2(img, template)

    threshold = 170;
    num_positive_pixels = 250;

    binary_img = img > threshold;
    binary_template = template > threshold;

    if sum(binary_img,'all') > num_positive_pixels

        Y = size(img,1);
        X = size(img,2);
           
        tformEstimate = imregcorr(binary_img, binary_template,"rigid");

        delta_x = tformEstimate.Translation(1);
        delta_y = tformEstimate.Translation(2);
        theta = tformEstimate.RotationAngle;

        normalized_delta_x = delta_x/X;
        normalized_delta_y = delta_y/Y;

        parameters = [normalized_delta_x normalized_delta_y theta];

    else

        disp('no worms can be found!')
        parameters = [];

    end

end



