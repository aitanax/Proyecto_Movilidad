
# Practica Modelado 1
#
# This finds the optimal solution for minimizing Tiempo de Atencion

/* SET OF PARTE 1 */
set DISTRITO;
set PARKING;
set NUEVAS_LOCALIZACIONES;
set localizaciones_seleccionadas;

/* SET OF PARTE 2 */


/* PARAMETERS */

/* ------ Parte 1 ------ */
param tiempo_llegada {i in PARKING, j in DISTRITO};
param llamadas_totales {i in DISTRITO};
param max_llamadas_parking;

/* ------ Parte 2 ------ */
param tiempo_llegada_nueva{k in NUEVAS_LOCALIZACIONES, j in DISTRITO};
param coste_fijo;  # Coste fijo de establecer nuevos estacionamientos
param coste_gasolina;

/* DECISION VARIABLES */

/* ------ Parte 1 ------ */
var tiempo_total_atencion{i in PARKING, j in DISTRITO} integer >= 0;

/* DECISION VARIABLES */

/* ------ Parte 2 ------ */
var tiempo_total_atencion_nueva{k in NUEVAS_LOCALIZACIONES, j in DISTRITO} integer >= 0;
var establecer_nuevo{k in NUEVAS_LOCALIZACIONES} binary;  # Variable binaria que indica si se establece un nuevo estacionamiento
var y{j in DISTRITO} binary;

/* OBJECTIVE FUNCTION */

minimize CosteTotal: 
    (sum{i in PARKING, j in DISTRITO}(tiempo_total_atencion[i,j] * tiempo_llegada[i,j]) + 
    sum{k in NUEVAS_LOCALIZACIONES, j in DISTRITO}(tiempo_total_atencion_nueva[k,j] * tiempo_llegada_nueva[k,j]))* coste_gasolina +
    sum{k in NUEVAS_LOCALIZACIONES}(coste_fijo * establecer_nuevo[k]);


/* Restricciones */

/* ------ Parte 1 ------ */

s.t. limiteLlamadasL{i in PARKING}: sum{j in DISTRITO} tiempo_total_atencion[i, j] <= max_llamadas_parking;

s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

s.t. LmnrL{i in PARKING, k in PARKING: k <> i}: sum{j in DISTRITO} tiempo_total_atencion[i,j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion[k,j];

s.t. totalD{j in DISTRITO}: sum{i in PARKING} tiempo_total_atencion[i, j] = llamadas_totales[j];


s.t. establecer_minimo{k in NUEVAS_LOCALIZACIONES}: establecer_nuevo[k] >= 0.1;  # Al menos el 10% de las llamadas

s.t. activar_y{j in DISTRITO}: y[j] >= 1 - floor(1.75 / llamadas_totales[j]);

s.t. distribuir_75{j in DISTRITO}: sum{k in NUEVAS_LOCALIZACIONES}(tiempo_total_atencion_nueva[k, j]) >= 0.1 * llamadas_totales[j] * y[j];

end
;
