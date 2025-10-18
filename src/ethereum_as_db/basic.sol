pragma solidity >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT
//import "hardhat/console.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelincontracts/blob/master/contracts/access/Ownable.sol
contract Basic {
    uint256 public balance = 5;

    function increment() public {
        balance = balance + 1;
    }

    function decrement() public {
        balance = balance - 1;
    }
}
