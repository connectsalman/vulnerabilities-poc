# Vulnerabilities PoC

Proof-of-concept exploits for smart contract bugs, built with Foundry.

## Reentrancy
- `VulnerableBank.sol`: sends ETH before updating the balance (bug)
- `Attacker.sol`: calls `withdraw` again from `receive()`
- `SecureBank.sol`: updates the balance first (fix)
- `test/Reentrancy.t.sol`: proves the attack and the fix

## Run
forge test -vv