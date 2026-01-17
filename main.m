%================================================
%% Run before
%================================================

% Clean variables
clear all; 
% Close all figures
close all; 
% Clean the commands window
clc; 


% Path (absolute or relative) of the acquisition
% AcquisitionPath = 'C:/Users/imvia/Desktop/catchIDI/CATCH_IDI_1/images/Face_A/rti'; 
% LPFileName = 'LP_35_D500_L1.lp';

% AcquisitionPath = 'F:/Beads_RTI/ALL_BEADS_BLACK_JPEG/ALL_BEADS_BLACK_JPEG/images/Face_A/rti';
% LPFileName = 'LP_105_D500.lp';

% AcquisitionPath = 'Shell/'; 
% LPFileName = 'LP_105_D500.lp';

% AcquisitionPath = '1D/'; 
% LPFileName = 'AGH_corrected.lp';

% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\Rust20';
% LPFileName = 'lp20.lp';
% testimage_path = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\Rust10\0007.png';


% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\adaptivelp10_add10\Global10new';
% LPFileName = '10newRustlp10.lp';

% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\adaptivelp10_add10\Cluster4new10';
% LPFileName = 'cluster4_newRustlp10.lp';

% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\adaptivelp10_add10\Cluster3new10';
% LPFileName = 'cluster3_newRustlp10.lp';
% 
% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\adaptivelp10_add10\Cluster2new10';
% LPFileName = 'cluster2_newRustlp10.lp';
% 

% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\adaptivelp10_add10\Cluster1new10';
% LPFileName = 'cluster1_newRustlp10.lp';


% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Rust\Rust20';
% LPFileName = 'lp20.lp';


% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Necklace\adaptivelp10_add10\Global_new10';
% LPFileName ='Necklace_10_new10_global.lp';

% AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Necklace\adaptivelp10_add10\Cluster1_new10';
% LPFileName ='Necklace_10_new10_Cluster1.lp';

AcquisitionPath = 'E:\PHD\Project\Papers\Journal_SARTIF\dataset\Dataset_Necklace\Necklace_20';
LPFileName ='lp20.lp';

[LP] = loadLP1(fullfile(AcquisitionPath, LPFileName));


% Get current directory
currentDir = pwd;

% Create full path for figures directory
figuresDir = fullfile(currentDir, 'Necklace20');
[~, dataset] = fileparts(figuresDir);

% Check if figures directory exists, if not create it
if ~exist(figuresDir, 'dir')
    mkdir(figuresDir);
end
%% Calculate mean RGB
rgbMean = calculateRGBMean(LP);

figure;
imshow(rgbMean);
%title('RGB Mean Image');
%print('-depsc2', 'figures/rgb_mean_image.eps');
%saveas(gcf, 'figures/rgb_mean_image.png');
% Use JPEG compression in EPS
%print('-djpeg', '-r300','figures/V1D_mean.jpg');
outFile = fullfile(figuresDir, [folderName '_' dataset '_mean_map_roi.jpg']);
exportgraphics(gcf, outFile, 'Resolution', 400, 'BackgroundColor', 'white');

% exportgraphics(gcf, 'Shell_figures/Shell_mean.jpg', 'Resolution', 400, 'BackgroundColor', 'white');



%% Calculate StD RGB
rgbStd = calculateRGBStd(LP);

figure;
imshow(rgbStd);
%title('RGB Standard Deviation Image');
%print('-depsc2', 'figures/rgb_std.eps');
%saveas(gcf, 'figures/rgb_std_image.png');
%print('-djpeg', '-r300','figures/V1D_std.jpg');
exportgraphics(gcf, 'Shell_figures/Shell_std.jpg', 'Resolution', 400, 'BackgroundColor', 'white');
%% Calculate RGB median image
rgbMedian = calculateRGBMedian(LP);

