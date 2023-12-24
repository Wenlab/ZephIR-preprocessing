addpath("../functions");

T = length(red_stacks);
C = 2;
Y = size(red_stacks{1},1);
X = size(red_stacks{1},2);
Z = size(red_stacks{1},3);

stacks = zeros(T,C,Z,Y,X,'uint8');

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


for t=1:T
    
    [red_stack_tformed, green_stack_tformed, lookup_PC1] = stack_transformation(red_stacks{t},...
                                                                                green_stacks{t},...
                                                                                heading_direction(t),...
                                                                                lookup_PC1,...
                                                                                theta_0);

    %reorganize data into the following order: T C Z Y X
    
    red_stack_tformed = permute(red_stack_tformed,[3,1,2]);
    green_stack_tformed = permute(green_stack_tformed,[3,1,2]);
    stacks(t,1,:,:,:) = green_stack_tformed;
    stacks(t,2,:,:,:) = red_stack_tformed;

    fprintf('t = %d stack has been preprocessed!\n', t);
end

filename = [datasetpath, '/', 'data.mat'];
save(filename, 'stacks', '-mat');

