clear
clc

% CONFIGURACIÓN
COM = "COM10";
Fs = 16;
Tmax = input("Ingrese tiempo de grabación (s): ");

% CONEXIÓN
s = serialport(COM,115200);
configureTerminator(s,"LF");
flush(s);

pause(3); % esperar Arduino

N = Fs*Tmax;

t = zeros(1,N);
P = zeros(1,N);

% GRÁFICA
figure
h = animatedline('Color','b','LineWidth',1.5);
xlabel('Tiempo (s)')
ylabel('Presión (hPa)')
title('Señal respiratoria BMP280')
grid on

estado_txt = text(0.02,0.95,'Esperando datos',...
    'Units','normalized','FontSize',12,...
    'FontWeight','bold','Color','r');

k = 1;
tic_global = tic;
ultimo_dato = tic;

while k <= N

    if s.NumBytesAvailable > 0

        dato = readline(s);
        presion = str2double(dato);

        if ~isnan(presion)

            t(k) = (k-1)/Fs;
            P(k) = presion;

            addpoints(h,t(k),P(k));
            drawnow limitrate

            set(estado_txt,'String','Recibiendo datos','Color','g');
            ultimo_dato = tic;

            k = k + 1;
        end
    end

    if toc(ultimo_dato) > 0.5
        set(estado_txt,'String','Sin datos','Color','r');
    end
end

% RECORTE SI SALIÓ ANTES
t = t(1:k-1);
P = P(1:k-1);

% PREGUNTAR NOMBRE Y UBICACIÓN DEL ARCHIVO
[archivo, ruta] = uiputfile('*.mat','Guardar señal respiratoria como');

if isequal(archivo,0)
    disp('Guardado cancelado por el usuario');
else
    save(fullfile(ruta,archivo),'t','P');
    disp(['Archivo guardado en: ', fullfile(ruta,archivo)]);
end


figure
plot(t,P,'b','LineWidth',1.5)
xlabel('Tiempo (s)')
ylabel('Presión (hPa)')
title('Registro completo')
grid on
