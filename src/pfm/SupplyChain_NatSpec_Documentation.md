# Guía de Documentación NatSpec para SupplyChain Contract (Complementada)

Este documento sirve como una guía y resumen de la documentación NatSpec para el contrato `SupplyChain.sol`. La documentación oficial y definitiva reside junto al código en el archivo `.sol`.

---

## 1. Enums (Enumeraciones)

-   **`PauseRole`**: Define los roles para la funcionalidad de pausa.
    -   `None`: Sin privilegios de pausa.
    -   `Pauser`: Puede pausar y reanudar el contrato.
-   **`UserStatus`**: Define el estado de un usuario en la plataforma.
    -   `Pending`: Solicitud de rol pendiente de aprobación.
    -   `Approved`: Usuario aprobado y activo.
    -   `Rejected`: Solicitud de rol rechazada.
    -   `Canceled`: Rol cancelado por el administrador.
-   **`UserRole`**: Define los roles funcionales dentro de la cadena de suministro.
    -   `Producer`: Crea materia prima.
    -   `Factory`: Transforma materia prima en producto terminado.
    -   `Retailer`: Distribuye producto terminado.
    -   `Consumer`: Receptor final del producto.
-   **`TransferStatus`**: Define el estado de una transferencia de tokens.
    -   `Pending`: Transferencia solicitada, pendiente de acción por el receptor.
    -   `Accepted`: El receptor ha aceptado los tokens.
    -   `Rejected`: El receptor ha rechazado los tokens.
-   **`TokenType`**: Diferencia entre los tipos de activos.
    -   `RowMaterial`: Materia prima.
    -   `FinishedProduct`: Producto terminado.

---

## 2. Structs (Estructuras de Datos)

-   **`User`**: Almacena la información de un usuario.
    -   `id`: Identificador único del usuario.
    -   `userAddress`: Dirección de la billetera del usuario.
    -   `role`: Rol asignado (`UserRole`).
    -   `status`: Estado actual del usuario (`UserStatus`).
-   **`Token`**: Representa un activo en la cadena de suministro.
    -   `id`: Identificador único del token.
    -   `creator`: Dirección del creador.
    -   `name`: Nombre del activo.
    -   `tokenType`: Tipo de token (`TokenType`).
    -   `totalSupply`: Cantidad total creada.
    -   `features`: Características del token (string en formato JSON).
    -   `parentId`: ID del token padre (para productos terminados).
    -   `dateCreated`: Timestamp de la creación.
    -   `balance`: Mapping que rastrea el saldo de este token para cada dirección.
-   **`Transfer`**: Modela una transferencia de tokens.
    -   `id`: Identificador único de la transferencia.
    -   `from`: Dirección del emisor.
    -   `to`: Dirección del receptor.
    -   `tokenId`: ID del token que se transfiere.
    -   `dateCreated`: Timestamp de la solicitud.
    -   `amount`: Cantidad de tokens transferidos.
    -   `status`: Estado de la transferencia (`TransferStatus`).

---

## 3. Funciones Principales

### Gestión de Ownership
-   **`initiateOwnershipTransfer(address newOwner)`**
    -   **@notice** Inicia la transferencia de propiedad del contrato a un nuevo candidato.
    -   **@dev** Solo el `owner` actual puede llamar a esta función. El `newOwner` debe aceptar para completar el proceso.
-   **`acceptOwnership()`**
    -   **@notice** El candidato a nuevo `owner` acepta la transferencia de propiedad.
    -   **@dev** Solo puede ser llamada por la dirección establecida como `pendingOwner`.

### Gestión de Pausabilidad
-   **`setPauseRole(address account, PauseRole role)`**
    -   **@notice** Asigna o revoca el rol de `Pauser` a una cuenta.
    -   **@dev** Solo el `owner` del contrato puede asignar roles.
