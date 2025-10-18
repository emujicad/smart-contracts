# Proyecto de Contrato Inteligente ERC-721

## Descripción General

Este proyecto es una implementación educativa del estándar de token no fungible (NFT) **EIP-721** en Solidity. El objetivo es proporcionar un ejemplo claro y bien documentado de cómo funciona un contrato de NFT, diseñado para personas que se inician en el desarrollo de Web3 y contratos inteligentes.

El contrato principal, `TokenERC721.sol`, implementa todas las funciones obligatorias del estándar ERC-721, así como el estándar **EIP-165** para el descubrimiento de interfaces.

## Estructura de Archivos

El proyecto está organizado en los siguientes archivos:

-   `TokenERC721.sol`: Este es el corazón del proyecto. Es el contrato inteligente que implementa la lógica de un NFT. Aquí se define cómo se crean los tokens (acuñación o "minting"), cómo se transfieren, quién es el propietario de cada uno, y cómo se gestionan los permisos.

-   `ERC165.sol`: Un contrato base que implementa el estándar EIP-165. Nuestro `TokenERC721` hereda de este contrato para poder "anunciar" a otros contratos qué funcionalidades (interfaces) soporta.

-   `interfaces/`: Esta carpeta contiene las "interfaces" que nuestro contrato promete implementar. Una interfaz en Solidity es como un contrato: define qué funciones debe tener un contrato, pero sin implementar la lógica.

    -   `IERC165/IERC165.sol`: Define la función `supportsInterface`, que es el núcleo del estándar EIP-165. Permite a otros contratos preguntar: "¿Oye, tú soportas la funcionalidad X?".

    -   `IERC721/IERC721.sol`: La interfaz principal para los NFTs. Define todas las funciones y eventos que un token ERC-721 debe tener, como `transferFrom`, `ownerOf`, `balanceOf`, `approve`, etc. Esto garantiza que nuestro NFT sea compatible con cualquier wallet o mercado del ecosistema Ethereum.

    -   `IERC721Receiver/IERC721Receiver.sol`: Una interfaz crucial para las transferencias seguras. Un contrato que quiera recibir un NFT de forma segura debe implementar la función `onERC721Received` definida aquí. Esto previene que los NFTs se envíen accidentalmente a contratos que no saben cómo manejarlos, evitando su pérdida.

## Conceptos Clave para Principiantes

#### ¿Qué es un NFT (ERC-721)?

Un Token No Fungible (NFT) es un tipo de token criptográfico que representa un activo único. "No fungible" significa que es único y no puede ser reemplazado por otro igual. Piensa en la diferencia entre un billete de 10 euros (fungible, puedes intercambiarlo por cualquier otro billete de 10 euros) y una obra de arte original como la Mona Lisa (no fungible, es única). Cada NFT tiene un ID de token único que lo distingue de los demás.

#### ¿Qué es una Interfaz en Solidity?

Una interfaz es como un esqueleto de un contrato. Define un conjunto de funciones que un contrato debe implementar, especificando sus nombres, parámetros y tipos de retorno, pero sin ninguna lógica interna. Cuando un contrato "implementa" una interfaz, se compromete a proporcionar el código para todas las funciones de esa interfaz. Esto es fundamental para la interoperabilidad, ya que permite que diferentes contratos se comuniquen de forma estandarizada.

#### ¿Qué es el estándar ERC-165?

Es un estándar que permite a un contrato anunciar qué interfaces implementa. La única función que tiene es `supportsInterface(bytes4 interfaceID)`, que devuelve `true` o `false`. De esta manera, antes de intentar interactuar con un contrato, podemos preguntarle si soporta la interfaz que necesitamos (por ejemplo, la interfaz ERC-721).

#### `transferFrom` vs. `safeTransferFrom`

Ambas funciones transfieren un NFT, pero hay una diferencia clave de seguridad:

-   `transferFrom`: Simplemente cambia la propiedad del token. Si lo envías a una dirección de un contrato que no está diseñado para manejar NFTs, el token puede quedar bloqueado y perderse para siempre.
-   `safeTransferFrom`: Es la opción recomendada. Antes de transferir el token a una dirección de contrato, verifica si ese contrato implementa la interfaz `IERC721Receiver`. Si no lo hace, la transferencia falla, protegiendo el NFT de ser perdido.

#### `approve` vs. `setApprovalForAll`

Estas funciones se usan para dar permisos a otras cuentas para que puedan transferir tus NFTs:

-   `approve`: Das permiso a una cuenta específica para transferir un **único NFT** con un ID de token concreto. El permiso se revoca una vez que el token es transferido.
-   `setApprovalForAll`: Das permiso (o lo revocas) a otra cuenta (un "operador") para que gestione **todos tus NFTs** en ese contrato. Esto es muy útil para los mercados de NFTs, ya que les permites transferir cualquier token que pongas a la venta sin necesidad de que apruebes cada uno individualmente.

## Cómo Usar

1.  **Compilación**: Puedes compilar estos contratos en un entorno de desarrollo como Remix, Hardhat o Foundry. Asegúrate de seleccionar un compilador compatible con la versión de Solidity especificada (`^0.8.20` o superior).
2.  **Despliegue**: Despliega el contrato `TokenERC721.sol`.
3.  **Interacción**: Una vez desplegado, puedes interactuar con las funciones del contrato:
    -   Llama a `safeMint(direccion, tokenId)` para crear un nuevo NFT y asignarlo a una dirección.
    -   Usa `transferFrom` o `safeTransferFrom` para enviar el token a otra dirección.
    -   Usa `approve` o `setApprovalForAll` para gestionar los permisos.
    -   Usa `ownerOf` y `balanceOf` para consultar la información de propiedad.
