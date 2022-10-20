return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "farmergreg/vim-lastplace"
  use "sheerun/vim-polyglot"
  use "savq/melange"

  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require("plugins/colorizer") end,
  }

  use {
    "cormacrelf/dark-notify",
    config = function() require("dark_notify").run() end,
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins/gitsigns") end,
  }

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function() require("plugins/neo-tree") end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = function() require("plugins/treesitter") end,
  }

  use {
    "terrortylor/nvim-comment",
    requires = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function() require("plugins/comment") end,
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require("plugins/indent-blankline") end,
  }

  use {
    "lukas-reineke/virt-column.nvim",
    config = function() require("plugins/virt-column") end,
  }

  use {
    "neovim/nvim-lspconfig",
    config = function() require("plugins/lsp") end,
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
    },
  }
end)
