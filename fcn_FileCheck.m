function [B_Files,G_Files] = fcn_FileCheck(cur_dir)
% Check for the 'Blue' and 'Green' tif files in the folder 'dir'
addpath(cur_dir)
HomeCD = cd(cur_dir);
B_Files = dir('*Blue*.TIF');
G_Files = dir('*Green*.TIF');
cd(HomeCD)
end

