{...}: {
  plugins.molten.enable = true;
  plugins.molten.python3Dependencies = p:
    with p; [
      pynvim
      jupyter-client
      cairosvg
      ipython
      nbformat
      ipykernel
      polars
    ];
}
