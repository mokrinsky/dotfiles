{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.yumi.wezterm;
in {
  options.yumi.wezterm.enable = mkEnableOption "Install wezterm config";

  config.programs.wezterm = mkIf cfg.enable {
    enable = true;
    package = pkgs.writeScriptBin "__dummy-wezterm" "";
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      local c = {}
      if wezterm.config_builder then
        c = wezterm.config_builder()
        c:set_strict_mode(true)
      end

      wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(c, {
        position = "top",
        max_width = 32,
        dividers = "rounded", -- or "slant_left", "arrows", "slant_right", false
        indicator = {
          leader = {
            enabled = false,
          },
          mode = {
            enabled = true,
            names = {
              resize_mode = "RESIZE",
              copy_mode = "VISUAL",
              search_mode = "SEARCH",
            },
          },
        },
        tabs = {
          numerals = "arabic", -- or "roman"
          pane_count = "superscript", -- or "subscript", false
          brackets = {
            active = { "", ":" },
            inactive = { "", ":" },
          },
        },
        clock = { -- note that this overrides the whole set_right_status
          enabled = false,
        },
      })

      local cs = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
      cs.tab_bar.background = 'rgba(30, 30, 46, 0.9)'
      cs.tab_bar.new_tab.bg_color = 'rgba(30, 30, 46, 0.9)'

      c.adjust_window_size_when_changing_font_size = false
      c.allow_square_glyphs_to_overflow_width = 'Always'
      c.animation_fps = 1
      c.audible_bell = 'Disabled'
      c.automatically_reload_config = true
      c.color_schemes = {
        ["Customppuccin"] = cs,
      }
      c.color_scheme = 'Customppuccin'
      c.debug_key_events = false
      c.enable_scroll_bar = false
      c.font = wezterm.font_with_fallback {
        {
          family = 'JetBrains Mono',
          harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
        },
      }
      c.font_size = 13
      c.front_end = 'Software'
      c.hide_tab_bar_if_only_one_tab = true
      c.line_height = 1.0
      c.macos_window_background_blur = 20
      c.mouse_bindings = {
        {
          event = { Down = { streak = 1, button = { WheelUp = 1 } } },
          mods = 'NONE',
          action = act.ScrollByCurrentEventWheelDelta,
          alt_screen = true,
        },
        {
          event = { Down = { streak = 1, button = { WheelDown = 1 } } },
          mods = 'NONE',
          action = act.ScrollByCurrentEventWheelDelta,
          alt_screen = true,
        },
      }
      c.scrollback_lines = 10000
      c.swallow_mouse_click_on_window_focus = false
      c.tab_bar_style = {
        new_tab = "",
        new_tab_hover = "",
      }
      c.tab_max_width = 32
      c.use_fancy_tab_bar = false
      c.use_ime = false
      c.window_background_opacity = 0.9
      c.window_decorations = 'RESIZE'
      c.window_padding = {
        bottom = 35,
        left = 35,
        right = 35,
        top = 25,
      }

      return c
    '';
  };
}
