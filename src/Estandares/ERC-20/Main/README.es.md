# Contrato Inteligente Main (Gestión de Tokens)

Este contrato de Solidity, `Main`, es un ejemplo que demuestra cómo interactuar con un token ERC-20 personalizado (`ERC20.sol`) dentro de otro contrato. Permite la creación de un token, la venta de tokens a cambio de Ether, la generación de nuevos tokens y la consulta de saldos y el suministro total.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. En este caso, `Main` actúa como un gestor para un token ERC-20.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que el contrato compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `import "../ERC20.sol";`

Esta línea importa el código del contrato `ERC20.sol`. Esto permite que el contrato `Main` utilice las funcionalidades definidas en `ERC20.sol`, como la creación de tokens, transferencias, etc.

### `ERC20 private _token;`

Declara una variable privada `_token` de tipo `ERC20`. Esta variable almacenará la instancia de nuestro token ERC-20 personalizado.

### `address private owner;`

Almacena la dirección de la persona que desplegó el contrato `Main`. Esta es una práctica común para implementar funciones que solo el propietario puede ejecutar.

### `address private contractAddress;`

Almacena la dirección del propio contrato `Main` en la blockchain.

### `constructor() { ... }`

El `constructor` es una función especial que se ejecuta una única vez cuando el contrato se despliega en la blockchain. Aquí se inicializan las variables:

*   `_token = new ERC20("TEST Coin", "TCI");`: Crea una nueva instancia del token ERC-20 con el nombre "TEST Coin" y el símbolo "TCI".
*   `owner = msg.sender;`: Establece al desplegador del contrato como el `owner`.
*   `contractAddress = address(this);`: Guarda la dirección de este contrato.

### `public pure` y `public payable`

*   **`public`**: La función puede ser llamada por cualquier persona.
*   **`pure`**: La función no lee ni modifica el estado de la blockchain. Solo realiza cálculos con los parámetros de entrada.
*   **`payable`**: La función puede recibir Ether (la criptomoneda nativa de Ethereum) junto con la llamada a la función.

## Funciones del Contrato

### `priceTokens(uint256 _numTokens) public pure returns (uint256)`

*   **Propósito:** Calcula el precio total en Ether para una cantidad dada de tokens.
*   **Parámetros:**
    *   `_numTokens`: La cantidad de tokens para la que se quiere calcular el precio.
*   **Funcionamiento:** Multiplica la cantidad de tokens por `1 ether`. Esto significa que 1 token cuesta 1 Ether en este ejemplo.

### `buyTokens(address _client, uint256 _amount) public payable`

*   **Propósito:** Permite a un usuario comprar tokens enviando Ether al contrato.
*   **Parámetros:**
    *   `_client`: La dirección a la que se enviarán los tokens comprados.
    *   `_amount`: La cantidad de tokens que se desea comprar.
*   **Funcionamiento:**
    1.  Calcula el `price` requerido usando `priceTokens`.
    2.  `require(msg.value >= price, "buy more tokens");`: Verifica que la cantidad de Ether enviada (`msg.value`) sea suficiente para cubrir el precio. Si no, la transacción falla.
    3.  `returnValue = msg.value - price;`: Calcula el cambio si se envió más Ether del necesario.
    4.  `payable(msg.sender).transfer(returnValue);`: Envía el cambio de vuelta al comprador.
    5.  `_token.transfer(_client, _amount);`: Transfiere la cantidad de tokens comprados desde el contrato (`Main`) a la dirección del cliente.

### `generateTokens(uint256 _amount) public`

*   **Propósito:** Genera una nueva cantidad de tokens y los asigna al contrato `Main`.
*   **Parámetros:**
    *   `_amount`: La cantidad de nuevos tokens a generar.
*   **Funcionamiento:** Llama a la función `increaseTotalSupply` del contrato `_token` (nuestro ERC-20) para aumentar el suministro total y asignar estos nuevos tokens a la dirección del contrato `Main`.

### `getContractAddress() public view returns (address)`

*   **Propósito:** Devuelve la dirección del propio contrato `Main`.
*   **Funcionamiento:** Simplemente retorna el valor de `contractAddress`.

### `balanceAccount(address _account) public view returns (uint256)`

*   **Propósito:** Consulta el balance de tokens de una dirección específica.
*   **Parámetros:**
    *   `_account`: La dirección de la que se quiere conocer el balance de tokens.
*   **Funcionamiento:** Llama a la función `balanceOf` del contrato `_token` para obtener el balance de tokens de la dirección proporcionada.

### `getTotalSupply() public view returns (uint256)`

*   **Propósito:** Devuelve el suministro total de tokens existentes.
*   **Funcionamiento:** Llama a la función `totalSupply` del contrato `_token` para obtener el suministro total de tokens.

## ¿Cómo interactuar con este contrato?

Este contrato se desplegaría junto con el contrato `ERC20.sol` (que es importado). Una vez desplegado, puedes interactuar con sus funciones públicas a través de una interfaz de usuario o directamente desde una consola de desarrollo de blockchain (como la de Remix o Hardhat) para comprar tokens, generar más, o consultar información.