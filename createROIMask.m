function [roiPosition,mask] = createROIMask(Image)


imshow(Image);  
roi = drawrectangle('Label', 'ROI','Color','r');
roiPosition = roi.Position;
mask = false(size(Image,1), size(Image,2));
mask(round(roiPosition(2)):round(roiPosition(2)+roiPosition(4)), round(roiPosition(1)):round(roiPosition(1)+roiPosition(3))) = true;

end