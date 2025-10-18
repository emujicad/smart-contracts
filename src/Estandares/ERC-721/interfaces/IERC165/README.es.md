# Interfaz IERC165 (Estándar de Detección de Interfaz)

Este archivo de Solidity, `IERC165.sol`, define la **interfaz** para el estándar **EIP-165**. Este estándar es crucial para la interoperabilidad en la blockchain, ya que permite que los contratos inteligentes declaren qué interfaces (conjuntos de funciones) implementan. Esto facilita que otros contratos o aplicaciones consulten si un contrato dado soporta una funcionalidad específica sin tener que intentar llamar a esas funciones y arriesgarse a que la transacción falle.

## ¿Qué es una Interfaz en Solidity?

Una interfaz es un tipo de contrato abstracto que solo contiene declaraciones de funciones y eventos, pero no su implementación. Se utiliza para:

*   **Definir Estándares:** Como el EIP-165, para asegurar que todos los contratos que implementan la interfaz sigan las mismas reglas.
*   **Interacción entre Contratos:** Permite que un contrato interactúe con otro contrato sin conocer su código fuente completo, solo su interfaz.
*   **Verificación en Tiempo de Compilación:** El compilador puede verificar que un contrato que dice implementar una interfaz realmente implemente todas sus funciones y eventos.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que la interfaz compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `interface IERC165 { ... }`

Declara la interfaz `IERC165`.

### `external view`

*   `external`: Significa que la función solo puede ser llamada desde fuera del contrato.
*   `view`: Indica que la función no modifica el estado del contrato. Son funciones de solo lectura y no cuestan gas para ejecutarse (cuando se llaman fuera de una transacción).

## Funciones de la Interfaz

### `function supportsInterface(bytes4 interfaceId) external view returns (bool);`

*   **Propósito:** Esta es la única función definida en la interfaz `IERC165`. Permite consultar si un contrato implementa una interfaz específica.
*   **Parámetros:**
    *   `interfaceId`: Un identificador único de 4 bytes para la interfaz que se desea consultar. Este ID se calcula tomando el XOR de los selectores de función de todas las funciones en la interfaz. Por ejemplo, para la interfaz `IERC721`, su `interfaceId` es `0x80ac58cd`.
*   **Retorno:** `true` si el contrato implementa la `interfaceId` proporcionada, `false` en caso contrario.

## ¿Cómo se utiliza esta Interfaz?

Cualquier contrato que quiera ser compatible con EIP-165 (como los tokens ERC-721 o ERC-1155) debe implementar esta interfaz. Esto significa que el contrato debe tener una función `supportsInterface` que devuelva `true` para los `interfaceId` de todas las interfaces que soporta. Por ejemplo:

```solidity
import "./IERC165.sol"; // Esta ruta es correcta si MyNFT.sol está en el mismo directorio que IERC165.sol
import "../IERC721/IERC721.sol"; // Suponiendo que también implementa ERC721

contract MyNFT is IERC165, IERC721 {
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IERC721).interfaceId || super.supportsInterface(interfaceId);
    }
    // ... resto de la implementación de ERC721 ...
}
```

**Aclaración sobre `import "./IERC165.sol";`:** Esta ruta de importación específica en el ejemplo asume que el contrato `MyNFT` (que está importando `IERC165.sol`) se encuentra en el mismo directorio que la propia interfaz `IERC165.sol`. En un proyecto real, la ruta relativa dependería de la estructura de archivos actual.

Al hacer esto, una aplicación puede preguntar a `MyNFT`: "¿Soportas la interfaz ERC-721?" y `MyNFT` responderá `true`, permitiendo que la aplicación interactúe con él de la manera esperada para un NFT.