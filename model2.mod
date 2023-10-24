# Practica Modelado 1
#
# Este código busca la solución óptima para minimizar el Tiempo de Atención

/* --------------------------------------------------------------------------------------------- SETS --------------------------------------------------------------------------------------------- */

set DISTRITOS;
set PARKINGS;
set NUEVAS_LOCALIZACIONES;

/* ------------------------------------------------------------------------------------------ PARAMETERS ------------------------------------------------------------------------------------------- */

param tiempo_llegada_nueva{parking in PARKINGS, distrito in DISTRITOS};                                                                             # Tiempo de llegada desde un parking a un distrito
param llamadas_totales{distrito in DISTRITOS};                                                                                                      # Total de llamadas en cada distrito
param max_llamadas_parking;                                                                                                                         # Máximo de llamadas que un parking puede atender
param coste_gasolina;                                                                                                                               # Costo de la gasolina
param contrains8;                                                                                                                                   # Porcentaje mínimo de llamadas a atender
param contrains3;                                                                                                                      # Porcentaje máximo de llamadas a atender
param porcentaje_distribucion;                                                                                                                      # Porcentaje de la distrucción
param coste_fijo;                                                                                                                                   # Costo fijo
param M;                                                                                                                                            # Un valor grande (infinito)
param minutos_de_atencion;                                                                                                                          # Minutos para atender

/* --------------------------------------------------------------------------------------- DECISION VARIABLES --------------------------------------------------------------------------------------- */

var tiempo_total_atencion_nueva{parking in PARKINGS, distrito in DISTRITOS} integer >= 0;                                                            # Tiempo de atención en una nueva ubicación
var llamadas_asignadas{parking in PARKINGS} binary;                                                                                                  # Variable binaria: 1 si el parking tiene llamadas, 0 si no
var atencion_llamada{distrito in DISTRITOS} binary;                                                                                                  # Variable binaria: 1 si se atienden llamadas en el distrito, 0 si no
var distribucion{parking in PARKINGS, distrito in DISTRITOS} binary;                                                                                 # Variable binaria: 1 si se distribuyen llamadas al parking y distrito, 0 si no

/* --------------------------------------------------------------------------------------- OBJETIVE FUNCTION --------------------------------------------------------------------------------------- */

# Esta función objetivo calcula el costo total teniendo en cuenta el tiempo de atención en las nuevas ubicaciones, multiplicado por el costo de la gasolina.
# También el costo fijo asociado a las ubicaciones (parking) en uso. Este modelo de optimización busca minimizar este costo total al tomar decisiones sobre 
# qué ubicaciones (parking) usar y cómo distribuir los tiempos de atención.

minimize CosteTotal: 
    sum{parking in PARKINGS, distrito in DISTRITOS} tiempo_total_atencion_nueva[parking, distrito] * tiempo_llegada_nueva[parking, distrito] * coste_gasolina + 
    sum{localizacion in NUEVAS_LOCALIZACIONES} coste_fijo * llamadas_asignadas[localizacion];

/* ------------------------------------------------------------------------------------------- CONTRAINS ------------------------------------------------------------------------------------------- */

# ------------------------------------------------------------------------------------ REUTILIZADAS DE LA PARTE 1 ---------------------------------------------------------------------------------- */
# 1:

    # Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este caso es 10.000 llamadas:
    s.t. limiteLlamadas{parking in PARKINGS}: sum{distrito in DISTRITOS} tiempo_total_atencion_nueva[ parking, distrito ] <= max_llamadas_parking;

# 2:

    # Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia:
    s.t. tiempoEmergencia{parking in PARKINGS, distrito in DISTRITOS}: tiempo_llegada_nueva[parking, distrito] * tiempo_total_atencion_nueva[ parking, distrito ] <= minutos_de_atencion * tiempo_total_atencion_nueva[parking, distrito];

# 3: 

    # Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número total de llamadas asignado a cualquier otro parking de ambulancias:
    s.t. PmnrP{parking1 in PARKINGS, parking2 in PARKINGS: parking2 <> parking1}: sum{distrito in DISTRITOS} tiempo_total_atencion_nueva[parking1, distrito] <= contrains3 * sum{distrito in DISTRITOS} tiempo_total_atencion_nueva[parking2, distrito] + (1 - llamadas_asignadas[parking2]) * M;

# 4:

    # Llamadas totales por distrito:
    s.t. totalD{distrito in DISTRITOS}: sum{parking in PARKINGS} tiempo_total_atencion_nueva[parking, distrito] = llamadas_totales[distrito];

# -------------------------------------------------------------------------------------- NUEVAS PARA LA PARTE 2 ---------------------------------------------------------------------------------- */

# 5:

    # Esta restricción asegura que si no hay llamadas asignadas a un parking (llamadas_asginadas[parking] es igual a 0), el tiempo de atención en ese parking sea 0 o, como máximo, M.
    # Esto garantiza que los recursos (tiempo de atención) no se desperdicien en ubicaciones sin llamadas:

    s.t. parking_en_uso{parking in PARKINGS}: sum{distrito in DISTRITOS} tiempo_total_atencion_nueva[parking, distrito] <= M * llamadas_asignadas[parking];
    s.t. parking_en_uso2{parking in PARKINGS}: sum{distrito in DISTRITOS} tiempo_total_atencion_nueva[parking, distrito] >= - M * (1 - llamadas_asignadas[parking]);

# 6:

    # Si el número de llamadas de un distrito es mayor o igual que el 75% del número máximo de llamadas que pueden atender los parkings de ambulancias, sus llamadas se tienen que distribuir
    # necesariamente entre dos o más parkings de ambulancias.
    s.t. max_75 {parking in PARKINGS, distrito in DISTRITOS}: tiempo_total_atencion_nueva[parking, distrito] <= (sum{localizacion in PARKINGS} tiempo_total_atencion_nueva[localizacion, distrito]) + M *(1 - atencion_llamada[distrito]) - 1;
    s.t. binaria_75_parte1{distrito in DISTRITOS}: sum{parking in PARKINGS} tiempo_total_atencion_nueva[ parking, distrito ] >= (porcentaje_distribucion * max_llamadas_parking) - M * (1 - atencion_llamada[distrito]);
    s.t. binaria_75_parte2{distrito in DISTRITOS}: sum{parking in PARKINGS} tiempo_total_atencion_nueva[ parking, distrito ] <= (porcentaje_distribucion * max_llamadas_parking) + M * atencion_llamada[distrito] - 1;
    s.t. distribuir_llamadas{parking in PARKINGS, distrito in DISTRITOS}: tiempo_total_atencion_nueva[parking, distrito] + M * (1 - distribucion[parking, distrito]) >= 0;
    s.t. distribuir_llamadas2{parking in PARKINGS, distrito in DISTRITOS}: tiempo_total_atencion_nueva[parking, distrito] - M * distribucion[parking, distrito] <= 0;

# 8: 

    # Si un parking de ambulancias cubre alguna llamada de un distrito, no puede cubrir menos del 10% del total de las llamadas de ese distrito:
    s.t. establecer_minimo{parking in PARKINGS, distrito in DISTRITOS}: tiempo_total_atencion_nueva[parking, distrito] >= contrains8*llamadas_totales[distrito]*distribucion[parking, distrito];

end;
