# Interfaz IERC721 (Estándar de Token No Fungible - NFT)

Este archivo de Solidity, `IERC721.sol`, define la **interfaz** para el estándar de token no fungible (NFT) **EIP-721**. Un NFT es un activo digital único e irrepetible, como una obra de arte digital, un coleccionable o una propiedad virtual. Esta interfaz especifica el conjunto de funciones y eventos que un contrato de NFT debe implementar para ser compatible con el ecosistema de Ethereum (carteras, mercados, etc.). Hereda de `IERC165` para poder anunciar que implementa esta interfaz.

## ¿Qué es una Interfaz en Solidity?

Una interfaz es un tipo de contrato abstracto que solo contiene declaraciones de funciones y eventos, pero no su implementación. Se utiliza para:

*   **Definir Estándares:** Como el ERC-721, para asegurar que todos los contratos que implementan la interfaz sigan las mismas reglas.
*   **Interacción entre Contratos:** Permite que un contrato interactúe con otro contrato sin conocer su código fuente completo, solo su interfaz.
*   **Verificación en Tiempo de Compilación:** El compilador puede verificar que un contrato que dice implementar una interfaz realmente implemente todas sus funciones y eventos.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.20;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.20` significa que la interfaz compilará con versiones desde 0.8.20 hasta la próxima versión mayor (ej. 0.9.0).

### `import {IERC165} from "../IERC165/IERC165.sol";`

Esta línea importa la interfaz `IERC165`, que es el estándar para la detección de interfaces. Al heredar de `IERC165`, un contrato ERC-721 puede informar a otros contratos que soporta el estándar ERC-721.

### `interface IERC721 is IERC165 { ... }`

Declara la interfaz `IERC721` y especifica que hereda de `IERC165`.

## Eventos del Estándar ERC-721

### `event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);`

*   **Propósito:** Emitido cuando un token con ID `tokenId` es transferido de `from` a `to`.
*   **Importancia:** Los eventos son cruciales para que las aplicaciones externas (como exploradores de bloques o mercados de NFT) puedan rastrear los movimientos de los tokens sin tener que leer todo el estado del contrato. Los parámetros `indexed` permiten una búsqueda y filtrado más eficientes de estos eventos.

### `event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);`

*   **Propósito:** Emitido cuando `owner` aprueba a `approved` para gestionar el token `tokenId`.
*   **Importancia:** Esto es como darle permiso a alguien más para mover tu tarjeta coleccionable digital.

### `event ApprovalForAll(address indexed owner, address indexed operator, bool approved);`

*   **Propósito:** Emitido cuando `owner` aprueba o desaprueba a un `operator` para gestionar *todos* sus tokens.
*   **Importancia:** Esta es una permiso más amplio que `Approval`. Un "operator" podría ser, por ejemplo, un mercado de NFT que necesita poder transferir tus tokens en tu nombre cuando los vendes.

## Funciones Mandatorias del Estándar ERC-721

La interfaz `IERC721` define las funciones principales que cualquier token ERC-721 debe tener:

### `function balanceOf(address owner) external view returns (uint256 balance);`

*   **Propósito:** Devuelve el número de tokens (NFTs) que posee una dirección `owner`.

### `function ownerOf(uint256 tokenId) external view returns (address owner);`

*   **Propósito:** Devuelve la dirección del propietario del token con ID `tokenId`.

### `function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;`

### `function safeTransferFrom(address from, address to, uint256 tokenId) external;`

*   **Propósito:** Transfiere un token de forma segura de `from` a `to`.
*   **Seguridad:** La versión "segura" verifica si el destinatario es un contrato capaz de recibir NFTs. Si `to` es un contrato, debe implementar la función `onERC721Received`. Esto previene que los tokens se queden "atrapados" en contratos que no saben cómo manejarlos.

### `function transferFrom(address from, address to, uint256 tokenId) external;`

*   **Propósito:** Transfiere un token de `from` a `to`.
*   **¡ADVERTENCIA!** Esta es una transferencia "insegura". Si `to` es un contrato que no sabe cómo manejar NFTs, el token podría perderse para siempre. Generalmente, es mejor usar `safeTransferFrom`.

### `function approve(address to, uint256 tokenId) external;`

*   **Propósito:** Otorga permiso a `to` para transferir el token `tokenId` en nombre del propietario. Solo una dirección puede ser aprobada por token a la vez.

### `function setApprovalForAll(address operator, bool approved) external;`

*   **Propósito:** Aprueba o revoca a un `operator` para gestionar *todos* los tokens del llamador (`msg.sender`).

### `function getApproved(uint256 tokenId) external view returns (address operator);`

*   **Propósito:** Devuelve la dirección aprobada para un `tokenId` específico.

### `function isApprovedForAll(address owner, address operator) external view returns (bool);`

*   **Propósito:** Consulta si un `operator` está aprobado para gestionar todos los activos de un `owner`.

## ¿Cómo se utiliza esta Interfaz?

Un contrato que quiera ser un token ERC-721 debe `implementar` esta interfaz. Esto significa que el contrato debe tener todas las funciones y eventos definidos en `IERC721` con las firmas exactas. Al hacer esto, cualquier aplicación o contrato que entienda la interfaz `IERC721` podrá interactuar con el token de manera estándar.