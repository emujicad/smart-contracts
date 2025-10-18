# Contrato Inteligente TokenERC721 (Estándar de Token No Fungible - NFT)

Este contrato de Solidity, `TokenERC721`, es una implementación completa del estándar **ERC-721** para tokens no fungibles (NFTs). Un NFT es un activo digital único que no es intercambiable por otro de su mismo tipo, como una obra de arte digital, un coleccionable o una propiedad virtual. Este contrato gestiona la creación (minting), transferencia y seguimiento de la propiedad de estos activos únicos, y también implementa el estándar EIP-165 para la detección de interfaces.

## ¿Qué es un Contrato Inteligente?

Un contrato inteligente es un programa que se ejecuta en la blockchain. Una vez desplegado, su código es inmutable y se ejecuta de forma autónoma. `TokenERC721` define las reglas y la lógica para la existencia y gestión de NFTs en la blockchain.

## ¿Qué es un Token ERC-721 (NFT)?

ERC-721 es el estándar técnico para tokens no fungibles en Ethereum. A diferencia de los tokens ERC-20 (fungibles), cada token ERC-721 es único y tiene un `tokenId` distintivo. Esto los hace ideales para representar activos únicos y coleccionables.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que el contrato compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### Importaciones de Interfaces

*   `../../interfaces/IERC165/IERC165.sol`: Interfaz para el estándar EIP-165, que permite a los contratos declarar qué interfaces soportan.
*   `../../interfaces/IERC721/IERC721.sol`: Interfaz principal del estándar ERC-721, que define las funciones y eventos obligatorios para un NFT.
*   `../../interfaces/IERC721Receiver/IERC721Receiver.sol`: Interfaz para contratos que pueden recibir NFTs de forma segura.

### `contract TokenERC721 is IERC165, IERC721 { ... }`

Declara el contrato `TokenERC721` e indica que implementa las interfaces `IERC165` y `IERC721`.

### Variables de Estado (Mappings)

*   `_owners (mapping(uint256 => address))`: Asocia cada `tokenId` con la dirección de su propietario.
*   `_balances (mapping(address => uint256))`: Almacena el número de NFTs que posee cada dirección.
*   `_tokenApprovals (mapping(uint256 => address))`: Almacena la dirección aprobada para transferir un `tokenId` específico.
*   `_operatorApprovals (mapping(address => mapping(address => bool)))`: Almacena si un `operator` tiene permiso para gestionar todos los tokens de un `owner`.

## Funciones del Estándar ERC-165

### `supportsInterface(bytes4 interfaceId) public view virtual override returns (bool)`

*   **Propósito:** Permite a otros contratos o aplicaciones consultar si este contrato soporta una interfaz específica (como ERC-721 o ERC-165).
*   **Funcionamiento:** Devuelve `true` si el `interfaceId` proporcionado coincide con el de `IERC721` o `IERC165`.

## Funciones del Estándar ERC-721

### `balanceOf(address owner) public view virtual override returns (uint256)`

*   **Propósito:** Devuelve el número de NFTs que posee una dirección.

### `ownerOf(uint256 tokenId) public view virtual override returns (address)`

*   **Propósito:** Devuelve la dirección del propietario de un `tokenId` específico.

### `approve(address to, uint256 tokenId) public virtual override`

*   **Propósito:** Otorga permiso a una dirección (`to`) para transferir un `tokenId` específico.
*   **Restricciones:** Solo el propietario del token o un operador aprobado puede llamar a esta función.

### `setApprovalForAll(address operator, bool approved) public virtual override`

*   **Propósito:** Otorga o revoca permiso a un `operator` para gestionar *todos* los tokens del remitente (`msg.sender`).

### `getApproved(uint256 tokenId) public view virtual override returns (address operator)`

*   **Propósito:** Devuelve la dirección que está aprobada para transferir un `tokenId` específico.

### `isApprovedForAll(address owner, address operator) public view virtual override returns (bool)`

*   **Propósito:** Consulta si un `operator` tiene permiso para gestionar todos los tokens de un `owner`.

### `safeTransferFrom(address from, address to, uint256 tokenId)` (dos versiones)

*   **Propósito:** Transfiere un token de forma segura de `from` a `to`. La versión con `bytes calldata data` permite enviar datos adicionales.
*   **Seguridad:** Incluye una verificación para asegurar que el contrato receptor (`to`) pueda manejar NFTs (llamando a `onERC721Received`). Si el receptor es un contrato que no implementa esta función, la transacción se revierte, evitando que los NFTs se queden "atrapados".

### `transferFrom(address from, address to, uint256 tokenId) public virtual override`

*   **Propósito:** Transfiere un token de `from` a `to` (versión "menos segura").
*   **Advertencia:** Es responsabilidad del llamador asegurarse de que el receptor (`to`) pueda manejar el token. No realiza la verificación `onERC721Received`.

## Funciones Internas (Lógica Principal)

### `_safeMint(address to, uint256 tokenId)` (dos versiones)

*   **Propósito:** Acuña (crea) un nuevo token de forma segura y lo asigna a `to`.
*   **Seguridad:** Incluye la verificación `_checkOnERC721Received` para asegurar que el receptor pueda manejar el NFT.

### `_mint(address to, uint256 tokenId) internal virtual`

*   **Propósito:** Lógica central para acuñar un nuevo token. Actualiza balances y asigna la propiedad.
*   **Restricciones:** No se puede acuñar a la dirección cero ni un token que ya exista.

### `_transfer(address from, address to, uint256 tokenId) internal virtual`

*   **Propósito:** Lógica central para transferir un token. Es utilizada por todas las funciones de transferencia.
*   **Funcionamiento:** Verifica la propiedad, limpia aprobaciones previas, actualiza balances y propietarios, y emite un evento `Transfer`.

### `_beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual`

*   **Propósito:** Un "hook" (gancho) que puede ser sobrescrito por contratos hijos para añadir lógica personalizada antes de cualquier transferencia (ej. listas blancas).

### `_approve(address to, uint256 tokenId) internal virtual`

*   **Propósito:** Establece la aprobación para un `tokenId`.

### `_exists(uint256 tokenId) internal view virtual returns (bool)`

*   **Propósito:** Verifica si un token con el `tokenId` dado existe.

### `_isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool)`

*   **Propósito:** Verifica si una dirección (`spender`) está autorizada para transferir un `tokenId` (es el propietario, un operador aprobado o tiene aprobación específica).

### `_checkOnERC721Received(...) internal virtual returns(bool)`

*   **Propósito:** Llama a la función `onERC721Received` en el contrato receptor si `to` es un contrato. Esto es parte de la seguridad de `safeTransferFrom`.

### `isContract(address addr) private view returns (bool)`

*   **Propósito:** Función auxiliar para determinar si una dirección es un contrato (tiene código).

## ¿Cómo interactuar con este contrato?

1.  **Desplegar el Contrato:** Una vez desplegado, puedes empezar a acuñar NFTs.
2.  **Acuñar NFTs:** Utiliza una función de acuñación (que normalmente se añadiría en un contrato que hereda de `TokenERC721`) para crear nuevos tokens y asignarlos a direcciones.
3.  **Transferir NFTs:** Usa `transferFrom` o `safeTransferFrom` para mover NFTs entre direcciones.
4.  **Gestionar Aprobaciones:** Usa `approve` para permitir que otros transfieran tus NFTs, o `setApprovalForAll` para dar control total a un operador.