/*
Los comentarios son una parte importante de cualquier contrato inteligente y proporcionan información sobre el contrato.
_____________________________________________________________________
|             COMMENTS                                              |
|___________________________________________________________________|
|                                                                   |
|    // Comentatio de una sola linea
|    /*
|    Comentatio multilinea o bloque de comentarios. NO afectan la ejecucion del contrato.
|    */
/*
|___________________________________________________________________|
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Comentatio de una sola linea
/*
Comentatio multilinea o bloque de comentarios. NO afectan la ejecucion del contrato.
*/

contract Primos {
    // Funcion publica que valida si un numero es primo
    function esPrimo(uint n) public pure returns (bool) {
        require(n > 1, 'El numero debe ser mayor que 1');
        // Si el numero es igual a 2, es primo
        if (n == 2) {
            return true;
        }
        /*
        Inicializamos el divisor desde 3
        hasta la raiz cuadrada de n con
        incrementos de 2
        */
        for (uint i = 3; i * i <= n; i += 2) {
            if (n % i == 0) {
                return false;
            }
        }
        // Si no se encuentra ningun divisor el numero es primo.
        return true;
    }
}
