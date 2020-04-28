clearvars;close all;clc;

[tableConfirmed,tableDeaths,tableRecovered,time] = getData_INDIA();
timeRef = time(1:end);




Npop= 135e7; % population
time = timeRef;

fprintf(['Most recent update: ',datestr(timeRef(end)),'\n'])
time = timeRef; % re-initialize value of time


Recovered = tableRecovered(:)';
Deaths = tableDeaths(:)';
Confirmed = tableConfirmed(:)';
time = time(:)';

% minimal number of high-quality data required for the fitting
minNum= max(100,round(0.1*max(Confirmed)));  
% If the number of confirmed Confirmed cases is small, it is difficult to know whether
% the quarantine has been rigorously applied or not. In addition, this
% suggests that the number of infectious is much larger than the number of
% confirmed cases
dummy = Confirmed - Recovered - Deaths;
Recovered(Confirmed<=minNum | isnan(dummy))=[];
Deaths(Confirmed<=minNum | isnan(dummy)) =[];
time(Confirmed<=minNum | isnan(dummy)) =  [];
Confirmed(Confirmed<=minNum | isnan(dummy)) =[];


tic

% Definition of the first estimates for the parameters
alpha_guess = 0.1; % protection rate
beta_guess = 1.0; % Infection rate
LT_guess = 5; % latent time in days
Q_guess = 0.5; % rate at which infectious people enter in quarantine
lambda_guess = [0.1,0.1,0.1]; % recovery rate
kappa_guess = [0.1,0.05]; % death rate

guess = [alpha_guess,beta_guess,1/LT_guess, Q_guess,lambda_guess,kappa_guess];

% Initial conditions
E0 = Confirmed(1); % Initial number of exposed cases. Unknown but unlikely to be zero.
I0 = Confirmed(1); % Initial number of infectious cases. Unknown but unlikely to be zero.
Q0 = Confirmed(1)-Recovered(1)-Deaths(1);
R0 = Recovered(1);
D0 = Deaths(1);


Active = Confirmed-Recovered-Deaths;
Active(Active<0) = 0; % No negative number possible

[alpha1,beta1,gamma1,delta1,Lambda1,Kappa1,lambdaFun] = ...
    fit_SEIQRDP(Active,Recovered,Deaths,Npop,E0,I0,time,guess,'Display','off','dt',1/24);

disp(lambdaFun)

dt = 1/24; % time step
time1 = datetime(time(1)):dt:datetime(datestr(floor(datenum(now))+datenum(7)));
N = numel(time1);
t = [0:N-1].*dt;


% Call of the function SEIQRDP.m with the fitted parameters
[S,E,I,Q,R,D,P] = ...
    SEIQRDP(alpha1,beta1,gamma1,delta1,Lambda1,Kappa1,Npop,E0,I0,Q0,R0,D0,t,lambdaFun);

clf;close all;
figure
semilogy(time1,Q,'r',time1,R,'b',time1,D,'k');
hold on
semilogy(time,Active,'ro',time,Recovered,'bo',time,Deaths,'ko');
% ylim([0,1.1*Npop])
ylabel('Number of cases')
xlabel('time (days)')
leg = {'Confirmed (fitted)',...
    'Recovered (fitted)','Deceased (fitted)',...
    'Confirmed (reported)','Recovered (reported)','Deceased  (reported)'};
legend(leg{:},'location','southoutside');
set(gcf,'color','w')
title(['Location: INDIA'])
%%%%%%%%%%%%%

grid on
axis tight
set(gca,'yscale','lin')
toc
