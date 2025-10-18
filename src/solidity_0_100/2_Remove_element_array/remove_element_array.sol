// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title RemoveArrayElement
 */

contract c1_RemoveArrayElement {

  uint[] public array;

  function deleteElementInArray() public {
    // This function removes an element inside an array using Solidity.
    // However, the element is not truly removed; its value is just set to 0 at its position.
    // For example, deleting element at index 1 results in [1, 0, 3], not [1, 3].
    array = [1, 2, 3];
    delete array[1];    // The result will be an array with 0 at position 1
                       // values:    [1, 0, 3]
                       // positions:  0  1  2
    // We don't want this behavior for actual element removal.
  }

  // We want to get an array like this: [1, 3]

  function removeElementInArray(uint _index) private {
    // This function removes an element at a specific index from the array.
    // The element at _index is removed by shifting all elements to the left,
    // starting from _index+1 to the end of the array.
    // Finally, the last element is removed from the array to reduce its length.
    require(_index < array.length, "Error: Index out of array bounds");

    for (uint i = _index; i < array.length - 1; i++) {
      array[i] = array[i + 1];  // Shift elements left to overwrite the removed element
    }
    array.pop();  // Remove the last element, since it's now duplicated
  }

  function test_removeElementInArray_ok() external {
    // Test case to verify that removeElementInArray works correctly.
    // Starting array:               [10, 20, 30, 40, 50, 60]
    // Removing element at index 2 (value 30)
    // Expected array after removal: [10, 20, 40, 50, 60]
    array = [10, 20, 30, 40, 50, 60];
    removeElementInArray(2);  

    // Validate the expected array and length after removal
    assert(array[0]  == 10);
    assert(array[1]  == 20);
    assert(array[2]  == 40);
    assert(array[3]  == 50);
    assert(array[4]  == 60);
    assert(array.length == 5);

    // Another example with an array of a single element (commented out)
    // array = [1];
    // removeElementInArray(0);  // Removing the only element results in an empty array []
    // assert(array.length == 0);  // Length should be zero after removal
  }

  function test_removeElementInArray_nok() external {
    // This test is intentionally incorrect to demonstrate that the assertion can fail
    array = [10, 20, 30, 40, 50, 60];
    removeElementInArray(2);
    // Expected array: [10, 20, 40, 50, 60]
    assert(array[0]  == 10);
    assert(array[1]  == 20);
    assert(array[2]  == 40);       
    assert(array[3]  == 50);
    assert(array[4]  == 60);
    assert(array.length == 6);  // This is incorrect on purpose; length should be 5
  }
}

contract c2_ReplaceLastElement {

  uint[] public array;

  function removeElementInArray(uint _index) private {
    // This function removes the element at _index by replacing it with the last element of the array.
    // This avoids shifting elements, so it's more gas efficient but changes order of elements.
    // After replacement, the last element is removed, reducing array length by 1.
    require(_index < array.length, "Error: Index out of array bounds");
    
    array[_index] = array[array.length - 1];  // Replace element at _index with the last element
    array.pop();  // Remove the last element
  }

  function test_removeElementInArray_ok() external {
    // Test case for removeElementInArray using replacement method.
    // Starting array:                        [10, 20, 30, 40, 50, 60]
    // Remove element at index 2 (value 30).
    // Expected result array (order changes): [10, 20, 60, 40, 50]
    array = [10, 20, 30, 40, 50, 60];
    removeElementInArray(2);

    // Validate the array content and length
    assert(array[0] == 10);
    assert(array[1] == 20);
    assert(array[2] == 60);
    assert(array[3] == 40);
    assert(array[4] == 50);
    assert(array.length == 5);

    // Another example with an array of a single element (commented out)
    // array = [1];
    // removeElementInArray(0);
    // assert(array.length == 0);  // After removal, array should be empty
  }

  function test_removeElementInArray_nok() external {
    // This test demonstrates an assertion failure by checking a wrong length.
    array = [10, 20, 30, 40, 50, 60];
    removeElementInArray(2);
    // Expected array: [10, 20, 60, 40, 50]
    assert(array[0] == 10);
    assert(array[1] == 20);
    assert(array[2] == 60);
    assert(array[3] == 40);
    assert(array[4] == 50);
    assert(array.length == 6);  // Incorrect assertion; length should be 5 here
  }
}