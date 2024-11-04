
# Checkers

Single steps quick start

### Terminal 1: Iniciar Katana

  ```bash
   cd dojo-starter
   ```

   ```bash
   katana --disable-fee --allowed-origins "*"
   ```

### Terminal 2: 

   ```bash
   cd dojo-starter
   ```

   ```bash
   sozo build
   ```

   ```bash
   sozo migrate
   ```

   ```bash
   torii --world 0x06171ed98331e849d6084bf2b3e3186a7ddf35574dd68cab4691053ee8ab69d7 --allowed-origins "*"
   ```

### Terminal 3:

   ```bash
   cd client
   ```

   ```bash
   pnpm i
   ```

   ```bash
   pnpm dev
   ```


https://api.cartridge.gg/x/starknet/sepolia

slot deployments delete marquis-checkers torii 

slot deployments create marquis-checkers sepolia

https://api.cartridge.gg/x/checkers-marquis/katana

Endpoints:
  GRAPHQL: https://api.cartridge.gg/x/checkers-marquis/torii/graphql
  GRPC: https://api.cartridge.gg/x/checkers-marquis/torii

slot deployments create checkers-marquis torii --world 0x06171ed98331e849d6084bf2b3e3186a7ddf35574dd68cab4691053ee8ab69d7