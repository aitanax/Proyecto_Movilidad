# Conjuntos
set D; # Distritos
set L; # Localizaciones de parkings
set LN; 

# Parámetros
param llamadas {D}; 
param tiempo {L, D};
param max_llamadas;
param tiempo_maximo_atencion;
param maximo_esfuerzo_relativo;
param coste_nuevo_parking;
param coste_combustible;
param M; # Un valor grande

# Variables de decisión
var x {L, D} integer, >= 0; # Llamada atendida por un parking de un distrito
var z {L} binary; # Selección de nuevas localizaciones
var w {L, D} binary; # Comprobación de que un parking cubre llamadas de un distrito
var y {D} binary; # Decisión de redistribuir llamadas de un distrito (Comprobación de que el número de llamadas de un distrito no 
sea igual o mayor que el 75% del número máximo de llamadas que pueden recibir los parkings)

# Función objetivo: Minimizar el gasto total (coste fijo + coste en combustible)
minimize gasto_total: sum {l in L, d in D} coste_combustible * tiempo[l,d] * x[l,d] 
					+ sum {ln in LN} coste_nuevo_parking * z[ln];
# Restricciones

# Todas las llamadas de todos los distritos deben ser atendidas en algún parking de ambulancias
s.t. atender_llamadas {l in L}: sum {d in D} x[l,d] = llamadas[d];

# Un parking de ambulancias no puede atender más de un determinado número de llamadas en total
s.t. maximo_llamadas {l in L}: sum {d in D} x[l,d] <= max_llamadas;

# Se debe garantizar que una ambulancia no tardará nunca más de 35 minutos en llegar al lugar donde se produce la emergencia
s.t. maximo_tiempo {l in L, d in D}: tiempo[l,d] * x[l,d] <= tiempo_maximo_atencion * x[l,d];

# Para balancear el esfuerzo, el número total de llamadas asignado a un parking no puede exceder en más del 50% el número total 
de llamadas asignado a cualquier otro parking de ambulancias.
s.t. balance_esfuerzo {l1 in L, l2 in L}: sum {d in D} x[l1,d] - (maximo_esfuerzo_relativo * sum {d in D} x[l2,d]) - (1 - z[l2]) * M <= 0;

# Una localización seleccionada debe estar asignada al menos a un distrito. PENDIENTE A BORRAR. YA NO
s.t. localizacion_seleccionada {ln in L}: sum{d in D} x[ln, d] >= z[ln];
s.t. localizacion_no_seleccionada {ln in L}: sum{d in D} x[ln, d] <= M * z[ln];

# Si el número de llamadas de un distrito es mayor o igual que el 75% del número máximo de llamadas que pueden atender los parkings 
de ambulancias, sus llamadas se tienen que distribuir necesariamente entre dos o más parkings de ambulancias.
# s.t. distri_llama {l in L, d in D}: x[l, d] <= (0.75 * max_llamadas) - 1;
#La anterior esta mal, hay que hacerlo con una variable binaria. 
s.t. real_distri_llama {l in L, d in D}: x[l, d] - (sum{loc in L} x[loc, d]) - (1 - y[d]) * M <=  -1;
s.t. binaria_75001 {d in D}: sum {l in L} x[l, d]  >= - M * (1 - y[d]) + (0.75 * max_llamadas);
s.t. binaria_75002 {d in D}: sum {l in L} x[l, d] <= y[d] * M + (0.75 * max_llamadas) - 1;

# Si un parking de ambulancias cubre alguna llamada de un distrito, no puede cubrir menos del 10% del total de las llamadas de ese 
distrito.
s.t. minimo_llamadas {l in L, d in D}: x[l,d] >= 0.1 * llamadas[d] * w[l,d];

# Si hay llamadas desde un distrito a un parking, entonces w[l,d] = 1
s.t. asignacion_llamadas1 {l in L, d in D}: x[l,d] >= w[l,d];
s.t. asignacion_llamadas2 {l in L, d in D}: x[l,d] <= M * w[l,d];

solve;
display x;
display w;
display z;
display gasto_total;
end;
