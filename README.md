# RSA-Based-Digital-Signature-and-Encryption-System
Designed and implemented an RSA cryptographic module in Verilog using modular exponentiation for encryption and digital signature operations.

# RSA-Based Digital Signature and Encryption System

A Verilog HDL implementation of the RSA cryptosystem, built to demonstrate the core mathematics of public-key encryption and decryption — key generation, modular exponentiation, and modular inverse computation — entirely in synthesizable/simulatable hardware description language.

## Overview

This project implements the RSA algorithm as a combinational hardware module (`rsa_calculator`) that:

1. Computes the modulus `n = a * b` and Euler's totient `phi = (a - 1) * (b - 1)` from two prime inputs `a` and `b`.
2. Derives the private key `d` as the modular multiplicative inverse of the public exponent `e` modulo `phi`, using the **Extended Euclidean Algorithm**.
3. Encrypts a plaintext message `m` into ciphertext `c` using **modular exponentiation by squaring**: `c = m^e mod n`.
4. Decrypts the ciphertext back into the original message: `dec = c^d mod n`.

A self-checking testbench (`rsa_calculator_tb`) drives the module with a sample key pair and message, then verifies that the decrypted output matches the original plaintext.

## How It Works

### Key Generation
Given two prime numbers `a` and `b` and a public exponent `e`, the module computes:
- `n = a * b` — the RSA modulus
- `phi = (a - 1) * (b - 1)` — Euler's totient of `n`
- `d = e⁻¹ mod phi` — the private exponent, computed via the Extended Euclidean Algorithm

### Encryption
The message `m` is encrypted as `c = m^e mod n`, computed efficiently using the **square-and-multiply** method to avoid overflow and reduce the number of multiplications.

### Decryption
The ciphertext `c` is decrypted as `dec = c^d mod n`, using the same modular exponentiation routine, recovering the original message when `d` and `e` are correctly paired.

## Module Interface

### `rsa_calculator`

| Port  | Direction | Width | Description                          |
|-------|-----------|-------|---------------------------------------|
| `e`   | input     | 32    | Public encryption exponent            |
| `a`   | input     | 32    | First prime number                    |
| `b`   | input     | 32    | Second prime number                   |
| `m`   | input     | 32    | Plaintext message to encrypt          |
| `d`   | output    | 64    | Computed private (decryption) exponent |
| `c`   | output    | 64    | Encrypted ciphertext                  |
| `dec` | output    | 64    | Decrypted message (should equal `m`)  |

### Internal Functions
- **`mod_exp(base, exponent, modulus)`** — Performs modular exponentiation using the binary square-and-multiply algorithm.
- **`modinv(e, phi)`** — Computes the modular multiplicative inverse of `e` mod `phi` using the Extended Euclidean Algorithm, returning `0` if no inverse exists.

## Testbench

`rsa_calculator_tb` instantiates the design with a sample key pair:

```
e = 65537
a = 463
b = 671
m = 47
```

The simulation displays the computed private key, ciphertext, and decrypted message, then checks that `dec == m` to confirm the encryption/decryption round trip is correct.

Expected console output:
```
Starting simulation...
Inputs: e=65537, a=463, b=671, m=47
Outputs: d=<computed>, c=<computed>, dec=47
Test Passed : Message decrypted correctly.
```

## Getting Started

### Prerequisites
Any standard Verilog simulator, such as:
- Xilinx Vivado
- Icarus Verilog (`iverilog` + `vvp`)
- ModelSim / QuestaSim

### Running the Simulation

**Using Icarus Verilog:**
```bash
iverilog -o rsa_sim rsa_calculator.v rsa_calculator_tb.v
vvp rsa_sim
```

**Using Vivado:**
1. Create a new project and add `rsa_calculator.v` as a design source.
2. Add `rsa_calculator_tb.v` as a simulation source.
3. Run Behavioral Simulation.

## Notes & Limitations

- This is intended as an **educational/demonstration** implementation, not a production-grade cryptographic core. The prime inputs, modulus, and intermediate products must fit within the declared bit widths (32-bit inputs, 64-bit internal/output registers) without overflow.
- The design uses combinational `always @(*)` blocks with `while` loops inside functions, which is suitable for simulation but should be reviewed for synthesizability and latency if targeted at real FPGA/ASIC hardware (loop-heavy combinational logic can synthesize to large/slow circuits).
- No padding scheme (e.g., OAEP) is used — this is "textbook RSA," which is not secure for real-world use without additional padding and key-size considerations.
- For actual digital signature functionality, the same primitives (modular exponentiation and modular inverse) can be reused: signing is decryption with the private key, and verification is encryption with the public key.

## Future Improvements

- Add support for digital signature generation and verification as separate top-level flows.
- Pipeline the modular exponentiation for better hardware performance.
- Add primality checks and automatic key generation from random seeds.
- Parameterize bit widths for larger key sizes.
- Add more comprehensive testbench coverage (edge cases, multiple key pairs).

## License

Specify your chosen license here (e.g., MIT, Apache 2.0).

## Author

[Abhiudaydas](https://github.com/Abhiudaydas)
