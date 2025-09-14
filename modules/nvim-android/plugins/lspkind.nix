{
  programs.nixvim.plugins.lspkind = {
    enable = true;
    cmp.enable = false;
    settings = {
      preset = "codicons";
      mode = "symbol_text";
    };
  };
}
