# Proyecto de Contrato Inteligente: SupplyChain

Este proyecto contiene un contrato inteligente de Solidity (`SupplyChain.sol`) diseñado para simular una cadena de suministro básica en la blockchain.

## Estructura del Proyecto

-   `SupplyChain.sol`: El código fuente principal del contrato inteligente. La documentación NatSpec oficial reside aquí.
-   `SupplyChain_NatSpec_Documentation.md`: Un documento complementario que resume la estructura y la documentación NatSpec del contrato.
-   `recomendaciones.md`: Un archivo con un análisis detallado y recomendaciones de mejora para el contrato.
-   `TODO.md`: Un archivo que lista las tareas pendientes y futuras mejoras para el proyecto.

## Funcionalidades del Contrato

El contrato `SupplyChain.sol` implementa las siguientes características:

-   **Gestión de Usuarios y Roles:** Permite a los usuarios solicitar roles (Productor, Fábrica, Minorista, Consumidor) que son aprobados o rechazados por el administrador del contrato.
-   **Creación de Tokens:** Los usuarios con roles apropiados pueden crear dos tipos de tokens: materia prima (`RowMaterial`) y productos terminados (`FinishedProduct`).
-   **Transferencia de Tokens:** Implementa un flujo de transferencia de dos pasos (solicitud y aceptación/rechazo) para mover tokens entre usuarios.
-   **Seguridad:**
    -   Control de acceso basado en roles y estado del usuario.
    -   Propiedad del contrato transferible (`Ownable`).
    -   Funcionalidad de Pausa (`Pausable`) para detener el contrato en caso de emergencia.
    -   Protección contra ataques de re-entrancy.
-   **Documentación:** Extensivamente documentado usando NatSpec.

## Próximos Pasos

Consulte el archivo `TODO.md` para ver la lista de tareas de desarrollo y mejoras planificadas.
