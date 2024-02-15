// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// Filter to storage
contract Contract {
    uint[] public evenNumbers;

    function filterEven(uint[] calldata list) external {
        for (uint i = 0; i < list.length; i++) {
            if (list[i] % 2 == 0) {
                evenNumbers.push(list[i]);
            }
        }
    }
}

// Filter to memory
contract Contract2 {
    function filterEven(
        uint[] calldata list
    ) external pure returns (uint256[] memory) {
        uint elements = 0;

        for (uint i = 0; i < list.length; i++) {
            if (list[i] % 2 == 0) {
                elements++;
            }
        }

        uint[] memory evenNumbers = new uint[](elements);
        uint filledIndex = 0;
        for (uint i = 0; i < list.length; i++) {
            if (list[i] % 2 == 0) {
                evenNumbers[filledIndex] = list[i]; // Dynamic memory array doesn't have a push method
                filledIndex++;
            }
        }

        return evenNumbers;
    }
}
