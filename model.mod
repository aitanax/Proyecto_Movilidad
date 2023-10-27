#
# Practica Modelado 1
#
# This finds the optimal solution for minizing Tiempo de Atencion
#

/* --------------------------------------------------------------------------------------------- SETS --------------------------------------------------------------------------------------------- */

set DISTRITO;
set PARKING;

/* ------------------------------------------------------------------------------------------ PARAMETERS ------------------------------------------------------------------------------------------- */

param tiempo_llegada {i in PARKING, j in DISTRITO};
param llamadas_totales {i in DISTRITO};
param max_llamadas_parking;
param minutos_de_atencion; 
param contrains3;

/* --------------------------------------------------------------------------------------- DECISION VARIABLES --------------------------------------------------------------------------------------- */
var decision{i in PARKING, j in DISTRITO} integer >= 0;

/* --------------------------------------------------------------------------------------- OBJETIVE FUNCTION --------------------------------------------------------------------------------------- */
minimize Timetoattemp: sum{i in PARKING, j in DISTRITO} (decision[i,j] * tiempo_llegada[i,j]);

/* ------------------------------------------------------------------------------------------- CONTRAINS ------------------------------------------------------------------------------------------- */

# ---------------------------------------------------------------------------------------------- PARTE 1 ------------------------------------------------------------------------------------------- */

# 1:

    /*Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este caso es 10.000 llamadas.*/
    s.t. limiteLlamadasL1{i in PARKING} : sum{j in DISTRITO} decision[i, j] <= max_llamadas_parking;

# 2:

    /* Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia */
    s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * decision[i, j] <= minutos_de_atencion * decision[i, j];

# 3:

    /* Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número total de llamadas asignado a cualquier otro parking de ambulancias. */
    s.t. LxmnrLx{i in PARKING, k in PARKING: k <> i}: sum{j in DISTRITO} decision[i,j] <= contrains3 * sum{j in DISTRITO} decision[k,j];

# 4:

    /* Llamadas totales*/
    s.t. totalD {j in DISTRITO}: sum{i in PARKING} decision[i, j] = llamadas_totales[j];


end