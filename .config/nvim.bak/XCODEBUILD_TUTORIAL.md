# xcodebuild.nvim Quick Start Guide

## 1. Install External Tools (one-time)

```bash
brew install xcp xcode-build-server xcbeautify rg jq coreutils
```

## 2. Open Your Project

```bash
cd /path/to/your/ios-project
nvim .
```

## 3. Initial Project Setup

Run the setup wizard inside Neovim:
```
:XcodebuildSetup
```

This will prompt you to select:
- Project file (`.xcodeproj` or `.xcworkspace`)
- Scheme (e.g., `MyApp`)
- Configuration (e.g., `Debug`)
- Device/Simulator (e.g., `iPhone 15 Pro`)
- Test Plan (optional, skip if you don't have one)

Settings are saved to `.nvim/xcodebuild/settings.json` - future sessions auto-load them.

## 4. Common Workflows

### Building & Running
| Keymap | Action |
|--------|--------|
| `<leader>xb` | Build project |
| `<leader>xr` | Build & Run on simulator |
| `<leader>X` | Open action picker |

### Testing
| Keymap | Action |
|--------|--------|
| `<leader>xt` | Run all tests |
| `<leader>xT` | Run tests in current class |
| `<leader>xe` | Toggle Test Explorer |

### Debugging
| Keymap | Action |
|--------|--------|
| `<leader>dd` | Build & Debug |
| `<leader>dr` | Debug without rebuilding |
| `<leader>dT` | Debug tests |
| `<leader>dx` | Terminate debugger |
| `<leader>db` | Toggle breakpoint |

### Logs & Diagnostics
| Keymap | Action |
|--------|--------|
| `<leader>xl` | Toggle build logs |
| `<leader>xd` | Select different device |

## 5. SwiftUI Previews (Optional)

### Add the Swift package to your project
In Xcode: File → Add Packages → `https://github.com/wojciech-kulik/xcodebuild-nvim-preview`

### Modify your App entry point
```swift
import SwiftUI
import XcodebuildNvimPreview

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupNvimPreview {
                    // Return any view you want to preview
                    ContentView()
                }
        }
    }
}
```

### Generate previews
| Keymap | Action |
|--------|--------|
| `<leader>xp` | Build & generate preview |
| `<leader>x<cr>` | Toggle preview window |

## 6. LSP Configuration

For best results, run this in your project root:
```bash
xcode-build-server config -project YourProject.xcodeproj -scheme YourScheme
```

This creates `buildServer.json` which helps sourcekit-lsp understand your project structure.

## Troubleshooting

**No devices shown?** Run `:XcodebuildSelectDevice` and press `<C-r>` to refresh.

**LSP not working?** Make sure you ran `xcode-build-server config` and have `buildServer.json` in your project root.

**Build fails?** Check logs with `<leader>xl` - errors appear in the quickfix list (`<leader>xq` with telescope).