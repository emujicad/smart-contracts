// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
#################################################################
#                  PATRÓN "OWNABLE" (PROPIETARIO)                 #
#################################################################
# Este patrón de diseño es fundamental en Solidity para el      #
# control de acceso. Permite que ciertas acciones solo puedan   #
# ser ejecutadas por el dueño del contrato.                     #
#                                                               #
# Componentes clave:                                            #
# 1. Una variable de estado `propietario` para guardar la       #
#    dirección del dueño.                                       #
# 2. Un `constructor` que asigna como dueño a `msg.sender`      #
#    (quien despliega el contrato).                             #
# 3. Un `modifier` (ej. `soloPropietario`) que comprueba si     #
#    `msg.sender` es el dueño antes de ejecutar una función.    #
#################################################################
*/

/**
 * @title Propietario
 * @dev Implementación simple del patrón Ownable.
 */
contract Propietario {
    // Variable de estado para almacenar la dirección del propietario del contrato.
    // Es `public` para que cualquiera pueda ver quién es el propietario a través de una función getter automática.
    address public propietario;

    /**
     * @dev El constructor se ejecuta solo una vez, en el momento del despliegue del contrato.
     * `msg.sender` es una variable global que contiene la dirección de la cuenta que está desplegando el contrato.
     * Así, la persona que despliega el contrato se convierte en su propietario inicial.
     */
    constructor() {
        propietario = msg.sender;
    }

    /**
     * @dev Un `modifier` es código reutilizable que se puede "enganchar" a una función.
     * Se usa para verificar una condición antes de que la función se ejecute.
     */
    modifier soloPropietario() {
        // `require` comprueba una condición. Si es falsa, revierte la transacción.
        // Aquí nos aseguramos de que la persona que llama a la función es el propietario.
        require(msg.sender == propietario, "Error: No es el propietario");
        // El guion bajo `_` es un marcador de posición. Si el `require` es verdadero,
        // la ejecución continúa y el código de la función a la que se aplica este modifier se inserta aquí.
        _;
    }

    /**
     * @notice Transfiere la propiedad del contrato a una nueva dirección.
     * @dev Solo el propietario actual puede llamar a esta función.
     * Es crucial tener una forma de cambiar de propietario.
     * @param _newOwner La dirección del nuevo propietario.
     */
    function setPropietario(address _newOwner) external soloPropietario {
        // Es una buena práctica verificar que la nueva dirección no sea la dirección cero.
        require(_newOwner != address(0), "Error: Direccion invalida");
        propietario = _newOwner;
    }

    /**
     * @dev Ejemplo de una función protegida por el modifier `soloPropietario`.
     * Solo el dueño del contrato podrá llamar a esta función con éxito.
     */
    function soloPropietarioPuedeLlamar() view external soloPropietario returns (string memory) {
        return "Funcion ejecutada por el propietario del contrato";
    }

    /**
     * @dev Ejemplo de una función pública que no tiene ninguna restricción.
     * Cualquiera puede llamarla.
     */
    function cualquieraPuedeLlamar() pure external returns (string memory) {
        return "Funcion ejecutada por cualquier usuario";
    }
}
