% Solving the Poisson equation
%--------------------------------------------------------------------------
close all
clear all
clc
% Grid Definition
nx = 50;
N = nx*nx; 
x = linspace(0,1,nx);
y = x;
[X,Y] = ndgrid(x,y);
dx = x(2)-x(1);
% Compute RHS with no BC, assuming f(X,Y)
b = -1.36364*X.^4.5 +  X.^3.5 - 0.818182*X.^9 + 0.818182*X.^8 - 0.0808081;
b = b * 247.5 .* (Y - 1).*Y.*cos(X);
b = b -45 *(-X.^5.5 + X.^4.5 - 0.444444*X + 0.222222).*(Y - 1).* Y.* sin(X);
b = b -20 *(X - 1).*X.*cos(X) ; 
b = exp( X.^4.5 ) .* b;
b = b.*dx.*dx;

b = -2.*cos(X).*sin(Y);

% Overwrite BC's on the RHS using vectorized assignment
isDirichlet = (X==0) | (X==1) | (Y==0) | (Y==1);
b(isDirichlet) = 0.0;
% Compute A Matrix diagonals Ad(1:N,1:5) assuming normal stencils
Ad = zeros(N,5);
% Compute off-center points, note that there is no y dependence in
% k(x,y)=cos(x)

% this istill doesn't work for the simple case.
Ad(:,1) = -cos(0.*X(:)); % Down = -kd = -cos(X)
Ad(:,2) = -cos(0.*(X(:)-dx*0.5)); % Left = -kl = -cos(X-dx/2)
Ad(:,4) = -cos(0.*(X(:)+dx*0.5)); % Right= -kl = -cos(X+dx/2)
Ad(:,5) = Ad(:,1); % Up = -ku = -cos(X) = Down

% Use these to get center by summing the negatives
Ad(:,3) = -sum( Ad(:,[1,2,4,5]), 2 ); % Center
% Overwrite BC's on the A Matrix diagonals
idx = find(isDirichlet(:)); % array of inidices of BC points
Ad(idx,:) = 0.0; % Zero all elements of rows defined by idx
Ad(idx,3) = 1.0; % Make center node=1
% Create A Matrix from Ad, assigning columns to diagonals
A = spdiags(Ad,[-nx,-1,0,1,nx],N,N)'; % ADDED TRANSPOSE
% Solve & Reshape
uh=A\b(:);
uh = reshape(uh,[nx,nx]);
% Compute Exact solution and error
%u_exact = 10*X.*Y.*(1-X).*(1-Y).*exp(X.^(4.5)); 

u_exact = cos(X).*sin(Y);

u_error = abs( (uh - u_exact)./u_exact );

% Reshape and plot solution on two subplots
f1=figure(1);
subplot(1,3,1); view(0,90); hold on; colorbar;
surf(x,y,uh,'edgecolor','none');
xlabel('x'); ylabel('y')
title('Computed')
shading interp
axis square
% Add exact solution
subplot(1,3,2); view(0,90); hold on; colorbar; 
surf(x,y,u_exact,'edgecolor','none');
xlabel('x'); 
title('Exact')
shading interp
axis square
% add Error
subplot(1,3,3); view(0,90); hold on; colorbar;
surf(x,y,u_error,'edgecolor','none');
xlabel('x'); 
title('Error')
shading interp
axis square