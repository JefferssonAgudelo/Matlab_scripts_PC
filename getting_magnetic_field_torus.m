% Ploting a torous

R=5; % outer radius of torus
r=2; % inner tube radius

% Defining the centers of the torous
Rc1 = 10; rc1 = 0;
Rc2 = -10; rc2 = -0;

th=linspace(0,2*pi,50); % e.g. 36 partitions along perimeter of the tube 
phi=linspace(0,2*pi,25); % e.g. 18 partitions along azimuth of torus
% we convert our vectors phi and th to [n x n] matrices with meshgrid command:
[Phi,Th]=meshgrid(phi,th); 
% now we generate n x n matrices for x,y,z according to eqn of torus
x=(R+r.*cos(Th)).*cos(Phi);
y=(R+r.*cos(Th)).*sin(Phi);
z=r.*sin(Th);

x1=((R-Rc1)+(r-rc1).*cos(Th)).*cos(Phi);
y1=((R-Rc1)+(r-rc1)*cos(Th)).*sin(Phi);
z1=(r-rc1).*sin(Th);

x2=((R-Rc2)+(r-rc2).*cos(Th)).*cos(Phi);
y2=((R-Rc2)+(r-rc2)*cos(Th)).*sin(Phi);
z2=(r-rc2).*sin(Th);

xt = x1-x2;
yt = y1-y2;
zt = z1-z2;

f987=figure(987);
subplot(2,4,1)
surf(x,y,z); % plot surface
daspect([1 1 1]) % preserves the shape of torus
colormap('jet') % change color appearance 
xlabel('X');ylabel('Y');zlabel('Z');
subplot(2,4,2)
surf(x1,y1,z1); % plot surface
daspect([1 1 1]) % preserves the shape of torus
colormap('jet') % change color appearance 
xlabel('X');ylabel('Y');zlabel('Z');
subplot(2,4,3)
surf(x2,y2,z2); % plot surface
daspect([1 1 1]); % preserves the shape of torus
colormap('jet') % change color appearance 
title('Torus')
xlabel('X');ylabel('Y');zlabel('Z');
subplot(2,4,4)
surf(xt,yt,zt); % plot surface
daspect([1 1 1]); % preserves the shape of torus
colormap('jet') % change color appearance 
title('Torus2')
xlabel('X');ylabel('Y');zlabel('Z');

xt = x1+x2;
yt = y1+y2;
zt = z1+z2;

f121=figure(121);
surf(xt,yt,zt); % plot surface
daspect([1 1 1]); % preserves the shape of torus
colormap('jet') % change color appearance 
title('Torus2')
xlabel('X');ylabel('Y');zlabel('Z');