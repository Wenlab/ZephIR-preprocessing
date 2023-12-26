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
[theta_0, lookup_PC1] = check_first_volume(red_stacks{1});

tform_parameters = zeros(T,3);
%translation delta_x, delta_y in normalized coordinates.
%rotation angle theta

for t=1:T

    img = uint8(max(red_stacks{t},[],3));

    [tform_param, lookup_PC1] = tform_parameter(img, theta_0, heading_direction(t), lookup_PC1);

    if ~isempty(tform_param)
    
        [red_stack_tformed, green_stack_tformed] = stack_transformation(red_stacks{t},...
                                                                    green_stacks{t},...
                                                                    tform_param,...
                                                                    data_type);

        %reorganize data into the following order: T C Z Y X
    
        red_stack_tformed = permute(red_stack_tformed,[3,1,2]);
        green_stack_tformed = permute(green_stack_tformed,[3,1,2]);
        stacks(t,1,:,:,:) = green_stack_tformed;
        stacks(t,2,:,:,:) = red_stack_tformed;
        tform_parameters(t,:) = tform_param;

        fprintf('t = %d stack has been preprocessed!\n', t);

    else
        break;
    end
end

filename = [date_directory, '/', 'data.mat'];
save(filename, 'stacks', 'tform_parameters', '-mat');

