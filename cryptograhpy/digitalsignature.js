const { keccak256 } = require('ethereum-cryptography/keccak');
const { utf8ToBytes } = require('ethereum-cryptography/utils');
const secp = require('ethereum-cryptography/secp256k1');

const PRIVATE_KEY = '6b911fd37cdf5c81d4c0adb1ab7fa822ed253ab0ad9aa18d77257c88b29b718e';

function hashMessage(message) {
  return keccak256(utf8ToBytes(message));
}

async function signMessage(msg) {
  let message = hashMessage(msg);
  let signature = await secp.sign(message, PRIVATE_KEY, { recovered: true });
  return signature;
}

async function recoverKey(message, signature, recoveryBit) {
  let hashedMessage = hashMessage(message);

  return secp.recoverPublicKey(hashedMessage, signature, recoveryBit);
}

module.exports = {
  hashMessage,
  signMessage,
  recoverKey,
};
