# 🎯 **FASE 3: EDGE CASES DIRIGIDOS A BRANCHES NO CUBIERTOS**

*Análisis específico de branches para alcanzar 65%+ coverage*

---

## 🔬 **BRANCHES IDENTIFICADOS NO CUBIERTOS**

### **📊 Análisis Sistemático:**
- **Total Branches**: 49 
- **Cubiertos Actualmente**: 18 (36.73%)
- **Pendientes**: 31 branches
- **Meta**: Cubrir 15-20 branches adicionales (50-65% coverage)

---

## 🎯 **EDGE CASES FASE 3 ESPECÍFICOS**

### **🔑 1. OWNERSHIP TRANSFER EDGE CASES (5 branches)**

#### **Edge Case 17: Transfer Ownership a Address(0)**
```solidity
function testTransferOwnershipToZeroAddress() public {
    // Branch: if (newOwner == address(0)) revert InvalidAddress();
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
    supplyChain.initiateOwnershipTransfer(address(0));
}
```
**Branch objetivo**: Línea 467 - Address validation en ownership transfer

#### **Edge Case 18: Accept Ownership Sin Pending Transfer**
```solidity
function testAcceptOwnershipWithoutPending() public {
    // Branch: if (msg.sender != pendingOwner) revert Unauthorized();
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
    vm.prank(producer_address);
    supplyChain.acceptOwnership();
}
```
**Branch objetivo**: Línea 478 - Pending owner validation

#### **Edge Case 19: Ownership Transfer Mientras Pausado**
```solidity
function testOwnershipTransferWhilePaused() public {
    supplyChain.pause();
    
    vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
    supplyChain.initiateOwnershipTransfer(producer_address);
}
```
**Branch objetivo**: whenNotPaused en initiateOwnershipTransfer

### **🔄 2. USER STATUS COMPLEX EDGE CASES (4 branches)**

#### **Edge Case 20: User Status Transition Edge**
```solidity
function testUserStatusNotPendingToRoleChange() public {
    // Setup: User con status diferente a Pending
    vm.prank(producer_address);
    supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
    
    // Cambiar a Approved
    supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
    
    // Cambiar a Rejected
    supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Rejected);
    
    // Ahora intentar cambiar rol - debe pasar por el branch: if (user.status != UserStatus.Pending)
    vm.prank(producer_address);
    supplyChain.requestUserRole(SupplyChain.UserRole.Factory);
}
```
**Branch objetivo**: Líneas 521-523 - Status transition logic

#### **Edge Case 21: Role Validation Boundary**
```solidity
function testInvalidRoleBoundary() public {
    // No se puede testear directamente uint(role) > 3 porque Solidity valida en compile time
    // Pero podemos testear el boundary máximo válido
    vm.prank(producer_address);
    supplyChain.requestUserRole(SupplyChain.UserRole.Consumer); // rol 3, máximo válido
    
    assertTrue(supplyChain.addressToUserId(producer_address) != 0);
}
```
**Branch objetivo**: Línea 504 - Role boundary validation (indirecto)

### **📦 3. TOKEN BALANCE EDGE CASES (3 branches)**

#### **Edge Case 22: Token Balance Zero After Transfer**
```solidity
function testTokenBalanceZeroAfterTransfer() public {
    _setupUserAndToken();
    
    // Transfer todo el balance
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 1000); // All tokens
    
    // Accept transfer
    vm.prank(factory_address);
    supplyChain.acceptTransfer(1);
    
    // Branch objetivo: if (token.balance[transferItem.from] == 0 && userTokenCount[transferItem.from] > 0)
    assertEq(supplyChain.getTokenBalance(1, producer_address), 0);
}
```
**Branch objetivo**: Línea 764 - Balance zero after transfer

#### **Edge Case 23: First Token Receipt**
```solidity  
function testFirstTokenReceipt() public {
    _setupUserAndToken();
    
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 100);
    
    vm.prank(factory_address);
    supplyChain.acceptTransfer(1);
    
    // Branch objetivo: if (token.balance[transferItem.to] == transferItem.amount)
    assertEq(supplyChain.getTokenBalance(1, factory_address), 100);
}
```
**Branch objetivo**: Línea 769 - First token receipt logic

### **🔄 4. TRANSFER STATUS COMPLEX SCENARIOS (3 branches)**

#### **Edge Case 24: Cancel Transfer Sender Balance Edge**
```solidity
function testCancelTransferSenderBalanceEdge() public {
    _setupUserAndToken();
    
    // Transfer parcial
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 100);
    
    // Cancel transfer - debería restaurar balance
    vm.prank(producer_address); 
    supplyChain.cancelTransfer(1);
    
    // Branch objetivo: if (senderHadZeroBefore) - línea 808
    assertEq(supplyChain.getTokenBalance(1, producer_address), 1000);
}
```

#### **Edge Case 25: Reject Transfer Balance Logic**
```solidity
function testRejectTransferBalanceLogic() public {
    _setupUserAndToken();
    
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 100);
    
    // Reject as receiver
    vm.prank(factory_address);
    supplyChain.rejectTransfer(1);
    
    // Branch objetivo: if (senderHadZeroBefore) - línea 842 en rejectTransfer
    assertEq(supplyChain.getTokenBalance(1, producer_address), 1000);
}
```

### **📋 5. ARRAY FILTERING EDGE CASES (2 branches)**

#### **Edge Case 26: getUserTokens con Balance Zero**
```solidity
function testGetUserTokensWithZeroBalance() public {
    _setupUserAndToken();
    
    // Transfer todo
    vm.prank(producer_address);
    supplyChain.transfer(factory_address, 1, 1000);
    
    vm.prank(factory_address);
    supplyChain.acceptTransfer(1);
    
    // Branch objetivo: if (tokens[i].balance[userAddress] > 0) - línea 885
    uint256[] memory tokens = supplyChain.getUserTokens(producer_address);
    assertEq(tokens.length, 0);
}
```

---

## 🎯 **RESUMEN FASE 3**

### **📈 IMPACTO ESPERADO**
- **Edge Cases a implementar**: 10 específicos
- **Branches objetivo**: 15-20 nuevos branches cubiertos
- **Coverage esperado**: 50-65% branches (vs 36.73% actual)
- **Tests finales**: 77 tests (67 actuales + 10 nuevos)

### **🔧 FUNCIONALIDADES CUBIERTAS**
- ✅ **Ownership Transfer**: Address validation, pending states
- ✅ **User Status Transitions**: Complex status changes
- ✅ **Token Balance Logic**: Zero balance scenarios
- ✅ **Transfer Status**: Complex acceptance/rejection logic
- ✅ **Array Filtering**: Edge cases en getUserTokens

### **⚡ ORDEN DE IMPLEMENTACIÓN**
1. **Ownership Transfer** (Edge Cases 17-19) - 3 tests
2. **User Status Complex** (Edge Cases 20-21) - 2 tests  
3. **Token Balance** (Edge Cases 22-23) - 2 tests
4. **Transfer Status** (Edge Cases 24-25) - 2 tests
5. **Array Filtering** (Edge Case 26) - 1 test

**Total**: 10 edge cases dirigidos específicamente a branches no cubiertos