% This is trying to adapt the 2 equations system 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%This is solving both equations!!!!
%--------------------------------------------------------------------------
syms psi(x) phi(x) psi_prime(x) phi_prime(x) x gamma k s Y


% This is for the inner region
% System of first-order ODEs
ode1 = diff(psi, x) == psi_prime;
ode2 = diff(phi, x) == phi_prime;
ode3 = diff(psi_prime, x) == psi*k^2 + gamma*s*(psi - tanh(x)*phi);
ode4 = diff(phi_prime, x) == (k^2 + ((s/(gamma*(k^2)))*(tanh(x))^2) )*phi ...
    -(psi/(gamma*(k^2)))*( ((2/gamma)*tanh(x) * (sech(x))^2) + (s*tanh(x)) );

% Convert to vector field form
[f, Subs] = odeToVectorField([ode1 ode2 ode3 ode4]);
F = matlabFunction(f, 'Vars', {x, Y, gamma, k, s});

% Set parameters and initial conditions
gamma = 0.1;
k = 4;
s = 1;
conditions = [0.1*ones(4,1)]; % Four equations = Four initial conditions
span = [0 1];

% Solve the system of differential equations
[rsol, psol] = ode45(@(x,Y) F(x,Y,gamma,k,s), span, conditions);

% Plot the solutions
f1=figure(1);
plot(rsol, psol(:,1:4), '-');
legend('psi(x)', 'phi(x)', 'dpsi/dx', 'dphi/dx');
xlabel('x');
ylabel('Solution');
grid

%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% %function definitions
syms psi(x) phi(x) x gamma k s Y

ode1 = diff(psi,x,2) == psi*k^2 + gamma*s*(psi - tanh(x)*phi);
ode2 = diff(phi,x,2) == (k^2 + ((s/(gamma*(k^2)))*(tanh(x))^2) )*phi ...
    -(psi/(gamma*(k^2)))*( ((2/gamma)*tanh(x) * (sech(x))^2) + (s*tanh(x)) );



% %function setup
[f1, Subs]= odeToVectorField([ode1 ode2]);
F1= matlabFunction(f1, 'Vars',{x,Y,gamma,k,s})
% %initial conditions

gamma = 0.1;                                               % Provide Value
k = 4;                                               % Provide Value
s = 1; 
% Provide Value                                             % Provide Value
%conditions = [rand(4,1)];                               % Three Equations = Three Initial Conditions
conditions = [0.1*ones(4,1)];                               % Three Equations = Three Initial Conditions
span = [0 1];
% %solver
[rsol,psol] = ode45(@(x,Y)F1(x,Y,gamma,k,s),span,conditions);

f2=figure(2)
plot(rsol, psol)
legend
grid
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------



