# Pruebas del Contrato SendEther (SendEther.t.sol)

Este contrato de Solidity (`SendEther.t.sol`) contiene las pruebas unitarias para el contrato `SendEther.sol`, que gestiona el envío y la recepción de Ether. Utiliza el framework de pruebas Foundry y sus "cheat codes" para simular transacciones de Ether, manipular saldos de cuentas y verificar el comportamiento del contrato en diferentes escenarios.

## Características Principales

*   **Configuración de Pruebas (`setUp`)**: Despliega una nueva instancia del contrato `SendEther` antes de cada prueba.
*   **Envío de Ether**: Demuestra cómo enviar Ether al contrato `SendEther` utilizando llamadas de bajo nivel (`call`).
*   **Verificación de Saldos**: Comprueba que los saldos de Ether se actualicen correctamente después de las transacciones.
*   **Manipulación de Cuentas de Prueba**: Usa `deal()` para asignar Ether a direcciones de prueba y `vm.prank()`/`hoax()` para simular transacciones desde esas direcciones.
*   **Depuración con `console.log`**: Muestra cómo usar `console.log` para inspeccionar saldos y estados durante las pruebas.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry.
*   **`import "../../src/9_SendEther/SendEther.sol";`**: Importa el contrato `SendEther` que se va a probar.
*   **`contract SendEtherTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada prueba para configurar el entorno.
*   **`address(contractInstance).call{value: amount}("");`**: Una forma de bajo nivel para interactuar con contratos, especialmente útil para enviar Ether. `value: amount` especifica la cantidad de Ether.
*   **`address(this).balance`**: Variable global que devuelve el saldo de Ether del contrato actual.
*   **`assertEq(expected, actual, "mensaje de error");`**: Función de aserción para verificar que dos valores son iguales.
*   **`deal(address account, uint256 amount);`**: Cheat code de Foundry para establecer el saldo de Ether de una dirección.
*   **`vm.prank(address account);`**: Cheat code de Foundry para simular que la siguiente llamada a función proviene de la `account` especificada.
*   **`hoax(address account, uint256 amount);`**: Cheat code de Foundry que combina `deal()` y `vm.prank()`, estableciendo el saldo y `msg.sender` para la siguiente llamada.
*   **`console.log(...)`**: Función de depuración de Foundry para imprimir información en la consola.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `SendEther`.
2.  **`_send(uint256 _amount)`**: Una función auxiliar privada que encapsula la lógica para enviar Ether al contrato `SendEther`, incluyendo comprobaciones de saldo y éxito de la transacción.
3.  **`testEtherBalance()`**: Simplemente imprime los saldos del contrato de prueba y del contrato `SendEther` para fines de depuración.
4.  **`testSendEther()`**: Envía 1 Ether desde el contrato de prueba al contrato `SendEther` y verifica que los saldos de ambos contratos se actualicen correctamente.
5.  **`testSendEther2()`**: Demuestra el uso de `deal()` y `hoax()` para simular transferencias de Ether desde direcciones externas (no el contrato de prueba) al contrato `SendEther`, verificando que los fondos se reciban correctamente.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/9_SendEther/SendEther.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de manejo de Ether de tu contrato `SendEther`.

Este contrato de prueba es un recurso esencial para aprender a probar las interacciones de Ether en Solidity, una habilidad fundamental para cualquier desarrollador de Web3.
