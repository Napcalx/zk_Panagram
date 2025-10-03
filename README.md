# 🧩 Panagram – Privacy-Preserving Word Guessing Game

## 🎯 About the Project

**Panagram** is a **zero-knowledge powered word-guessing game** that merges the fun of puzzles with the trustless guarantees of cryptography.
Players attempt to guess the secret word each round, but thanks to **zkSNARK proofs**, correctness is verified without revealing the actual secret.

The game introduces **on-chain rewards and NFTs**:

* ✅ First correct guess in a round is crowned **Winner**
* 🏆 Winners receive a **unique NFT badge** to prove their achievement
* 🔒 ZK-Verifier contract ensures fairness and censorship resistance

This project blends **Noir** (for building zk circuits) with **Solidity** (for on-chain game logic) to create a seamless cryptographic gaming experience.

---

## ⚡ Features

* **Zero-Knowledge Verification** – correctness of guesses without leaking the answer
* **Round-based Gameplay** – players compete in guessing rounds
* **NFT Rewards** – winners automatically mint a special NFT badge
* **Fairness Guarantee** – no central authority, purely trustless verification
* **Composable Contracts** – easy integration with other dApps

---

## 📂 Project Structure

```
Panagram/
│── contracts/
│   ├── Panagram.sol      # Core game logic, winner tracking, NFT minting
│   ├── Verifier.sol      # zkSNARK verifier (auto-generated Noir verifier)
│   ├── foundry.toml      # Foundry configuration
│── src/
│   └── main.nr           # Noir circuit (word guessing logic & constraints)
│── target/
│   ├── vk                # Verification key
│   └── zk_Panagram.json  # Compiled proving key & circuit data
│── Nargo.toml            # Noir project config
```

---

## 🚀 How It Works

1. A **secret word** is encoded into a Noir circuit (`main.nr`).
2. Players submit guesses → a **zk proof** is generated off-chain.
3. Proof is verified on-chain by the `Verifier.sol` contract.
4. If the guess is correct:

   * The first player to succeed in a round is declared **Winner**
   * `Panagram.sol` mints a **Winner NFT** for that player
   * An event `Panagram__WinnerCrowned` is emitted

---

## 🛠 Tech Stack

* **Noir** – zk circuit development (Aztec’s zk language)
* **Solidity** – smart contracts for game + verifier
* **Foundry** – contract deployment & testing
* **Ethereum / EVM Chains** – on-chain execution
* **zkSNARKs** – zero-knowledge proof verification

---

## 📦 Installation & Setup

1. Clone the repo:

   ```bash
   git clone https://github.com/your-username/panagram.git
   cd panagram
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Compile Noir circuit:

   ```bash
   nargo build
   ```

4. Compile and test contracts:

   ```bash
   forge build
   forge test
   ```

5. Deploy to a testnet (example with Foundry):

   ```bash
   forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
   ```

---

## 🎮 Gameplay Flow

1. Start a round → secret word chosen (hidden inside circuit).
2. Players submit zk proofs of guesses.
3. Verifier contract checks validity.
4. First valid proof = winner gets NFT minted.
5. Round resets → game continues!

---

## 📸 Demo Preview

*(Optional: insert screenshots or terminal outputs here for style, like proof generation, winner crown event, NFT mint.)*

---

## 🌟 Why Panagram?

* Brings **privacy** to on-chain games
* Eliminates **trust issues** in puzzle fairness
* Rewards winners with **collectible NFTs**
* Bridges **ZK proofs** with **EVM gaming**

---

## 📜 License

MIT License © 2025 – Built with ❤️ and zkMagic
