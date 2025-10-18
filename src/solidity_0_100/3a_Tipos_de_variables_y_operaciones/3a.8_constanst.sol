// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Al declarar una variable de estado como constante, podemos ahorrar gas cuando se llame a una función que utilice esa variable de estado.

+----------------------+
|      CONSTANT        |
+----------------------+
|                      |
| <tipo_dato> constant <nombre_variable>; |
|                      |
+----------------------+

*/

contract TestNoConstants {
    // Variable de estado
    uint256 public max_num = 100;

    // usa 2682 de gas
    function esMayor(uint256 _num) public view returns (bool) {
        return _num > max_num;
    }
}

contract TestConstants {
    // Constante
    uint256 public constant MAX_NUM = 100;

    // usa 605 de gas
    function esMayor(uint256 _num) public pure returns (bool) {
        return _num > MAX_NUM;
    }
}