function [Kxx, Kyy, Kxy] = calculateDoubleDerivatives(normalMap, pixelSizeX, pixelSizeY,Dx,Dy)
    % If pixel sizes are not provided, default to 1
    if nargin < 2
        pixelSizeX = 1;
        pixelSizeY = 1;
    end
    
    % First calculate Dx and Dy
%     Dx = calculateDirectionalDerivativeX(normalMap, pixelSizeX);
%     Dy = calculateDirectionalDerivativeY(normalMap, pixelSizeY);
    
    % Convert back to single precision and [-1,1] range for calculations
    Dx = single(Dx)/127.5 - 1;
    Dy = single(Dy)/127.5 - 1;
    
    % Calculate second derivatives using central differences
    [dDx_dx, dDx_dy] = gradient(Dx);
    [dDy_dx, dDy_dy] = gradient(Dy);
    
    % Scale by pixel sizes
    Kxx = dDx_dx / pixelSizeX;  % Second derivative in x direction
    Kyy = dDy_dy / pixelSizeY;  % Second derivative in y direction
    % Kxy = dDx_dy / pixelSizeY;  % Mixed partial derivative
    Kxy = (dDx_dy + dDy_dx) / (2 * pixelSizeY); % Average of both mixed derivatives

%     Mathematically, for a well-behaved surface (specifically, a C² continuous surface), 
%     the mixed partial derivatives should be equal:
% 
%       dDx_dy = ∂²z/∂x∂y
%       dDy_dx = ∂²z/∂y∂x
% 
%     According to Schwarz's theorem (also called Clairaut's theorem), 
%     these mixed derivatives should be equal: ∂²z/∂x∂y = ∂²z/∂y∂x,
%     assuming the function is sufficiently smooth.
    
    % Convert to visualization range [0, 255]
    % Function to normalize and convert to uint8
    function result = normalizeToUint8(data)
        maxVal = max(abs(data(:)));
        if maxVal > 0
            data = data / maxVal;
        end
        result = uint8((data + 1) * 127.5);
    end
    
    Kxx = normalizeToUint8(Kxx);
    Kyy = normalizeToUint8(Kyy);
    Kxy = normalizeToUint8(Kxy);
end