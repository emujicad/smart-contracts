// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
#################################################################
#                       HERENCIA MÚLTIPLE                       #
#################################################################
# - Un contrato puede heredar de múltiples contratos padres.
# - Sintaxis: `contract Hijo is PadreA, PadreB, ...`
# - Solidity resuelve conflictos de herencia usando Linearización C3.
#
# Orden de Herencia (Linearización):
# - Solidity determina un orden estricto para resolver qué función
#   padre llamar. El orden de los padres en la declaración `is` es
#   CRÍTICO y se lee de DERECHA a IZQUIERDA para determinar la prioridad.
#
# Para `contract Z is X, Y`:
#  1. El compilador mira el padre más a la derecha: Y.
#  2. Luego el siguiente a la izquierda: X.
# La cadena de herencia (linearización) para Z es: Z -> Y -> X
#
# Esto significa que si Z llama a una función que no ha implementado,
# la buscará primero en Y y luego en X.
#
# Problema del "Diamante" y su Resolución:
# - Un conflicto ocurre cuando un contrato hereda de múltiples padres
#   que tienen una función con el mismo nombre (ej. `foo()`).
# - En nuestro caso, Z hereda de Y, que a su vez hereda de X.
#   `Y` ya tiene `foo()` de `X`. `Z` hereda `foo()` de `X` y de `Y`.
# - Para resolver esta ambigüedad, el contrato hijo (Z) debe
#   sobrescribir la función y especificar explícitamente a qué
#   padres está sobrescribiendo.
# - Sintaxis: `override(PadreA, PadreB)`. En nuestro caso, `override(X, Y)`.
#   Esto confirma al compilador que entendemos la ambigüedad y la 
#   estamos resolviendo intencionalmente.
#
# Reglas importantes:
# - Si un contrato padre tiene una función marcada como `virtual`,
#   un contrato hijo puede sobrescribirla usando `override`.
# - Si múltiples contratos padres tienen la misma función, el
#   contrato hijo debe especificar explícitamente cuál versión
#   está sobrescribiendo usando `override(PadreA, PadreB)`.
#
# Ejemplo visual de la herencia en ESTE código:
#
#       X
#      /|
#     / |
#    Y  |  (Z hereda de X directamente)
#     \ |
#      \|
#       Z (hereda de Y y de X)
#
#################################################################
*/


/**
 * @title X
 * @dev El contrato ancestro base(el punto más alto del diamante). Todas sus funciones son `virtual` para permitir la sobrescritura.
 */
contract X {
    function foo() public pure virtual returns(string memory) {
        return "X";
    }

    function bar() public pure virtual returns(string memory) {
        return "X";
    }

    function baz() public pure returns(string memory) {
        return "X";
    }
}

/**
 * @title Y
 * @dev Primer hijo de X y hereda de X. Sobrescribe algunas funciones de X.
 */
contract Y is X {
    // Sobrescribe `foo` de X. Como es `virtual`, permite que sus hijos de Y puedan sobrescribirla.
    function foo() public pure virtual override returns(string memory) {
        return "Y";
    }

    // Sobrescribe `bar` de X y permite que sus hijos la sobrescriban también.
    function bar() public pure virtual override returns(string memory) {
        return "Y";
    }

    // Una función propia de Y.
    function y() public pure returns(string memory) {
        return "Y";
    }
}

/**
 * @title Z
 * @dev Hereda de X y de Y, creando el "problema del diamante".
 * La linearización es Z -> Y -> X.
 */
contract Z is X, Y {
    /**
     * @dev Sobrescribe la función `foo`.
     * Es obligatorio especificar de qué contratos padres se está sobrescribiendo: `override(X, Y)`.
     * Esto confirma al compilador que entendemos la ambigüedad y la estamos resolviendo.
     */
    function foo() public pure override(X, Y) returns(string memory) {
        return "Z";
    }

    /**
     * @dev Lo mismo para la función `bar`.
     */
    function bar() public pure override(X, Y) returns(string memory) {
        return "Z";
    }

    // Si desplegamos Z y llamamos a sus funciones:
    // - Z.foo() devuelve "Z" (la implementación más derivada).
    // - Z.bar() devuelve "Z" (la implementación más derivada).
    // - Z.baz() busca en Z (no está), busca en Y (no está), busca en X (sí está) -> devuelve "X".
    // - Z.y() busca en Z (no está), busca en Y (sí está) -> devuelve "Y".
}