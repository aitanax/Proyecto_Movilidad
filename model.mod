#
# Practica Modelado 1
#
# This finds the optimal solution for minizing Tiempo de Atencion
#


/* SET OF CALLS */
set DISTRITO;
set PARKING;


/* PARAMETERS */

/* ------ Parte 1 ------ */
param tiempo_llegada {i in PARKING, j in DISTRITO};
param llamadas_totales {i in DISTRITO};
param max_llamadas_parking;


/* DECISION VARIABLES */
var tiempo_total_atencion{i in PARKING, j in DISTRITO} integer >= 0;


/* OBJECTIVE FUNCTION */
minimize Timetoattemp: sum{i in PARKING, j in DISTRITO} (tiempo_total_atencion[i,j]*tiempo_llegada[i,j]);


/* RESTRICCIONES */

/* ------ Parte 1 ------ */
/* Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este 
caso es 10.000 llamadas.*/ 

s.t. limiteLlamadasL1 : sum{j in DISTRITO} tiempo_total_atencion['L1', j] <= max_llamadas_parking;
s.t. limiteLlamadasL2: sum{j in DISTRITO} tiempo_total_atencion['L2', j] <= max_llamadas_parking;
s.t. limiteLlamadasL3: sum{j in DISTRITO} tiempo_total_atencion['L3', j] <= max_llamadas_parking;

/* Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia */
s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

/* Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número 
total de llamadas asignado a cualquier otro parking de ambulancias. */
s.t. L1mnrL2: sum{j in DISTRITO} tiempo_total_atencion['L1',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L2',j];
s.t. L1mnrL3: sum{j in DISTRITO} tiempo_total_atencion['L1',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L3',j];
s.t. L2mnrL1: sum{j in DISTRITO} tiempo_total_atencion['L2',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L1',j];
s.t. L2mnrL3: sum{j in DISTRITO} tiempo_total_atencion['L2',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L3',j];
s.t. L3mnrL1: sum{j in DISTRITO} tiempo_total_atencion['L3',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L1',j];
s.t. L3mnrL2: sum{j in DISTRITO} tiempo_total_atencion['L3',j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion['L2',j];

/* Llamadas totales*/
s.t. totalD1: sum{i in PARKING} tiempo_total_atencion[i, 'D1'] = llamadas_totales['D1'];
s.t. totalD2: sum{i in PARKING} tiempo_total_atencion[i, 'D2'] = llamadas_totales['D2'];
s.t. totalD3: sum{i in PARKING} tiempo_total_atencion[i, 'D3'] = llamadas_totales['D3'];
s.t. totalD4: sum{i in PARKING} tiempo_total_atencion[i, 'D4'] = llamadas_totales['D4'];
s.t. totalD5: sum{i in PARKING} tiempo_total_atencion[i, 'D5'] = llamadas_totales['D5'];


/* ------ Parte 2 ------ */
/* Un parking de ambulancias no puede atender más de un determinado número de llamadas en total, que en este 
caso es 10.000 llamadas.*/ 
s.t. limiteLlamadasL{i in PARKING}: sum{j in DISTRITO} tiempo_total_atencion[i, j] <= max_llamadas_parking;

/* Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia */
s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

/* Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número 
total de llamadas asignado a cualquier otro parking de ambulancias. */
s.t. LmnrL{i in PARKING, k in PARKING: k != i}: sum{j in DISTRITO} tiempo_total_atencion[i,j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion[k,j];

/* Llamadas totales*/
s.t. totalD {j in DISTRITO}: sum{i in PARKING} tiempo_total_atencion[i, j] = llamadas_totales[j];

solve;

display tiempo_total_atencion;




s.t. tiempoEmergencia{i in PARKING, j in DISTRITO}: tiempo_llegada[i, j] * tiempo_total_atencion[i, j] <= 35 * tiempo_total_atencion[i, j];

s.t. LmnrL{i in PARKING, k in PARKING: k != i}: sum{j in DISTRITO} tiempo_total_atencion[i,j] <= 1.5 * sum{j in DISTRITO} tiempo_total_atencion[k,j];




end;