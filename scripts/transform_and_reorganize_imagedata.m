addpath("../functions");

data_type = 'uint8';
%ZephIR does not support uint16

T = length(red_stacks);
C = 2;
Y = size(red_stacks{1},1);
X = size(red_stacks{1},2);
Z = size(red_stacks{1},3);


stacks = zeros(T,C,Z,Y,X,data_type);




%the heading_direction is extracted from the centerlines, where the
%direction at t=0 is defined as 0.
if exist('centerlines','var')
    angles = head_orientation(centerlines);
    t_videos = length(centerlines);
    interval = round(t_videos/T);
    angles = movavg(angles, 'simple', interval);
    heading_direction = angles(1:interval:end);
else
    heading_direction = nan(1,T);
end


%return the rotation angle of the first image stack and the principal axis
%of PC1
[tform_param, lookup_PC1] = check_first_volume(red_stacks{1});

%when head direction cannot be easily extracted (either using PCA or centerlines)
%do not perform rotation
forbid_rotation = True;

if forbid_rotation
    tform_param(3) = 0;
end

[red_stack_tformed, green_stack_tformed] = stack_transformation(red_stacks{1},...
                                                                green_stacks{1},...
                                                                tform_param,...
                                                                data_type);

template = max(red_stack_tformed,[],3);

red_stack_tformed = permute(red_stack_tformed,[3,1,2]);
green_stack_tformed = permute(green_stack_tformed,[3,1,2]);
stacks(1,2,:,:,:) = green_stack_tformed;
stacks(1,1,:,:,:) = red_stack_tformed;

tform_parameters = zeros(T,3);
tform_parameters(1,:) = tform_param;
theta_0 = tform_param(3);



%translation delta_x, delta_y in normalized coordinates.
%rotation angle theta




for t=2:T

    img = max(uint8(red_stacks{t}),[],3);

    [tform_param, lookup_PC1] = tform_parameter(img, theta_0, heading_direction(t), lookup_PC1);
    %tform_param = tform_parameter2(img, template);
    if forbid_rotation
        tform_param(3) = 0;
    end
    
    if ~isempty(tform_param)
    
        [red_stack_tformed, green_stack_tformed] = stack_transformation(red_stacks{t},...
                                                                    green_stacks{t},...
                                                                    tform_param,...
                                                                    data_type);
        %reorganize data into the following order: T C Z Y X
    
        red_stack_tformed = permute(red_stack_tformed,[3,1,2]);
        green_stack_tformed = permute(green_stack_tformed,[3,1,2]);
        stacks(t,2,:,:,:) = green_stack_tformed;
        stacks(t,1,:,:,:) = red_stack_tformed;
        tform_parameters(t,:) = tform_param;

        fprintf('t = %d stack has been preprocessed!\n', t);

    else
        break;
    end
    
end

%filename = [data_directory, '/', 'data.mat'];
%save(filename, 'stacks', 'tform_parameters', '-mat');

filename = [data_directory, '/', 'data.h5'];
save2h5(filename,stacks,tform_parameters);

