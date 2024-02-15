const SHA256 = require('crypto-js/sha256');
const TARGET_DIFFICULTY = BigInt(0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
const MAX_TRANSACTIONS = 10;

const mempool = [];
const blocks = [];

function addTransaction(transaction) {
  mempool.push(transaction);
}

function mine() {
  let newBlock = {
    id: blocks.length,
    transactions: pullNextTxsAndRemoveFromMempool(),
    nonce: 0,
  };

  newBlock.hash = SHA256(JSON.stringify(newBlock));

  while (BigInt(`0x${newBlock.hash}`) > TARGET_DIFFICULTY) {
    newBlock.nonce = newBlock.nonce + 1;
    newBlock.hash = SHA256(JSON.stringify(newBlock));
  }

  blocks.push(newBlock);
}

function pullNextTxsAndRemoveFromMempool() {
  return mempool.splice(0, MAX_TRANSACTIONS);
}

module.exports = {
  TARGET_DIFFICULTY,
  MAX_TRANSACTIONS,
  addTransaction,
  mine,
  blocks,
  mempool,
};
