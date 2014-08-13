% Luong Nguyen
% June 12th
% create figure for the abstract. 

close all;
workdir = '/Users/lun5/Research/color_deconvolution'; 
resultdir = fullfile(workdir, 'results',datestr(now,'yymmdd'));

if ~exist(resultdir,'dir')
    mkdir(resultdir);
end
% need to load new training data
trainingdir = fullfile(workdir, 'results', '140625');
% Read the input in RGB form
training_purple = load([trainingdir filesep 'training_purple.mat'],'training_data_purple');
training_pink = load([trainingdir filesep 'training_pink.mat'],'training_data_pink');
X_purple_rgb = training_purple.training_data_purple;
X_pink_rgb = training_pink.training_data_pink;

standard_purple_rgb = mean(X_purple_rgb,2)';
standard_pink_rgb = mean(X_pink_rgb,2)';
%standard_purple_rgb = [128,1,128];
%standard_pink_rgb = [255,20,147];

standard_purple_hsv = rgb2hsv(standard_purple_rgb./255);
standard_pink_hsv = rgb2hsv(standard_pink_rgb./255);
[x_purple, y_purple] = pol2cart(standard_purple_hsv(1) - pi/2,standard_purple_hsv(2));
[x_pink, y_pink] = pol2cart(standard_pink_hsv(1)- pi/2,standard_pink_hsv(2));
%[x_purple, y_purple] = pol2cart(standard_purple_hsv(1),standard_purple_hsv(2));
%[x_pink, y_pink] = pol2cart(standard_pink_hsv(1),standard_pink_hsv(2));

% color wheel
r = linspace(0,1,10);
theta = linspace(0, 2*pi, 1000);
[rg, thg] = meshgrid(r,theta);
[x,y] = pol2cart(thg,rg);

%%
h = figure; %subplot(1,1,1);
h0 = pcolor(x,y,thg);
colormap(hsv);
hold on
h1 = plot([0 x_purple],[0 y_purple],'-', 'LineWidth',3,'Color',standard_purple_rgb./255);
%h2 = plot([0 x_pink],[0 y_pink],'-', 'LineWidth',3,'Color',standard_pink_rgb./255);
h2 = plot([0 x_pink],[0 y_pink],'-', 'LineWidth',3,'Color','g'); %standard_pink_rgb./255);
legend([h1, h2],'purple', 'pink')
set(gca,'FontSize',20);
shading flat;
axis equal;
axis([-1 1 -1 1]);
axis off
print(h,'-dtiff', [resultdir filesep 'hsv' datestr(now,'hhMM') '.tiff']);

%%
% new color space
training_data = [X_purple_rgb(:,1:3000) X_pink_rgb(:,1:9000)];
[U,D,V] = svd(training_data,0);
rotation_matrix = [-U(:,1) U(:,2:3)]'; % this is correct one

% plot the sic coordinates
options = struct('Normalize','on');
mu_s = 4; sigma_s = 2;
[training_oppCol,~] = rgb2oppCol(training_data,mu_s, sigma_s, rotation_matrix, options); 
standard_purple_oppCol = rgb2oppCol(standard_purple_rgb', mu_s, sigma_s, rotation_matrix, options);
standard_pink_oppCol = rgb2oppCol(standard_pink_rgb', mu_s, sigma_s, rotation_matrix, options);
% scatter plot of training data
%subplot(1,2,2);
h3 =figure; 
scatter(training_oppCol(1,:),training_oppCol(2,:),20,training_data'./255,'filled');
hold on
%xlabel('s1','FontSize',15);ylabel('s2','FontSize',15);
%line([-1 1],[0 0],'Color','k')
%line([0 0],[-1 1],'Color','k')
h4 = plot([0 standard_purple_oppCol(1)],[0 standard_purple_oppCol(2)],'-', 'LineWidth',3,'Color',standard_purple_rgb./255);
%h4 = plot([0 standard_purple_oppCol(1)],[0 standard_purple_oppCol(2)],'-', 'LineWidth',3,'Color','b');
%h5 = plot([0 standard_pink_oppCol(1)],[0 standard_pink_oppCol(2)],'-', 'LineWidth',3,'Color',standard_pink_rgb./255);
h5 = plot([0 standard_pink_oppCol(1)],[0 standard_pink_oppCol(2)],'-', 'LineWidth',3,'Color','g'); %standard_pink_rgb./255);
legend([h4, h5],'purple', 'pink');
hold off
%title('Color opponency 2D representation','FontSize',15);
axis([-1 1 -1 1])
set(gca,'FontSize',20); 
axis equal
%grid on
axis off
print(h3,'-dtiff', [resultdir filesep 'trainingCOspace' datestr(now,'hhMM') '.tiff']);

% purp_pink_image = zeros(100,200,3);
% purp_pink_image(:,1:100,1) = standard_purple_rgb(1);
% purp_pink_image(:,1:100,2) = standard_purple_rgb(2);
% purp_pink_image(:,1:100,3) = standard_purple_rgb(3);
% purp_pink_image(:,101:end,1) = standard_pink_rgb(1);
% purp_pink_image(:,101:end,2) = standard_pink_rgb(2);
% purp_pink_image(:,101:end,3) = standard_pink_rgb(3);
% purp_pink_image =uint8(purp_pink_image);
% imwrite(purp_pink_image,'purp_pink_image.tif')
% I = imread('purp_pink_image.tif'); imshow(I,[]);

