% Read the image (replace 'your_image.jpg' with the actual image filename)
rgbImage = imread('your_image.jpg');
imshow (rgbImage)
% Convert the image to grayscale
grayImage = im2gray(rgbImage); % or rgb2gray(rgbImage);
% Apply edge detection to enhance the circular edges
edgeImage = edge(grayImage, 'canny');
% Define the radius range for the circles you want to detect
minRadius = 10;
maxRadius = 50;
% Detect circles using Hough Circle Transform
[centers, radii, ~] = imfindcircles(edgeImage, [minRadius, maxRadius], 'ObjectPolarity', 'bright');
% Create a new black image of the same size as the original image
blackImage = zeros(size(rgbImage, 1), size(rgbImage, 2));
% Draw the detected circles on the black image
for i = 1:numel(radii)
    centerX = centers(i, 1);
    centerY = centers(i, 2);
    radius = radii(i);
    circlePixels = draw_circle([centerX, centerY], radius, size(rgbImage));
    blackImage(circlePixels) = 1;
end
% Calculate the entropy of the resulting image
entropyValue = entropy(blackImage);
% Display the original image with detected circles
figure;
imshow(rgbImage);
hold on;
viscircles(centers, radii, 'EdgeColor', 'r');
title('Detected Circular Particles');
% Display the separated circles image
figure;
imshow(blackImage);
title('Separated Circles Image');
disp(['Entropy of separated circles image: ', num2str(entropyValue)]);
% Function to draw a circle given its center and radius
function circlePixels = draw_circle(center, radius, imageSize)
    [X, Y] = meshgrid(1:imageSize(2), 1:imageSize(1));
    circlePixels = (X - center(1)).^2 + (Y - center(2)).^2 <= radius^2;
end
