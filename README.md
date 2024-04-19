# Shoe Store Smart Contract

This smart contract defines the functionality for a shoe store on the Sui blockchain framework.

## Overview

The Shoe Store smart contract allows users to manage a shoe store, including adding new shoes, updating stock, purchasing shoes, and retrieving shoe information.

## Features

- **Add Shoe:** Add a new shoe to the store with details such as name, description, price, stock, color, and size.
- **Get Shoes:** Retrieve all shoes available in the store.
- **Get Shoe:** Retrieve a specific shoe by its ID.
- **Delete Shoe:** Remove a shoe from the store.
- **Update Stock:** Update the stock of a shoe.
- **Purchase Shoe:** Allow users to purchase a shoe from the store, updating the stock accordingly.
- **Get Shoe Order:** Retrieve information about a shoe order by its ID.

## Note

- Ensure to handle errors such as shoe not found and insufficient stock.
- Transactions such as adding, updating, and purchasing shoes require sufficient gas for execution.
- Access control mechanisms can be implemented to restrict certain operations to authorized users only.
- Consider implementing events to emit notifications for important actions like shoe purchases or stock updates.


## Dependency

- This DApp relies on the Sui blockchain framework for its smart contract functionality.
- Ensure you have the Move compiler installed and configured to the appropriate framework (e.g., `framework/devnet` for Devnet or `framework/testnet` for Testnet).

```bash
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }
```

## Installation

Follow these steps to deploy and use the Charity Donation Platform:

1. **Move Compiler Installation:**
   Ensure you have the Move compiler installed. Refer to the [Sui documentation](https://docs.sui.io/) for installation instructions.

2. **Compile the Smart Contract:**
   Switch the dependencies in the `Sui` configuration to match your chosen framework (`framework/devnet` or `framework/testnet`), then build the contract.

   ```bash
   sui move build
   ```

3. **Deployment:**
   Deploy the compiled smart contract to your chosen blockchain platform using the Sui command-line interface.

   ```bash
   sui client publish --gas-budget 100000000 --json
   ```

## Note

- Logs (`2024-04-19T08_52_35_994Z-debug-0.log` and `2024-04-19T08_52_35_994Z-eresolve-report.txt`) may provide more specific information about the problem.