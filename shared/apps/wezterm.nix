{pkgs, ...}: {
  xdg.configFile = {
    "wezterm/hyperlink.lua" = {
      source = ./wezterm/hyperlink.lua;
    };
    "wezterm/tabbar.lua" = {
      source = ./wezterm/tabbar.lua;
    };
  };
  programs.wezterm = {
    enable = true;
    package = pkgs.nur.repos.nekowinston.wezterm-nightly;
    extraConfig = ''
      local hyperlink = require 'hyperlink'
      require 'tabbar'

      return {
        adjust_window_size_when_changing_font_size = false,
        allow_square_glyphs_to_overflow_width = 'Always',
        animation_fps = 1,
        audible_bell = 'Disabled',
        automatically_reload_config = true,
        color_scheme = 'Catppuccin Mocha', -- or Macchiato, Frappe, Latte
        colors = {
          tab_bar = {
            background = 'rgba(30, 30, 46, 0.3)',
          },
        },
        debug_key_events = false,
        enable_scroll_bar = false,
        font = wezterm.font_with_fallback {
          {
            family = 'JetBrains Mono',
            harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
          },
        },
        font_size = 12,
        front_end = 'Software',
        hide_tab_bar_if_only_one_tab = true,
        hyperlink_rules = hyperlink,
        line_height = 0.9,
        -- macos_window_background_blur = 20,
        scrollback_lines = 10000,
        swallow_mouse_click_on_window_focus = false,
        tab_bar_style = {
          new_tab = "",
          new_tab_hover = "",
        },
        tab_max_width = 32,
        use_fancy_tab_bar = false,
        use_ime = false,
        window_background_opacity = 0.7,
        window_decorations = 'RESIZE',
        window_padding = {
          bottom = 0,
          left = 5,
          right = 5,
          top = 0,
        },
      }
    '';
  };
}
