# Pruebas de Eventos (Events.t.sol)

Este contrato de Solidity (`Events.t.sol`) contiene las pruebas unitarias para el contrato `CEvents.sol`, que demuestra cómo emitir y verificar eventos en la blockchain. Utiliza el framework de pruebas Foundry, que proporciona herramientas poderosas como `vm.expectEmit()` para asegurar que los eventos se emiten correctamente con los datos esperados.

## Características Principales

*   **Verificación de Emisión de Eventos**: Demuestra cómo usar `vm.expectEmit()` para probar que un evento específico ha sido emitido.
*   **Prueba de Evento Único**: Verifica la emisión de un solo evento con `transferOnce()`.
*   **Prueba de Múltiples Eventos**: Comprueba la emisión de varios eventos dentro de un bucle con `transferMany()`.
*   **Coincidencia de Parámetros Indexados y No Indexados**: Muestra cómo `vm.expectEmit()` puede configurarse para verificar selectivamente los parámetros indexados (topics) y los datos no indexados de un evento.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry.
*   **`import "../../src/7_TestEvents/Events.sol";`**: Importa el contrato `CEvents` que se va a probar.
*   **`contract EventsTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`event Transfer(address indexed from, address indexed to, uint256 amount);`**: Re-declaración del evento `Transfer` en el contrato de prueba. Esto es crucial para que `vm.expectEmit()` pueda hacer coincidir el evento.
*   **`setUp()`**: Función especial que se ejecuta antes de cada prueba para configurar el entorno, en este caso, desplegando una nueva instancia de `CEvents`.
*   **`vm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData);`**: Cheat code de Foundry para esperar la emisión de un evento.
    *   Los primeros tres booleanos (`checkTopic1`, `checkTopic2`, `checkTopic3`) indican si se deben verificar los parámetros `indexed` del evento.
    *   `checkData` indica si se deben verificar los parámetros no indexados.
*   **`emit EventName(param1, param2, ...);`**: En el contexto de `vm.expectEmit()`, esta línea "pre-emite" el evento esperado. Foundry lo captura y lo compara con el evento real emitido por la función que se está probando.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `CEvents`.
2.  **`testEmitTransferOnce()`**:
    *   Configura `vm.expectEmit()` para esperar un evento `Transfer` que coincida con los parámetros `from`, `to` (indexados) y `amount` (no indexado).
    *   Llama a `cevents.transferOnce()`, que debería emitir el evento esperado.
    *   Se repite el proceso con diferentes parámetros para demostrar la flexibilidad.
3.  **`testEmitTransferMany()`**:
    *   Prepara arrays de direcciones y cantidades.
    *   Dentro de un bucle, configura `vm.expectEmit()` para cada evento `Transfer` individual que se espera que `transferMany()` emita.
    *   Llama a `cevents.transferMany()`, y Foundry verifica que todos los eventos esperados se emitan en el orden correcto.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/7_TestEvents/Events.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de emisión de eventos de tu contrato `CEvents`.

Este contrato de prueba es un recurso esencial para aprender a probar la emisión de eventos en Solidity, una habilidad crucial para construir aplicaciones descentralizadas que interactúen eficazmente con la blockchain.
