# Data Location 📍

There are three different locations for data in Solidity: calldata, memory and storage. Quite simply, calldata is for external argument data, memory is for temporary data, and storage is for persistent data. Let's examine them more closely. 🔬

## calldata ☎️

When we broadcast a transaction from an EOA, we include bytecode for the EVM to run. This bytecode is the calldata which includes an identifier for the function we're targeting and the arguments we're sending.

When we take an array as a parameter in an external function, it must be labeled as calldata. It is a read-only reference to the argument data. Other than being read-only, it behaves quite like memory.

## memory 🧠

Memory is a temporary data location provided for us to keep our local variables in. These variables will only exist in memory for the length of the transaction.

When we're working with arrays that should only exist for the length of the transaction, we label them with the memory keyword. We can read/write to this data location relatively cheaply when compared to storage.

## storage ⛓️

Storage is the data that actually gets stored on the blockchain. This is where state variables are stored!

Every full node client on the Ethereum network stores this data on their machine. For this reason storage operations are expensive.

💡 If you recall in earlier lessons we talked about how every account has its own storage root which is the root hash of the particia merkle storage trie. This is where the Solidity storage keyword is referring to.

# Value vs Reference

Assigning an array will copy it in some cases and store a reference in other cases.

Let's consider this example:

```
import "hardhat/console.sol";
contract Contract {
uint[3] numbers = [1,2,3];

    function modify() external {
        uint[3] memory memoryArray = numbers;
        // will modifying memoryArray modify numbers?
        memoryArray[0] = 4;
        // nope!
        console.log(numbers[0]); // 1
    }

}
```

☝️ This will not modify the numbers. The values from numbers are copied into memoryArray at this assignment and they are otherwise unrelated.

📖 In fact, the compiler will warn that this can be labeled as a view. Didn't want to give any spoilers. 😉

```
import "hardhat/console.sol";
contract Contract {
uint[3] numbers = [1,2,3];

    function modify() external {
        uint[3] storage storageArray = numbers;
        // will modifying storageArray modify numbers?
        storageArray[0] = 4;
        // yup!
        console.log(numbers[0]); // 4
    }

}
```

☝️ This will modify the numbers. In this case, storageArray contains a reference to numbers due to its storage location.

💡 Equal references point to the same spot in memory. Making a modification updates the memory directly, all the references still point to the same place.

Further Reading
If you want more resources on how smart contract stoage works, check out this guide on What is Smart Contract Storage Layout?.
https://docs.alchemy.com/docs/smart-contract-storage-layout

# Another example

```
contract Library {

    struct Book {
        string title;
        string author;
        uint bookId;
    }

    Book[] public books;

    function addBook(string memory _title, string memory _author) public {
        books.push(Book(_title, _author, books.length));
    }
}
```

The string parameters use memory. This is a requirement of Solidity whenever you use reference types as a parameter, you must precede the parameter with either memory or calldata. This is just telling the Solidity compiler where the data being passed in lives. Since this is an ephemeral call, we are passing in the value from memory.
