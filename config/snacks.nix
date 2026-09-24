{
  plugins.snacks = {
    enable = true;
    settings = {
      scratch = {
        enabled = true;
        win = {
          style = "split";
          position = "right";
        };
      };
      bufdelete.enabled = true;
    };
  };
  userCommands = {
    Scratch.command.__raw = "function() Snacks.scratch() end";
    Bd.command.__raw = "function() Snacks.bufdelete.other() end";
  };
}
