clear all
close all

addpath("../functions");
addpath("../scripts");



data_directory = 'F:\SAA\20240109_saa_wNEMOs_preprocess\w2\stk1\';
red_stacks_filename = [data_directory,'/', 'ImgStk001_dk001_w2_red_812to1811.mat'];
green_stacks_filename = [data_directory, '/','ImgStk001_dk001_w2_green_812to1811.mat'];

temp_red = load(red_stacks_filename);
temp_green = load(green_stacks_filename);


field_r = fieldnames(temp_red);
field_g = fieldnames(temp_green);

red_stacks = getfield(temp_red,field_r{1});
green_stacks = getfield(temp_green,field_g{1});
clear temp_red;
clear temp_green;

binning = true;

if binning

    red_stacks = binning2by2(red_stacks);
    green_stacks = binning2by2(green_stacks);

end

flip = true; 

if flip
    green_stacks =Flipstacks(green_stacks);
end

%if centerline has been extracted, load them. If not, explain away the following lines.
%centerline_filename = [data_directory, '/','imgstk2_IR_centerline.mat'];
%temp_centerline = load(centerline_filename);
%fieldname = fieldnames(temp_centerline);
%centerlines = getfield(temp_centerline,fieldname{1});
%clear temp_centerline;






