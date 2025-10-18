// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
/*
La función keccak256 en Solidity se utiliza para calcular el hash Keccak-256 de una entrada dada.
_____________________________________________________________________________________
|                KECCAK256
|_____________________________________________________________________________________
|       keccak256(<values>);
|
|Para calcular el hash con keccak256() hay que usar abi.encodePacked() para pasar los argumentos a tipo byte
|_____________________________________________________________________________________
|        KECCAK256 Y ABI.ENCODEPACKED
|_____________________________________________________________________________________
|   //Para poder usar la función abi.encodePacked() 
|   pragma abicoder v2;
|   
|   contract <nombre_contrato> {
|       // Funcion Cómputo del hash
|       function test() public pure returns (bytes32){
|           keccak256 ( abi.encodePacked (<values>));
|   }
|   }
*/

pragma abicoder v2;

contract testKeccad256 {

    // Function basica para testear un hash
    function testHash() public pure returns(bytes32) {
        return keccak256(abi.encodePacked("Test String"));
    }
    // Function basica para testear un hash personalizado
    function testPersonalHash(string memory _string) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_string));
    }
    // Function to validate/compare string
    function CompareString(string memory _string1, string memory _string2) public pure returns(bool) {
        if ( keccak256(abi.encodePacked(_string1)) == keccak256(abi.encodePacked(_string2))) {
            return true;
        }
        else {
            return false;
        }
                   
    }
}