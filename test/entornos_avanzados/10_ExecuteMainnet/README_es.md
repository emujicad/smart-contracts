# Pruebas de Forking de Mainnet (Fork.t.sol)

Este contrato de Solidity (`Fork.t.sol`) demuestra un enfoque fundamental para probar contratos inteligentes haciendo un "fork" de la mainnet de Ethereum. El forking de mainnet te permite simular transacciones e interactuar con contratos desplegados como si estuvieras en la red en vivo, pero en un entorno local y controlado. Esta prueba muestra específicamente cómo interactuar con el contrato oficial de WETH en la mainnet para probar una función de depósito.

## Características Principales

*   **Forking de Mainnet**: La prueba está diseñada para ejecutarse en un fork de la mainnet de Ethereum, especificado a través de un parámetro en la línea de comandos.
*   **Interacción con Contratos Desplegados**: La prueba muestra cómo interactuar con un contrato real en mainnet (WETH) utilizando su dirección e interfaz.
*   **Verificación de Balance y Estado**: Verifica que un cambio de estado (un depósito de WETH) ocurra correctamente al comprobar el balance de WETH del contrato antes y después de la transacción.

## Conceptos de Solidity y Foundry para Aprender

*   **`import {Test, console} from "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry y las utilidades de `console.log`.
*   **`interface IWETH { ... }`**: Define una interfaz mínima para el contrato WETH, que contiene solo las funciones necesarias para la prueba (`balanceOf` y `deposit`). Esto permite que el contrato de prueba llame a estas funciones en el contrato WETH real.
*   **`setUp()`**: Una función especial en las pruebas de Foundry que se ejecuta antes de cada función de prueba. Aquí, se usa para inicializar la variable `weth` con una interfaz que apunta a la dirección oficial del contrato WETH en la mainnet.
*   **`address(this)`**: La dirección del contrato de prueba actual.
*   **`weth.deposit{value: 500}()`**: Llama a la función `deposit` en el contrato WETH y envía 500 wei junto con la llamada. La sintaxis `{value: 500}` es la forma de enviar Ether al llamar a una función `payable`.
*   **`console.log(...)`**: Una utilidad de `forge-std` que se usa para imprimir información en la consola durante la ejecución de la prueba, lo cual es útil para la depuración.

## Cómo Funciona la Prueba

1.  **`setUp()`**: Antes de que se ejecute la prueba, esta función inicializa la variable `weth`, convirtiéndola en una instancia utilizable del contrato WETH en su dirección de mainnet `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`.
2.  **`testDeposit()`**:
    *   Primero, registra el balance inicial de WETH del propio contrato de prueba.
    *   Luego, ejecuta una transacción de `deposit`, enviando 500 wei al contrato WETH para ser convertidos en WETH.
    *   Finalmente, obtiene el balance final de WETH y muestra en la consola tanto el balance inicial como el final, permitiéndote observar el resultado del depósito.

## Uso (Ejecución de la Prueba)

Para ejecutar esta prueba, necesitas tener Foundry instalado y una URL de RPC para la mainnet de Ethereum (por ejemplo, de Alchemy o Infura). La prueba se ejecuta usando el comando `forge test` con el flag `--fork-url`.

```bash
forge test --fork-url <TU_URL_RPC> --match-path test/10_ExecuteMainnet/Fork.t.sol -vvv
```

Reemplaza `<TU_URL_RPC>` con tu URL de RPC real. Por ejemplo:
```bash
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P --match-path test/10_ExecuteMainnet/Fork.t.sol -vvv
```

Este contrato de prueba es un excelente y práctico ejemplo de cómo interactuar con protocolos existentes en la mainnet de Ethereum en un entorno de prueba, una habilidad crucial para cualquier desarrollador de Web3.