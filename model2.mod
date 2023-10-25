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
param contrains3;                                                                                                                                   # Porcentaje máximo de llamadas a atender
param porcentaje_distribucion;                                                                                                                      # Porcentaje de la distrucción
param coste_fijo;                                                                                                                                   # Costo fijo
param M;                                                                                                                                            # Un valor grande (infinito)
param minutos_de_atencion;                                                                                                                          # Minutos para atender


/* --------------------------------------------------------------------------------------- DECISION VARIABLES --------------------------------------------------------------------------------------- */

var decision{parking in PARKINGS, distrito in DISTRITOS} integer >= 0;                                                                               # Ubicación exacta
var llamadas_asignadas{parking in PARKINGS} binary;                                                                                                  # Variable binaria: 1 si el parking tiene llamadas, 0 si no
var limite_superior{distrito in DISTRITOS} binary;                                                                                                    # Variable binaria: 1 si se alcanza el limite, 0 si no
var recibir_llamada{parking in PARKINGS, distrito in DISTRITOS} binary;                                                                              # Variable binaria: 1 si hay llamadas de un parking recibe llamadas de un determinado distrito, 0 si no


/* --------------------------------------------------------------------------------------- OBJETIVE FUNCTION --------------------------------------------------------------------------------------- */

# Esta función objetivo calcula el costo total teniendo en cuenta el tiempo de atención en las nuevas ubicaciones, multiplicado por el costo de la gasolina.
# También el costo fijo asociado a las ubicaciones (parking) en uso. Este modelo de optimización busca minimizar este costo total al tomar decisiones sobre 
# qué ubicaciones (parking) usar y cómo distribuir los tiempos de atención.

minimize coste_total: 
    sum{parking in PARKINGS, distrito in DISTRITOS} decision[parking, distrito] * tiempo_llegada_nueva[parking, distrito] * coste_gasolina + 
    sum{localizacion in NUEVAS_LOCALIZACIONES} coste_fijo * llamadas_asignadas[localizacion];

/* ------------------------------------------------------------------------------------------- CONTRAINS ------------------------------------------------------------------------------------------- */

# ------------------------------------------------------------------------------------ REUTILIZADAS DE LA PARTE 1 ---------------------------------------------------------------------------------- */
# 1:

    # Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este caso es 10.000 llamadas:
    s.t. limite_llamadas{parking in PARKINGS}: sum{distrito in DISTRITOS} decision[parking, distrito] <= max_llamadas_parking;

# 2:

    # Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia:
    s.t. tiempo_emergencia{parking in PARKINGS, distrito in DISTRITOS}: tiempo_llegada_nueva[parking, distrito] * decision[parking, distrito] <= minutos_de_atencion * decision[parking, distrito];

# 3: 

    # Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número total de llamadas asignado a cualquier otro parking de ambulancias:
    s.t. PmnrP{parking1 in PARKINGS, parking2 in PARKINGS: parking2 <> parking1}: sum{distrito in DISTRITOS} decision[parking1, distrito] <= contrains3 * sum{distrito in DISTRITOS} decision[parking2, distrito] + M * (1 - llamadas_asignadas[parking2]) ;

# 4:

    # Llamadas totales por distrito:
    s.t. total_d{distrito in DISTRITOS}: sum{parking in PARKINGS} decision[parking, distrito] = llamadas_totales[distrito];

# -------------------------------------------------------------------------------------- NUEVAS PARA LA PARTE 2 ---------------------------------------------------------------------------------- */

# 5:

    # Esta restricción asegura que una localización seleccionada debe estar asignada al menos a un distrito.
    s.t. asignada{parking in PARKINGS}: sum{distrito in DISTRITOS} decision[parking, distrito] <= M * llamadas_asignadas[parking]; # En otras palabras, si hay llamadas asignadas, se garantiza que el tiempo de atención sea efectivo y no supere un valor M. Esto evita que se asignen recursos de tiempo de atención innecesarios cuando no hay llamadas.
    s.t. no_asignada{parking in PARKINGS}: sum{distrito in DISTRITOS} decision[parking, distrito] >= - M * (1 - llamadas_asignadas[parking]);

# 6:

    # Si el número de llamadas de un distrito es mayor o igual que el 75% del número máximo de llamadas que pueden atender los parkings de ambulancias, sus llamadas se tienen que distribuir necesariamente entre dos o más parkings de ambulancias.
    # necesariamente entre dos o más parkings de ambulancias.
    # Se enfoca en la distribución equitativa de llamadas cuando estas son muchas
    s.t. max_75 {parking in PARKINGS, distrito in DISTRITOS}: decision[parking, distrito] <= (sum{localizacion in PARKINGS} decision[localizacion, distrito]) + M *( 1 - limite_superior[distrito]) -1;
  
    # Se enfoca en el límite de asignación de llamadas a cada parking individualmente.
    s.t. distribucion_075{distrito in DISTRITOS}: sum{parking in PARKINGS} decision[ parking, distrito ] <= (max_llamadas_parking * porcentaje_distribucion) + M * limite_superior[distrito] -1; #7499
    s.t. distribucion_0752{distrito in DISTRITOS}: sum{parking in PARKINGS} decision[ parking, distrito ] >= (max_llamadas_parking* porcentaje_distribucion) - M * (1 - limite_superior[distrito]); #7500
    
# 7: 

    # Si un parking de ambulancias cubre alguna llamada de un distrito, no puede cubrir menos del 10% del total de las llamadas de ese distrito:
    s.t. establecer_minimo{parking in PARKINGS, distrito in DISTRITOS}: decision[parking, distrito] >= contrains8 * llamadas_totales[distrito] * recibir_llamada[parking, distrito];

# 8:

    # Si se da una llamada, se debe cubrir la llamada:
    s.t. distribuir_llamadas{parking in PARKINGS, distrito in DISTRITOS}: decision[parking, distrito] <= M * recibir_llamada[parking, distrito];
    s.t. distribuir_llamadas2{parking in PARKINGS, distrito in DISTRITOS}: decision[parking, distrito] >= - M * (1 - recibir_llamada[parking, distrito]);


solve;
display decision;
display recibir_llamada;
display limite_superior;
display coste_total;



end;
