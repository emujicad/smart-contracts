# Contrato Inteligente ERC20 (Estándar de Token Fungible)

Este contrato de Solidity, `ERC20`, es una implementación básica del estándar de token ERC-20. Este estándar define un conjunto común de reglas para los tokens fungibles en la blockchain de Ethereum, permitiendo que diferentes tokens interactúen de manera predecible con aplicaciones y otros contratos.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. Este contrato en particular define un token digital que puede ser transferido, aprobado para ser gastado por otros, acuñado (creado) y quemado (destruido).

## ¿Qué es un Token ERC-20?

ERC-20 es el estándar técnico más común para tokens fungibles en Ethereum. Los tokens fungibles son aquellos que son idénticos entre sí y pueden ser intercambiados uno por uno (como el dinero o las acciones de una empresa). El estándar ERC-20 define funciones como `transfer`, `balanceOf`, `approve`, `transferFrom`, `totalSupply`, `name`, `symbol` y `decimals`.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que el contrato compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `import "./interfaces/IERC20/IERC20.sol";` y `import "./interfaces/IERC20Metadata/IERC20Metadata.sol";`

Estas líneas importan las interfaces `IERC20` y `IERC20Metadata`. Una interfaz define las funciones que un contrato debe implementar para cumplir con un estándar. Al implementar estas interfaces, el contrato `ERC20` garantiza que cumple con el estándar ERC-20.

### `mapping(address => uint256) private _balances;`

Un `mapping` que asocia una dirección de Ethereum (`address`) con el balance de tokens (`uint256`) que posee esa dirección. Es privado, lo que significa que solo puede ser accedido desde dentro del contrato.

### `mapping(address => mapping(address => uint256)) private _allowances;`

Un `mapping` anidado que gestiona las "aprobaciones" (allowances). Almacena cuánto de los tokens de un `owner` (`address`) un `spender` (`address`) está autorizado a gastar. También es privado.

### `uint256 private _totalSupply;`

Almacena el suministro total de tokens en circulación. Es privado.

### `string private _name;` y `string private _symbol;`

Almacenan el nombre y el símbolo del token (ej. "MyToken", "MTK"). Son privados.

### `constructor(string memory name_, string memory symbol_) { ... }`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega. Aquí se inicializan el nombre y el símbolo del token.

## Funciones del Estándar ERC-20

### `name() public view override returns (string memory)`

*   **Propósito:** Devuelve el nombre del token.

### `symbol() public view override returns (string memory)`

*   **Propósito:** Devuelve el símbolo del token.

### `decimals() public pure override returns (uint8)`

*   **Propósito:** Devuelve el número de decimales que utiliza el token. Comúnmente 18, similar a Ether.

### `totalSupply() public view override returns (uint256)`

*   **Propósito:** Devuelve el suministro total de tokens en circulación.

### `balanceOf(address _account) public view override returns (uint256)`

*   **Propósito:** Devuelve el balance de tokens de una dirección específica.
*   **Parámetros:**
    *   `_account`: La dirección de la que se quiere conocer el balance.

### `transfer(address _to, uint256 _amount) public override returns (bool)`

*   **Propósito:** Transfiere `_amount` de tokens desde el remitente (`msg.sender`) a la dirección `_to`.
*   **Funcionamiento:** Llama a la función interna `_transfer`.

### `approve(address _spender, uint256 _amount) public override returns (bool)`

*   **Propósito:** Permite que una dirección (`_spender`) gaste hasta `_amount` de tokens en nombre del remitente (`msg.sender`).
*   **Funcionamiento:** Llama a la función interna `_approve`.

### `allowance(address _owner, address _spender) public view override returns (uint256)`

*   **Propósito:** Devuelve la cantidad de tokens que `_spender` puede gastar en nombre de `_owner`.

### `transferFrom(address _from, address _to, uint256 _amount) public override returns (bool)`

*   **Propósito:** Transfiere `_amount` de tokens desde la dirección `_from` a la dirección `_to`, utilizando la aprobación previa de `_from` por parte del remitente (`msg.sender`).
*   **Funcionamiento:** Primero, reduce la aprobación (`_spendAllowance`), luego llama a la función interna `_transfer`.

## Funciones Internas (Auxiliares)

### `_transfer(address _from, address _to, uint256 _amount) internal`

*   **Propósito:** Lógica central para transferir tokens. Es interna, lo que significa que solo puede ser llamada por otras funciones dentro de este contrato o contratos que hereden de él.
*   **Funcionamiento:** Realiza verificaciones de direcciones y balances, actualiza los balances de `_from` y `_to`, y emite un evento `Transfer`.

### `_approve(address _owner, address _spender, uint256 _amount) internal`

*   **Propósito:** Lógica central para establecer o actualizar una aprobación.
*   **Funcionamiento:** Actualiza el `_allowances` mapping y emite un evento `Approval`.

### `_spendAllowance(address _owner, address _spender, uint256 _amount) internal`

*   **Propósito:** Reduce la cantidad que un `_spender` puede gastar de los tokens de un `_owner`.
*   **Funcionamiento:** Verifica la aprobación existente y la reduce. Si la aprobación es `type(uint256).max`, se considera ilimitada y no se reduce.

### `_mint(address _account, uint256 _amount) internal`

*   **Propósito:** Crea nuevos tokens y los asigna a una dirección.
*   **Funcionamiento:** Aumenta el `_totalSupply` y el balance de `_account`, y emite un evento `Transfer` desde la dirección cero (representando la creación).

### `_burn(address _account, uint256 _amount) internal`

