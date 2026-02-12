clear
clc
close all

% ================= CARGAR ARCHIVO =================
[archivo, ruta] = uigetfile('*.mat','Seleccione el archivo .mat');

if isequal(archivo,0)
    error('No se seleccionó ningún archivo');
end

load(fullfile(ruta,archivo));   

t = t(:);
P = P(:);

Fs = 16;

% ================= SEÑAL ORIGINAL =================
figure
plot(t,P,'Color',[0.6 0.6 0.6])
title('Señal Original')
xlabel('Tiempo (s)')
ylabel('Presión')
grid on

% ================= FILTRADO =================
fc = 1.1;
orden = 2;
[b,a] = butter(orden,fc/(Fs/2),'low');

P_filtrada = filtfilt(b,a,P);
P_final = P_filtrada - mean(P_filtrada);

figure
plot(t,P_final,'b','LineWidth',1.4)
title('Señal Filtrada')
xlabel('Tiempo (s)')
ylabel('Presión')
grid on

% ================= FRECUENCIA POR TIEMPO =================
minDist = round(1.5*Fs);
[pks,locs] = findpeaks(P_final,'MinPeakDistance',minDist);

tiempos_picos = t(locs);

duracion_min = (t(end)-t(1))/60;
num_respiraciones = length(pks);
FR = num_respiraciones/duracion_min;

fprintf('\n========================================\n');
fprintf('ANÁLISIS DE FRECUENCIA RESPIRATORIA\n');
fprintf('Número de respiraciones: %d\n', num_respiraciones);
fprintf('Frecuencia Respiratoria: %.2f RPM\n', FR);
fprintf('========================================\n');

% ================= FRECUENCIA POR FFT (RANGO FISIOLÓGICO) =================
L = length(P_final);

Y = fft(P_final);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1);
f = Fs*(0:(floor(L/2)))/L;

% Rango respiratorio normal
fmin = 0.08;   % 5 RPM
fmax = 0.7;    % 42 RPM

idx = (f>=fmin & f<=fmax);
f_band = f(idx);
P_band = P1(idx);

if all(P_band < 1e-6)
    FR_fft = 0;
    f_dom = 0;
else
    [~,i] = max(P_band);
    f_dom = f_band(i);
    FR_fft = 60*f_dom;
end

fprintf('\nFR por FFT: %.2f RPM\n',FR_fft);

figure
plot(f,P1,'k','LineWidth',1.2)
hold on
xline(fmin,'--b','5 RPM')
xline(fmax,'--b','42 RPM')
plot(f_dom,interp1(f,P1,f_dom),'ro','MarkerFaceColor','r')
xlim([0 1])
xlabel('Frecuencia (Hz)')
ylabel('Magnitud')
title(['Espectro FFT — FR = ',num2str(FR_fft,'%.2f'),' RPM'])
grid on

% ================= HABLA VS REPOSO =================
idx_habla = (f>1 & f<3);
energia_total = sum(P1(f>0.1));

if energia_total==0
    energia_habla=0;
else
    energia_habla=sum(P1(idx_habla))/energia_total;
end

asimetria = std(diff(P_final))/mean(abs(P_final));

umbral_energia = 0.20;
umbral_asimetria = 0.08;

if (energia_habla>umbral_energia)&&(asimetria>umbral_asimetria)
    estado='ESTADO: HABLA';
    color='r';
else
    estado='ESTADO: REPOSO';
    color='b';
end

fprintf('%s\n',estado);

% ================= GRAFICA FINAL =================
figure
plot(t,P_final,'k')
hold on
plot(tiempos_picos,pks,'ro','MarkerFaceColor','r')
title(['Respiraciones Detectadas — ',estado])
xlabel('Tiempo (s)')
ylabel('Presión (hPa)')
legend('Señal filtrada','Respiraciones')
grid on