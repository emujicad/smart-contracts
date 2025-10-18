# Interfaz IERC20

Este archivo define la interfaz para el estándar de token ERC20. Incluye las seis funciones obligatorias que cualquier token ERC20 debe implementar:

*   `totalSupply()`
*   `balanceOf(address account)`
*   `transfer(address recipient, uint256 amount)`
*   `allowance(address owner, address spender)`
*   `approve(address spender, uint256 amount)`
*   `transferFrom(address sender, address recipient, uint256 amount)`

También define dos eventos, `Transfer` y `Approval`, que se emiten cuando se transfieren o aprueban tokens.

Esta interfaz se utiliza en los archivos de prueba para interactuar con tokens ERC20, como el token DAI en la prueba `forkDai.sol`.