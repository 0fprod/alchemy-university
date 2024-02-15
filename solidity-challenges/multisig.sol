// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    address[] public owners;
    uint public required;
    uint private transactionsSize;
    mapping(uint => Transaction) public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;
    mapping(uint => uint) private confirmationsPerId;

    modifier IsOwner(address addrs) {
        bool flag;
        uint i;
        while (i < owners.length && flag == false) {
            if (owners[i] == addrs) {
                flag = true;
            }
            i++;
        }

        if (flag) {
            _;
        } else {
            revert("Nope!");
        }
    }

    constructor(address[] memory _owners, uint req) {
        require(_owners.length > 0, "At least one owner");
        require(
            req > 0 && req < _owners.length,
            "Invalid required confirmations"
        );
        owners = _owners;
        required = req;
    }

    function submitTransaction(
        address _destination,
        uint _value,
        bytes memory _data
    ) external IsOwner(msg.sender) {
        confirmTransaction(addTransaction(_destination, _value, _data));
    }

    function addTransaction(
        address _destination,
        uint _value,
        bytes memory _data
    ) internal IsOwner(msg.sender) returns (uint txIndex) {
        txIndex = transactionsSize;
        transactions[txIndex] = Transaction(_destination, _value, false, _data);
        transactionsSize++;
    }

    function confirmTransaction(uint txId) public IsOwner(msg.sender) {
        confirmations[txId][msg.sender] = true;
        confirmationsPerId[txId]++;
        if (isConfirmed(txId)) {
            executeTransaction(txId);
        }
    }

    function executeTransaction(uint txId) public {
        require(isConfirmed(txId), "Bro wtf");
        Transaction storage trx = transactions[txId];
        (bool s, ) = trx.destination.call{value: trx.value}(trx.data);
        require(s, "Could not send moni to destination");
        trx.executed = true;
    }

    function getConfirmationsCount(uint txId) public view returns (uint) {
        return confirmationsPerId[txId];
    }

    function isConfirmed(uint txId) public view returns (bool) {
        return confirmationsPerId[txId] >= required;
    }

    function transactionCount() public view returns (uint) {
        return transactionsSize;
    }

    receive() external payable {
        // nothing
    }
}
