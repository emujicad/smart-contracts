# TODO - Mejoras y Próximos Pasos para SupplyChain Contract

Este archivo se basa en el análisis inicial y las recomendaciones generadas en `recomendaciones.md`.

## Crítico / Próximos Pasos

- [ ] **Refactorizar `require` a Errores Personalizados:** Reemplazar todos los `require` con mensajes de texto por condicionales `if` y `revert` con errores personalizados para optimizar gas y mejorar la legibilidad. (Ver guía detallada en `recomendaciones.md`).
- [ ] **Fijar Versión del Compilador:** Cambiar `pragma solidity ^0.8.13;` a una versión fija (ej. `pragma solidity 0.8.24;`) para garantizar la estabilidad y previsibilidad del contrato.
- [ ] **Añadir Advertencias de Gas en Funciones con Bucles:** Actualizar la documentación NatSpec de `getUserTokens` y `getUserTransfers` para advertir explícitamente que son funciones de alto coste de gas y no deben ser llamadas en transacciones on-chain a gran escala.
- [ ] **Revisar Visibilidad de Funciones:** Cambiar la visibilidad de `public` a `external` en funciones que solo se llaman desde fuera del contrato (ej. `requestUserRole`, `createToken`) para optimizar gas.

## Nuevas Funcionalidades Sugeridas

- [ ] **Implementar `cancelTransfer`:** Añadir una función que permita al *emisor* de una transferencia cancelarla mientras esté en estado `Pending`.
- [ ] **(Opcional) Implementar Transferencias por Lote:** Considerar una función `transferBatch` para permitir múltiples transferencias en una sola transacción, reduciendo costes de gas para los usuarios.
- [ ] **(Opcional) Implementar `burn`:** Considerar una función para "quemar" (destruir) tokens, reduciendo el `totalSupply`.

## Tareas Originales (Revisadas)

- [ ] **Optimización de Listas de Usuario:** Investigar una forma más eficiente que los bucles para obtener los tokens/transferencias de un usuario on-chain. El `mapping(address => uint256[]) userTokensList` es una opción, pero su mantenimiento puede ser costoso. La mejor práctica sigue siendo la indexación off-chain a través de eventos.
- [x] **Flujo de Transferencia Completo:** Las funciones `transfer`, `acceptTransfer`, y `rejectTransfer` están implementadas con `nonReentrant`.
- [x] **Gestión de Ownership:** Transferencia de `owner` en dos pasos implementada y con getter para `pendingOwner`.
- [x] **Pausabilidad con Roles:** Implementada con `onlyPauser` y eventos `Paused`/`Unpaused`.
- [ ] **Pruebas Unitarias:** Añadir pruebas unitarias robustas para todos los fluegos, especialmente los casos límite y los modificadores de seguridad.
- [ ] **Almacenamiento Off-chain:** Evaluar mover datos pesados como el campo `features` (string JSON) a un sistema de almacenamiento off-chain como IPFS para reducir drásticamente los costos de gas en la creación de tokens.
- [ ] **Limpieza de Código:** Limpiar código comentado o finalizar funciones y módulos en borrador o sin uso.

---
