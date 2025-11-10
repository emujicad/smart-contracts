# Guía para la Limpieza de Código en `SupplyChain.sol`

Este archivo contiene una serie de recomendaciones para eliminar código comentado, borradores y elementos obsoletos del contrato `SupplyChain.sol`. El objetivo es mejorar la legibilidad y facilitar el mantenimiento futuro del código.

---

### 1. Eliminar Comentarios de Módulos Futuros

Al inicio del contrato, existen comentarios sobre una futura modularización.

**Código a Eliminar:**
```solidity
// FUTURE TODO: dividir en módulos
// import "./UserManager.sol";
// import "./TokenManager.sol";
// import "./TransferManager.sol";
// import "./AccessControl.sol";
```

**Recomendación:**
Dado que estos módulos no están implementados, estos comentarios pueden eliminarse para limpiar la cabecera del archivo. La tarea "dividir en módulos" ya debería estar registrada en `TODO.md` como una mejora a futuro.

---

### 2. Eliminar Definiciones de Eventos Antiguos

Existen definiciones de eventos que fueron reemplazadas por versiones más detalladas.

**Código a Eliminar:**
```solidity
//event UserStatusChanged(address indexed user, UserStatus status); // Evento de cambio de estado de usuario
```
y
```solidity
//event TokenCreated(uint256 indexed tokenId, address indexed creator, string name, uint256 totalSupply); // Evento de creación de token
```

**Recomendación:**
Estos eventos ya no se utilizan. Eliminarlos hará que la sección de eventos sea más clara y concisa.

---

### 3. Eliminar `require` Comentados

A lo largo del contrato, hay muchas sentencias `require` que fueron reemplazadas por la lógica `if/revert` con errores personalizados.

**Ejemplos de Código a Eliminar:**
```solidity
// En el modifier onlyTokenCreators:
//require((user.role == UserRole.Producer || user.role == UserRole.Factory) && user.status == UserStatus.Approved, "Sin permisos para crear tokens");  

// En la función transfer:
//require(senderBalance >= amount, "Saldo insuficiente para transferencia");

// En la función acceptTransfer:
//require(transferItem.status == TransferStatus.Pending, "Transfer not pending");
//require(transferItem.to == msg.sender, "Solo receptor puede aceptar transferencias");
```

**Recomendación:**
Ahora que la nueva lógica está implementada y validada, estos comentarios son "deuda técnica". Se recomienda eliminarlos todos para despejar el cuerpo de las funciones y mejorar drásticamente la legibilidad.

---

### 4. Eliminar Implementaciones Alternativas Comentadas

Al final del contrato, existe una implementación alternativa de la función `getUserTransfers` que está completamente comentada.

**Código a Eliminar:**
```solidity
/*
function getUserTransfers(address userAddress) public view returns (uint[] memory) {
    uint[] memory userTransfers = new uint[](userTransferCount[userAddress]);
    uint index = 0;
    for (uint i = 1; i < nextTransferId; i++) {
        if (transfers[i].from == userAddress || transfers[i].to == userAddress) {
            userTransfers[index] = i;
            index++;
        }
    }
    return userTransfers;
}
*/
```

**Recomendación:**
La implementación actual de `getUserTransfers` es más robusta. Este bloque comentado puede eliminarse por completo.

---

### 5. Eliminar Líneas de Código Obsoletas Dentro de Funciones

Algunas funciones todavía contienen líneas de código comentadas de versiones anteriores de la lógica.

**Ejemplos de Código a Eliminar:**

En `requestUserRole`:
```solidity
//users[nextUserId] = User(nextUserId, msg.sender, role, UserStatus.Pending);
```

En `changeStatusUser`:
```solidity
// userId = addressToUserId[userAddress]; 
```

**Recomendación:**
Estas líneas ya no son necesarias y pueden eliminarse para simplificar el código.
