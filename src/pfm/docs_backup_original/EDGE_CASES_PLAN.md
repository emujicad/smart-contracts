# 🎯 **PLAN DETALLADO: Edge Cases para Mejorar Branch Coverage**

## 📊 **Estado Actual: 36.73% → Meta: 65%+**

### **🔍 ANÁLISIS DE BRANCHES NO CUBIERTOS**

Basado en el análisis del código SupplyChain.sol, he identificado **23 branches críticos** no cubiertos que están afectando tu coverage. Aquí está el plan implementable paso a paso:

---

## **📝 FASE 1: EDGE CASES DE VALIDACIÓN (Prioridad ALTA)**

### **🔴 1.1 User Registration Edge Cases**
```solidity
// FILE: test/pfm/SupplyChain.t.sol
// AGREGAR estos tests:

// Edge Case 1: Owner intenta registrarse  
function testOwnerCannotRegisterAsUser() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
    vm.prank(owner);
    supplyChain.registerUser(UserRole.Producer);
}

// Edge Case 2: Registro con rol inválido (> 3)
function testInvalidRoleRegistration() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidRole.selector));
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole(4)); // Rol inexistente
}

// Edge Case 3: Usuario ya approved intenta re-registrarse  
function testApprovedUserCannotReregister() public {
    // Registrar y aprobar usuario
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    
    vm.prank(owner);
    supplyChain.approveUser(producer_address);
    
    // Intentar registrarse de nuevo
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.UserAlreadyApproved.selector));
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Factory);
}

// Edge Case 4: Usuario con status != Pending intenta cambiar rol
function testRejectedUserCannotChangeRole() public {
    // Registrar y rechazar usuario
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    
    vm.prank(owner);
    supplyChain.rejectUser(producer_address);
    
    // Intentar cambiar rol
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.UserNotPending.selector));
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Factory);
}
```

### **🔴 1.2 Token Creation Edge Cases**
```solidity
// Edge Case 5: Token con nombre vacío
function testCreateTokenEmptyName() public {
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    vm.prank(owner);
    supplyChain.approveUser(producer_address);
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidName.selector));
    vm.prank(producer_address);
    supplyChain.createToken("", TokenType.RawMaterial, 0, "features", 0);
}

// Edge Case 6: Token con totalSupply = 0
function testCreateTokenZeroSupply() public {
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    vm.prank(owner);
    supplyChain.approveUser(producer_address);
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidTotalSupply.selector));
    vm.prank(producer_address);
    supplyChain.createToken("Test", TokenType.RawMaterial, 0, "features", 0);
}

// Edge Case 7: Token con parentId inexistente
function testCreateTokenInvalidParent() public {
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    vm.prank(owner);
    supplyChain.approveUser(producer_address);
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.TokenDoesNotExist.selector));
    vm.prank(producer_address);
    supplyChain.createToken("Test", TokenType.RawMaterial, 100, "features", 999);
}

// Edge Case 8: Owner intenta crear token
function testOwnerCannotCreateToken() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(owner);
    supplyChain.createToken("Test", TokenType.RawMaterial, 100, "features", 0);
}
```

### **🔴 1.3 Transfer Edge Cases**
```solidity
// Edge Case 9: Transfer a address(0)
function testTransferToZeroAddress() public {
    // Setup user y token
    setupUserAndToken();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
    vm.prank(producer_address);
    supplyChain.transfer(address(0), 1, 10);
}

// Edge Case 10: Transfer amount = 0
function testTransferZeroAmount() public {
    setupUserAndToken();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAmount.selector));
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 0);
}

// Edge Case 11: Transfer token inexistente
function testTransferNonExistentToken() public {
    setupUserAndToken();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.TokenDoesNotExist.selector));
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 999, 10);
}

// Edge Case 12: Consumer intenta hacer transfer
function testConsumerCannotInitiateTransfer() public {
    // Setup consumer
    vm.prank(consumer_address);
    supplyChain.registerUser(UserRole.Consumer);
    vm.prank(owner);
    supplyChain.approveUser(consumer_address);
    
    setupUserAndToken();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.NoTransfersAllowed.selector));
    vm.prank(consumer_address);
    supplyChain.transfer(factory_address, 1, 10);
}
```

---

## **📝 FASE 2: EDGE CASES DE ESTADO Y AUTORIZACIÓN (Prioridad MEDIA)**

### **🟡 2.1 Pause Functionality Edge Cases**
```solidity
// Edge Case 13: User sin permisos intenta pausar
function testUnauthorizedUserCannotPause() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(producer_address);
    supplyChain.pause();
}

// Edge Case 14: Pausar cuando ya está pausado
function testCannotPauseWhenAlreadyPaused() public {
    vm.prank(owner);
    supplyChain.pause();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
    vm.prank(owner);
    supplyChain.pause();
}

// Edge Case 15: Despausar cuando no está pausado
function testCannotUnpauseWhenNotPaused() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractNotPaused.selector));
    vm.prank(owner);
    supplyChain.unpause();
}

// Edge Case 16: Operaciones durante pausa
function testOperationsFailWhenPaused() public {
    // Pausar contrato
    vm.prank(owner);
    supplyChain.pause();
    
    // Intentar registrar usuario
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
}
```

