function y = playDW(fs, f0, N, x, velo)
% the function that play one specific note based on digital waveguide model
% 
% fs: sampling rate
% f0: target frequency
% N: samples to count
% x: body-to-air response of the string instrument
% velo: the velocity vector in the midi file

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
delay = delay*0.5;      % split delayline
D = floor(delay);       % integer delayline length
delta = delay - D;
if (delta < 0.3)
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
M = round(M*D*2);
b0 = 1;
bM = 0.9;
pluck_a = 1;
pluck_b = [b0, zeros(1, M-1), bM];
x = filter(pluck_b, pluck_a, x);

% String Damping Filter Parameters
S = 0.5;
damp_b = -0.995*[1-S, S];
damp_z = 0;
damp_a = 1;

% Initialize Delay Line Buffer
y = zeros(1, N);            % initialize output vector
dl_up = zeros(1, N);        % upper delayline buffer
dl_dwn = zeros(1, N);       % bottom delayline buffer



ptr = 1;
readloc = 30/38 ;     % read location: 0 = left-end; 1 = right-end
ptr_up = round((1-readloc)*(D-1)) + 1;
ptr_dwn = D - ptr_up + 1;
xm1ap_dwn = 0;      % x[n-1] for first order all-pass 
ym1ap_dwn = 0;      % y[n-1] for first order all-pass 
xm1ap_up = 0;       % x[n-1] for first order all-pass 
ym1ap_up = 0;       % y[n-1] for first order all-pass 

% Loop
for n = 1:N
    
    % interpolation version
    temp = dl_dwn(ptr);
    
    % upper delayline interpolation
    x_up = dl_up(ptr_up);
    y_up = apc * ( x_up - ym1ap_up) + xm1ap_up;
    xm1ap_up = x_up;
    ym1ap_up = y_up;    
    dl_up(ptr_up) = y_up;
    
    % bottom delayline interpolation
    x_dwn = dl_dwn(ptr_dwn);
    y_dwn = apc * ( x_dwn - ym1ap_dwn) + xm1ap_dwn;
    xm1ap_dwn = x_dwn;
    ym1ap_dwn = y_dwn;
    dl_dwn(ptr_dwn) = y_dwn;
    
    % summation
    y(n) = y_up + y_dwn;

%     dl_dwn(ptr_dwn) = y_dwn;

    % Reflection
    dl_dwn(ptr) = -dl_up(ptr);
    
    % string dampling filter
    [dl_up(ptr), damp_z] = filter(damp_b, damp_a, temp,damp_z);
    dl_up(ptr) = dl_up(ptr) + x(n);
    
    % Increment Pointers & Check Limits
    ptr = ptr + 1;
    ptr_up = ptr_up + 1;
    ptr_dwn = ptr_dwn + 1;
    if ptr > D, ptr = 1; end
    if ptr_up > D, ptr_up = 1; end
    if ptr_dwn > D, ptr_dwn = 1; end
end


end
