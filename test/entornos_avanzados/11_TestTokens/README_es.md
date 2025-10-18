# Probando con un Fork de un Contrato de Mainnet

Esta sección explica cómo probar contratos inteligentes interactuando con contratos que ya están desplegados en la mainnet de Ethereum. Esta es una técnica poderosa conocida como "forking", que te permite simular transacciones y probar funcionalidades en un entorno realista sin gastar gas real.

## Conceptos Clave

### Forking

El forking es el proceso de crear una copia local de una blockchain (como la mainnet de Ethereum) en un número de bloque específico. Esto te permite interactuar con los contratos desplegados como si estuvieras en la mainnet, pero en un entorno local y controlado. Foundry facilita esto simplemente proporcionando un punto de conexión RPC de mainnet.

### Interactuando con un Contrato Desplegado

Para interactuar con un contrato desplegado, necesitas dos cosas:

1.  **La dirección del contrato:** Este es el identificador único del contrato en la blockchain.
2.  **La interfaz del contrato:** Este es un archivo de Solidity que define las funciones del contrato con las que quieres interactuar. No necesitas el código fuente completo del contrato, solo la interfaz.

### Cheatcode `deal`

El cheatcode `deal` es una característica poderosa de Foundry que te permite establecer el saldo de cualquier cuenta para cualquier token ERC20. Esto es extremadamente útil para las pruebas, ya que te permite simular tener cualquier cantidad de tokens sin tener que adquirirlos en la mainnet.

## Explicación del Código

### `test/interfaces/IERC20.sol`

Este archivo define la interfaz para el estándar de token ERC20. Incluye las seis funciones obligatorias que cualquier token ERC20 debe implementar:

*   `totalSupply()`
*   `balanceOf(address account)`
*   `transfer(address recipient, uint256 amount)`
*   `allowance(address owner, address spender)`
*   `approve(address spender, uint256 amount)`
*   `transferFrom(address sender, address recipient, uint256 amount)`

También define dos eventos, `Transfer` y `Approval`, que se emiten cuando se transfieren o aprueban tokens.

### `test/11_TestTokens/forkDai.sol`

Este es el contrato de prueba que demuestra cómo interactuar con el contrato del token DAI en la mainnet de Ethereum. Analicemos el código:

1.  **Importando los archivos necesarios:**

    *   `forge-std/Test.sol`: Utilidades de prueba de Foundry.
    *   `forge-std/console.sol`: Para registrar información en la consola.
    *   `../interfaces/IERC20.sol`: La interfaz para el token ERC20.

2.  **Definición del contrato:**

    *   `contract ForkDaiTest is Test`: Define el contrato de prueba, que hereda del contrato `Test` de Foundry.

3.  **Variable de estado:**

    *   `IERC20 public dai;`: Declara una variable pública `dai` de tipo `IERC20`. Esta variable se usará para interactuar con el contrato del token DAI.

4.  **Función `setUp()`:**

    *   Esta función se ejecuta antes de cada caso de prueba.
    *   `dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);`: Inicializa la variable `dai` con la dirección del contrato oficial de DAI en la mainnet de Ethereum.

5.  **Funciones de prueba:**

    *   `testDeposit()`: Esta función prueba el proceso de simular un depósito de tokens DAI.
        *   Primero obtiene el saldo inicial de una cuenta.
        *   Luego, usa el cheatcode `deal` para simular que la cuenta recibe 1 millón de tokens DAI.
        *   Finalmente, afirma que el saldo final es mayor que el saldo inicial y que el suministro total de DAI permanece sin cambios.

## Cómo Ejecutar las Pruebas

Para ejecutar las pruebas, necesitas tener Foundry instalado. Luego, puedes ejecutar el siguiente comando en tu terminal:

```bash
forge test --fork-url <your_mainnet_rpc_url> --match-path test/11_TestTokens/forkDai.sol -vvv
```
Reemplaza `<tu_url_rpc_de_mainnet>` con tu propia URL RPC de la mainnet de Ethereum (por ejemplo, de Alchemy o Infura).
```bash
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P --match-path test/11_TestTokens/forkDai.sol -vvv
```
Esto ejecutará las pruebas en un entorno de fork, permitiendo que el contrato de prueba interactúe con el contrato real de DAI en la mainnet.