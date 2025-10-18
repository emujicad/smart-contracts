# Contrato de Subasta Simple (CAuction.sol)

Este contrato de Solidity (`CAuction.sol`) es un ejemplo básico de cómo se podría estructurar una subasta simple en la blockchain. Está diseñado para ayudar a los principiantes a entender conceptos fundamentales de Solidity y la lógica de contratos inteligentes.

## Características Principales

*   **Control de Tiempo:** El contrato define un período de inicio y fin para la subasta, asegurando que las acciones solo puedan ocurrir dentro de este marco de tiempo.
*   **Función `offer()`:** Permite a los participantes intentar realizar una oferta, pero solo si la subasta está activa.
*   **Función `finishAuction()`:** Una función para finalizar la subasta, que solo puede ser llamada una vez que el período de la subasta ha terminado.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`contract CAuction { ... }`**: La estructura básica de un contrato inteligente.
*   **`uint256 public variable;`**: Declaración de variables de estado públicas. `uint256` es un tipo de entero sin signo de 256 bits.
*   **`block.timestamp`**: Una variable global que representa la marca de tiempo del bloque actual. Útil para la lógica basada en el tiempo.
*   **`1 days`, `2 days`**: Unidades de tiempo convenientes en Solidity.
*   **`function name() external view { ... }`**: Declaración de funciones.
    *   **`external`**: La función solo puede ser llamada desde fuera del contrato.
    *   **`view`**: La función no modifica el estado del contrato (solo lee datos).
*   **`require(condition, "mensaje de error");`**: Se utiliza para validar condiciones. Si la condición es falsa, la transacción se revierte y se devuelve el mensaje de error.

## Cómo Funciona

1.  **Despliegue del Contrato:** Cuando el contrato `CAuction` se despliega en la blockchain, las variables `startAuction` y `endAuction` se inicializan automáticamente basándose en la marca de tiempo del bloque de despliegue.
2.  **Realizar una Oferta:** Los usuarios pueden llamar a la función `offer()`. El contrato verificará si la marca de tiempo actual está entre `startAuction` y `endAuction`. Si no lo está, la transacción fallará con el mensaje "You cannot offer now".
3.  **Finalizar la Subasta:** Una vez que `block.timestamp` es mayor que `endAuction`, cualquiera puede llamar a `finishAuction()`. En un contrato real, esta función contendría la lógica para determinar el ganador y transferir los activos.

## Uso (Ejemplo Simplificado)

Este contrato es puramente demostrativo y no maneja la lógica de ofertas reales, el seguimiento de la oferta más alta, los participantes o la transferencia de activos. Su propósito es ilustrar el uso de `block.timestamp` y `require` para controlar el flujo de un contrato basado en el tiempo.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Puedes leer los valores de `startAuction` y `endAuction` directamente.
*   Intenta llamar a `offer()` antes, durante y después del período de la subasta para observar el comportamiento de `require`.
*   Intenta llamar a `finishAuction()` antes y después de que la subasta haya terminado.

Este contrato es un excelente punto de partida para entender cómo los contratos inteligentes pueden interactuar con el tiempo y controlar el acceso a funciones.
