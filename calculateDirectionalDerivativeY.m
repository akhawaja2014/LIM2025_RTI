function [Dy] = calculateDirectionalDerivativeY(normalMap, pixelSizeY)
   % If pixelSizeY is not provided, default to 1
   if nargin < 2
       pixelSizeY = 1;
   end
   
   % Get normal components
   % Assuming normalMap is in [0,255] range, convert back to [-1,1]
   Ny = single(normalMap(:,:,2)) / 127.5 - 1;  % Y component
   Nz = single(normalMap(:,:,3)) / 127.5 - 1;  % Z component
   
   % Calculate directional derivative
   % Dy = Py_size * (Ny/Nz)
   Dy = pixelSizeY * (Ny ./ Nz);
   
   % Handle potential division by zero
   Dy(abs(Nz) < eps) = 0;
   
   % Convert to visualization range [0, 255]
   % First normalize to [-1,1] range
   maxVal = max(abs(Dy(:)));
   if maxVal > 0
       Dy = Dy / maxVal;
   end
   
   % Then convert to [0,255] range
   Dy = uint8((Dy + 1) * 127.5);
end