% This part in here has some of the attemps to solve the system of
% equations
%--------------------------------------------------------------------------
%{
%--------------------------------------------------------------------------
x_max = 10; % Define the maximum value of x
x_span = [0, x_max]; % Define the x-span of the solution
y_initial = [0, 0, 0, 0]; % Initial values
gamma = 1; % Set your value for gamma
k = 1; % Set your value for k
s = 1; % Set your value for s

% Define initial guesses for ya and yb
psi_initial = 0;
phi_initial = 0;
dpsi_dx_initial = 0;
dphi_dx_initial = 0;

ya_initial = [psi_initial, phi_initial, dpsi_dx_initial, dphi_dx_initial];
yb_initial = [psi_initial, phi_initial, dpsi_dx_initial, dphi_dx_initial];

options = odeset('RelTol',1e-6,'AbsTol',1e-6); % Set options for the ODE solver

sol = bvpinit(x_span,y_initial); % Initialize the boundary value problem

sol = bvp4c(@equations, @boundary_conditions, sol, options, gamma, k, s); % Solve the BVP



% % Funtions
% %--------------------------------------------------------------------------
% function dydx = equations(x, y, gamma, k, s)
% 
%     F = tanh(x);
%     F1 = gradient(F,x);
%     F2 = gradient(F1,x);
% 
%     psi = y(1);
%     phi = y(2);
%     dpsi_dx = y(3);
%     dphi_dx = y(4);
% 
%     dydx = zeros(4,1);
% 
%     % Equations
%     dydx(1) = dpsi_dx - psi;
%     dydx(2) = dphi_dx - phi;
%     dydx(3) = gradient(dpsi_dx,x) - psi * k^2 - gamma*s*(psi - F*phi);
%     dydx(4) = gradient(dphi_dx,x) - psi * k + (F/(gamma*k)^2)*gradient(dpsi_dx,x) - (psi/gamma^2)*(F - F2/(gamma*k)^2);
% end
% %--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function dydx = equations(x, y, gamma, k, s)
    F = tanh(x);

    psi = y(1);
    phi = y(2);
    dpsi_dx = y(3);
    dphi_dx = y(4);

    dydx = zeros(4,1);

    % Equations
    dydx(1) = dpsi_dx - psi;
    dydx(2) = dphi_dx - phi;
    dydx(3) = (psi - k^2 * psi - gamma * s * (psi - F * phi));
    dydx(4) = (phi - k^2 * phi) + (F / (gamma * k)^2) * (dpsi_dx - k^2 * psi) - (psi / gamma^2) * (F - (1 - F^2) / (gamma * k)^2);

     dydx(5:8) = 0; % Additional derivatives are set to zero
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function bc = boundary_conditions(ya, yb, gamma, k, s)
    bc = [ya(1) - ya(3);  
          yb(2) - yb(4)]; 
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% This would be for a theoretical solution
%--------------------------------------------------------------------------
gamma = 1;
k = 1;
s=1;
syms F
F = tanh(x);
F1 = diff(F,x);
F2 = diff(F1,x);

syms psi(x) phi(x) PSIc(x) PHIc(x)

ode1 = diff(psi) == PSIc;
ode2 = diff(phi) == PHIc;

ode3 = diff(PSIc) == psi * k^2 + gamma*s*(psi - F*phi);
ode4 = diff(PHIc) == psi * k - (F/(gamma*k)^2)*diff(PSIc) + (psi/gamma^2)*(F - F2/(gamma*k)^2);

odes = [ode1; ode2; ode3; ode4;];

S = dsolve(odes);
%--------------------------------------------------------------------------



% This is trying to solve it using a sort of finite difference approach
%--------------------------------------------------------------------------
% Parameters
gamma = 1;
k = 1;
s = 1;

% Discretization
N = 100; % Number of grid points
x_max = 1;
x = linspace(0.01, x_max, N); % Grid points
dx = x(2) - x(1); % Grid spacing

factor=rand(1);

% Initial guesses
psi_guess = ones(1, N)*factor;
phi_guess = ones(1, N)*factor;
PSIc_guess = ones(1, N)*factor;
PHIc_guess = ones(1, N)*factor;

% Solve using finite differences
tolerance = 1e-6; % Tolerance for convergence
max_iterations = 1000; % Maximum number of iterations


for iter = 1:max_iterations
    % Update PSIc and PHIc using finite difference approximations
    PSIc_new = psi_guess .* k^2 + gamma * s .* (psi_guess - tanh(x) .* phi_guess);
    PHIc_new = psi_guess .* k - (tanh(x) ./ (gamma * k)^2) .* gradient(PSIc_guess, dx) + ...
        (psi_guess ./ gamma^2) .* (tanh(x) - (2/k^2) * (tanh(x) .* (1 - tanh(x).^2)));
    
    % Update psi using finite difference approximations
    psi_new = psi_guess;
    grad_PSIc = gradient(PSIc_guess, dx);
    psi_new(1:end-1) = psi_guess(1:end-1) + grad_PSIc(1:end-1);

    % Update phi using finite difference approximations
    phi_new = phi_guess;
    grad_PHIc = gradient(PHIc_guess, dx);
    phi_new(1:end-1) = phi_guess(1:end-1) + grad_PHIc(1:end-1);

    % Check for convergence
    if max(abs(PSIc_new - PSIc_guess)) < tolerance && max(abs(PHIc_new - PHIc_guess)) < tolerance && ...
            max(abs(psi_new - psi_guess)) < tolerance && max(abs(phi_new - phi_guess)) < tolerance
        disp(['Convergence reached after ', num2str(iter), ' iterations']);
        break;
    end
    
    % Update guesses
    psi_guess = psi_new;
    phi_guess = phi_new;
    PSIc_guess = PSIc_new;
    PHIc_guess = PHIc_new;
end

% Plot results
f1=figure(1);
plot(x, psi_guess, x, phi_guess, x, PSIc_guess, x, PHIc_guess);
xlabel('x');
ylabel('Solution');
legend('psi(x)', 'phi(x)', 'PSIc(x)', 'PHIc(x)');

%--------------------------------------------------------------------------
%}
%--------------------------------------------------------------------------








