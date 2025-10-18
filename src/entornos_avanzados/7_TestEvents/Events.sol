// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

contract CEvents {
    // This declares a new smart contract named 'CEvents'.
    // This contract demonstrates the use of 'events' in Solidity.
    // Events are a way for your smart contracts to communicate with the outside world (e.g., web applications, blockchain explorers).
    // They are essentially logs that are stored on the blockchain and can be efficiently searched and listened to by off-chain applications.

    event Transfer(address indexed from, address indexed to, uint256 amount);
    // This declares an event named 'Transfer'.
    // Events are defined with the 'event' keyword, followed by the event name and a list of parameters.
    // 'address indexed from': 'address' is a type for Ethereum addresses. 'indexed' means this parameter will be indexed,
    // making it searchable in blockchain logs. This is useful for filtering events.
    // 'address indexed to': Another indexed address parameter.
    // 'uint256 amount': A non-indexed unsigned integer parameter for the amount.
    // Events are crucial for building user interfaces that react to smart contract actions without constantly polling the blockchain state.

    function transferOnce(address _from, address _to, uint256 _amount) public {
        // This function demonstrates emitting a single event.
        // 'public' means this function can be called from anywhere.
        // It takes three arguments: a sender address, a recipient address, and an amount.

        emit Transfer(_from, _to, _amount);
        // The 'emit' keyword is used to trigger an event.
        // When this line is executed, a 'Transfer' event will be logged on the blockchain
        // with the provided '_from', '_to', and '_amount' values.
        // This is a very common pattern in ERC-20 token contracts to signal token transfers.
    }

    function transferMany(address _from, address[] calldata _to, uint256[] calldata _amounts) public {
        // This function demonstrates emitting multiple events in a loop.
        // 'address[] calldata _to': An array of recipient addresses. 'calldata' is a data location
        // that means the data is passed as a read-only reference from the transaction call data.
        // It's more gas-efficient for external function arguments than 'memory'.
        // 'uint256[] calldata _amounts': An array of amounts corresponding to each recipient.

        // The commented out line below is a good practice to ensure array lengths match,
        // preventing potential errors if the input arrays are not of the same size.
        // require(_to.length == _amounts.length, "Mismatched arrays");

        for (uint256 i = 0; i < _to.length; i++) {
            // This loop iterates through the arrays of recipients and amounts.
            emit Transfer(_from, _to[i], _amounts[i]);
            // For each iteration, a 'Transfer' event is emitted, logging a transfer
            // from '_from' to a specific recipient '_to[i]' with a specific amount '_amounts[i]'.
            // This shows how events can be used to log a series of related actions.
        }
    }
}
