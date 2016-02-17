function [voix_prete] = ral_prepare_sample(signal,fs, fsnew)
%RAL_PREPARE_SAMPLE Prepare the sample for the MFCC extraction
%   The steps are the following :
%       1. Get the channel (mono/stereo)
%       2. Exeption for NAO : we cut the trigger sound
%       3. Pre-emphasis
%       4. Resample if needed (fsnew=16000 Hz)
%       5. Elimination of the DC component
%       6. Delete silance

load('ral_settings.mat');

%********* Get the channel *****************
[dimx, dimy] = size(signal);
% conversion from 4 channels to 1 
if dimy==4
    % 4 channels means it's from NAO so we take the 3rd one
    signal = signal(:,3);
end
% stereo to mono; we take the 1rst one
if dimy==2
    signal = signal(:,1);  
end
% figure;
% subplot(3,2,1);plot(signal);

%****** Exception for NAO : we cut the 1rst second of the .ogg file
% because we hear a trigger sound ******
signalEnd = size(signal,1);
% signalBegin = fs * 0.9;
signalBegin = fs*settings.trigger_cut_length;
signal=signal(signalBegin:signalEnd,1);
% subplot(3,2,2); plot(signal);


% This function applies a FIR-filter on a signal (PREEMPHASIS)
c = settings.fir_filter_value;% 0.97;
b = [1, -c];
a = 1;
signal = filter(b,a,signal);
% subplot(3,2,3);plot(signal);    

%******* Resample the signal if necessary with fsnew=16000 Hz
if fs~=fsnew    
    signal = resample(signal,fsnew,fs);
end
% subplot(3,2,4);plot(signal);

% Elimination of the DC component
% Elimination de la composante continue
sr = signal;
    srdct    = dct(sr);
    srdct(1) = 0;
    sr       = idct(srdct);
signal = sr;
% subplot(3,2,5);plot(signal);

%**************** Delete silence ***************************
% step1 - Break the signal into frames of 01 seconds
frame_duration = 0.1;
frame_len = 0.1*fs;
N = length(signal);

num_frames = floor(N/frame_len);
new_sig = zeros(N, 1);
count = 0;
for k = 1 : num_frames
	frame = signal( (k-1)*frame_len + 1 : frame_len*k);
	
	% step2 - Identify non silent frames by finding frames with max amplitude more than 0.07
	max_val = max(frame);
	
    % if(max_val > 0.07)
	if(max_val > settings.silence_threshold)
		% this frame is not silent
		count = count + 1;
		new_sig( (count-1)*frame_len + 1 : frame_len*count) = frame;
	end
end
signal = new_sig(any(new_sig,2),:);
% subplot(3,2,6);plot(signal);

voix_prete = signal;

end