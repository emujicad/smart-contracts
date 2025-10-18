# Interfaz IERC20 (Estándar de Token Fungible)

Este archivo de Solidity, `IERC20.sol`, define la **interfaz** para el estándar de token ERC-20. Una interfaz en Solidity es como un "contrato" de lo que otro contrato debe hacer. Especifica las funciones y eventos que un contrato de token debe implementar para ser considerado compatible con ERC-20. No contiene ninguna lógica de implementación, solo las firmas de las funciones y los eventos.

## ¿Qué es una Interfaz en Solidity?

Una interfaz es un tipo de contrato abstracto que solo contiene declaraciones de funciones y eventos, pero no su implementación. Se utiliza para:

*   **Definir Estándares:** Como el ERC-20, para asegurar que todos los contratos que implementan la interfaz sigan las mismas reglas.
*   **Interacción entre Contratos:** Permite que un contrato interactúe con otro contrato sin conocer su código fuente completo, solo su interfaz.
*   **Verificación en Tiempo de Compilación:** El compilador puede verificar que un contrato que dice implementar una interfaz realmente implemente todas sus funciones y eventos.

## Conceptos Clave Utilizados

### `pragma solidity ^0.8.24;`

Indica la versión del compilador de Solidity que debe usarse. `^0.8.24` significa que la interfaz compilará con versiones desde 0.8.24 hasta la próxima versión mayor (ej. 0.9.0).

### `interface IERC20 { ... }`

Declara la interfaz `IERC20`.

### `event Transfer(address indexed _from, address indexed _to, uint256 _value);`

Este es un evento que debe ser emitido cada vez que se transfieren tokens. Es crucial para que las aplicaciones externas puedan rastrear los movimientos de tokens.

*   `indexed`: Las palabras clave `indexed` hacen que los parámetros sean "buscables" en los logs de la blockchain, lo que facilita la filtración de eventos.

### `event Approval(address indexed _owner, address indexed _spender, uint256 _value);`

Este evento debe ser emitido cada vez que se aprueba que un `_spender` gaste tokens en nombre de un `_owner`.

### `external view` y `external`

*   `external`: Significa que la función solo puede ser llamada desde fuera del contrato.
*   `view`: Indica que la función no modifica el estado del contrato. Son funciones de solo lectura y no cuestan gas para ejecutarse (cuando se llaman fuera de una transacción).

## Funciones Mandatorias del Estándar ERC-20

La interfaz `IERC20` define las seis funciones principales que cualquier token ERC-20 debe tener:

### `function totalSupply() external view returns (uint256);`

*   **Propósito:** Devuelve el suministro total de tokens en circulación.

### `function balanceOf(address _owner) external view returns (uint256);`

*   **Propósito:** Devuelve el balance de tokens de una dirección específica.
*   **Parámetros:**
    *   `_owner`: La dirección de la que se quiere conocer el balance.

### `function transfer(address _to, uint256 _value) external returns (bool);`

*   **Propósito:** Transfiere `_value` de tokens desde el remitente (`msg.sender`) a la dirección `_to`.
*   **Retorno:** `true` si la transferencia fue exitosa, `false` en caso contrario (aunque la práctica moderna es revertir en caso de fallo).

### `function transferFrom(address _from, address _to, uint256 _value) external returns (bool);`

*   **Propósito:** Transfiere `_value` de tokens desde la dirección `_from` a la dirección `_to`, utilizando la aprobación previa de `_from` por parte del remitente (`msg.sender`).
*   **Retorno:** `true` si la transferencia fue exitosa.

### `function approve(address _spender, uint256 _value) external returns (bool);`

*   **Propósito:** Permite que una dirección (`_spender`) gaste hasta `_value` de tokens en nombre del remitente (`msg.sender`).
*   **Retorno:** `true` si la aprobación fue exitosa.

### `function allowance(address _owner, address _spender) external view returns (uint256);`

*   **Propósito:** Devuelve la cantidad de tokens que `_spender` puede gastar en nombre de `_owner`.

## ¿Cómo se utiliza esta Interfaz?

Un contrato que quiera ser un token ERC-20 debe `implementar` esta interfaz. Esto significa que el contrato debe tener todas las funciones y eventos definidos en `IERC20` con las firmas exactas. Por ejemplo:

```solidity
import "./IERC20.sol";

contract MyToken is IERC20 {
    // ... implementación de todas las funciones y eventos de IERC20 ...
}
```

Al hacer esto, cualquier aplicación o contrato que entienda la interfaz `IERC20` podrá interactuar con `MyToken` de manera estándar.