% This script is to try an solve a system of ordinary differential
% equations that corresponds to the harris configuration



% lets state the variables first.
B0=1;
a=1;
Bg=0.1;
P_per0=0.1;


% zeroth order. Also known as equilibrium configuration

B0x = B0 * tanh(z/a);
B0y=Bg;
v0=0;
P_per0 = B0.^2 * (sech(z/a)).^2 + P_per0;

% This is the comnstraint on the resistivity.
dz( eta0(z)*dz(tanh(z/a) ) ) = 0 ;

% Assuming constant eta0
eta0*dz(dz(tanh(z/a))) = 0;

%first order equations