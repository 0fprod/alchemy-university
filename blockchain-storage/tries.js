class TrieNode {
  constructor(key, children = {}, isWord = false) {
    this.key = key;
    this.children = children;
    this.isWord = isWord;
  }
}

class Trie {
  constructor() {
    this.root = new TrieNode(null);
  }

  insert(word = '') {
    let node = this.root;
    for (let i = 0; i < word.length; i++) {
      const letter = word[i];
      if (!node.children[letter]) {
        node.children[letter] = new TrieNode(letter);
      }
      node = node.children[letter];
      console.log(`index ${i}:`, node);
    }
    node.isWord = true;
  }

  contains(word = '') {
    let node = this.root;
    for (let i = 0; i < word.length; i++) {
      const letter = word[i];
      if (!node.children[letter]) {
        return false;
      }
      node = node.children[letter];
    }
    return node.isWord;
  }
}

module.exports = { Trie, TrieNode };
