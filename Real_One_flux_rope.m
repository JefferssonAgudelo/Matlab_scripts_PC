function [Bx_fr_12, By_fr_12, Bz_fr_12] = Real_One_flux_rope(XL,YL,ZL,L0_i,d0_i,M0,x1,r0_i,Bc,h0_i)

%--------------------------------------------------------------------------
M = M0*ones(size(XL)); L0 = L0_i.*ones(size(XL));
d0 = d0_i.*ones(size(XL)); r0=r0_i.*ones(size(XL));
h0 =h0_i.*ones(size(XL)); I0 = 2.*pi.*r0.*Bc.*besselj(1,x1);

% This part is not working for h0
%{
%M2 = M./(I0.*d0);
%h0p = d0.*( (M2 -1) + sqrt(M2.^2 - 2.*M2) );
%h0m = d0.*( (M2 -1) - sqrt(M2.^2 - 2.*M2) );
%h0 = h0m;
%}

R_d = sqrt((YL-L0).^2 + (ZL + d0).^2);
rc = sqrt((YL-L0).^2 + (ZL - h0).^2);
alpha =  x1/r0_i;
alpharc = alpha.*rc;
J0 = besselj(0,alpharc);
J1 = besselj(1,alpharc);

% Define the conditions
%--------------------------------------------------------------------------
cnd1 = ((0 < rc) & (rc < r0_i)); 
cnd2 = (rc >= r0_i);
%--------------------------------------------------------------------------

% Calculate the magnetic field in both cases
%--------------------------------------------------------------------------
Bx_fr_1 = Bc.*J0; 
By_fr_1 = (-Bc.*J1 .*(ZL - h0)) ./ sqrt( (YL - L0).^2 + (ZL - h0).^2 ) + ...
        (I0./(2.*pi)) .* ( (ZL + h0) ./ ( (YL - L0).^2 + (ZL + h0).^2 ) ) ;
Bz_fr_1 = (Bc.*J1 .*(YL - L0)) ./ sqrt( (YL - L0).^2 + (ZL - h0).^2 ) - ...
        (I0./(2.*pi)) .* ( (YL - L0) ./ ( (YL - L0).^2 + (ZL + h0).^2 ) ) ;

Bx_fr_2 = 0.*Bc.*J0; % Bc.*J0; is it 0? 
By_fr_2 = (-I0./(2.*pi)) .* ( (ZL - h0) ./ ( (YL - L0).^2 + (ZL - h0).^2 ) ) + ...
        (I0./(2.*pi)) .* ( (ZL + h0) ./ ( (YL - L0).^2 + (ZL + h0).^2 ) ) ;
Bz_fr_2 = (I0./(2.*pi)) .* ( (YL - L0) ./ ( (YL - L0).^2 + (ZL - h0).^2 ) ) - ...
        (I0./(2.*pi)) .* ( (YL - L0) ./ ( (YL - L0).^2 + (ZL + h0).^2 ) ) ;
%--------------------------------------------------------------------------

% Get magnetic field satisfying the conditions 
%--------------------------------------------------------------------------
Bx_fr_12 = Bx_fr_1.*cnd1 + Bx_fr_2.*cnd2; 
By_fr_12 = By_fr_1.*cnd1 + By_fr_2.*cnd2; 
Bz_fr_12 = Bz_fr_1.*cnd1 + Bz_fr_2.*cnd2; 

%Bx_fr_12_2 = Bx_fr_2; 
%By_fr_12_2 = By_fr_2; 
%Bz_fr_12_2 = Bz_fr_2; 
%--------------------------------------------------------------------------
end