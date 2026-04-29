return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "wojciech-kulik/xcodebuild.nvim",
        },
        keys = {
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Debug: Continue",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step Over",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step Into",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug: Step Out",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Debug: Toggle Breakpoint",
            },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Debug: Conditional Breakpoint",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle()
                end,
                desc = "Debug: REPL",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Debug: Run Last",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                end,
                desc = "Debug: Terminate",
            },
        },
    },
    {
        "wojciech-kulik/xcodebuild.nvim",
        config = function()
            local xcodebuild_dap = require("xcodebuild.integrations.dap")
            xcodebuild_dap.setup()

            vim.keymap.set("n", "<leader>dd", xcodebuild_dap.build_and_debug, { desc = "Build & Debug" })
            vim.keymap.set("n", "<leader>dr", xcodebuild_dap.debug_without_build, { desc = "Debug Without Building" })
            vim.keymap.set("n", "<leader>dT", xcodebuild_dap.debug_tests, { desc = "Debug Tests" })
            vim.keymap.set("n", "<leader>dx", xcodebuild_dap.terminate_session, { desc = "Terminate Debugger" })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
                coreclr = function(config)
                    if config.configurations and config.configurations[1] then
                        local launch = config.configurations[1]
                        launch.name = "NetCoreDbg: Launch (Web API)"
                        launch.cwd = "${workspaceFolder}"
                        launch.console = "integratedTerminal"
                        launch.env = vim.tbl_extend("force", launch.env or {}, {
                            ASPNETCORE_ENVIRONMENT = "Development",
                            ASPNETCORE_URLS = "http://localhost:5000",
                        })
                    end
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
            ensure_installed = { "coreclr" },
        },
        config = function(_, opts)
            require("mason-nvim-dap").setup(opts)
        end,
    },
}
