# ERC20 Token Vesting

An expert-level, gas-optimized token vesting schedule manager. This contract allows projects to lock up ERC20 tokens for beneficiaries and release them gradually over time using a continuous linear release model after an optional cliff period. It guarantees that team or investor allocations cannot be dumped prematurely, ensuring long-term structural alignment.

## Features
- **Continuous Linear Release:** Tokens unlock incrementally second by second rather than in massive blocks.
- **Optional Cliff Period:** Enforces an initial lockup window before any vesting distributions begin.
- **Precise Pull Architecture:** Beneficiaries claim their vested allocations at their convenience, minimizing smart contract gas interaction patterns.

## Getting Started

1. Install project dependencies:
   ```bash
   npm install