### **🟡 2.2 Ownership Transfer Edge Cases**
```solidity
// Edge Case 17: Transfer ownership a address(0)
function testTransferOwnershipToZeroAddress() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
    vm.prank(owner);
    supplyChain.transferOwnership(address(0));
}

// Edge Case 18: Usuario no autorizado intenta aceptar ownership
function testUnauthorizedAcceptOwnership() public {
    vm.prank(owner);
    supplyChain.transferOwnership(producer_address);
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(factory_address); // Wrong user
    supplyChain.acceptOwnership();
}

// Edge Case 19: Owner sin pending transfer intenta aceptar
function testAcceptOwnershipWithoutPendingTransfer() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(producer_address);
    supplyChain.acceptOwnership();
}
```

### **🟡 2.3 Transfer Status Edge Cases**
```solidity
// Edge Case 20: Accept transfer ya aceptado
function testAcceptAlreadyAcceptedTransfer() public {
    uint transferId = createPendingTransfer();
    
    // Aceptar transfer
    vm.prank(factory_address);
    supplyChain.acceptTransfer(transferId);
    
    // Intentar aceptar de nuevo
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.TransferNotPending.selector));
    vm.prank(factory_address);
    supplyChain.acceptTransfer(transferId);
}

// Edge Case 21: Reject transfer inexistente
function testRejectNonExistentTransfer() public {
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.TransferDoesNotExist.selector));
    vm.prank(factory_address);
    supplyChain.rejectTransfer(999);
}

// Edge Case 22: Usuario incorrecto intenta accept/reject
function testWrongUserAcceptTransfer() public {
    uint transferId = createPendingTransfer();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(retailer_address); // Wrong recipient
    supplyChain.acceptTransfer(transferId);
}
```

---

## **📝 FASE 3: EDGE CASES COMPLEJOS (Prioridad BAJA)**

### **🟢 3.1 Balance y Accounting Edge Cases**
```solidity
// Edge Case 23: Balance después de transfer cancelado
function testBalanceAfterCancelTransfer() public {
    uint transferId = createPendingTransfer();
    uint initialBalance = supplyChain.getTokenBalance(1, producer_address);
    
    // Cancelar transfer
    vm.prank(producer_address);
    supplyChain.cancelTransfer(transferId);
    
    // Verificar que balance se restauró
    uint finalBalance = supplyChain.getTokenBalance(1, producer_address);
    assertEq(finalBalance, initialBalance + 50); // Cantidad del transfer
}

// Helper function para setup común
function setupUserAndToken() internal {
    vm.prank(producer_address);
    supplyChain.registerUser(UserRole.Producer);
    vm.prank(owner);
    supplyChain.approveUser(producer_address);
    
    vm.prank(factory_address);
    supplyChain.registerUser(UserRole.Factory);
    vm.prank(owner);
    supplyChain.approveUser(factory_address);
    
    vm.prank(producer_address);
    supplyChain.createToken("Test Token", TokenType.RawMaterial, 1000, "features", 0);
}

function createPendingTransfer() internal returns (uint) {
    setupUserAndToken();
    
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 50);
    
    return 1; // First transfer ID
}
```

---

## **⚡ IMPLEMENTACIÓN RÁPIDA**

### **🎯 Orden de Implementación:**

1. **SEMANA 1**: Implementar Edge Cases 1-8 (Validación básica)
2. **SEMANA 2**: Implementar Edge Cases 9-16 (Estados y autorización)
3. **SEMANA 3**: Implementar Edge Cases 17-23 (Casos complejos)

### **📊 Expectativa de Mejora:**

- **Después FASE 1**: ~45-50% branch coverage
- **Después FASE 2**: ~55-60% branch coverage  
- **Después FASE 3**: ~65-70% branch coverage

### **🔧 Comandos para Testing:**

```bash
# Test específico
forge test --match-test testOwnerCannotRegisterAsUser -vv

# Coverage después de cada fase
./src/pfm/coverage-reporter-simple.sh

# Test todos los edge cases nuevos
forge test --match-path test/pfm/SupplyChain.t.sol --match-test "testInvalid|testUnauthorized|testCannot" -vv
```

---

## **💡 TIPS IMPORTANTES:**

1. **Implementa gradualmente** - No todos a la vez
2. **Verifica coverage** después de cada grupo de tests
3. **Mantén consistencia** en nomenclatura de tests
4. **Documenta cada edge case** que cubres
5. **Focus en branches** con mayor impacto en seguridad

**¿Por dónde empezar?** Implementa primero los **Edge Cases 1-4** (User Registration) ya que son fundamentales y fáciles de implementar.