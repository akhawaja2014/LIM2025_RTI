function [Kxx, Kyy, Kxy] = calculateDoubleDerivatives_Visual(normalMap, pixelSizeX, pixelSizeY)
    % If pixel sizes are not provided, default to 1
    if nargin < 2
        pixelSizeX = 1;
        pixelSizeY = 1;
    end
    
    % First calculate Dx and Dy
    Dx = calculateDirectionalDerivativeX(normalMap, pixelSizeX);
    Dy = calculateDirectionalDerivativeY(normalMap, pixelSizeY);
    
    % Convert back to single precision and [-1,1] range for calculations
    Dx = single(Dx)/127.5 - 1;
    Dy = single(Dy)/127.5 - 1;
    
    % Calculate second derivatives using central differences
    [dDx_dx, dDx_dy] = gradient(Dx);
    [dDy_dx, dDy_dy] = gradient(Dy);
    
    % Scale by pixel sizes
    Kxx = dDx_dx / pixelSizeX;
    Kyy = dDy_dy / pixelSizeY;
    Kxy = dDx_dy / pixelSizeY;
    
    % Visualization with better contrast for concave/convex
    function result = visualizeCurvature(data)
        % Normalize to [-1, 1]
        maxVal = max(abs(data(:)));
        if maxVal > 0
            data = data / maxVal;
        end
        
        % Map [-1, 1] to [0, 255]
        % Negative values (concave) -> blue colors (0 to 127)
        % Positive values (convex) -> red colors (128 to 255)
        result = uint8((data + 1) * 127.5);
    end
    
    Kxx = visualizeCurvature(Kxx);
    Kyy = visualizeCurvature(Kyy);
    Kxy = visualizeCurvature(Kxy);
end