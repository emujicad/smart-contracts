// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
Si añadimos el modificador public al declarar una variable, se creará una función getter (una función que permite consultar su valor).

+---------------------------------------------+
|           MODIFICADOR PUBLIC                |
+---------------------------------------------+
|                                             |
|   <tipo_dato> [public]* <nombre_variable>;  |
|                                             |
+---------------------------------------------+

Private: Las variables private solo son visible desde dentro del contrato en el que se definen.
Internal: Las variables internal solo son accesibles internamente desde el contrato y desde los contratos que hereden de él.

+---------------------------------------------------------+
|      MODIFICADOR PRIVATE INTERNAL                       |
+---------------------------------------------------------+
|                                                         |
|   <tipo_dato> [private | internal]* <nombre_variable>;  |
|                                                         |
+---------------------------------------------------------+
*/

contract testModificadores {
    // Modificador public
    uint256 public numero = 8;
    string public texto = "Hola Mundo publico";
    bool public booleano = true;
    address public direccion = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    // Modificador private (Solo accesible desde el contrato)
    uint256 private numeroPrivado = 20;
    string private textoPrivado = "Hola mundo privado";
    bool private booleanoPrivado = true;

    function testPrivate() public view returns (string memory) {
        return textoPrivado;
    }

    // Modificador internal (solo accesible desde el contrato o desde los contratos que hereden de el)
    uint256 internal numeroInterno = 50;
    string internal textoInterno = "Hola mundo Internal";
    bool internal booleanoInterno = true;

    function testInternal() public view returns (string memory) {
        return textoInterno;
    }
}

contract testModificadoresHijos is testModificadores {

    function testInternalHijo() public view returns(string memory) {
        return textoInterno;
    }

}

//este contrato no funciona porque a pesar de que esta heredando no puede acceder a una variable private del contrato padre.
/*
contract testModificadoresHijosPrivate is testModificadores {

    function testPrivateHijo() public view returns(string memory) {
        return textoPrivado;
    }

}
*/