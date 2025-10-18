// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Las variables son un espacio en memoria que nos permite almacenar información de nuestro contrato.
+-----------------------------+
|           VARIABLES         |
+-----------------------------+
|                             |
| <tipo_dato> <nombre_variable>; |
|                             |
+-----------------------------+

Inicializar una variable
+-----------------------------+
|        INICIALIZACION       |
+-----------------------------+
|                             |
| <tipo_dato> <nombre_variable> = <valor>; |
|                             |
+-----------------------------+

+-------------------+------------------------------+-------------------------+-----------------------------+
| Tipo de Variable  | Descripción                  | Rango                   | Ejemplo                     |
+-------------------+------------------------------+-------------------------+-----------------------------+
| uint *            | Entero sin signo de 256 bits | 0 a 2^256 - 1           | 1,000,000,000               |
| int               | Entero con signo de 256 bits | -2^255 a 2^255 - 1      | -1,000,000,000              |
| bool              | Valor booleano (true o false)| true o false            | true                        |
| address *         | Dirección Ethereum (20 bytes)|                         | 0xAbCdEf0123456789          |
| string            | Cadena de texto              |                         | "Hola, mundo!"              |
| bytes *           | Bytes dinámicos              | 0 a 2^256 - 1 bytes     | 0x01, 0x02, 0x03            |
+-------------------+------------------------------+-------------------------+-----------------------------+
*/

contract TestVariables {

// Variables de tipo string
string stringVariableDeclarada;
string stringVariableInicializada = "Valor de mi variable";
string stringVariableVacia = "";

// Variables de tipo Boolean
bool booleanVariableDeclarada;
bool booleanVariableInicializada = true;
bool booleanVariableFalse = false;

// Variables de tipo Bytes
bytes1 bytes1Variable = "a";
bytes32 bytes32Variable = keccak256("Hola Mundo");

// Variables de tipo address
address addressVariables;
address addressVariablesInicializada = 0xF682b36A296b3A38D87DE45a4A6900bAA1dF2adA;

}
