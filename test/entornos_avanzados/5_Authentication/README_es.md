# Pruebas del Contrato de Billetera (Wallet.t.sol)

Este contrato de Solidity (`Wallet.t.sol`) contiene las pruebas unitarias para el contrato `Wallet.sol`. Utiliza el framework de pruebas Foundry para verificar la funcionalidad de cambio de propietario y el control de acceso del contrato de billetera. Es un ejemplo clave para entender cómo probar la seguridad y los permisos en contratos inteligentes.

## Características Principales

*   **Configuración de Pruebas (`setUp`)**: Despliega una nueva instancia del contrato `Wallet` antes de cada prueba.
*   **Prueba de Cambio de Propietario**: Verifica que la función `changeOwner()` actualice correctamente la dirección del propietario.
*   **Prueba de Fallo por No Propietario**: Comprueba que la función `changeOwner()` revierta cuando es llamada por una dirección que no es el propietario actual.
*   **Simulación de `msg.sender`**: Utiliza `vm.prank()` para simular llamadas desde diferentes direcciones.
*   **Depuración con `console.log`**: Muestra cómo usar `console.log` para inspeccionar `msg.sender` y el propietario del contrato durante las pruebas.

## Conceptos de Solidity y Foundry para Aprender

*   **`pragma solidity ^0.8.24;`**: Define la versión del compilador de Solidity.
*   **`import "forge-std/Test.sol";`**: Importa la biblioteca de pruebas estándar de Foundry.
*   **`import "../../src/5_Authentication/Wallet.sol";`**: Importa el contrato `Wallet` que se va a probar.
*   **`contract WalletTest is Test { ... }`**: Declaración del contrato de prueba, que hereda de `Test`.
*   **`setUp()`**: Función especial que se ejecuta antes de cada prueba para configurar el entorno.
*   **`vm.prank(address account);`**: Cheat code de Foundry para simular que la siguiente llamada a función proviene de la `account` especificada. Es fundamental para probar el control de acceso.
*   **`vm.expectRevert("mensaje de error");`**: Cheat code para esperar que la siguiente llamada a función revierta con un mensaje de error específico.
*   **`assertEq(expected, actual, "mensaje de error");`**: Función de aserción para verificar que dos valores son iguales.
*   **`msg.sender`**: Variable global que representa la dirección que inició la transacción actual.
*   **`console.log(...)`**: Función de depuración de Foundry para imprimir información en la consola.

## Cómo Funcionan las Pruebas

1.  **`setUp()`**: Despliega una nueva instancia del contrato `Wallet`. El `msg.sender` que despliega el contrato de prueba (`WalletTest`) se convierte en el propietario inicial del contrato `Wallet`.
2.  **`test_changeOwner()`**:
    *   Define una `newOwner` (nueva dirección de propietario).
    *   Llama a `wallet.changeOwner(newOwner)` desde el `WalletTest` (que es el propietario inicial).
    *   Verifica con `assertEq` que el propietario del contrato `Wallet` se haya actualizado correctamente a `newOwner`.
3.  **`test_failNotOwner()`**:
    *   Utiliza `vm.prank(address(0x00000124))` para simular que la siguiente llamada proviene de una dirección diferente al propietario.
    *   Utiliza `vm.expectRevert("Error: Only owner can change owner")` para esperar que la llamada a `changeOwner()` falle con el mensaje de error específico.
    *   Llama a `wallet.changeOwner()` desde la dirección "no propietaria" simulada, confirmando que la restricción de acceso funciona.

## Uso (Ejecución de Pruebas)

Para ejecutar estas pruebas, necesitarás tener Foundry instalado. Navega al directorio raíz de tu proyecto y ejecuta:

```bash
forge test --match-path test/5_Authentication/Wallet.t.sol -vvvvv
```

Foundry compilará los contratos y ejecutará todas las funciones de prueba. Los resultados te indicarán si las pruebas pasaron o fallaron, lo que te ayudará a verificar la lógica de control de acceso de tu contrato `Wallet`.

Este contrato de prueba es un recurso esencial para aprender a probar la seguridad y los permisos en Solidity, habilidades críticas para construir contratos inteligentes robustos y confiables.
