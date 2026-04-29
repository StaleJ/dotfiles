# Neovim .NET Debugger (DAP + Mason)

This config uses:
- `mfussenegger/nvim-dap`
- `jay-babu/mason-nvim-dap.nvim`
- `.NET` adapter: `coreclr` (backed by Mason package `netcoredbg`)

## Do I need `dotnet run`?

No, not for this setup.

Use `dotnet build` first, then start debugging from Neovim.

Why: this debugger configuration launches a built `.dll` from `bin/Debug/**`.

## Quick Start (.NET)

1. Open Neovim in your project root.
2. Build once:
   ```bash
   dotnet build
   ```
3. Open a `.cs` file and set a breakpoint with `<leader>db`.
4. Start debugger with `<leader>dc`.
5. Choose the `.dll` from the picker.
6. Open `http://localhost:5000/swagger`

If the picker is empty, build again (`dotnet build`) and retry.

## Keymaps

- `<leader>dc`: continue/start
- `<leader>do`: step over
- `<leader>di`: step into
- `<leader>dO`: step out
- `<leader>db`: toggle breakpoint
- `<leader>dB`: conditional breakpoint
- `<leader>dr`: toggle DAP REPL
- `<leader>dl`: run last config
- `<leader>dt`: terminate

## Notes

- This is launch-based debugging (not attach).
- Debug output is sent to Neovim's integrated terminal.
- The debugger sets:
  - `ASPNETCORE_ENVIRONMENT=Development`
  - `ASPNETCORE_URLS=http://localhost:5000`
- If you want attach-to-process debugging later, we can add that config.
