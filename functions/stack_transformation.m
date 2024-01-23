function [red_stack, green_stack] = stack_transformation(red_stack,green_stack,tform_parameter, data_type)
        
           
    % translate the neuron cluster to the center of an image

    if strcmp(data_type, 'uint8')
        red_stack = convert2uint8(red_stack);
        green_stack = convert2uint8(green_stack);
    end

    X = size(red_stack,2);
    Y = size(red_stack,1);
    depth = size(red_stack, 3);
        
    delta_x = tform_parameter(1)*X;
    delta_y = tform_parameter(2)*Y;

    translation = [delta_x delta_y];
    tform = rigidtform2d(0, -translation);
    sameAsInput = affineOutputView([X,Y],tform,"BoundsStyle","SameAsInput");
            
    for z=1:depth
        red_stack(:,:,z) = imwarp(red_stack(:,:,z),tform,"cubic","OutputView",sameAsInput);
        green_stack(:,:,z) = imwarp(green_stack(:,:,z),tform,"cubic","OutputView",sameAsInput);
    end

    %rotate the image counterclockwisely

    theta = tform_parameter(3);
            
    for z=1:depth
        red_stack(:,:,z) = imrotate(red_stack(:,:,z), theta,"bicubic","crop");
        green_stack(:,:,z) = imrotate(green_stack(:,:,z), theta,"bicubic","crop");
    end

    
end