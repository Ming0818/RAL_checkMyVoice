function [voix_prete] = prepare_voix(signal,fs, fsnew)


%*********Récupération du bon Channel si nécessaire *****************
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

%****** Cas particulier de NAO en .ogg on coupe la première seconde ******
fin = size(signal,1);
deb = fs*0.9;
signal=signal(deb:fin,1);
% subplot(3,2,2); plot(signal);


%This function applies a FIR-filter on a signal (PREEMPHASIS)
c = 0.95;
b = [1, -c];
a = 1;
signal = filter(b,a,signal);
% subplot(3,2,3);plot(signal);    

%*******Rééchantillonner le signal si nécessaire à la valeur fsnew=16000 Hz

if fs~=fsnew    
    signal = resample(signal,fsnew,fs);
end
% subplot(3,2,4);plot(signal);

%Elimination de la composante continue
sr = signal;
    srdct    = dct(sr);
    srdct(1) = 0;
    sr       = idct(srdct);
signal = sr;
% subplot(3,2,5);plot(signal);
%**************** Suppession des silences ***************************
% step1 - Break the signal into frames of 01 seconds
frame_duration = 0.1;
frame_len = 0.1*fs;
N = length(signal);

num_frames = floor(N/frame_len);
new_sig = zeros(N, 1);
count = 0;
for k = 1 : num_frames
	frame = signal( (k-1)*frame_len + 1 : frame_len*k);
	
	% step2 - Identify non silent frames by finding frames with max amplitude more than 0.05
	max_val = max(frame);
	
	if(max_val > 0.05)
		% this frame is not silent
		count = count + 1;
		new_sig( (count-1)*frame_len + 1 : frame_len*count) = frame;
	end
end
signal = new_sig(any(new_sig,2),:);
% subplot(3,2,6);plot(signal);

voix_prete = signal;

end