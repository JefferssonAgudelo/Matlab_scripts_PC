%%%%%%%%%%% Checking the initial distribution that I put %%%%%%% 

%%---------------------------------------------------------------------- 

rng('default') 

NN=8000000; 

% initial values for the distributions 

me_f=1 ; 
ne_core_ = 0.9; 
ne_strahl_ = 0.08; 
ne_halo_ = 0.02; 

pzec_f=0 ; 
Tzec_f=0.005 ; 

pzes_f = 0.2; 
Tzes_f = 0.005 ;  

% for the kappa
kappa = 5;
T_k = 0.03;        % electron T (in your PIC units)
T_over_m = T_k/me_f;


a=0; b=NN; 

%r = a + (b-a).*rand(NN,1); 

k=5; 
rng(k); 

NNi=1*NN; 
NNc=fix(ne_core_*NN); 
NNs=fix(ne_strahl_*NN); 
NNh=fix(ne_halo_*NN); 

% make random numbers for the distributions 

ran3=randi([0 NNc],NNc,1)/(NNc+1); 
ran4=randi([0 NNc],NNc,1)/(NNc+1); 
ran5=randi([0 NNs],NNs,1)/(NNs+1); 
ran6=randi([0 NNs],NNs,1)/(NNs+1); 

% this is for the maxell distributions 

%-------------------------------------------------------------------------- 
pzec_f_1 = pzec_f+sqrt(-(2*Tzec_f/me_f).*log(1 - ran3)).* cos(2*pi*ran4); 
pzes_f_1 = pzes_f+sqrt(-(2*Tzes_f/me_f).*log(1 - ran5)).* cos(2*pi*ran6); 
%-------------------------------------------------------------------------- 

% For the kappa distributions 

%-------------------------------------------------------------------------- 

v = kappa_sample_student_t(NNh, kappa, T_over_m);
%-------------------------------------------------------------------------- 

edges = linspace(-1,1); 
[Nc,edges] = histcounts(pzec_f_1,edges); 
[Ns,edges] = histcounts(pzes_f_1,edges); 
[Nh,edges] = histcounts(v,edges); 
Ncs=Nc+Ns; 
Ncsh=Nc+Ns+Nh; 


% Compare to Maxwellian
f668=figure(668); 
semilogy(edges(2:100),Nc/sum(Ncsh),'-*r') % Everything is normalised to the total number of counts 
hold on 
semilogy(edges(2:100),Nh/sum(Ncsh),'-*m')
semilogy(edges(2:100),Ns/sum(Ncsh),'-*b') 
semilogy(edges(2:100),Ncsh/sum(Ncsh),'-*k') 
xline(0,'k') 
xlabel('$v_{s,\parallel}$','Interpreter','latex','FontSize',20) 
ylabel('Probability','Interpreter','latex','FontSize',20) 
title('$$Fake \ distribution$$','Interpreter','latex','FontSize',20) 
legend('$v_{ec}$','$v_{h}$','$v_{es}$','$v_{e Total}$','Interpreter','latex','FontSize',20) 
hold off 


%[Ncpdf,edges] = histcounts(pzec_f_1,edges,'Normalization', 'probability'); 
%[Nspdf,edges] = histcounts(pzes_f_1,edges,'Normalization', 'probability'); 
%Ncspdf=Ncpdf+Nspdf; 

% make plot 
%{
f667=figure(667); 
semilogy(edges(2:100),Nc/sum(Ncs),'-*r') % Everything is normalised to the total number of counts 
hold on 
semilogy(edges(2:100),Ns/sum(Ncs),'-*b') 
semilogy(edges(2:100),Ncs/sum(Ncs),'-*k') 
xline(0,'k') 
xlabel('$v_{s,\parallel}$','Interpreter','latex','FontSize',20) 
ylabel('Probability','Interpreter','latex','FontSize',20) 
title('$$Fake \ distribution$$','Interpreter','latex','FontSize',20) 
legend('$v_{ec,\parallel}$','$v_{es,\parallel}$','$v_{ecs,\parallel}$','Interpreter','latex','FontSize',20) 
hold off 
%}


%--------------------------------------------------------------------------




function v = kappa_sample_student_t(N, kappa, T_over_m)
% Generate N samples from a 1-D kappa distribution using the
% transformation method described in:
%   "A method to generate kappa distributed random deviates for
%    particle-in-cell simulations", PoP 2020.
%
% INPUTS:
%   N         : number of samples
%   kappa     : kappa index (> 1/2, variance finite only if kappa > 1)
%   T_over_m  : desired variance = T / m   (PIC: temperature divided by mass)
%
% OUTPUT:
%   v         : N samples from the desired kappa distribution
%
% The distribution matches the PIC definition of temperature:
%   <v^2> = T/m

    % degrees of freedom for Student-t
    nu = 2*kappa - 1;       % from the paper
    if nu <= 1
        warning('Variance divergent: kappa must be > 1 for finite <v^2>.');
    end

    % draw two uniform deviates
    a1 = rand(N,1);
    a2 = rand(N,1);

    % --- Student-t transform from the paper ---
    % b = Student-t deviate (unit scale)
    b = sqrt(nu*(a1.^(-2/nu) - 1)) .* cos(2*pi*a2);

    % Student-t variance = nu/(nu-2), valid only for nu>2
    if nu <= 2
        warning('nu<=2: variance infinite; cannot scale to T/m meaningfully.');
    end
    var_b = nu/(nu - 2);       % variance of standard Student-t

    % rescale so that <v^2> = T_over_m
    scale = sqrt(T_over_m / var_b);

    % final kappa samples
    v = scale * b;
end
