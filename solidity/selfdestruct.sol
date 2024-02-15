// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Contract {
    address public owner;
    address public charity;

    constructor(address _charity) {
        owner = msg.sender;
        charity = _charity;
    }

    function tip() external payable {
        (bool s, ) = owner.call{value: msg.value}(""); // send the tip to the owner
        require(s);
    }

    receive() external payable {
        // fallback function
        // console.log("Received ", msg.value, " wei from ", msg.sender);
    }

    function donate() external {
        uint contractBalance = address(this).balance;
        (bool s, ) = charity.call{value: contractBalance}("");
        require(s);
        selfdestruct(payable(charity)); // destroy the contract and send the remaining funds to the charity
        /*
          "selfdestruct" has been deprecated. 
          Note that, starting from the Cancun hard fork, 
          the underlying opcode no longer deletes the code and data associated 
          with an account and only transfers its Ether to the beneficiary, 
          unless executed in the same transaction in which the contract was created (see EIP-6780). 
          Any use in newly deployed contracts is strongly discouraged even if the new behavior is taken into account.
          Future changes to the EVM might further reduce the functionality of the opcode.solidity(5159)
         */
    }
}
// payables are used to send ether to a contract
