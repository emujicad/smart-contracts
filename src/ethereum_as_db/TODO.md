# TODO - Mejoras para `e-commerce.sol`

Este documento recopila futuras extensiones y mejoras para el contrato `e-commerce.sol`. Las tareas de refactorización, seguridad y mejora de la API iniciales ya han sido implementadas.

---

## P4 — Posibles extensiones de pago

*   **Contexto**: Actualmente, el contrato solo registra datos y no maneja fondos para mantener su enfoque educativo simple. Estas tareas solo aplicarían si se decide extender el contrato para procesar pagos reales.

- [ ] **Soporte de pagos nativos o ERC-20**
  - **Acción**: Modificar `facturaCrear` para que sea `payable` y acepte la criptomoneda nativa, o para que maneje transferencias de un token ERC-20.
  - **Consideraciones**: Se debería aplicar el patrón de seguridad "Checks-Effects-Interactions" y usar un protector contra reentrada (`ReentrancyGuard`) si se realizan llamadas a otros contratos.

- [ ] **Moneda y decimales**
  - **Acción**: Documentar claramente la unidad monetaria (ej. `wei`) y el número de decimales esperados en los precios para evitar errores de cálculo.

## P7 — Pruebas y Herramientas

- [ ] **Tests unitarios y de integración**
  - **Acción**: Crear un conjunto de pruebas (usando Hardhat/Foundry) que cubra todos los flujos del contrato:
    - Creación y actualización de empresas.
    - Permisos y roles (propietario del contrato vs. admin de empresa).
    - Creación, actualización y eliminación de productos (incluyendo la prevención de duplicados).
    - Creación, anulación y restauración de facturas.
    - Fallos esperados (intentar acciones sin permisos, con datos inválidos, etc.).

- [ ] **Scripts de despliegue y uso**
  - **Acción**: Añadir scripts que demuestren los flujos de uso más comunes del contrato, como registrar una empresa, añadirle productos, emitir una factura y consultar los datos.

## P8 — Seguridad y Control de Acceso (Avanzado)

- [ ] **Implementar Control de Acceso Basado en Roles (RBAC)**
  - **Acción**: En lugar de un único `adminEmpresa`, se podría crear un sistema de roles más granular. Por ejemplo, un rol `EDITOR_PRODUCTOS` que solo puede gestionar el catálogo y un rol `CONTADOR` que solo puede gestionar facturas.
  - **Consideraciones**: Se puede implementar usando la librería de `AccessControl.sol` de OpenZeppelin, que es un estándar en la industria.

- [ ] **Hacer el Contrato "Pausable"**
  - **Acción**: Añadir una funcionalidad de emergencia que permita al `propietarioContracto` pausar todas las funciones que modifican el estado (como crear productos o facturas) en caso de que se descubra una vulnerabilidad.
  - **Consideraciones**: Esto es un patrón de seguridad muy común. La librería `Pausable.sol` de OpenZeppelin facilita enormemente su implementación.

- [ ] **Permitir la Transferencia de Propiedad del Contrato**
  - **Acción**: El `propietarioContracto` actual está fijado en el constructor. Se debería añadir una función para que el propietario actual pueda transferir su rol a una nueva dirección.
  - **Consideraciones**: La librería `Ownable.sol` de OpenZeppelin es la solución estándar para esto.

## P9 — Nuevas Funcionalidades de Negocio

- [ ] **Añadir Gestión de Inventario (Stock)**
  - **Acción**: Añadir un campo `uint256 stock;` a la `struct Producto`. La función `facturaCrear` debería modificarse para aceptar una lista de productos y cantidades, y debería descontar el stock correspondiente.
  - **Consideraciones**: Esto haría el contrato mucho más potente, pero también más complejo, ya que `facturaCrear` necesitaría recibir un array de productos.

- [ ] **Detallar el Contenido de las Facturas**
  - **Acción**: Actualmente, la `Factura` solo guarda un `importeTotal`. Se podría crear una `struct FacturaItem { uint256 idProducto; uint256 cantidad; }` y añadir un array `FacturaItem[] items;` a la `struct Factura`.
  - **Consideraciones**: Esto proporcionaría un registro on-chain completo de cada venta, pero incrementaría significativamente el coste de gas al crear facturas.

- [ ] **Funciones para Operaciones por Lotes (Batch)**
  - **Acción**: Crear funciones como `productosCrearBatch` que acepten un array de productos para crearlos todos en una sola transacción.
  - **Consideraciones**: Muy útil para la carga inicial de datos o para administradores que gestionan grandes catálogos, ya que ahorra gas en comparación con hacer múltiples llamadas individuales.

## P10 — Optimización de Gas (Avanzado)

- [x] **Evaluar "Struct Packing"**
  - **Acción**: Analizar si los campos de las `structs` se pueden reorganizar o reducir de tamaño (ej. `uint256` a `uint128`) para que el compilador pueda empaquetarlos en menos slots de almacenamiento. Por ejemplo, `EstatusProducto` y `existeProducto` podrían caber en un solo slot junto a otro dato.
  - **Resultado**: Se ha determinado que las `structs` `Producto` y `Empresa` ya están óptimamente empaquetadas dadas sus definiciones de tipos actuales. La reducción de `uint256` a `uint128` para `precio` en `Producto` no ahorraría un slot de almacenamiento debido a la presencia del campo `bytes32 imagen`.
  - **Consideraciones**: Es una técnica de optimización avanzada que puede ahorrar gas en contratos con muchísimos datos.