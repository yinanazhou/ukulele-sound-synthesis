function y = playKS(fs, f0, N, x, velo)
% the function that play one specific note 
% based on Karplus-Strong algorithm
% 
% fs: sampling rate
% f0: target frequency
% N: samples to count
% x: body-to-air response of the string instrument
% velo: the velocity in the midi file

% Scale the Frequencies to Ukulele Frequency Range If Needed
% while(f0>1244.51||f0<261.63)
%     if f0>1244.51
%         f0 = f0/2;
%     elseif f0<261.63
%         f0 = f0*2;
%     end
% end

% Set Up Delayline Parameters
delay = fs / f0;        % # of samples for delay line
delay = delay - 0.5;    % subtract phase delay of averaging filter
D = floor( delay );     % integer delayline length
delta = delay - D;
if ( delta < 0.3)
  delta = delta + 1;
  D = D - 1;
end
apc = ( 1 - delta ) / ( 1 + delta );  % allpass coefficient

% Timbre Control Filter
x = lowp(x, 4000, 4500,1, 30, fs); 

x = x*velo;                         % implement velocity difference
x = [x', zeros(1, N-length(x))];    % zero padding

% Pluck Position Filter
M = 0.8;% set pluck position is 1/5 string length from the bridge
M = round(M*D);
b0 = 1;
bM = 0.9;
pluck_a = 1;
pluck_b = [b0, zeros(1, M-1), bM];
x = filter(pluck_b, pluck_a, x);

% String Damping Filter Parameters
S = 0.5;
damp_b = 0.995*[1-S, S];
damp_z = 0;
damp_a = 1;

% Initialize Delay Line Buffer
y = zeros(1, N);            % initialize output vector
dl = zeros(1, N);           % delayline buffer

ptr = 1;
xm1ap = 0;  % x[n-1] for first order all-pass 
ym1ap = 0;  % y[n-1] for first order all-pass 

% Loop
for n = 1:N
    
    y(n) = dl( ptr );
    [y(n), damp_z] = filter(damp_b, damp_a, y(n),damp_z);
    xtemp = y(n);
    y(n) = apc * ( xtemp - ym1ap) + xm1ap;
    xm1ap = xtemp;
    ym1ap = y(n);

    dl( ptr ) = y(n)+x(n);
    
    % Increment Pointers & Check Limits
    ptr = ptr + 1;
    if ptr > D, ptr = 1; end
end


end
