const Block = require('./block');

class Blockchain {
  constructor() {
    this.chain = [new Block('Genesis Block')];
  }

  addBlock(block) {
    let lastBlock = this.chain[this.chain.length - 1];

    block.previousHash = lastBlock.toHash();
    this.chain.push(block);
  }

  isValid() {
    let isValid = true;

    for (let i = 0; i < this.chain.length - 1; i++) {
      let currentBlock = this.chain[i];
      let nextBlock = this.chain[i + 1];
      let cHash = currentBlock.toHash().toString();
      let nHash = nextBlock.previousHash.toString();

      if (cHash !== nHash) {
        isValid = false;
      }

      if (isValid === false) {
        break;
      }
    }

    return isValid;
  }
}

module.exports = Blockchain;
