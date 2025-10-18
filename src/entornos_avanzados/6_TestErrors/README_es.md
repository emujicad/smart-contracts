# Contrato de Manejo de Errores (CErrors.sol)

Este contrato de Solidity (`CErrors.sol`) está diseñado para ilustrar diferentes formas de manejar errores y revertir transacciones en la blockchain. Es crucial para los desarrolladores de Web3 entender cómo y cuándo usar los mecanismos de error para asegurar la robustez y seguridad de sus contratos.

## Características Principales

*   **Error Personalizado `UnAuthorized()`**: Demuestra la definición y uso de errores personalizados, una característica más eficiente en gas.
*   **Función `throwError()`**: Muestra el uso tradicional de `require()` con un mensaje de cadena para revertir una transacción.
*   **Función `throwCustomError()`**: Ilustra cómo usar la declaración `revert` con un error personalizado.

## Conceptos de Solidity para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`contract CErrors { ... }`**: La estructura básica de un contrato inteligente.
*   **`error MyCustomError();`**: Declaración de un error personalizado. Los errores personalizados son más eficientes en gas que los mensajes de cadena de `require` o `revert`.
*   **`require(condition, "mensaje de error");`**: Una función incorporada que se utiliza para validar condiciones. Si la `condition` es falsa, la ejecución se detiene, todos los cambios de estado se revierten y se devuelve el `mensaje de error`.
*   **`revert MyCustomError();`**: Una declaración que detiene la ejecución y revierte todos los cambios de estado. Se puede usar con o sin un error personalizado. Cuando se usa con un error personalizado, proporciona información estructurada sobre el error.
*   **`external`**: Modificador de visibilidad que significa que la función solo puede ser llamada desde fuera del contrato.
*   **`public`**: Modificador de visibilidad que significa que la función puede ser llamada desde cualquier lugar (externamente o internamente).
*   **`pure`**: Modificador de estado que significa que la función no lee ni modifica el estado de la blockchain.

## Cómo Funciona

1.  **`throwError()`**: Cuando se llama a esta función, la condición `false` en `require(false, "UnAuthorized...!")` siempre será falsa. Esto hará que la transacción se revierta, y el mensaje "UnAuthorized...!" se devolverá como parte de la información de la transacción fallida.
2.  **`throwCustomError()`**: Cuando se llama a esta función, la declaración `revert UnAuthorized();` detendrá inmediatamente la ejecución y revertirá la transacción. En lugar de un mensaje de cadena, el error personalizado `UnAuthorized` se emitirá, lo que puede ser capturado y manejado por las aplicaciones cliente de manera más eficiente.

## Uso (Ejemplo Educativo)

Este contrato es una herramienta educativa para entender las diferencias entre `require` con mensajes de cadena y `revert` con errores personalizados.

Para interactuar con este contrato (después de desplegarlo en una red de prueba o entorno de desarrollo):

*   Llama a `throwError()` y observa cómo la transacción falla con el mensaje de cadena.
*   Llama a `throwCustomError()` y observa cómo la transacción falla con el error personalizado.

Comprender el manejo de errores es fundamental para construir contratos inteligentes seguros y robustos. Los errores personalizados son la forma recomendada de manejar errores en las versiones modernas de Solidity debido a su eficiencia y claridad.
