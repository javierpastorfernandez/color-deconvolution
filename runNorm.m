function runNorm

% im_dir = 'C:\Users\tam128\Documents\MATLAB\Norm\Tiles_512';
% targ_dir = 'C:\Users\tam128\Documents\MATLAB\Norm\Tiles_512\Target\';
% print_dir = 'C:\Users\tam128\Documents\MATLAB\Norm\15 Targets Tiles 512';
code_dir = 'D:\Documents\Tiles_Norm\codes\';addpath(genpath(code_dir));
%spams_dir = 'D:\Documents\Tiles_Norm\codes\spams-matlab';
%cd(spams_dir); start_spams;addpath(genpath(spams_dir));

cd(code_dir);
data_dir = 'D:\Documents\Tiles_Norm\';
im_dir = fullfile(data_dir,'Tiles_2k');
targ_dir = fullfile(data_dir,'Target_2k');
print_dir = fullfile(data_dir,'normalized_images_2k_24May17');
if ~exist(print_dir,'dir');mkdir(print_dir);end;

imlist = dir(fullfile(im_dir,'*.tif'));
imlist = {imlist.name}';
targlist = dir(fullfile(targ_dir,'*.tif'));
targlist = {targlist.name}';
targlist = {'ocmmhhrtzz5.tif'};
%time_matrix = cell(length(targlist),1);
time_matrix = cell(length(targlist),length(imlist));
%time_matrix = cell(5,length(imlist));

method_names = {'Luong','Macenko','Reinhard','Khan','Vahadane','VahadaneFast'};
method_names = {'Luong'};

for i = 1:length(method_names)
   outdir = fullfile(print_dir,method_names{i});
   if ~exist(outdir,'dir'); mkdir(outdir);end;
end

if ~exist(targ_dir,'dir'); mkdir(targ_dir);end;
for i=1:length(targlist)
    targetname = targlist{i};
    target = imread(fullfile(targ_dir,targetname));
    tt = tic;
    %time_matrix_target = cell(length(imlist),1);
    for j=1:length(imlist)
        imname = imlist{j};imname = lower(imname);
        time_methods = zeros(1,6);
        if strcmp(targetname, imname)== 0
            source_im = imread(fullfile(im_dir,imname));
            start = tic; normLuong = NormLuong(source_im, target);
            time_methods(1) = toc(start);
            printfile(fullfile(print_dir, method_names{1}), normLuong, targetname, imname);
%             start = tic; normMacenko = NormMacenko(source_im, target);
%             time_methods(2) = toc(start);
%             printfile(fullfile(print_dir, method_names{2}), normMacenko, targetname, imname);
%             start = tic; normReinhard = im2uint8(NormReinhard(source_im, target));
%             time_methods(3) = toc(start);
%             printfile(fullfile(print_dir, method_names{3}), normReinhard, targetname, imname);
%             start = tic; normSCDLeeds = NormSCDLeeds(source_im, target);
%             time_methods(4) = toc(start);
%             printfile(fullfile(print_dir, method_names{4}), normSCDLeeds, targetname, imname);
%             start = tic; normVahadane = SNMFnorm(source_im, target);
%             time_methods(5) = toc(start);
%             printfile(fullfile(print_dir, method_names{5}), normVahadane, targetname, imname);
%             start = tic; normVahadaneFast = Demo_colornorm(source_im, target);
%             time_methods(6) = toc(start);
%             printfile(fullfile(print_dir, method_names{6}), normVahadaneFast, targetname, imname);
        end
        time_matrix{i, j} = time_methods;
        %time_matrix_target{j} = time_methods;
    end
    %time_matrix{i} = time_matrix_target;
    timepassed = toc(tt);
    fprintf('Done with target num %d: %s in %.2f seconds\n',i, targetname,timepassed);
end
%save('total_time_Aug_4_Vahadane.mat', 'time_matrix');
end