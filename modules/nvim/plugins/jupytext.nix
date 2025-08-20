{
  programs.nixvim = {
    plugins.jupytext = {
      settings = {
        style = "markdown";
        output_extension = "md";
        force_ft = "markdown";
      };
    };
  };
}
