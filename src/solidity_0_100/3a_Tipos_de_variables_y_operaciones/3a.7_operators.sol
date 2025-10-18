// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*

MATEMATICOS                        COMPARACION                         LOGICOS

| Simbolo | Descripcion          |  | Simbolo | Descripcion          |  | Simbolo | Descripcion           |
| ------- | ---------------------|  | ------- | ---------------------|  | ------- | ---------------------|
| +       | Suma                 |  | >       | Mayor                |  | !       | Negacion             |
| -       | Resta                |  | <       | Menor                |  | &&      | And                  |
| *       | Multip               |  | >=      | Mayor Igual          |  | ||      | Or                   |
| /       | Division             |  | <=      | Menor Igual          |  | ------- | -------------------- |
| %       | Modulo               |  | ==      | Igualdad             |
| **      | Exponent             |  | !=      | Inigualdad           | 
| ------- | ---------------------|  | ------- | ---------------------|

*/
contract Operators {
// Operadores Matematicos
uint public suma = 2 + 4;
uint public resta = 4 - 3;
uint public multiplicacion = 2 * 2;
uint public division = 10 / 2;
uint public modulo = 5 % 2;

// Operadores de Comparacion
bool public igual = 2 == 2;
bool public distinto = 2 != 2;
bool public mayor = 2 > 2;
bool public menor = 2 < 3;
bool public mayorIgual = 2 >= 1;
bool public menorIgual = 2 <= 3;

// Operadores Logicos
bool public y = true && true;
bool public o = true || false;
bool public no = !true;
}