*   **Propósito:** Destruye tokens de una dirección.
*   **Funcionamiento:** Reduce el `_totalSupply` y el balance de `_account`, y emite un evento `Transfer` a la dirección cero (representando la destrucción).

### `increaseTotalSupply(address _account, uint256 _amount) public`

*   **Propósito:** Función pública para aumentar el suministro total de tokens y asignarlos a una cuenta. Es una envoltura alrededor de `_mint`.

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Al desplegar, se le da un nombre y un símbolo al token.
2.  **Acuñar Tokens:** Utiliza la función `increaseTotalSupply` (o `_mint` si es accesible) para crear tokens y asignarlos a una dirección.
3.  **Transferir Tokens:** Usa `transfer` para enviar tokens directamente a otra dirección.
4.  **Aprobar y Transferir por Terceros:** Usa `approve` para permitir que otra dirección gaste tus tokens, y luego esa dirección puede usar `transferFrom`.

---

# Contrato Inteligente MyToken (Token ERC-20 Extendido)

Este contrato de Solidity, `MyToken`, es un ejemplo avanzado de un token ERC-20 que incorpora múltiples funcionalidades de los contratos de OpenZeppelin. Está diseñado para ser un token versátil con capacidades de quema, pausa, acuñación (minting), permisos y flash minting, además de ser propiedad de una dirección específica.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. `MyToken` es un tipo de contrato inteligente que representa una moneda digital o un activo en la blockchain.

## ¿Qué es un Token ERC-20?

ERC-20 es un estándar técnico utilizado para todos los contratos inteligentes implementados en la blockchain de Ethereum para la implementación de tokens fungibles. Los tokens fungibles son aquellos que son idénticos entre sí y pueden ser intercambiados uno por uno (como el dinero).

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.27;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.27` significa que el contrato compilará con versiones desde 0.8.27 hasta la próxima versión mayor (ej. 0.9.0).

### Importaciones de OpenZeppelin

El contrato `MyToken` hereda funcionalidades de varios contratos estándar de OpenZeppelin, una biblioteca de contratos inteligentes seguros y auditados. Esto ahorra tiempo y reduce el riesgo de errores.

*   `ERC20`: La implementación base del estándar ERC-20.
*   `ERC20Burnable`: Permite a los poseedores de tokens "quemar" (destruir) sus propios tokens, reduciendo el suministro total.
*   `ERC20FlashMint`: Habilita la funcionalidad de "flash loans" (préstamos instantáneos) para tokens, donde se pueden acuñar y devolver tokens en la misma transacción.
*   `ERC20Pausable`: Permite pausar y reanudar las transferencias de tokens, útil en situaciones de emergencia o mantenimiento.
*   `ERC20Permit`: Añade la funcionalidad `permit` (EIP-2612), que permite a los usuarios firmar un mensaje fuera de la cadena para autorizar a un tercero a gastar sus tokens, sin necesidad de una transacción `approve` en la cadena.
*   `Ownable`: Implementa un mecanismo de control de acceso básico, donde una única dirección (`owner`) tiene permisos especiales para ciertas funciones.

### `contract MyToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit, ERC20FlashMint { ... }`

Esta línea declara el contrato `MyToken` y especifica que hereda (es decir, utiliza las funcionalidades de) todos los contratos de OpenZeppelin listados. Esto es un ejemplo de herencia múltiple en Solidity.

### `constructor(address initialOwner)`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega. Aquí se inicializan los contratos base:

*   `ERC20("MyToken", "EAM")`: Inicializa el token ERC-20 con el nombre "MyToken" y el símbolo "EAM".
*   `Ownable(initialOwner)`: Establece la dirección `initialOwner` como el propietario del contrato. Solo esta dirección tendrá permisos para funciones restringidas por `onlyOwner`.
*   `ERC20Permit("MyToken")`: Inicializa la funcionalidad de permisos con el nombre del token.

## Funciones del Contrato

### `pause() public onlyOwner`

*   **Propósito:** Pausa todas las transferencias de tokens.
*   **Funcionamiento:** Solo el `owner` del contrato puede llamar a esta función. Llama a la función interna `_pause()` heredada de `ERC20Pausable`.

### `unpause() public onlyOwner`

*   **Propósito:** Reanuda todas las transferencias de tokens después de haber sido pausadas.
*   **Funcionamiento:** Solo el `owner` del contrato puede llamar a esta función. Llama a la función interna `_unpause()` heredada de `ERC20Pausable`.

### `mint(address to, uint256 amount) public onlyOwner`

*   **Propósito:** Acuña (crea) nuevos tokens y los asigna a una dirección específica.
*   **Parámetros:**
    *   `to`: La dirección a la que se enviarán los nuevos tokens.
    *   `amount`: La cantidad de tokens a acuñar.
*   **Funcionamiento:** Solo el `owner` del contrato puede llamar a esta función. Llama a la función interna `_mint(to, amount)` heredada de `ERC20`.

### `_update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable)`

Esta es una función interna que sobrescribe (override) la lógica de actualización de saldos de los contratos `ERC20` y `ERC20Pausable`. Asegura que las reglas de pausa se apliquen durante las transferencias de tokens. La llamada a `super._update(from, to, value)` asegura que la lógica original de los contratos padre también se ejecute.

## ¿Cómo interactuar con este contrato?

Una vez desplegado en una red Ethereum (o una red de prueba), puedes interactuar con él usando herramientas como Remix, Hardhat, Truffle, o a través de una interfaz de usuario (DApp). El `initialOwner` tendrá control sobre las funciones `pause`, `unpause` y `mint`.