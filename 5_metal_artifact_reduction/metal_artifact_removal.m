%% Computed Tomography Reconstruction
% Metal Artifact Reduction (MAR)

clc
clear
close all

%% Load Data
% Load Sinogram
data = load('hip_sino.mat');
data_sino = data.sino;

% Visualize Sinogram
figure('units','normalized','outerposition',[0 0 .6 .75])
imagesc(data_sino)
colormap gray(256)
img_title = "Hip with Metal Prosthesis - Sinogram";
title(img_title,'FontSize',16)
axis off

%% Reconstruct the Data
% Perform reconstruction
data_reco = reconstruct(data_sino);

% Set thresholds for visualization
level = 0.014;
window = 0.007;
vmin = level - window/2;
vmax = level + window/2;

% Visualize Reconstruction
figure('units','normalized','outerposition',[0 0 .4 .75]);
imagesc(data_reco, [vmin vmax]);
colormap gray(256)
img_title = "Hip with Metal Prosthesis - CT Image";
title(img_title,'FontSize',16)
axis('square')
% axis off
xticklabels ''
yticklabels ''

%% Create Metal Mask
% Adjust image for les saturation
img = imadjust(data_reco);

% Perform Canny Edge Detection (shows borders of metal)
canny = edge(data_reco, "canny", 0.02, 2);


% Fill closed regions within image (areas that are metal)
canny_regions = imfill(canny,'holes'); % fill closed areas on the image


% Remove remaining edges from Canny Edge Detection (false readings)
kernel = strel('disk',1);
canny_clean = imopen(canny_regions, kernel);

% Visualize Metal Artifact Detection
figure('units','normalized','outerposition',[0 0 1 .66]);
subplot(1, 3, 1);
imagesc(canny);
colormap gray(256)
img_title = "Canny Edge Detection";
title(img_title,'FontSize',16)
axis('square')
xticklabels ''
yticklabels ''

subplot(1, 3, 2);
imagesc(canny_regions);
colormap gray(256)
img_title = "Filled Regions";
title(img_title,'FontSize',16)
axis('square')
xticklabels ''
yticklabels ''

subplot(1, 3, 3);
imagesc(canny_clean);
colormap gray(256)
img_title = "Isolated Metal Regions";
title(img_title,'FontSize',16)
axis('square')
xticklabels ''
yticklabels ''

%% Mask the full dataset with the metal mask
% Create Sinogram of mask with forward projection
mask_sino = forwardproject(canny_clean);

% Threshold Sinogram of mask with forward projection
level=0.014;
window=0.007;
vmin=level-window/2;
vmax=level+window/2;

% Scale Mask Sinogram to match data sinogram
% mask_sino_log = mask_sino;
% mask_sino_log(mask_sino_log ~= 0) = 1;

%% TODO Solve Mask/Data Merge
% Filter full sinogram with metal mask
% data_masked = data_sino;
data_masked = bsxfun(@minus, data_sino, mask_sino);
% data_masked(mask_sino_log == 1) = 0;

% Visualize Metal Mask Sinogram and Filtered Sinogram of data
figure('units','normalized','outerposition',[0 0 1 .5]);
subplot(1, 3, 1);
imagesc(mask_sino);
colormap gray(256)
img_title = "Isolated Metal Regions - Sinogram";
title(img_title,'FontSize',16)
axis off

subplot(1, 3, 2);
imagesc(mask_sino, [vmin vmax]);
colormap gray(256)
img_title = "Isolated Metal Regions - Sinogram (Thresholds)";
title(img_title,'FontSize',16)
axis off

subplot(1, 3, 3);
imagesc(data_masked);
colormap gray(256)
img_title = "Data Sinogram with Mask Applied";
title(img_title,'FontSize',16)
axis off

%% Reconstruction of Masked Sinogram
reco_masked = reconstruct(data_masked);

% Visualize Reconstruction
figure('units','normalized','outerposition',[0 0 .4 .75]); 
% level=0.014;
% window=0.007;
% vmin=level-window/2;
% vmax=level+window/2;
% imshow(reco_masked,[vmin vmax]);
% colormap gray(256)
imagesc(reco_masked);
colormap gray(256)
img_title = "Masked Reconstruction";
title(img_title,'FontSize',16)
axis('square')
xticklabels ''
yticklabels ''
