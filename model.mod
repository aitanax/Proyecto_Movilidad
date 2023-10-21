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
param llamadas_totales {i in DISTRITOS};
param max_llamdas_parking;

/* decision variables */
var llamadas_distrito {i in DISTRITO, j in PARKING} integer, >=0;


/* objective function */
minimize Timetoattemp: sum{i in DISTRITO, j in PARKING}(llamadas_distrito[i,j]);

/* Constraints */
s.t. Fin_hours : sum{i in TOY} Finishing_hours[i]*units[i] <= 100;
s.t. Carp_hours : sum{i in TOY} Carpentry_hours[i]*units[i] <= 80;
s.t. Dem {i in TOY} : units[i] <= Demand_toys[i];

end;
