function t_refined = refine_transmission(I, t)

gray = rgb2gray(I);
t_refined = imguidedfilter(t, gray);

end