-   **`pause()`**
    -   **@notice** Pausa las funciones críticas del contrato.
    -   **@dev** Solo el `owner` o una cuenta con rol `Pauser` puede ejecutarla.
-   **`unpause()`**
    -   **@notice** Reanuda la funcionalidad del contrato.
    -   **@dev** Solo el `owner` o una cuenta con rol `Pauser` puede ejecutarla.

### Gestión de Usuarios
-   **`requestUserRole(UserRole role)`**
    -   **@notice** Permite a cualquier usuario solicitar un rol en la plataforma.
    -   **@dev** Crea un nuevo usuario en estado `Pending` o actualiza la solicitud de uno existente.
-   **`changeStatusUser(address userAddress, UserStatus newStatus)`**
    -   **@notice** El `owner` del contrato cambia el estado de un usuario (aprobar, rechazar, etc.).
-   **`getUserInfo(address userAddress)` / `getUserInfoById(uint userId)`**
    -   **@notice** Devuelve la información completa de un usuario.

### Gestión de Tokens
-   **`createToken(...)`**
    -   **@notice** Crea un nuevo token (materia prima o producto terminado).
    -   **@param** `name`, `tokenType`, `totalSupply`, `features`, `parentId`.
    -   **@dev** Solo usuarios con roles `Producer` o `Factory` pueden crear tokens.
-   **`getToken(uint tokenId)`**
    -   **@notice** Devuelve la información completa de un token.
-   **`getTokenBalance(uint tokenId, address userAddress)`**
    -   **@notice** Consulta el saldo de un token específico para un usuario.

### Gestión de Transferencias
-   **`transfer(address to, uint tokenId, uint amount)`**
    -   **@notice** Solicita una transferencia de tokens, dejándola en estado `Pending`.
    -   **@dev** Usa `nonReentrant`. El receptor debe aceptar para completar.
-   **`acceptTransfer(uint transferId)`**
    -   **@notice** Acepta una transferencia pendiente.
    -   **@dev** Solo el destinatario puede llamar. Usa `nonReentrant`.
-   **`rejectTransfer(uint transferId)`**
    -   **@notice** Rechaza una transferencia pendiente, devolviendo los tokens al emisor.
    -   **@dev** Solo el destinatario puede llamar. Usa `nonReentrant`.
-   **`getTransfer(uint transferId)`**
    -   **@notice** Recupera el detalle completo de una transferencia.

---

## 4. Modificadores
-   **`onlyOwner`**: Restringe al `owner` del contrato.
-   **`onlyPauser`**: Restringe al `owner` o a una cuenta con rol `Pauser`.
-   **`whenNotPaused` / `whenPaused`**: Restringe la ejecución dependiendo del estado de pausa del contrato.
-   **`onlyTokenCreators`**: Permite acceso a `Producer` o `Factory` aprobados.
-   **`onlyTransfersAllowed`**: Permite a `Producer`, `Factory` o `Retailer` iniciar transferencias.
-   **`onlyReceiverAllowed`**: Permite a `Factory`, `Retailer` o `Consumer` aceptar/rechazar transferencias.

---

## 5. Eventos
- Se emiten eventos para cada acción significativa:
    - Cambios de estado de usuario (`UserStatusChanged`).
    - Creación de tokens (`TokenCreated`).
    - Solicitud, aceptación y rechazo de transferencias (`TransferRequested`, `TransferAccepted`, `TransferRejected`).
    - Cambios en la gestión de pausa y propiedad.

---

## 6. Recomendaciones Generales (del Análisis)
- **Limitaciones de Gas:** Funciones como `getUserTokens` y `getUserTransfers` usan bucles y pueden ser muy costosas. Se recomienda su uso solo para consultas off-chain.
- **Modularización:** Para contratos más complejos, considerar dividir la lógica en módulos separados (ej. `UserManager`, `TokenManager`).
- **Pruebas Unitarias:** Es crucial desarrollar un conjunto completo de pruebas unitarias para validar todos los flujos y casos límite.