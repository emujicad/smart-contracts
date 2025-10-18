// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title UserCrud
 * @author @emujicad
 * @notice Implements a UserCrud contract for basic Create, Read, Update, and
 * Delete (CRUD) operations on a User structure.
 * @dev Allows creating, reading, updating, and "deleting" (deactivating) users.
 * @dev Includes a function to get all active users.
 */

contract UserCrud {
    // Structure to define what a User looks like in our smart contract
    // Think of this as a blueprint for user data
    struct User {
        uint256 id;        // Unique identifier for each user (like a database ID)
        string name;       // User's name stored as text
        uint256 age;       // User's age as a whole number
        bool isActive;     // Flag to check if user is active (true) or deleted (false)
    }

    // Mapping stores user data efficiently - think of it as a dictionary
    // where the key is a number (ID) and value is a User struct
    mapping(uint256 => User) private users;

    // Counter to assign unique IDs to new users
    // Private means only this contract can access it
    uint256 private nextId;

    // Events are like notifications that get logged on the blockchain
    // Other applications can listen for these events to know when something happens
    event UserCreated(uint256 id, string name, uint256 age);
    event UserUpdated(uint256 id, string name, uint256 age);
    event UserDeleted(uint256 id);

    // CREATE: Function to add a new user to our system
    // 'memory' means the name parameter is temporarily stored during function execution
    function createUser(string memory _name, uint256 _age) public {
        // Create a new user with current nextId and set as active
        users[nextId] = User(nextId, _name, _age, true);
        // Emit an event to notify that a user was created
        emit UserCreated(nextId, _name, _age);
        // Increment the counter for the next user
        nextId++;
    }

    // READ: Function to get a user's information by their ID
    // 'view' means this function only reads data, doesn't modify anything
    // 'returns' tells us what type of data this function gives back
    function readUser(uint256 _id) public view returns (User memory) {
        // Check if the user ID exists in our system
        require(_id < nextId, "Error: User does not exist");
        // Check if the user is still active (not deleted)
        require(users[_id].isActive, "Error: User is inactive");
        // Return the user's data
        return users[_id];
    }

    // UPDATE: Function to modify existing user information
    function updateUser(uint256 _id, string memory _name, uint256 _age) public {
        // Verify the user exists and is active
        require(_id < nextId, "Error: User does not exist");
        require(users[_id].isActive, "Error: User is inactive");
        // Get a direct reference to the user in storage for modification
        // 'storage' means we're working with the actual stored data
        User storage user = users[_id];
        // Update the user's information
        user.name = _name;
        user.age = _age;
        // Notify that a user was updated
        emit UserUpdated(nextId, _name, _age);
    }

    // DELETE: Function to "delete" a user (actually just marks as inactive)
    // In blockchain, we rarely truly delete data, just mark it as inactive
    function deleteUser(uint256 _id) public {
        // Verify the user exists and is active
        require(_id < nextId, "Error: User does not exist");
        require(users[_id].isActive, "Error: User is inactive");
        // Mark user as inactive instead of truly deleting
        users[_id].isActive = false;
        // Notify that a user was deleted
        emit UserDeleted(_id);
    }

    // Function to get all users that are still active
    // Returns an array of User structs
    function getAllActiveUsers() public view returns (User[] memory) {
        // First, count how many active users we have
        uint256 activeCount = 0;
        // Loop through all users to count active ones
        for (uint256 i = 0; i<nextId; i++){
           if(users[i].isActive){
               activeCount++;
           }  
        }

        // Create a new array with the exact size we need
        User[] memory activeUsers = new User[](activeCount);
        // Index to keep track of position in our new array
        uint256 index = 0;

        // Loop again to actually copy active users to our array
        for (uint256 i = 0; i<nextId; i++){
           if(users[i].isActive){
               // Copy the active user to our result array
               activeUsers[index]=users[i];
               index++;
           }
        }

        // Return the array of all active users
        return activeUsers;
    }
}
