# Contrato de Billetera Simple (Wallet.sol)

Este contrato de Solidity (`Wallet.sol`) implementa una billetera de Ether básica en la blockchain. Permite a un propietario designado recibir y retirar Ether, y también transferir la propiedad del contrato. Es un ejemplo fundamental para comprender la gestión de fondos y el control de acceso en los contratos inteligentes.

## Características Principales

*   **Recepción de Ether**: El contrato puede recibir Ether directamente.
*   **Retiro de Ether**: Solo el propietario puede retirar una cantidad específica de Ether.
*   **Control de Propiedad**: La dirección que despliega el contrato se convierte en el propietario, con acceso exclusivo a funciones sensibles.
*   **Cambio de Propietario**: El propietario actual puede transferir la propiedad del contrato a una nueva dirección.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`address payable public owner;`**: Declaración de una variable de estado para el propietario.
    *   **`address payable`**: Un tipo de dirección especial que puede recibir Ether.
    *   **`public`**: Permite leer la dirección del propietario desde fuera del contrato.
*   **`constructor() { ... }`**: Función especial que se ejecuta una sola vez al desplegar el contrato.
    *   **`msg.sender`**: Variable global que representa la dirección que inició la transacción actual.
*   **`receive() external payable { ... }`**: Función especial que se ejecuta cuando el contrato recibe Ether sin datos de llamada (transacción de Ether simple).
    *   **`external`**: Solo puede ser llamada desde fuera del contrato.
    *   **`payable`**: Permite que la función reciba Ether.
*   **`function withdraw(uint256 _amount) external { ... }`**: Función para retirar Ether.
    *   **`require(condition, "mensaje de error");`**: Se utiliza para validar condiciones y revertir la transacción si no se cumplen. Aquí, se usa para el control de acceso, asegurando que solo el propietario pueda retirar.
    *   **`payable(address).transfer(amount);`**: Método para enviar Ether a una dirección.
*   **`function changeOwner(address _newOwner) external { ... }`**: Función para cambiar el propietario.

## Cómo Funciona

1.  **Despliegue**: Al desplegar el contrato, la dirección que lo despliega se establece como el `owner`.
2.  **Depósito de Ether**: Cualquier persona puede enviar Ether directamente a la dirección del contrato. El Ether se almacenará en el balance del contrato.
3.  **Retiro de Ether**: El `owner` puede llamar a la función `withdraw()` para enviar una cantidad específica de Ether desde el contrato a su propia dirección. Si una dirección que no es el `owner` intenta llamar a esta función, la transacción fallará.
4.  **Cambio de Propiedad**: El `owner` actual puede transferir la propiedad del contrato a una nueva dirección llamando a `changeOwner()`.

## Uso (Ejemplo Educativo)

Este contrato es un excelente punto de partida para entender cómo se pueden construir contratos que gestionen fondos y cómo implementar patrones de seguridad básicos como el control de acceso basado en la propiedad.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Envía Ether a la dirección del contrato.
*   Llama a `withdraw()` desde la dirección del propietario para retirar fondos.
*   Intenta llamar a `withdraw()` desde una dirección que no sea la del propietario para observar el mensaje de error.
*   Llama a `changeOwner()` para transferir la propiedad a otra dirección.

Este contrato es una base sólida para explorar conceptos más avanzados de gestión de fondos y seguridad en Solidity.
