{
  lz-n = import ./lz-n.nix;
  which-key = import ./which-key.nix;
  treesitter = import ./treesitter.nix;
  treesitter-refactor = import ./treesitter-refactor.nix;
  treesitter-context = import ./treesitter-context.nix;
  lsp = import ./lsp.nix;
  lspkind = import ./lspkind.nix;
  none-ls = import ./none-ls.nix;
  # nvim-lint = import ./nvim-lint.nix;
  trouble = import ./trouble.nix;
  nav = import ./nav.nix;
  telescope = import ./telescope.nix;
  deicons = import ./devicons.nix;
  blink-cmp = import ./blink-cmp.nix;
  copilot = import ./copilot.nix;
  hlchunk = import ./hlchunk.nix;
  gitsigns = import ./gitsigns.nix;
  neoscroll = import ./neoscroll.nix;
  scrollview = import ./scrollview.nix;
  oil = import ./oil.nix;
  noice = import ./noice.nix;
  fidget = import ./fidget.nix;
  rainbow-delimiters = import ./rainbow-delimiters.nix;
  autopairs = import ./autopairs.nix;
  comment = import ./comment.nix;
  aerial = import ./aerial.nix;
  terminal = import ./terminal.nix;
  typst-preview = import ./typst-preview.nix;
  surround = import ./surround.nix;
  lualine = import ./lualine.nix;
  smear-cursor = import ./smear-cursor.nix;

  # markdown
  render-markdown = import ./render-markdown.nix;

  # repl
  # iron = import ./iron.nix;
  # jupyter plugins
  # molten = import ./molten.nix;
  # quarto = import ./quarto.nix;
  # jupytext = import ./jupytext.nix;
  # treesitter-textobjects = import ./treesitter-textobjects.nix;
  # hydra = import ./hydra.nix;
  # image = import ./image.nix;
  # otter = import ./otter.nix;
}
