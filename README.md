
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
   sozo migrate apply
   ```

   ```bash
   torii --world 0xc82dfe2cb4f8a90dba1e88dfa24578aeb1c19152d51e3c7cf413be6d65d9e --allowed-origins "*"
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

