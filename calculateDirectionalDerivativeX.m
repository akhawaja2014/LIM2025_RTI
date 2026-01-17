function [Dx] = calculateDirectionalDerivativeX(normalMap, pixelSizeX)
   % If pixelSizeX is not provided, default to 1
   if nargin < 2
       pixelSizeX = 1;
   end
   
   % Get normal components
   % Assuming normalMap is in [0,255] range, convert back to [-1,1]
   Nx = single(normalMap(:,:,1)) / 127.5 - 1;  % X component
   Nz = single(normalMap(:,:,3)) / 127.5 - 1;  % Z component
   
   % Calculate directional derivative
   % Dx = Px_size * (Nx/Nz)
   Dx = pixelSizeX * (Nx ./ Nz);
   
   % Handle potential division by zero
   Dx(abs(Nz) < eps) = 0;
   
   % Convert to visualization range [0, 255]
   % First normalize to [-1,1] range
   maxVal = max(abs(Dx(:)));
   if maxVal > 0
       Dx = Dx / maxVal;
   end
   
   % Then convert to [0,255] range
   Dx = uint8((Dx + 1) * 127.5);
end