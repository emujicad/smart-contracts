# Pruebas del Contrato Contador (Counter.t.sol)

Este contrato de Solidity (`Counter.t.sol`) contiene las pruebas unitarias para el contrato `Counter.sol`. Utiliza el framework de pruebas Foundry, que es una herramienta poderosa para escribir pruebas eficientes y robustas para contratos inteligentes. Este archivo demuestra cómo probar funciones básicas, el manejo de errores y el uso de "fuzz testing".

## Características Principales

*   **Configuración de Pruebas (`setUp`)**: Inicializa una nueva instancia del contrato `Counter` antes de cada prueba, asegurando un estado limpio.
*   **Prueba de Incremento**: Verifica que la función `increment()` aumente correctamente el valor del contador.
*   **Prueba de Decremento con Reversión**: Demuestra cómo probar que una función revierta con un error específico (en este caso, un error aritmético por underflow).
*   **Fuzz Testing (`testFuzz_SetNumber`)**: Utiliza el fuzzing para probar la función `setNumber()` con una amplia gama de entradas aleatorias, lo que ayuda a descubrir errores inesperados.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`import {Test, console, stdError} from "forge-std/Test.sol";`**: Importa componentes específicos de la biblioteca de pruebas estándar de Foundry.
    *   **`Test`**: El contrato base para escribir pruebas.
    *   **`console`**: Para depuración (ej. `console.log`).
    *   **`stdError`**: Contiene errores estándar de Solidity (ej. `stdError.arithmeticError`).
*   **`import {Counter} from "../../src/3_Formatter/Counter.sol";`**: Importa el contrato `Counter` que se va a probar.
*   **`contract CounterTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada función de prueba para configurar el entorno.
*   **`assertEq(expected, actual, "mensaje de error");`**: Función de aserción para verificar que dos valores son iguales. Si no lo son, la prueba falla y se muestra el mensaje de error opcional.
*   **`vm.expectRevert(errorType);`**: Cheat code de Foundry que espera que la siguiente llamada a función revierta con el tipo de error especificado.
*   **Fuzz Testing (`testFuzz_FunctionName(type param)`)**: Una técnica de prueba donde la función se ejecuta con entradas aleatorias generadas por el fuzzer de Foundry. Las funciones de fuzzing deben comenzar con `testFuzz_`.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `Counter` y establece su número inicial en 0.
2.  **`test_Increment()`**: Llama a `increment()` y verifica que el número se haya convertido en 1.
3.  **`test_Decrement()`**: Llama a `decrement()` cuando el número es 0. Dado que Solidity 0.8.0+ revierte automáticamente en caso de underflow, se espera que la transacción revierta con un `stdError.arithmeticError`.
4.  **`testFuzz_SetNumber(uint256 x)`**: Foundry ejecuta esta prueba con muchos valores diferentes para `x`. Para cada `x`, se llama a `setNumber(x)` y se verifica que el valor del contador sea exactamente `x`. Esto asegura que `setNumber` funciona correctamente para un amplio rango de entradas.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/3_Formatter/Counter.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de tu contrato `Counter`.

Este contrato de prueba es un recurso excelente para aprender a escribir pruebas unitarias y de fuzzing para contratos inteligentes, habilidades cruciales para garantizar la seguridad y corrección de tu código en la blockchain.
