addpath("../functions");

x = h5read([data_directory,'/','annotations.h5'],'/x');
y = h5read([data_directory,'/','annotations.h5'],'/y');
%x and y are normalized coordinates of the annotated points

t_idx = h5read([data_directory,'/','annotations.h5'],'/t_idx');
%time index starts from 0 in ZephIR

x_original = x;
y_original = y;

Size = length(x);
%Size = number of annotated neurons \times number of time points

tform_parameters = h5read([data_directory,'/','data.h5'],'/tform_parameters');

for i = 1:Size
    delta_x = tform_parameters(t_idx(i)+1,1);
    delta_y = tform_parameters(t_idx(i)+1,2);
    angle = tform_parameters(t_idx(i)+1,3);
    %center of an image
    pivot = [0.5 0.5]; 
    %rotate the points clockwisely with the specified angle
    %Note the Non-standard orientation of the coordinate system of the
    %image where the y axis is downwards.
    point = rotatePointCloud([x(i) y(i)],pivot, angle);
    point = point + [delta_x delta_y];
    x_original(i) = single(point(1));
    y_original(i) = single(point(2));
end

copyfile([data_directory,'/','annotations.h5'], [data_directory,'/','annotations_edited.h5']);

h5create([data_directory,'/','annotations_edited.h5'],'/x_original',Size);
h5write([data_directory,'/','annotations_edited.h5'],'/x_original',x_original);

h5create([data_directory,'/','annotations_edited.h5'],'/y_original',Size);
h5write([data_directory,'/','annotations_edited.h5'],'/y_original',y_original);


    

