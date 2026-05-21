# Arc Testnet 简易借贷 DApp

一个基于 **Arc Network** 的简易借贷协议（Lending Protocol），使用 Solidity 开发，支持抵押、借款、还款、自动利息等功能。

项目采用 **Remix + MetaMask** 最简方式部署，适合学习和快速演示。

---

## 🌐 项目信息

- **网络**：Arc Testnet
- **借款资产**：USDC (`0x3600000000000000000000000000000000000000`)
- **抵押资产**：WETH (`0x4200000000000000000000000000000000000006`)
- **合约地址**：
  - EnhancedLending：`0x313CeBB29eD02AdF31cA15520a9cACa9f1956cd5`
  - MockOracle：`0x84a8563dECad0f5E1e56C8A635A86DcEf9C17C12`

---

## ✨ 主要功能

- 支持多抵押品（当前已支持 WETH）
- 实时利率模型（Utilization-based）
- 存款自动产生利息（可随时领取）
- 借款 & 还款
- 健康因子（Health Factor）检查
- 清算机制（基础版）
- 完整的网页前端交互

---

## 📁 项目结构

```bash
arc-lending-dapp/
├── contracts/
│   ├── EnhancedLending.sol          # 主借贷合约
│   └── MockOracle.sol               # 测试价格预言机
├── frontend/
│   └── index.html                   # 单文件前端 DApp
├── README.md
└── .gitignore
合约地址（Arc Testnet）合约名称
地址
EnhancedLending
0x313CeBB29eD02AdF31cA15520a9cACa9f1956cd5
MockOracle
0x84a8563dECad0f5E1e56C8A635A86DcEf9C17C12
USDC
0x3600000000000000000000000000000000000000
WETH
0x4200000000000000000000000000000000000006

