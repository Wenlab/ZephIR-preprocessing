addpath("../functions");
addpath("../scripts");

date_directory = '/Users/quanwen/Documents/GitHub/calcium imaging';

red_stacks_filename = [data_directory,'/', 'ImgStk001_dk001_w6_Dt231025_{red}_{from-3119-to-5118}_{1to50-trimed}.mat'];
green_stacks_filename = [data_directory, '/','ImgStk001_dk001_w6_Dt231025_{Green}_{from-3119-to-5118}_{fliped}_{1to50-trimed}.mat'];

temp_red = load(red_stacks_filename);
temp_green = load(green_stacks_filename);


field_r = fieldnames(temp_red);
field_g = fieldnames(temp_green);

red_stacks = getfield(temp_red,field_r{1});
green_stacks = getfield(temp_green,field_g{1});
clear temp_red;
clear temp_green;

centerline_filename = [data_directory, '/','w6_{IR_vedio}_{from-3211-to-3710}_{correspoding-to-ImgStk001_dk001-1to50}.mat'];
temp_centerline = load(centerline_filename);
fieldname = fieldnames(temp_centerline);
centerlines = getfield(temp_centerline,fieldname{1});
clear temp_centerline;

binning = true;

if binning

    red_stacks = binning2by2(red_stacks);
    green_stacks = binning2by2(green_stacks);

end




