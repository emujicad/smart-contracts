# Pruebas del Contrato de Subasta (Auction.t.sol)

Este contrato de Solidity (`Auction.t.sol`) contiene las pruebas unitarias para el contrato `CAuction.sol`. Utiliza el framework de pruebas Foundry, que es popular en el ecosistema de Solidity por su velocidad y sus "cheat codes" (códigos de trampa) que facilitan la manipulación del entorno de la blockchain durante las pruebas.

## Características Principales

*   **Configuración de Pruebas (`setUp`)**: Inicializa una nueva instancia del contrato `CAuction` antes de cada prueba, asegurando un entorno de prueba limpio.
*   **Pruebas Basadas en el Tiempo**: Utiliza `vm.warp()` para simular el paso del tiempo y probar el comportamiento de la subasta en diferentes fases (antes de iniciar, durante y después de finalizar).
*   **Manejo de Reversiones**: Emplea `vm.expectRevert()` para verificar que las funciones reviertan con el mensaje de error esperado bajo ciertas condiciones.
*   **Manipulación de `block.timestamp` y `block.number`**: Demuestra cómo los "cheat codes" de Foundry (`skip`, `rewind`, `vm.roll`) permiten controlar el tiempo y el número de bloque para pruebas precisas.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry.
*   **`import "../../src/8_TestTime/Auction.sol";`**: Importa el contrato que se va a probar.
*   **`contract AuctionTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada prueba. Ideal para inicializar el estado.
*   **`vm.warp(timestamp)`**: Cheat code para establecer la marca de tiempo del bloque actual.
*   **`vm.expectRevert("mensaje");`**: Cheat code para esperar que la siguiente llamada a función revierta con un mensaje específico.
*   **`assertEq(expected, actual);`**: Función de aserción para verificar que dos valores son iguales.
*   **`skip(seconds)`**: Cheat code para avanzar la marca de tiempo del bloque por un número de segundos.
*   **`rewind(seconds)`**: Cheat code para retroceder la marca de tiempo del bloque por un número de segundos.
*   **`vm.roll(blockNumber)`**: Cheat code para establecer el número de bloque actual.
*   **`block.timestamp`**: Variable global que representa la marca de tiempo del bloque actual.
*   **`block.number`**: Variable global que representa el número de bloque actual.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Antes de cada prueba, se crea una nueva instancia del contrato `CAuction`.
2.  **`testOfferBeforeAuctionStarts()`**: La prueba manipula el tiempo para que sea antes del inicio de la subasta y verifica que la función `offer()` revierta con el mensaje de error correcto.
3.  **`testOffer()`**: La prueba avanza el tiempo para que sea durante la subasta y verifica que la función `offer()` se ejecute sin revertir.
4.  **`testOfferfailAfterAuctionEnds()`**: La prueba avanza el tiempo para que sea después de que la subasta haya terminado y verifica que la función `offer()` revierta con el mensaje de error correcto.
5.  **`testTimestamp()`**: Demuestra cómo `skip` y `rewind` afectan `block.timestamp` y cómo se pueden verificar con `assertEq`.
6.  **`testBlockNumber()`**: Demuestra cómo `vm.roll` afecta `block.number` y cómo se puede verificar.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/8_TestTime/Auction.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba (aquellas que comienzan con `test`). Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de tu contrato `CAuction`.

Este contrato de prueba es un excelente recurso para aprender a escribir pruebas robustas y eficientes para contratos inteligentes utilizando Foundry, una habilidad esencial para cualquier desarrollador de Web3.
