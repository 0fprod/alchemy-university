const { assert } = require('chai');
const deposit = ethers.utils.parseEther('1');

/**
 * Approves the Escrow, signed by the arbiter
 *
 * @param {ethers.Contract} contract - ethers.js contract instance
 * @param {ethers.types.Signer} arbiterSigner - the arbiter EOA
 *
 * @return {promise} a promise of the approve transaction
 */
function approve(contract, arbiterSigner) {
  return contract.connect(arbiterSigner).approve();
}

describe('Escrow', function () {
  let contract;
  let accounts = {};
  beforeEach(async () => {
    const roles = ['arbiter', 'beneficiary', 'depositor'];
    for (let i = 0; i < roles.length; i++) {
      const signer = ethers.provider.getSigner(i);
      const address = await signer.getAddress();
      accounts[roles[i]] = { signer, address };
    }

    const Contract = await ethers.getContractFactory('Escrow');
    contract = await Contract.connect(accounts.depositor.signer).deploy(
      accounts.arbiter.address,
      accounts.beneficiary.address,
      { value: deposit }
    );
  });

  it('should be funded', async () => {
    const balance = await ethers.provider.getBalance(contract.address);
    assert.equal(balance.toString(), deposit.toString());
  });

  describe('after approval', () => {
    let balanceBefore;
    before(async () => {
      balanceBefore = await ethers.provider.getBalance(accounts.beneficiary.address);
      await approve(contract, accounts.arbiter.signer);
    });

    it('should transfer balance to beneficiary', async () => {
      const after = await ethers.provider.getBalance(accounts.beneficiary.address);
      assert.equal(after.sub(balanceBefore).toString(), deposit.toString());
    });
  });
});
