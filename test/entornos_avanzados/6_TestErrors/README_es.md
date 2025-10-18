# Pruebas de Manejo de Errores (Errors.t.sol)

Este contrato de Solidity (`Errors.t.sol`) contiene las pruebas unitarias para el contrato `CErrors.sol`, que demuestra diferentes mecanismos de manejo de errores en Solidity. Utiliza el framework de pruebas Foundry para verificar que las funciones reviertan correctamente con los mensajes o errores esperados.

## Características Principales

*   **Prueba de Reversión General**: Verifica que una función revierta sin especificar el mensaje.
*   **Prueba de Reversión con Mensaje de Cadena**: Comprueba que una función revierta con un mensaje de error de cadena específico.
*   **Prueba de Reversión con Error Personalizado**: Valida que una función revierta con un error personalizado definido en el contrato.
*   **Mensajes de Error Personalizados en `assertEq`**: Demuestra cómo añadir mensajes descriptivos a las aserciones para una mejor depuración.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry.
*   **`import "../../src/6_TestErrors/Errors.sol";`**: Importa el contrato `CErrors` que se va a probar.
*   **`contract ErrorTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada prueba para configurar el entorno, en este caso, desplegando una nueva instancia de `CErrors`.
*   **`vm.expectRevert();`**: Cheat code de Foundry que espera que la siguiente llamada a función revierta, sin importar el mensaje o tipo de error.
*   **`vm.expectRevert(bytes("mensaje"));`**: Cheat code para esperar una reversión con un mensaje de cadena exacto. El mensaje debe convertirse a `bytes`.
*   **`vm.expectRevert(CustomError.selector);`**: Cheat code para esperar una reversión con un error personalizado específico. `.selector` obtiene el identificador único de 4 bytes del error.
*   **`assertEq(expected, actual, "mensaje");`**: Función de aserción que verifica la igualdad de dos valores y muestra un mensaje personalizado si la aserción falla.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `CErrors`.
2.  **`test_withoutRevert_ThrowError()`**: Esta prueba está diseñada para fallar si se ejecuta sin `vm.expectRevert()`, demostrando que las transacciones que revierten sin ser esperadas causan fallos en las pruebas.
3.  **`testRevert_ThrowError()`**: Llama a `throwError()` y verifica que revierta, utilizando `vm.expectRevert()` sin un mensaje específico.
4.  **`testRevert_RequireMessageThrowError()`**: Llama a `throwError()` y verifica que revierta con el mensaje de cadena "UnAuthorized...!" exacto.
5.  **`testRevert_ThrowCustomError()`**: Llama a `throwCustomError()` y verifica que revierta con el error personalizado `UnAuthorized`.
6.  **`testErrorLabel()`**: Demuestra cómo los mensajes personalizados en `assertEq` pueden ayudar a depurar pruebas fallidas, mostrando un ejemplo de aserción que pasa y otra que falla con un mensaje claro.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/6_TestErrors/Errors.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de manejo de errores de tu contrato `CErrors`.

Este contrato de prueba es un recurso valioso para aprender a probar el manejo de errores en Solidity, una parte crítica para construir contratos inteligentes seguros y confiables.