% Display the result
figure;
imshow(rgbMedian);
%title('RGB Median Image');
%print('-depsc2', 'figures/rgb_median.eps');
%saveas(gcf, 'figures/rgb_median_image.png');
%print('-djpeg', '-r300','figures/V1D_median.jpg');
exportgraphics(gcf, 'Shell_figures/Shell_median.jpg', 'Resolution', 400, 'BackgroundColor', 'white');
%% Calculate RGB maximum image
rgbMax = calculateRGBMax95(LP);

% Display the result
figure;
imshow(rgbMax);
%title('RGB Maximum Image');
%print('-depsc2', 'figures/rgb_max.eps');
%saveas(gcf, 'figures/rgb_max_image.png');
%print('-djpeg', '-r300','figures/V1D_max.jpg');
exportgraphics(gcf, 'Shell_figures/Shell_max_925.jpg', 'Resolution', 400, 'BackgroundColor', 'white');
%% Calculate RGB minimum image
rgbMin = calculateRGBMin95(LP);

% Display the result
figure;
imshow(rgbMin);
%title('RGB Minimum Image');
%saveas(gcf, 'figures/rgb_min_image_normalized.png');
%print('-depsc2', 'figures/rgb_min.eps');
%print('-djpeg', '-r300','figures/V1D_minde.jpg');
exportgraphics(gcf, 'Shell_figures/Shell_min_99perc.jpg', 'Resolution', 400, 'BackgroundColor', 'white');




%% Statistical Second order analysis




%% Calculate skewness using previously calculated mean and std
% In the skewness calculation function, before normalization
[rawSkewness, norm_Skewness] = calculateRGBSkewness(LP, rgbMean, rgbStd);



figure;
imagesc(rawSkewness);
colormap('gray');
clim([min(rawSkewness(:)) max(rawSkewness(:))]);  % Non-symmetric
colorbar;
title('RGB Skewness- Non-symmetric Scale');

figure;
imagesc(rawSkewness(:,:,3));
% Get min and max values
% minVal = min(min(rawSkewness(:,:,3)));
% maxVal = max(max(rawSkewness(:,:,3)));
% Create custom colormap that changes at zero
% negLength = round(512 * abs(minVal)/(abs(minVal) + maxVal));
% posLength = 512 - negLength;
% Create asymmetric colormap (blue for negative, red for positive)
%customMap = [flipud(winter(negLength)); autumn(posLength)];
% Or another option: 
% customMap = [flipud(cool(negLength)); autumn(posLength)];
% colormap(customMap);
% clim([minVal maxVal]);
colormap("jet")
clim([-0.2 0.2]);
colorbar;
%title('Skewness Values - Blue Channel (Zero-Centered Colormap)');
axis image;
axis off;
%print('-djpeg', '-r300', 'figures/Skewness_blue_channel.jpg')
exportgraphics(gcf, 'Shell_figures/Shell_Skewness_blue_channel.jpg', 'Resolution', 400, 'BackgroundColor', 'white');



