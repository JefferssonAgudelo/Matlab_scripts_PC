% This is the script to to get the agyrotropy things. First I will write
% this to be used in paraview 

% Loading the arrays in paraview

%--------------------------------------------------------------------------
Nxx_e =  hy*hy*Tzz_e -2*hy*hz*Tyz_e + hz*hz*Tyy_e
Nxy_e = -hy*hx*Tzz_e + hy*hz*Txz_e + hz*hx*Tyz_e - hz*hz*Txy_e
Nxz_e =  hy*hx*Tyz_e - hy*hy*Txz_e - hz*hx*Tyy_e + hz*hy*Txy_e
Nyy_e =  hx*hx*Tzz_e -2*hz*hx*Txz_e + hz*hz*Txx_e
Nyz_e = -hx*hx*Tyz_e + hx*hy*Txz_e + hz*hx*Txy_e - hz*hy*Txx_e
Nzz_e =  hx*hx*Tyy_e -2*hy*hx*Txy_e + hy*hy*Txx_e

alpha_e = (Nxx_e + Nyy_e + Nzz_e)
beta_e = -(Nxx_e*Nxx_e + Nyy_e*Nyy_e + Nzz_e*Nzz_e - Nxx_e*Nyy_e - Nxx_e*Nzz_e - Nyy_e*Nzz_e)

lambda_p_e = (0.5)*(alpha_e + sqrt(alpha_e*alpha_e - 4*beta_e))
lambda_m_e = (0.5)*(alpha_e - sqrt(alpha_e*alpha_e - 4*beta_e))

Agy_e = (2*sqrt(alpha_e*alpha_e - 4*beta_e))/alpha_e
%--------------------------------------------------------------------------


% This is 
%--------------------------------------------------------------------------