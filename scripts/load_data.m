clear all
close all

addpath("../functions");
addpath("../scripts");



data_directory = '/Users/quanwen/Documents/GitHub/calcium imaging/w10_dataset2';

red_stacks_filename = [data_directory,'/', 'imgstk2_red.mat'];
green_stacks_filename = [data_directory, '/','imgstk2_green.mat'];

temp_red = load(red_stacks_filename);
temp_green = load(green_stacks_filename);


field_r = fieldnames(temp_red);
field_g = fieldnames(temp_green);

red_stacks = getfield(temp_red,field_r{1});
green_stacks = getfield(temp_green,field_g{1});
clear temp_red;
clear temp_green;

centerline_filename = [data_directory, '/','imgstk2_IR_centerline.mat'];
temp_centerline = load(centerline_filename);
fieldname = fieldnames(temp_centerline);
centerlines = getfield(temp_centerline,fieldname{1});
clear temp_centerline;

binning = true;

if binning

    red_stacks = binning2by2(red_stacks);
    green_stacks = binning2by2(green_stacks);

end




