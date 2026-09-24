function J = recover_radiance(I, A, t, t0)

t = max(t, t0);
J = zeros(size(I));

for c = 1:3
    J(:,:,c) = (I(:,:,c) - A(c)) ./ t + A(c);
end

J = min(max(J,0),1);

end
