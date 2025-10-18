# Contrato Contador Simple (Counter.sol)

Este contrato de Solidity (`Counter.sol`) es un ejemplo fundamental utilizado para introducir los conceptos más básicos de los contratos inteligentes en la blockchain. Es ideal para principiantes que están aprendiendo sobre variables de estado y funciones que modifican el estado.

## Características Principales

*   **Variable de Estado `number`**: Almacena un número entero que puede ser incrementado, decrementado o establecido a un valor específico.
*   **`setNumber(uint256 newNumber)`**: Permite establecer el valor de `number` a cualquier valor deseado.
*   **`increment()`**: Aumenta el valor de `number` en uno.
*   **`decrement()`**: Disminuye el valor de `number` en uno.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`contract Counter { ... }`**: La estructura básica de un contrato inteligente.
*   **`uint256 public number;`**: Declaración de una variable de estado pública.
    *   **`uint256`**: Tipo de dato para enteros sin signo de 256 bits, adecuado para números grandes.
    *   **`public`**: Hace que la variable sea accesible para lectura desde fuera del contrato.
    *   **Variables de Estado**: Datos que se almacenan permanentemente en la blockchain.
*   **`function name() public { ... }`**: Declaración de funciones.
    *   **`public`**: La función puede ser llamada desde cualquier lugar (por usuarios externos o por otros contratos).
    *   **Funciones que Modifican el Estado**: Las funciones como `setNumber`, `increment` y `decrement` cambian el valor de las variables de estado del contrato. Cada vez que se llaman, se crea una transacción en la blockchain y se incurre en un costo de gas.

## Cómo Funciona

1.  **Despliegue del Contrato:** Cuando el contrato `Counter` se despliega en la blockchain, la variable `number` se inicializa con su valor por defecto (0 para `uint256`).
2.  **Leer el Valor:** Puedes leer el valor actual de `number` directamente, ya que es una variable `public`.
3.  **Establecer el Número:** Llama a `setNumber(X)` para cambiar el valor de `number` a `X`.
4.  **Incrementar/Decrementar:** Llama a `increment()` para sumar 1 a `number`, o `decrement()` para restar 1.

## Uso (Ejemplo Básico)

Este contrato es un "Hola Mundo" para la modificación de estado en Solidity. Es útil para:

*   Entender cómo las variables de estado se almacenan en la blockchain.
*   Comprender cómo las funciones pueden modificar estas variables.
*   Familiarizarse con el concepto de "gas" (costo de transacción) al modificar el estado.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Llama a `setNumber(5)` para establecer el contador en 5.
*   Llama a `increment()` varias veces y observa cómo `number` aumenta.
*   Llama a `decrement()` y observa cómo `number` disminuye.
*   Siempre puedes leer el valor actual de `number` para verificar los cambios.

Este contrato es un excelente primer paso para entender la interactividad y la persistencia de datos en la blockchain.
