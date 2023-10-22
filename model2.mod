
#
# Practica Modelado 1
#
# This finds the optimal solution for minizing Tiempo de Atencion
#


/* SET OF PARTE 1*/
set DISTRITO;
set PARKING;

/* SET OF PARTE 2*/
set LOCALIZACION_DISTRITO_SEL;

/* PARAMETERS */

/* ------ Parte 1 ------ */
param tiempo_llegada {i in PARKING, j in DISTRITO};
param llamadas_totales {i in DISTRITO};
param max_llamadas_parking;




/* ------ Parte 2 ------ */



/* DECISION VARIABLES */
/* ------ Parte 1 ------ */

var tiempo_total_atencion{i in PARKING, j in DISTRITO} integer >= 0;

/* DECISION VARIABLES */
/* ------ Parte 2 ------ */




/* OBJECTIVE FUNCTION */
minimize Timetoattemp: sum{i in PARKING, j in DISTRITO} (tiempo_total_atencion[i,j]*tiempo_llegada[i,j]);


/* Restricciones */
/* ------ Parte 1 ------ */

/*Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este caso es 10.000 llamadas.*/
s.t. limiteLlamadasL1{i in PARKING} : sum{j in DISTRITO} tiempo_total_atencion[i, j] <= max_llamadas_parking;


/* Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia */
s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

/* Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número total de llamadas asignado a cualquier otro parking de ambulancias. */
s.t. LxmnrLx{i in PARKING, k in PARKING: k <> i}: sum{j in DISTRITO} tiempo_total_atencion[i,j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion[k,j];

/* Llamadas totales*/
s.t. totalD {j in DISTRITO}: sum{i in PARKING} tiempo_total_atencion[i, j] = llamadas_totales[j];

/* ------ Parte 2 ------ */
s.t. limiteLlamadasLocalizacionSeleccionada{i in PARKING, l in localizaciones_seleccionadas}:
    sum {d in DISTRITO : <l, d> in LOCALIZACION_DISTRITO_SELECCIONADO} llamadas_totales[d] * x[i, d] <= 1.5 * sum {k in PARKING} sum {d in DISTRITO : <l, d> in LOCALIZACION_DISTRITO_SELECCIONADO} llamadas_totales[d] * x[k, d];






param tiempo_llegada{i in PARKING, j in DISTRITO};
param tiempo_llegada_nueva{k in NEW_LOCATIONS, j in DISTRITO};
param llamadas_totales{j in DISTRITO};
param max_llamadas_parking;
param coste_fijo{NEW_LOCATIONS};  # Coste fijo de establecer nuevos estacionamientos

var tiempo_total_atencion{i in PARKING, j in DISTRITO} integer >= 0;
var tiempo_total_atencion_nueva{k in NEW_LOCATIONS, j in DISTRITO} integer >= 0;
var establecer_nuevo{k in NEW_LOCATIONS} binary;  # Variable binaria que indica si se establece un nuevo estacionamiento

minimize CosteTotal: sum{i in PARKING, j in DISTRITO}(tiempo_total_atencion[i,j] * tiempo_llegada[i,j]) + 
                     sum{k in NEW_LOCATIONS, j in DISTRITO}(tiempo_total_atencion_nueva[k,j] * tiempo_llegada_nueva[k,j]) +
                     sum{k in NEW_LOCATIONS}(coste_fijo[k] * establecer_nuevo[k]);

s.t. limiteLlamadasL{i in PARKING}: sum{j in DISTRITO} tiempo_total_atencion[i, j] <= max_llamadas_parking;
s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

s.t. LmnrL{i in PARKING, k in PARKING: k != i}: sum{j in DISTRITO} tiempo_total_atencion[i,j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion[k,j];

s.t. totalD{j in DISTRITO}: sum{i in PARKING} tiempo_total_atencion[i, j] = llamadas_totales[j];

s.t. establecer_minimo{k in NEW_LOCATIONS}: establecer_nuevo[k] >= 0.1;  # Al menos 10% de las llamadas

s.t. distribuir_75{j in DISTRITO: llamadas_totales[j] >= 7500}: sum{k in NEW_LOCATIONS}(tiempo_total_atencion_nueva[k, j]) >= 0.1 * llamadas_totales[j];

solve;

display tiempo_total_atencion, tiempo_total_atencion_nueva, establecer_nuevo;











end