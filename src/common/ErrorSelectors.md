# List Of Error Selectors

This list comprehends the selectors of the custom errors inside the contracts. The method to get this selectors is the following:

Selector = (Keccak-256(CUSTOM_ERROR_FUNCTION))[:4]

As explained above, the selector is the result of the hash of the custom error function. This error function must have no spaces, and if arguments, they must specify only the type. Finally, only the first 4 bytes of the hash are used. For example:

CUSTOM_ERROR_FUNCTION = InvalidDateWindow(uint256,uint256)

Keccak-256 Hash = 0x702434261a75c3efd3a36189e63f0a9e0be4005d6d10e0bca897577de20f33b4

Selector (first 4 bytes of hash) = 0x70243426

An online Keccak-256 hash digester can be found at https://emn178.github.io/online-tools/keccak_256.html

| SELECTOR   | ERROR                                                  |
| ---------- | ------------------------------------------------------ |
| 0x058e826d | XnCannotBeZero()                                       |
| 0x3e060e90 | BnCannotBeZero()                                       |
| 0xb1b3aff4 | bytesLargerThanUint256()                               |
| 0x1ccfdd2f | diffGreaterThanUint256()                               |
| 0x1de42a90 | DivideByZero()                                         |
| 0x13d54d96 | YTokenNotAllowed()                                     |
| 0xfeaf73c7 | BeyondLiquidity()                                      |
| 0x07149010 | LPFeeAboveMax(uint16 proposedFee, uint16 maxFee)       |
| 0xbc19b2bf | MaxTotalSupplyTooLarge()                               |
| 0xd0b73f52 | NotAnAllowedDeployer()                                 |
| 0x22ef9850 | PriceRangeNotWideEnough()                              |
| 0xc29ffb2f | PriceRangeTooLarge()                                   |
| 0x692853b9 | MaxTotalSupplyCannotBeZero()                           |
| 0x5b33356a | lowerPriceTooLow()                                     |
| 0x9cf8540c | ZeroValueNotAllowed()                                  |
| 0x90b8ec18 | TransferFailed()                                       |
| 0xd92e233d | ZeroAddress()                                          |
| 0x03137159 | NegativeValue()                                        |
| 0x5d32e464 | CTooSmall(uint256)                                     |
| 0x5bcae70a | DnTooLarge()                                           |
| 0x4bc1f6e0 | CTooLarge()                                            |
| 0xedd7abac | LiquidityRemovalForbidden()                            |
| 0xc1ab6dc1 | InvalidToken()                                         |
| 0xcd6c7802 | XOutOfBounds(uint256 howMuch)                          |
| 0x32a1d94e | YTokenDecimalsGT18()                                   |
| 0x15affb65 | XTokenDecimalsIsNot18()                                |
| 0x88356ef9 | XandYTokensAreTheSame()                                |
| 0x4bc811d1 | ProtocolFeeAboveMax(uint16 proposedFee, uint16 maxFee) |
| 0x97992322 | NotProtocolFeeCollector()                              |
| 0xa8ed10f5 | NotProposedProtocolFeeCollector()                      |
| 0x6d52fdaf | NoProtocolFeeCollector()                               |
| 0x9d6b0927 | KTooLow()                                              |
| 0x95d02cac | KTooHigh()                                             |
| 0xac9c209c | VOutOfBounds()                                         |
| 0xcc9d2d63 | VTooLow()                                              |
| 0x2d281418 | VTooHigh()                                             |
| 0xd9fd1a29 | PoolClosed()                                           |