figure;
imagesc(rawSkewness(:,:,2));
% Get min and max values
%minVal = min(min(rawSkewness(:,:,2)));
%maxVal = max(max(rawSkewness(:,:,2)));
% Create custom colormap that changes at zero
%negLength = round(512 * abs(minVal)/(abs(minVal) + maxVal));
%posLength = 512 - negLength;
% Create asymmetric colormap (blue for negative, red for positive)
%customMap = [flipud(winter(negLength)); hot(posLength)];
% Or another option: 
%customMap = [flipud(cool(negLength)); autumn(posLength)];
%colormap(customMap);
colormap("jet")
clim([-0.2 0.2]);
%clim([minVal maxVal]);
colorbar;
%title('Skewness Values - Green Channel (Zero-Centered Colormap)');
axis image;
axis off;
%print('-djpeg', '-r300', 'figures/Skewness_green_channel.jpg')
exportgraphics(gcf, 'Shell_figures/Shell_Skewness_green_channel.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
imagesc(rawSkewness(:,:,1));
% Get min and max values
% minVal = min(min(rawSkewness(:,:,1)));
% maxVal = max(max(rawSkewness(:,:,1)));
% Create custom colormap that changes at zero
% negLength = round(512 * abs(minVal)/(abs(minVal) + maxVal));
% posLength = 512 - negLength;
% Create asymmetric colormap (blue for negative, red for positive)
%customMap = [flipud(winter(negLength)); hot(posLength)];
% Or another option: 
% customMap = [flipud(cool(negLength)); autumn(posLength)];
colormap("jet")
clim([-0.2 0.2]);
colorbar;
%title('Skewness Values - Red Channel (Zero-Centered Colormap)');
axis image;
axis off;
%print('-djpeg', '-r300', 'figures/Skewness_red_channel.jpg')
exportgraphics(gcf, 'Shell_figures/Shell_Skewness_red_channel.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

% Normalized Skewness
% figure;
% imagesc(rgb2gray(norm_Skewness));  % Convert to grayscale for better visualization
% colormap('gray');  % or use other colormaps like 'parula', 'hot', or custom diverging colormap
% colorbar;
% title('RGB Skewness Image');

% Positive Skewness tells us that Distribution has a longer tail towards higher intensities (to mean value). More extreme bright values than dark values.  


%% Calculate kurtosis using previously calculated mean and std
rgbKurtosis = calculateRGBKurtosis(LP, rgbMean, rgbStd);

% Display the result
figure;
imshow(rgbKurtosis(:,:,2));
title('RGB Kurtosis Image');
saveas(gcf, 'Shell_figures/Shell_meanrgb_kurtosis_image.png');

figure;
imshow(rgbKurtosis(:,:,3));
colormap("jet")
clim([-0.1 0.1]);
colorbar;
%title('Skewness Values - Red Channel (Zero-Centered Colormap)');
%axis image;






%% Calculate normal map
normalMap = calculateRGBNormal(LP);

% % Display the result
% figure;
% imshow(normalMap);
% %title('Surface Normal Map');
% axis off;
% saveas(gcf, 'figures/V124_normalMap.png');

% Show the normal map for ROI selection
figure;
imshow(normalMap);
title('Select Region of Interest');

% Let user select ROI interactively
[roiPosition,mask] = createROIMask(normalMap);

% Extract ROI from normal map
x = round(roiPosition(1));
y = round(roiPosition(2));
width = round(roiPosition(3));
height = round(roiPosition(4));
normalMap_roi = normalMap(y:y+height-1, x:x+width-1, :);

% Display only the ROI of the normal map
figure;
imshow(normalMap_roi);
axis off;
%title('ROI of Normal Map');
[~, folderName] = fileparts(AcquisitionPath);
outFile = fullfile(figuresDir, [folderName '_' dataset '_normal_map_roi.jpg']);
exportgraphics(gcf, outFile, 'Resolution', 400, 'BackgroundColor', 'white');


% exportgraphics(gcf, 'Rust_Figures/Global20_normal_map_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');
%% Calculate directional derivative X
% Assuming pixelSizeX is in millimeters
pixelSizeX = 1;  % adjust based on your actual pixel size
Dx = calculateDirectionalDerivativeX(normalMap_roi, pixelSizeX);

% Display the result
figure;
%imshow(Dx);
imshow(imadjust(Dx));
%title('Directional Derivative X');
colormap('gray');
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Dx_image.png');
outFile = fullfile(figuresDir, [folderName '_' dataset '_Dx_roi.jpg']);
exportgraphics(gcf, outFile, 'Resolution', 400, 'BackgroundColor', 'white');
% exportgraphics(gcf, 'Rust_Figures/Globallp20_Dx_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');
% Calculate directional derivative Y
% Assuming pixelSizeY is in millimeters
pixelSizeY = 1;  % adjust based on your actual pixel size
Dy = calculateDirectionalDerivativeY(normalMap_roi, pixelSizeY);

% Display the result
figure;
%imshow(Dy);
imshow(imadjust(Dy));
%title('Directional Derivative Y');
colormap('gray');
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Dy_image.png');
outFile = fullfile(figuresDir, [folderName '_' dataset '_Dy_roi.jpg']);
exportgraphics(gcf, outFile, 'Resolution', 400, 'BackgroundColor', 'white');

% exportgraphics(gcf, 'Rust_Figures/Globallp20_Dy_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');



%% Calculate second derivatives
[Kxx, Kyy, Kxy] = calculateDoubleDerivatives(normalMap_roi, pixelSizeX, pixelSizeY, Dx, Dy);

% Display results
figure;
%imshow(Kxx);
imshow(imadjust(Kxx))
%title('Kxx (d²/dx²)');
colormap('gray');
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Dxx_image.png');
exportgraphics(gcf, 'Rust_Figures/lp300_Dxx_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
%imshow(Kyy);
imshow(imadjust(Kyy))
%title('Kyy (d²/dy²)');
colormap('gray');
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Dyy_image.png');
exportgraphics(gcf, 'Shell_figures/Dyy_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
%imshow(Kxy);
imshow(imadjust(Kxy))
%title('Kxy (d²/dxdy)');
colormap('gray');
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Dxy_image.png');
exportgraphics(gcf, 'Shell_figures/Dxy_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');



% %% Calculate second derivatives
% [Kxx, Kyy, Kxy] = calculateDoubleDerivatives_Visual(normalMap_roi, pixelSizeX, pixelSizeY);
% 
% 
% % Create custom colormap for better visualization
% % Blue (concave) to White (flat) to Red (convex)
% customColormap = [flipud(autumn(128)); winter(128)];
% 
% figure;
% imagesc(double(Kxx));
% %title('Kxx - Second Derivative X');
% colormap(customColormap);
% colorbar;
% axis off;
% saveas(gcf, 'figures/rgb_DxxVisual_image.png');
% 
% 
% figure;
% imagesc(double(Kyy));
% %title('Kyy - Second Derivative Y');
% colormap(customColormap);
% colorbar;
% axis off;
% saveas(gcf, 'figures/rgb_DyyVisual_image.png');
% 
% figure;
% imagesc(double(Kxy));
% %title('Kxy - Mixed Derivative');
% colormap(customColormap);
% colorbar;
% axis off;
% saveas(gcf, 'figures/rgb_DxyVisual_image.png');

%% Calculate critical curvatures
[Kmin, Kmax] = calculateCriticalCurvatures(normalMap_roi, pixelSizeX, pixelSizeY,  Kxx, Kyy, Kxy);

% Display results
figure;
imshow(imadjust(Kmin));
axis image; 
%title('Minimum Curvature (Kmin)');
colormap("gray");
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Kmin_image.png');
exportgraphics(gcf, 'Shell_figures/Kmin_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
%imagesc(double(Kmax));
imshow(imadjust(Kmax));
axis image; 
%title('Maximum Curvature (Kmax)');
colormap("gray");
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Kmax_image.png');
exportgraphics(gcf, 'Shell_figures/Kmax_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

%% Calculate invariant curvatures
[Kmean, Kgaussian, Kmehlum] = calculateInvariantCurvatures(normalMap_roi, pixelSizeX, pixelSizeY, Kmin, Kmax);

% Display results
figure;
imshow(imadjust(Kmean))
%imagesc(double(Kmean));
axis image; 
%title('Mean Curvature (Kµ)');
colormap(gca, "gray");
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_Kmean_image.png');
exportgraphics(gcf, 'Shell_figures/Kmean_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
%imagesc(double(Kgaussian));
imshow(imadjust(Kgaussian));
axis image; 
%title('Gaussian Curvature (KG)');
colormap(gca, "gray");
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_KG_image.png');
exportgraphics(gcf, 'Shell_figures/Kgaussian_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');

figure;
%imagesc(double(Kmehlum));
imshow(imadjust(Kmehlum));
axis image; 
%title('Mehlum Curvature (KM)');
colormap(gca, "gray");
%colorbar;
axis off;
%saveas(gcf, 'figures/rgb_KM_image.png');
exportgraphics(gcf, 'Shell_figures/Kmelhum_roi.jpg', 'Resolution', 400, 'BackgroundColor', 'white');




