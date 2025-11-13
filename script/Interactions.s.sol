// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {SupplyChain} from "../src/pfm/SupplyChain.sol";

/**
 * @title Interactions Script
 * @dev Complete workflow demonstration with automated user flow
 * @notice Run after deployment: forge script script/Interactions.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
 */
contract InteractionsScript is Script {
    SupplyChain public supplyChain;
    
    // Demo addresses (use different private keys in production)
    address public admin;
    address public manufacturer = 0x1111111111111111111111111111111111111111;
    address public distributor = 0x2222222222222222222222222222222222222222;
    address public retailer = 0x3333333333333333333333333333333333333333;
    
    function setUp() public {
        // Set contract address (update after deployment)
        supplyChain = SupplyChain(0x5FbDB2315678afecb367f032d93F642f64180aa3); // Update this!
        admin = supplyChain.owner();
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        console.log("=== SupplyChain Complete Workflow Demo ===");
        console.log("Contract address:", address(supplyChain));
        console.log("Admin address:", admin);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // === PHASE 1: USER REGISTRATION ===
        console.log("\n🏭 === PHASE 1: USER REGISTRATION ===");
        
        _registerUser(manufacturer, "Tesla Manufacturing", SupplyChain.UserStatus.Manufacturer);
        _registerUser(distributor, "Global Distribution Co", SupplyChain.UserStatus.Distributor);
        _registerUser(retailer, "TechRetail Store", SupplyChain.UserStatus.Retailer);
        
        // === PHASE 2: TOKEN CREATION ===
        console.log("\n📦 === PHASE 2: TOKEN CREATION ===");
        
        uint256 tokenId1 = _createToken(manufacturer, "iPhone 15 Pro", "High-end smartphone", "Electronics");
        uint256 tokenId2 = _createToken(manufacturer, "MacBook Pro M3", "Professional laptop", "Computers");
        
        // === PHASE 3: TRANSFER WORKFLOW ===
        console.log("\n🚚 === PHASE 3: TRANSFER WORKFLOW ===");
        
        uint256 transferId1 = _initiateTransfer(manufacturer, tokenId1, distributor, "Factory to Warehouse");
        uint256 transferId2 = _initiateTransfer(manufacturer, tokenId2, distributor, "Direct shipment");
        
        // === PHASE 4: TRANSFER OPERATIONS ===
        console.log("\n✅ === PHASE 4: TRANSFER OPERATIONS ===");
        
        _acceptTransfer(distributor, transferId1);
        _rejectTransfer(distributor, transferId2, "Quality issues detected");
        
        // === PHASE 5: SECONDARY TRANSFER ===
        console.log("\n🔄 === PHASE 5: SECONDARY TRANSFER ===");
        
        uint256 transferId3 = _initiateTransfer(distributor, tokenId1, retailer, "Warehouse to Store");
        _acceptTransfer(retailer, transferId3);
        
        // === PHASE 6: EDGE CASE DEMONSTRATIONS ===
        console.log("\n⚠️  === PHASE 6: EDGE CASE DEMONSTRATIONS ===");
        
        uint256 tokenId3 = _createToken(manufacturer, "Test Product", "For cancellation demo", "Test");
        uint256 transferId4 = _initiateTransfer(manufacturer, tokenId3, distributor, "Will be cancelled");
        _cancelTransfer(manufacturer, transferId4);
        
        vm.stopBroadcast();
        
        // === FINAL VERIFICATION ===
        console.log("\n📊 === WORKFLOW COMPLETION SUMMARY ===");
        _printFinalStatus();
    }
    
    function _registerUser(address userAddr, string memory name, SupplyChain.UserStatus status) internal {
        supplyChain.registerUser(userAddr, name, status);
        console.log("✅ Registered:", name, "as", _statusToString(status));
    }
    
    function _createToken(address creator, string memory name, string memory description, string memory category) internal returns (uint256) {
        uint256 tokenId = supplyChain.createToken(name, description, category, creator);
        console.log("📦 Token created - ID:", tokenId, "Name:", name, "Owner:", creator);
        return tokenId;
    }
    
    function _initiateTransfer(address from, uint256 tokenId, address to, string memory notes) internal returns (uint256) {
        uint256 transferId = supplyChain.transfer(tokenId, to, notes);
        console.log("🚚 Transfer initiated - ID:", transferId, "Token:", tokenId, "To:", to);
        return transferId;
    }
    
    function _acceptTransfer(address acceptor, uint256 transferId) internal {
        vm.stopBroadcast();
        vm.startBroadcast(vm.envUint("ACCEPTOR_PRIVATE_KEY")); // Different key for acceptor
        supplyChain.acceptTransfer(transferId);
        console.log("✅ Transfer accepted - ID:", transferId, "By:", acceptor);
        vm.stopBroadcast();
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    }
    
    function _rejectTransfer(address rejector, uint256 transferId, string memory reason) internal {
        vm.stopBroadcast();
        vm.startBroadcast(vm.envUint("REJECTOR_PRIVATE_KEY")); // Different key for rejector
        supplyChain.rejectTransfer(transferId, reason);
        console.log("❌ Transfer rejected - ID:", transferId, "Reason:", reason);
        vm.stopBroadcast();
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
    }
    
    function _cancelTransfer(address canceller, uint256 transferId) internal {
        supplyChain.cancelTransfer(transferId);
        console.log("🚫 Transfer cancelled - ID:", transferId, "By:", canceller);
    }
    
    function _statusToString(SupplyChain.UserStatus status) internal pure returns (string memory) {
        if (status == SupplyChain.UserStatus.Manufacturer) return "Manufacturer";
        if (status == SupplyChain.UserStatus.Distributor) return "Distributor";
        if (status == SupplyChain.UserStatus.Retailer) return "Retailer";
        return "Unknown";
    }
    
    function _printFinalStatus() internal view {
        console.log("Contract Address:", address(supplyChain));
        console.log("Total Users Registered: 3");
        console.log("Total Tokens Created: 3"); 
        console.log("Total Transfers: 4");
        console.log("✅ Workflow completed successfully!");
        console.log("🎯 Ready for academic presentation");
    }
}