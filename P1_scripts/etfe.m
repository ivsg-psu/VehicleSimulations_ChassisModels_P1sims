function []=etfe(t_start,t_end,V,Cf0,Cr0,Iz0,lf0,lr0);

    % ETFE plotter script for P1 data.
    % Version 1.1 by Shad Laws, 8/29/05
    % This script takes the dataset in the workspace and generates ETFE
    % plots of the data.  It optionally plots bike models with or without
    % relaxation length.

    % See if postprocess was run.  If not, run it.
    if evalin('base','~(exist(''Steering'')&exist(''SSest''))');
        evalin('base','postprocess');
    elseif evalin('base','size(t,1)~=size(SSest,1)');
        evalin('base','postprocess');
    end;

    t = evalin('base','t');
    PostProc = evalin('base','PostProc');
    SSest = evalin('base','SSest');
    info = evalin('base','info');
    Ts = round((t(2)-t(1))*10000)/10000;
    p1_params;
    a = param.a;
    b = param.b;
    m = param.m;
        
    i_start = find(round(t*10000)/10000==t_start);
    i_end = find(round(t*10000)/10000==t_end);
    T = i_start:i_end;
    
    fftD = fft(PostProc(T,3));
    fftR = fft(SSest(T,4));
    fftB = fft(SSest(T,15));
    w = 2*pi/Ts/length(T)*(1:length(T))';

    Ni=length(w);
    if mod(Ni,2)==0;
        N = Ni/2;
    else
        N = (Ni+1)/2;
    end;
    
    fftD = fftD(1:N);
    fftR = fftR(1:N);
    fftB = fftB(1:N);
    w = w(1:N);
    
    figure;
    subplot(5,1,1:2);
    loglog(w/2/pi,abs([fftR./fftD fftB./fftD]));
    ylabel('ETFE mag');
    grid;
    subplot(5,1,3:4);
    semilogx(w/2/pi,180/pi*angle([fftR./fftD fftB./fftD]));
    ylabel('ETFE phase (deg)');
    grid;
    legend('^R/_\delta','^\beta/_\delta');
    subplot(5,1,5);
    loglog(w/2/pi,abs([fftD]/Ni).^2,'m');
    ylabel('INPUT spec density');
    grid;
    xlabel('freq (Hz)');
    
    if (nargin == 8);
        A = [0 -1 1/m/V 1/m/V;0 0 a/Iz0 -b/Iz0; -V*Cf0/lf0 -a*Cf0/lf0 -V/lf0 0; -V*Cr0/lr0 b*Cr0/lr0 0 -V/lr0];
        B = [0;0;V*Cf0/lf0;0];
        C = [0 1 0 0;1 0 0 0];
        D = [0;0];
        fitmodel = ss(A,B,C,D);
        fitmodeld = c2d(fitmodel,Ts);
        fitresp = squeeze(freqresp(fitmodeld,w)).';
        subplot(5,1,1:2);
        hold on;
        loglog(w/2/pi,abs(fitresp(:,1)),'r');
        loglog(w/2/pi,abs(fitresp(:,2)),'c');
        subplot(5,1,3:4);
        hold on;
        semilogx(w/2/pi,180/pi*angle(fitresp(:,1)),'r');
        semilogx(w/2/pi,180/pi*angle(fitresp(:,2)),'c');
        legend('^R/_\delta','^\beta/_\delta','^R/_\delta est','^\beta/_\delta est');
    end;
    
    if (nargin == 6)|(nargin == 8);
        A = [-(Cf0+Cr0)/m/V -(a*Cf0-b*Cr0)/m/V^2-1; -(a*Cf0-b*Cr0)/Iz0 -(a^2*Cf0+b^2*Cr0)/Iz0/V];
        B = [Cf0/m/V ; a*Cf0/Iz0];
        C = [0 1;1 0];
        D = [0;0];
        fitmodel = ss(A,B,C,D);
        fitmodeld = c2d(fitmodel,Ts);
        fitresp = squeeze(freqresp(fitmodeld,w)).';
        subplot(5,1,1:2);
        hold on;
        loglog(w/2/pi,abs(fitresp(:,1)),'r');
        loglog(w/2/pi,abs(fitresp(:,2)),'c');
        subplot(5,1,3:4);
        hold on;
        semilogx(w/2/pi,180/pi*angle(fitresp(:,1)),'r');
        semilogx(w/2/pi,180/pi*angle(fitresp(:,2)),'c');
        legend('^R/_\delta','^\beta/_\delta','^R/_\delta est','^\beta/_\delta est');
    end;
    
    titlestring = ['ETFE of ' info.driver ' ' info.time(1:10) ' ' info.run ', test ' num2str(info.testnum) ', t=' num2str(t_start) '-' num2str(t_end)];
    if (nargin == 6);
        titlestring = [titlestring '; fit with V=' num2str(V) ', C_f=' num2str(Cf0) ', C_r=' num2str(Cr0) ', I_z=' num2str(Iz0)];
    elseif (nargin == 8);
        titlestring = [titlestring '; fit with V=' num2str(V) ', C_f=' num2str(Cf0) ', C_r=' num2str(Cr0) ', I_z=' num2str(Iz0) ', l_f=' num2str(lf0) ', l_r=' num2str(lr0)];
    end;
    subplot(5,1,1:2);
    title(titlestring);
    
return;