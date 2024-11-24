# Sample AMM Project

This project is a dex project with an AMM v2 module. 


## Table of Contents

- [Architectural Overview](#architectural-overview)
- [Design Rationale](#design-rationale)
- [User Guide](#user-guide)
- [Developer Guide](#developer-guide)


## Architectural Overview

The Sample AMM Project is composed of several key smart contracts that work together to provide decentralized exchange functionality. The main components are the Factory, Router, Pair, and MasterChef contracts. Below is a detailed explanation of each component and their relationships.

The Pair contracts are the core of the AMM. Each Pair contract manages a specific pair of tokens and implements the automated market-making logic. It keeps track of the token reserves, calculates prices, and handles the actual token transfers during swaps and liquidity operations.

Factory contract is a single contract that is the central registry for all token pairs in the AMM. It is responsible for creating new Pair contracts and keeping track of all existing pairs. The Factory contract ensures that each token pair is unique.

The Router contract acts as an intermediary between users and the Pair contracts. It provides user-friendly functions for adding liquidity, removing liquidity, and swapping tokens. The Router contract abstracts away the complexity of interacting directly with Pair contracts, making it easier for users to perform common operations.

The MasterChef contract is responsible for managing liquidity mining incentives. It allows users to stake their liquidity provider (LP) tokens to earn rewards (the goveranance token). The MasterChef contract keeps track of user stakes, calculates rewards, and distributes them accordingly.


                            +----------------+         
                            |                |       
                            | Factory        |       
                            |                |      
                            +-------+--------+      
                                    |                        
                                    |                        
                                    v                        
           +------------------------+------------------------+           
           |                        ｜                       ｜             
           |                        ｜                       ｜
           v                        v                        v        
+----------------+       +----------------+       +----------------+     
|                |       |                |       |                |
| Pair           |       | Pair           |       | Pair           |
|                |       |                |       |                |
+----------------+       +----------------+       +----------------+
           |                        |                        |
           |                        |                        |
           |                        |                        |
           +------------------------+------------------------+
                                    |
                                    |
                                    v
                           +----------------+             +----------------+
                           |                |             |                |
                           |    Router      |---- USER ---| MasterChef     |
                           |                |             |                |
                           +----------------+             +----------------+

## Design Rationale

The design of the Sample AMM Project is based on the following principles:

1. **Decentralization**: All operations are performed on-chain without the need for a central authority.
2. **Efficiency**: The AMM logic is optimized for gas efficiency to minimize transaction costs.
3. **Security**: The contracts are designed with security best practices to prevent common vulnerabilities.
4. **Flexibility**: The system supports a wide range of token pairs and allows for easy integration with other DeFi protocols.

## User Guide

In this project , these methods are provided:
   - create new token pair pool.
   - add or remove liquidity in pools and get LP tokens to get transaction fee.
   - swap tokens
   - stake LP tokens to earn governance token.


## Developer Guide
### Prerequisites
- node and npm environment
- hardhat and foundry framework
- mdbook tool

You can read the api document by this following command:
`cd docs && mdbook serve`

The test script is excuted by this following command:
`forge test -vvvv`

If you want to deploy this contracts you should configure the network information in `hardhat.config.ts` and `./scripts/config.ts` run:
```
npx hardhat run --network <network-name> ./script/1.deploy.ts

```