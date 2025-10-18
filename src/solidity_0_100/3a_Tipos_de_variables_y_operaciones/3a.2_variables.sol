// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Existen 2 tipos de variables enteras en solidity con y sin signo (int / uint).
+-------------------------------------------+
|        VARIABLES INT/UINT                 |
+-------------------------------------------+
|                                           |
|   uint<x> <nombre_variable>;              |
|   int<x> <nombre_variable>;               |
|                                           |
+-------------------------------------------+

- <x> varia de 8 a 256 en incrementos de 8, por ejemplo: uint8, uint16, uint24, ..., uint256
- Si no especificamos el numero de bits, por defecto es uint256

Con 8 bits, podemos representar 2^8 = 256 valores distintos contando el 0. Sin embargo, para los tipos de datos sin signo, como uint8, uno de los bits se utiliza para el signo (positivo o negativo). Por lo tanto, un int8 puede representar 2^7 = 128 valores distintos.

+-------------+-------------------+--------------------------+
| Tipo de Dato| Valor Mínimo      | Valor Máximo             |
+-------------+-------------------+--------------------------+
| uint8       | 0                 | 255                      |
| int8        | -128              | 127                      |
| uint16      | 0                 | 65,535                   |
| int16       | -32,768           | 32,767                   |
| uint32      | 0                 | 4,294,967,295            |
| int32       | -2,147,483,648    | 2,147,483,647            |
| ...         |                   |                          |
+-------------+-------------------+--------------------------+

NOTA: En una variable de tipo uint256 se puede almacenar un numero muy grande igual a:

115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457,584,007,913,129,639,935

115 cuatrillones (aproximadamente).
*/

contract Enteros {

// Variables enteras sin especificar un numero de bits
uint uintVariable;
int intVariable;

// Variables enteras sin signo
uint8 uint8Variable;
uint16 uint16Variable = 122;
uint32 uint32Variable;

// Variables enteras con signo
int8 int8Variable;
int16 int16Variable = -122;
int32 int32Variable;

// Funcion para obtener el tipo y los bits
function obtenerTipoyBits(uint _numero) public pure returns(string memory, uint) {
    if(_numero <= type(uint8).max){
        return ("uint8", 8);
    } else if (_numero <= type(uint16).max){
        return ("uint16", 16);
    } else if (_numero <= type(uint32).max){
        return ("uint32", 32);
    } else if (_numero <= type(uint64).max){
        return ("uint64", 64);
    } else if (_numero <= type(uint128).max){
        return ("uint128", 128);
    } else if (_numero <= type(uint256).max){
        return ("uint256", 256);
    } else {
        revert("Numero demasiado grande para ser representado por solidity");
    }
}

}