% These two blocks in here work well to solve systems of two equations and three second order diferential equations  
%--------------------------------------------------------------------------


% % % % This is for two equations
% % % %--------------------------------------------------------------------------
% % % % %function definitions
% % % syms r(T) p(T) c E h L m rs T Y 
% % % ode1 = diff(r,T,2) == E^2 / ((m^2)*(c^2)) - (1- rs/r)*(c^2 + (h^2)/(r^2));
% % % ode2 = diff(p,T) == (1/r^2) * L;
% % % % %function setup
% % % [f1, Subs]= odeToVectorField([ode1 ode2]);
% % % F1= matlabFunction(f1, 'Vars',{T,Y, c, E, h, L, m, rs})
% % % % %initial conditions
% % % r_0= 5*rs;
% % % r_prime_0 = 5*rs;
% % % r_double_prime_0 = 5*rs;
% % % p_0 = 0;
% % % PI = rand;                                              % Provide Value
% % % p_prime_0 = PI/100;
% % % c = rand;                                               % Provide Value
% % % E = rand;                                               % Provide Value
% % % h = rand;                                               % Provide Value
% % % L = rand;                                               % Provide Value
% % % m = rand;                                               % Provide Value
% % % rs = rand;                                              % Provide Value
% % % conditions = [rand(3,1)];                               % Three Equations = Three Initial Conditions
% % % span = [0 100];
% % % % %solver
% % % [rsol,psol] = ode45(@(T,Y)F1(T,Y,c,E,h,L,m,rs),span,conditions);
% % % figure
% % % plot(rsol, psol)
% % % grid
% % % %--------------------------------------------------------------------------


% % % 
% % % %This is for 3 equations
% % % %--------------------------------------------------------------------------
% % % global kr kf lf dr dm p1 p2
% % % 
% % % % Parameter
% % % kr = 1;     % formation R-centers
% % % kf = 0.1;   % formation M-centers
% % % lf = 100;  % loss of F-centers
% % % dr = 0.1;   % decay R-center
% % % dm = 1;     % decay M-center
% % % p1 = 10000;
% % % p2 = 0;
% % % % function definiton
% % % syms R(T) M(T) F(T) T Y;
% % % ode1 = diff(R,T) == -(dr*R) + (kr*M*F);
% % % ode2 = diff(M,T) == (dr*R) - (dm*M) + (kf*(F^2)) - (kr*M*F);
% % % ode3 = diff(F,T,2) == (dr*R) + (2*dm*M) - (kr*M*F) - (2*kf*(F^2)) - (lf*F)+p1;
% % % % function setup
% % % [f1, Subs] = odeToVectorField([ode1 ode2 ode3]);
% % % F1 = matlabFunction(f1, 'Vars',{T, Y});
% % % 
% % % 
% % % % initial states
% % % R0 = 84.99;
% % % M0 = 1.675;
% % % F0 = 9.975;
% % % conditions = [R0; M0; F0; 42];                                  % <— 4 DEs => 4 ICs!  Added ‘42’ To Test Code
% % % span = [0 10];
% % % % solver
% % % tic;
% % % [Rsol, Msol] = ode23s(F1,span,conditions);                      % All Arguments Already Included In ‘F1’ After ‘subs’ Call
% % % toc;
% % % %Log. plotting
% % % figure                                                          % Using 'log' Scale Not Appropriate With Negative Values, Use 'yyaxis' Instead
% % % yyaxis left
% % % plot(Rsol, Msol(:,[1 3 4]));                                    % 2 Arguments Only!
% % % yyaxis right
% % % plot(Rsol, Msol(:,2))
% % % grid on;
% % % legend(string(Subs), 'Location','NW')
% % % 
% % % %--------------------------------------------------------------------------
