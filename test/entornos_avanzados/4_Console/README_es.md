# Pruebas de Consola (ConsoleTest.t.sol)

Este contrato de Solidity (`ConsoleTest.t.sol`) es un ejemplo simple que demuestra cómo utilizar las funciones de `console.log` de Foundry para depurar y registrar información durante la ejecución de las pruebas. Es una herramienta invaluable para los desarrolladores de Solidity, ya que permite inspeccionar el estado y el flujo de ejecución de los contratos de manera similar a como se usaría `console.log` en JavaScript.

## Características Principales

*   **Depuración con `console.log`**: Muestra cómo imprimir mensajes y valores de variables directamente en la consola durante la ejecución de las pruebas.
*   **`console.logInt`**: Una variante específica para imprimir números enteros.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.13;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry, que incluye las funcionalidades de `console.log`.
*   **`contract ConsoleTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`console.log(...)`**: Una función de "cheat code" de Foundry que permite imprimir información en la consola. Es solo para pruebas y desarrollo; no está disponible en contratos desplegados en la red principal.
*   **`console.logInt(int value)`**: Una función auxiliar para imprimir valores enteros.
*   **`public pure`**: Modificadores de visibilidad y estado para la función de prueba.
    *   **`public`**: La función puede ser llamada desde cualquier lugar.
    *   **`pure`**: La función no lee ni modifica el estado de la blockchain.

## Cómo Funciona

La función `testLog()` simplemente declara una variable entera `x` y luego utiliza `console.log()` y `console.logInt()` para imprimir su valor junto con un mensaje de texto. Cuando ejecutas las pruebas con Foundry, verás estas salidas en tu terminal, lo que te ayuda a entender qué está sucediendo dentro de tu contrato durante la ejecución de la prueba.

## Uso (Depuración de Pruebas)

Para ejecutar esta prueba y ver la salida de `console.log`, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/4_Console/ConsoleTest.t.sol -vvvvv
```

El flag `-vvvv` (o `-v` con más `v`s) aumenta la verbosidad de la salida de Foundry, lo que es necesario para ver los mensajes de `console.log`.

Este contrato es un recurso valioso para aprender técnicas de depuración en el desarrollo de contratos inteligentes con Foundry, lo que es esencial para identificar y resolver problemas en tu código.
