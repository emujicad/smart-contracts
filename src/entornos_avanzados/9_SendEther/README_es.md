# Contrato de Envío y Recepción de Ether (SendEther.sol)

Este contrato de Solidity (`SendEther.sol`) es un ejemplo fundamental para entender cómo los contratos inteligentes pueden manejar Ether (la criptomoneda nativa de Ethereum). Demuestra cómo un contrato puede recibir, almacenar y enviar Ether, así como implementar un control de acceso básico para funciones sensibles.

## Características Principales

*   **Recepción de Ether**: El contrato puede recibir Ether directamente a través de su función `receive()`.
*   **Almacenamiento de Ether**: El Ether recibido se almacena en el balance del contrato.
*   **Retiro de Ether**: El propietario del contrato puede retirar una cantidad específica de Ether.
*   **Control de Propiedad**: Implementa un mecanismo de `owner` (propietario) para restringir el acceso a funciones críticas.
*   **Cambio de Propietario**: El propietario actual puede transferir la propiedad del contrato a una nueva dirección.
*   **Eventos**: Emite un evento `deposit` cada vez que se recibe Ether, lo que facilita el seguimiento de los fondos.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`address payable public owner;`**: Declaración de una variable de estado para el propietario.
    *   **`address payable`**: Un tipo de dirección especial que puede recibir Ether.
    *   **`public`**: Permite leer la dirección del propietario desde fuera del contrato.
*   **`event deposit(address indexed sender, uint256 amount);`**: Declaración de un evento para registrar depósitos.
    *   **`indexed`**: Hace que el parámetro `sender` sea buscable en los logs de la blockchain.
*   **`constructor() payable { ... }`**: Función especial que se ejecuta una sola vez al desplegar el contrato.
    *   **`payable`**: Permite que el constructor reciba Ether durante el despliegue.
    *   **`msg.sender`**: Variable global que representa la dirección que inició la transacción actual.
*   **`receive() external payable { ... }`**: Función especial que se ejecuta cuando el contrato recibe Ether sin datos de llamada (transacción de Ether simple).
    *   **`external`**: Solo puede ser llamada desde fuera del contrato.
    *   **`payable`**: Permite que la función reciba Ether.
    *   **`msg.value`**: Variable global que representa la cantidad de Ether (en Wei) enviada con la transacción actual.
*   **`function withdraw(uint256 _amount) external { ... }`**: Función para retirar Ether.
    *   **`require(condition, "mensaje de error");`**: Se utiliza para validar condiciones y revertir la transacción si no se cumplen. Aquí, se usa para el control de acceso.
    *   **`address(this).balance`**: Variable global que devuelve el balance de Ether actual del contrato.
    *   **`payable(address).transfer(amount);`**: Método para enviar Ether a una dirección. Es una forma segura pero con un límite de gas de 2300.
*   **`function changeOwner(address _newOwner) external { ... }`**: Función para cambiar el propietario.
*   **`view`**: Modificador de estado para funciones que solo leen el estado del contrato y no lo modifican.
*   **`returns (uint256)`**: Especifica el tipo de dato que devuelve una función.

## Cómo Funciona

1.  **Despliegue**: Al desplegar el contrato, la dirección que lo despliega se convierte en el `owner`.
2.  **Depósito de Ether**: Cualquier persona puede enviar Ether directamente a la dirección del contrato. Esto activará la función `receive()`, que emitirá un evento `deposit` para registrar la transacción.
3.  **Retiro de Ether**: Solo el `owner` puede llamar a la función `withdraw()` para sacar Ether del contrato. Se verifica que el `msg.sender` sea el `owner` antes de permitir el retiro.
4.  **Cambio de Propiedad**: El `owner` actual puede transferir la propiedad del contrato a una nueva dirección llamando a `changeOwner()`.

## Uso (Ejemplo Educativo)

Este contrato es fundamental para entender la gestión de Ether en Solidity. Es un bloque de construcción para contratos más complejos que necesitan manejar fondos, como bóvedas, sistemas de pago o contratos de crowdfunding.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Envía Ether directamente a la dirección del contrato.
*   Llama a `withdraw()` desde la dirección del propietario para retirar fondos.
*   Intenta llamar a `withdraw()` desde una dirección que no sea la del propietario para ver cómo falla la transacción.
*   Llama a `changeOwner()` para transferir la propiedad.

Este contrato proporciona una base sólida para comprender las interacciones de Ether en la blockchain y los patrones de control de acceso.
