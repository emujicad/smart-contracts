/*
Los contratos de solidity pueden utilizar una forma especial de comentarios para proporcionar documentación rica para funciones, variables de retorno y más. Esta forma especial se denomina Formato de especificación del lenguaje natural de Ethereum (NatSpec).

                  ESTANDAR DE COMENTARIO
____________________________________________________________________
|
|    /// @title <Título del contrato>
|    /// @author <Autor del contrato>
|    /// @notice <Explicar lo que hace el contrato o la función>
|    /// @dev <Detalles adicionales sobre  el contrato o la función>
|    /// @param <nombre_parametro> <Describe para qué sirve el parámetro>
|    /// @return <valor_retorno> <Describe para qué sirve el valor de retorno>
____________________________________________________________________

https://docs.soliditylang.org/en/latest/natspec-format.html

*/

// SPDX-License-Identifier: MIT

/// @title Contrato Persona
/// @author Ender Mujica
/// @notice Contrato de ejemplo que retorna el nombre de una persona
/// @dev Todas las funciones estan implementadas de forma didactica
/// @param <nombre_parametro> <Describe para qué sirve el parámetro>
/// @return <valor_retorno> <Describe para qué sirve el valor de retorno>

pragma solidity ^0.8.0;

contract Persona {
    string private testNombre;

    /// @notice Guarda el nombre de una persona
    /// @dev La variable testNombre se guarda en la BlockChain
    function setNombre(string memory _nombre) public {
        testNombre = _nombre;
    }

    /// @return Retorna el nombre de la persona que ha sido guardado en la funcion setNombre
    function getNombre() public view returns (string memory) {
        return testNombre;
    }

    /// @dev Devuelve solo un texto fijo
    /// @return Devuelve un string con la cantidad de la poblacion Mundial
    function poblacionMundial() external pure returns (string memory) {
        string memory poblacion = 'Poblacion Mundial Actual: 8.083.080.515';
        return poblacion;
    }
}