function [weight_x, weight_y] = Gradient_weight(I)

I = rgb2gray(I);
lambda = 10;

f1 = [1, -1];
f2 = [1; -1];

Gx = -imfilter(I, f1, 'circular');
Gy = -imfilter(I, f2, 'circular');

ax = exp(-lambda * abs(Gx));
ax(Gx < 0.01) = 0;
weight_x = 1 + ax;

ay = exp(-lambda * abs(Gy));
ay(Gy < 0.01) = 0;
weight_y = 1 + ay;

end
