# Laboratorio-1-Frecuencia-respiratoria
# Proceso respiratorio

La respiración es un proceso fisiológico vital complejo, que se compone de tres fases principales: ventilación, intercambio gaseoso y utilización de oxígeno por los tejidos [1].
Nos enfocaremos principalmente en la fase de ventilación mecánica, durante la cual el aire es transportado desde el exterior hasta los alveolos pulmonares; este proceso es posible debido a las propiedades mecánicas propias de los pulmones [2]. El sistema respiratorio está compuesto por: la nariz, la cavidad nasal, la laringe, la tráquea, los bronquiolos y los pulmones, además de otras estructuras que no conforman como tal parte del mismo, pero que desempeñan funciones importantes para su correcto funcionamiento, como las costillas y el diafragma y el sistema cardiovascular central, que proporciona arterias y venas pulmonares [3].

Las dos fases principales de la ventilación mecánica son la inspiración y la espiración. Durante la inspiración, se contrae el diafragma, aplanándose y descendiendo; esto aumenta el volumen torácico, mientras la espiración se produce por relajación muscular y retroceso elástico. Estos cambios de volumen causan a su vez variaciones de presión que pueden ser registradas [1].


<img width="250" height="346" alt="Image" src="https://github.com/user-attachments/assets/9ec903b8-fe2b-4ae3-9821-fb3c8d7d02e3" />
<img width="250" height="346" alt="sistema respiratorio2" src="https://github.com/user-attachments/assets/018934f6-bbfd-433c-9d36-e9c47c49ba1d" />

Figura 1. Esquema del sistema respiratorio.  
Fuente: Fox [1].
# Objetivos de la práctica

## Objetivo General

Evaluar la influencia del habla en el patrón respiratorio
## Objetivos Específicos

- Reconocer las variables físicas que se involucran en este proceso.
- Desarrollar un sistema que calcule la frecuencia respiratoria y el patrón respiratorio.
- Identificar cuando el sujeto está verbalizando, detectando cambios en los patrones respiratorios.

# Selección del sensor

Durante el proceso de ventilación respiratoria, como mencionamos anteriormente, hay variaciones de presión; según Guyton, la presión alveolar varía desde el rango de -1 cmH2O hasta un máximo de 1 cm H₂O (-1,96 hPa - 1,96 hPa) [4].

El sensor bmp280 es un sensor de presión atmosférica de tipo piezoelectrico. La resolución del mismo es de 0,16 Pa, a la vez que tiene una precisión relativa de ±0,12 Pa, por lo que consideramos que es adecuado para hacer una medición adecuada de los cambios de presión y poder usar los datos extraídos por el mismo para graficar el patrón respiratorio y calcular la frecuencia respiratoria [5].


<img width="412" height="469" alt="image" src="https://github.com/user-attachments/assets/22df451b-1e0e-4d00-b0cf-89d5b3d824f4" />\
Figura 2. Variación de presiones durante la respiración\
Fuente: Guyton [4].


# Transducción y comunicación serial
El sensor bmp280 es un sensor de tipo piezoelectrico, es decir que cuando una presión deforma el material al aplicarse un esfuerzo se produce una polarización eléctrica. Los valores del transductor piezoelectrico son convertidos por un conversor ADC integrado al sensor y envía la información en formato de 16 bits. Para transmitir los datos al computador y hacer la comunicación serial se usó un Arduino Uno, y la librería <BMP280_DEV.h>. La frecuencia de muestreo usada es de 16Hz, que cumple el teorema de NYquist para señales respiratorias.
```
#include <BMP280_DEV.h>

float temperature, pressure, altitude;
BMP280_DEV bmp280;

void setup()
{
    Serial.begin(115200);

    bmp280.begin(BMP280_I2C_ALT_ADDR);

    bmp280.setTimeStandby(TIME_STANDBY_62MS); // ~16 Hz
    bmp280.startNormalConversion();
}

void loop()
{
    if (bmp280.getMeasurements(temperature, pressure, altitude))
    {
        Serial.println(pressure);  // SOLO presión
    }
}
```

# Procesamiento de la señal y obtención de la frecuencia respiratoria
Se usó MATLAB para conectarse mediante el puerto serial con el Arduino, para después de recibir los datos de presión graficarlos en tiempo real, el usuario selecciona la longitud de la grabación de datos. Luego esos datos se guardan en un archivo .mat para posteriormente ser procesados y obtener la medida de la frecuencia respiratoria.

Figura 3. Señal sin procesar
## Filtros


# Comparación de gráficas


# Análisis en el dominio de la frecuencia

# Análisis de resultados y conclusiones

# Bibliografía
[1] S. Fox, Ed., Fisiología respiratoria, en Fisiología humana, 15.ª ed. New York, NY, USA: McGraw Hill Education, 2023. [En línea]. Disponible en: https://accessmedicina-mhmedical-com.ezproxy.umng.edu.co/content.aspx?bookid=3384&sectionid=281683931 

[2] J. Canet, Fisiología respiratoria, 2006. [En línea]. Disponible en: http://www.scartd.org/arxius/fisioresp06.pdf 

[3] H. J. Huang, “The respiratory system,” en The Big Picture: Medical Biochemistry, L. W. Janson y M. E. Tischler, Eds. New York, NY, USA: McGraw-Hill Education, 2018.[En línea]. Disponible en:https://accessmedicine-mhmedical-com.ezproxy.umng.edu.co/content.aspx?bookid=2355&sectionid=185845306 

[4] J. E. Hall, Guyton and Hall Textbook of Medical Physiology, 13ª ed., Philadelphia, PA, USA: Elsevier, 2016. 

[5] Bosch Sensortec, “BMP280 Digital Pressure Sensor Datasheet,” datasheet, rev. 1.19, oct. 2021. [En línea].
Disponible en: https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bmp280-ds001.pdf

