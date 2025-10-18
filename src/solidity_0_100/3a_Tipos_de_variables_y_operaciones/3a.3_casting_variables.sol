// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
El casting o cast nos permite convertir una variable de un tipo a otro.
+-------------------------------------------------------------+
|                    CASTING (CASTEO)                         |
+-------------------------------------------------------------+
// Podemos transformar un uint (o un int) con Y número de bits a un uint
// (o un int) con X número de bits.
uint<x> (<dato_uint<y>>);
int<x> (<dato_int<y>>);

// Podemos transformar un int con Y números de bits a un uint con X número
// de bits y viceversa.
uint<x> (<dato_int<y>>);
int<x> (<dato_uint<y>>);

+-------------------------------------------------------------+

En Solidity, las conversiones explícitas (casting) están limitadas y solo se permiten entre tipos de datos relacionados.
No puedes convertir directamente cualquier variable a cualquier tipo arbitrario. Las conversiones están definidas entre tipos compatibles en el lenguaje.
*/

contract CastingVariables {

// Variables a castear
uint8 numeroUint8 = 5;
uint16 numeroUint16 = 123;
uint numeroUint = 8000000;
int8 numeroInt8 = -4;
int16 numeroInt16 = -234;
int numeroInt = -8000000;
string stringVariable = "354";

// Casting Variables
uint32 public castingNumero1 = uint32(numeroUint8);
int16 public castingNumero2 = int16(numeroUint16);
uint8 public castingNumero3 = uint8(numeroInt8);
int public castingNumero4 = int(numeroInt16);
uint public castingNumero5 = uint(numeroUint);
//uint public castingNumero6 = uint(stringVariable);   Not supported

    function castingVariables8a32(uint8 _numero) public pure returns (uint32) {
        return uint32(_numero);
    }

}
