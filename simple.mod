#
# Practica Modelado 1
#
# This finds the optimal solution for minizing Tiempo de Atencion
#

/* Variables de decisión */
var x11 >=0; /*distrito1parking1*/
var x12 >=0;  /*distrito1parking2*/
var x13 >=0;  /*distrito1parking3*/

var x21 >=0; /*distrito2parking1*/
var x22 >=0;  /*distrito2parking2*/
var x23 >=0;  /*distrito2parking3*/

var x31 >=0; /*distrito3parking1*/
var x32 >=0;  /*distrito3parking2*/
var x33 >=0;  /*distrito3parking3*/

var x41 >=0; /*distrito4parking1*/
var x42 >=0;  /*distrito4parking2*/
var x43 >=0;  /*distrito4parking3*/

var x51 >=0; /*distrito5parking1*/
var x52 >=0;  /*distrito5parking2*/
var x53 >=0;  /*distrito5parking3*/

/* Fucion objetivo */
minimize Timetoattemp: 20x11 + 15x12 + 34x13 + 30x21 + 18x22 + 20x23 + 50x31 + 30x32 + 14x33 + 15x41 + 12x42 + 30x43 + 32x51 + 15x52 + 18x53 ;

/* Restricciones */

s.t. LimitellamadasL1 : x11 + x21 + x31 + x41 + x51 <= 10000;
s.t. LimitellamadasL2 : x12 + x22 + x32 + x42 + x52 <= 10000;
s.t. LimitellamadasL3 : x13 + x23 + x33 + x43 + x53 <= 10000;

s.t. L1mnrL2 : x11 + x21 + x31 + x41 + x51 <= 1.5 * (x12 + x22 + x32 + x42 + x52);
s.t. L2mnrL1 : x12 + x22 + x32 + x42 + x52 <= 1.5 * (x11 + x21 + x31 + x41 + x51);
s.t. L1mnrL3 : x11 + x21 + x31 + x41 + x51 <= x13 + x23 + x33 + x43 + x53;
s.t. L3mnrL2 : x13 + x23 + x33 + x43 + x53 <= 1.5 * (x12 + x22 + x32 + x42 + x52);
s.t. L3mnrL1 : x13 + x23 + x33 + x43 + x53 <= 1.5 * (x11 + x21 + x31 + x41 + x51);
s.t. L2mnrL3 : x12 + x22 + x32 + x42 + x52 <= 1.5 * (x13 + x23 + x33 + x43 + x53);

s.t. d15000 : x11 + x12 + x13 = 5000;
s.t. d26500 : x21 + x22 + x23 = 6500;
s.t. d35400 : x31 + x32 + x33 = 5400;
s.t. d47500 : x41 + x42 + x43 = 7500;
s.t. d55500 : x51 + x42 + x43 = 5500;

end;
