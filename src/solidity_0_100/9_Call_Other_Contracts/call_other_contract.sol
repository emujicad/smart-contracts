// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
#################################################################
#                LLAMAR A OTROS CONTRATOS                       #
#################################################################
# La "composabilidad" es una de las mayores fortalezas de       #
# Solidity y Ethereum. Permite que los contratos inteligentes   #
# interactúen entre sí como si fueran piezas de Lego.           #
#                                                               #
# Para llamar a otro contrato, necesitas dos cosas:             #
# 1. La dirección del contrato que quieres llamar.              #
# 2. La "interfaz" del contrato (las firmas de sus funciones).  #
#################################################################
*/


/**
 * @title LlamarContratoPrueba
 * @dev Este es el contrato "llamador". Contiene la lógica para interactuar
 * con un contrato `ContratoPrueba` que ya está desplegado en la blockchain.
 */
contract LlamarContratoPrueba {

    /**
     * @notice Llama a la función `setX` en el contrato de destino para cambiar su estado.
     * @param _test La instancia del contrato `ContratoPrueba` a llamar.
     * @param _x El nuevo valor para la variable `x` en el contrato de destino.
     */
    function setX(ContratoPrueba _test, uint _x) external {
        // Se llama directamente a la función del otro contrato.
        _test.setX(_x);
    }

    /**
     * @notice Llama a la función `getX` en el contrato de destino para leer su estado.
     * @param _test La dirección del contrato `ContratoPrueba` a llamar.
     * @return x El valor de la variable `x` del contrato de destino.
     */
    function getX(address _test) external view returns (uint x) {
        // Para llamar a un contrato solo con su dirección, primero lo "convertimos" (cast)
        // a su tipo de contrato y luego llamamos a la función.
        x = ContratoPrueba(_test).getX();
    }

    /**
     * @notice Llama a una función en el contrato de destino y le envía Ether al mismo tiempo.
     * @dev Esta función debe ser `payable` para poder recibir Ether y reenviarlo.
     * @param _test La dirección del contrato `ContratoPrueba` a llamar.
     * @param _x El nuevo valor para la variable `x`.
     */
    function setXandSendEther(address _test, uint _x) external payable {
        // La sintaxis `{value: msg.value}` se usa para reenviar el Ether recibido
        // en esta transacción a la función que estamos llamando.
        // La función de destino (`setXandReceiveEther`) también debe ser `payable`.
        ContratoPrueba(_test).setXandReceiveEther{value: msg.value}(_x);
    }

    /**
     * @notice Llama a una función que devuelve múltiples valores.
     * @param _test La dirección del contrato `ContratoPrueba` a llamar.
     * @return x El valor de la variable `x`.
     * @return value El valor de la variable `value`.
     */
    function getXandValue(address _test) external view returns (uint x, uint value) {
        // Se asignan los valores de retorno a las variables locales `x` y `value`.
        (x, value) = ContratoPrueba(_test).getXandValue();
    }
}

/**
 * @title ContratoPrueba
 * @dev Este es el contrato "llamado" o de destino. Simplemente almacena algunos
 * datos y permite que otros contratos interactúen con él.
 */
contract ContratoPrueba {
    // Variables de estado que serán leídas y modificadas por el contrato llamador.
    uint public x;
    uint public value = 123;

    // Establece el valor de x.
    function setX(uint _x) external {
        x = _x;
    }

    // Devuelve el valor de x.
    function getX() external view returns (uint) {
        return x;
    }

    // Establece el valor de x y, al ser `payable`, permite que la transacción reciba Ether.
    // `msg.value` contendrá la cantidad de Ether enviada en la llamada.
    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    // Devuelve ambos valores, x y value.
    function getXandValue() external view returns (uint, uint) {
        return (x, value);
    }
}