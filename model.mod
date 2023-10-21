#
# Giapetto's problem
#
# This finds the optimal solution for maximizing Giapetto's profit
#

/* set of calls */
set DISTRITO;
set PARKING;

/* parameters */
/* Parte 1*/
param tiempo_llegada {i in PARKING, j in DISTRITO};
param llamadas_totales {i in DISTRITO};
param max_llamadas_parking;

/* decision variables */
var tiempo_total_atencion{i in PARKING, j in DISTRITO} integer, >=0;


/* objective function */
minimize Timetoattemp: sum{i in PARKING, j in DISTRITO}(tiempo_total_atencion[i,j]*tiempo_llegada[i,j]);

/* Restricciones */
/*Parte 1*/

/*Un parking de ambulancias no puede atender más de un determinado número de llamadas en
total, que en este caso es 10.000 llamadas.*/
s.t. limitellamadasL1{i in PARKING} : sum{j in DISTRITO} tiempo_total_atencion['L1', j] <= max_llamadas_parking;
s.t. limitellamadasL2{i in PARKING} : sum{j in DISTRITO} tiempo_total_atencion['L2', j] <= max_llamadas_parking;
s.t. limitellamadasL3{i in PARKING} : sum{j in DISTRITO} tiempo_total_atencion['L3', j] <= max_llamadas_parking;

/*Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar
donde se produce la emergencia */

/* Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder
en más del 50% el número total de llamadas asignado a cualquier otro parking de ambulancias. */


end;
