# Vulnerabilities PoC

Proof-of-concept exploits for smart contract bugs, built with Foundry.

## 1. Reentrancy
- `VulnerableBank.sol`: sends ETH before updating the balance (bug)
- `Attacker.sol`: calls `withdraw` again from `receive()`
- `SecureBank.sol`: updates the balance first (fix)
- `test/Reentrancy.t.sol`: proves the attack and the fix

## 2. Access Control
- `VulnerableVault.sol`: `setOwner` has no caller check (bug)
- `SecureVault.sol`: `setOwner` requires the caller to be the owner (fix)
- `test/AccessControl.t.sol`: proves the takeover and the fix

## 3. tx.origin Phishing
- `TxOriginWallet.sol`: uses `tx.origin` for authorization (bug)
- `PhishingAttacker.sol`: a malicious contract that borrows the owner's identity
- `SecureTxWallet.sol`: uses `msg.sender` instead (fix)
- `test/TxOrigin.t.sol`: proves the phishing attack and the fix

## Run
forge test -vv