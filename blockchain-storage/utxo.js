class TXO {
  constructor(owner, amount) {
    this.owner = owner;
    this.amount = amount;
    this.spent = false;
  }
  spend() {
    this.spent = true;
  }
}

class Transaction {
  constructor(inputUTXOs, outputUTXOs) {
    this.inputUTXOs = inputUTXOs;
    this.outputUTXOs = outputUTXOs;
  }

  execute() {
    let spentInputTxs = this.inputUTXOs.filter((inputs) => inputs.spent);

    if (spentInputTxs.length > 0) {
      throw new Error('Spent txs');
    }

    let totalInputsAmount = this.calculateTotal(this.inputUTXOs);
    let totalOutputsAmount = this.calculateTotal(this.outputUTXOs);

    if (totalInputsAmount < totalOutputsAmount) {
      throw new Error('Insufficient Input');
    }

    this.inputUTXOs.forEach((inputs) => inputs.spend());
    this.fee = totalInputsAmount - totalOutputsAmount;
  }

  calculateTotal(txos) {
    return txos.reduce((acc, curr) => acc + curr.amount, 0);
  }
}

module.exports = {
  TXO,
  Transaction,
};
