# Contrato "Hola Mundo" (helloworld.sol)

Este contrato de Solidity (`helloworld.sol`) es el equivalente al programa "Hola Mundo" en el desarrollo de contratos inteligentes. Es un punto de partida excelente para cualquier persona que se inicie en Web3 y Solidity, ya que introduce los conceptos más básicos de un contrato inteligente: variables de estado, constructores y funciones simples.

## Características Principales

*   **Mensaje Almacenado**: Almacena una cadena de texto (`string`) en la blockchain.
*   **Constructor**: Inicializa el mensaje cuando el contrato se despliega.
*   **`getMessage()`**: Permite leer el mensaje almacenado.
*   **`updateMessage()`**: Permite cambiar el mensaje almacenado.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`contract helloworld { ... }`**: La estructura básica de un contrato inteligente.
*   **`string private message;`**: Declaración de una variable de estado.
    *   **`string`**: Tipo de dato para almacenar texto.
    *   **`private`**: Modificador de visibilidad que significa que la variable solo es accesible desde dentro del contrato.
    *   **Variables de Estado**: Datos que se almacenan permanentemente en la blockchain.
*   **`constructor() { ... }`**: Función especial que se ejecuta una sola vez cuando el contrato se despliega. Se utiliza para la inicialización.
*   **`function getMessage() public view returns (string memory) { ... }`**: Declaración de una función para leer datos.
    *   **`public`**: La función puede ser llamada desde cualquier lugar.
    *   **`view`**: La función no modifica el estado del contrato (solo lee datos). Las llamadas a funciones `view` no cuestan gas.
    *   **`returns (string memory)`**: Especifica que la función devuelve una cadena de texto. `memory` es una ubicación de datos temporal.
*   **`function updateMessage(string memory _newMessage) public { ... }`**: Declaración de una función para modificar datos.
    *   **`public`**: La función puede ser llamada desde cualquier lugar.
    *   **Funciones que Modifican el Estado**: Las funciones que cambian el estado del contrato (como `updateMessage`) requieren una transacción en la blockchain y, por lo tanto, cuestan gas.

## Cómo Funciona

1.  **Despliegue**: Cuando el contrato `helloworld` se despliega en la blockchain, el `constructor` se ejecuta y establece el `message` inicial a "Hello, World from foundry!".
2.  **Lectura del Mensaje**: Cualquier persona puede llamar a la función `getMessage()` para leer el mensaje actual almacenado en el contrato. Esta operación es gratuita (no cuesta gas) porque no modifica el estado de la blockchain.
3.  **Actualización del Mensaje**: Cualquier persona puede llamar a la función `updateMessage()` y pasarle una nueva cadena de texto. Esta acción modificará el estado del contrato en la blockchain y requerirá una transacción, lo que incurrirá en un costo de gas.

## Uso (Ejemplo Introductorio)

Este contrato es perfecto para:

*   Familiarizarse con el ciclo de vida de un contrato inteligente (despliegue, lectura, escritura).
*   Entender la diferencia entre funciones `view` (lectura) y funciones que modifican el estado (escritura).
*   Ver cómo los datos persisten en la blockchain.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Llama a `getMessage()` para ver el mensaje inicial.
*   Llama a `updateMessage("¡Hola Blockchain!")` para cambiar el mensaje.
*   Vuelve a llamar a `getMessage()` para confirmar que el mensaje ha cambiado.

Este contrato es el primer paso para construir aplicaciones descentralizadas y comprender cómo interactúan los contratos inteligentes con la blockchain.
