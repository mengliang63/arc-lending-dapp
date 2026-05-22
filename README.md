# Arc Testnet Simple Lending DApp

A simple yet functional Lending Protocol built on **Arc Network** using Solidity. This project demonstrates core DeFi lending mechanics including collateral management, borrowing, repayment, and interest accrual.

Designed for easy learning and quick demonstration using **Remix + MetaMask**.

---

## 🌐 Project Information

- **Network**: Arc Testnet
- **Borrow Asset**: USDC  
  **Address**: `0x3600000000000000000000000000000000000000`
- **Collateral Asset**: WETH  
  **Address**: `0x4200000000000000000000000000000000000006`

### Deployed Contracts

| Contract Name     | Address                                      |
|-------------------|----------------------------------------------|
| EnhancedLending   | `0x313CeBB29eD02AdF31cA15520a9cACa9f1956cd5` |
| MockOracle        | `0x84a8563dECad0f5E1e56C8A635A86DcEf9C17C12` |

---

## ✨ Key Features

- Support for collateral deposits (currently WETH)
- Utilization-based dynamic interest rate model
- Automatic interest accrual on supplied assets (claimable anytime)
- Borrow and repay functionality
- Real-time Health Factor monitoring
- Basic liquidation mechanism
- Clean, single-file web frontend for easy interaction

---

## 📁 Project Structure

```bash
arc-lending-dapp/
├── contracts/
│   ├── EnhancedLending.sol          # Main lending logic
│   └── MockOracle.sol               # Mock price oracle for testing
├── frontend/
│   └── index.html                   # Single-page frontend DApp
├── README.md
└── .gitignore
