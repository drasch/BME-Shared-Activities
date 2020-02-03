function [KSpace, IM] = imagedomain(xshift, yshift)

IM = zeros(256,256);
IM(128+xshift,128+yshift) = 1;
IM(128-xshift,128-yshift) = 1;

KSpace = fftshift(fft2(IM));

% figure;
% subplot 121
% imshow(IM);
% 
% subplot 122
% imshow(abs(KSpace./max(KSpace(:))));
end

