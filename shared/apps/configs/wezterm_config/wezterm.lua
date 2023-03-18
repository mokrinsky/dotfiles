local wezterm = require 'wezterm'
local hyperlink = require 'hyperlink'
require 'tabbar'
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

return {
  adjust_window_size_when_changing_font_size = false,
  allow_square_glyphs_to_overflow_width = 'Always',
  audible_bell = 'Disabled',
  automatically_reload_config = true,
  color_scheme = 'Catppuccin Mocha', -- or Macchiato, Frappe, Latte
  colors = {
    tab_bar = {
      background = 'rgba(30, 30, 46, 0.05)',
    },
  },
  debug_key_events = false,
  enable_scroll_bar = false,
  font = wezterm.font_with_fallback {
    {
      family = 'Berkeley Mono',
      harfbuzz_features = { 'calt=0', 'clig=1', 'liga=1' },
    },
  },
  font_size = 12,
  hyperlink_rules = hyperlink,
  scrollback_lines = 10000,
  swallow_mouse_click_on_window_focus = false,
  tab_max_width = 32,
  use_fancy_tab_bar = false,
  use_ime = false,
  window_background_opacity = 0.8,
  window_decorations = 'RESIZE',
  window_padding = {
    bottom = 0,
    left = 2,
    right = 2,
    top = 0,
  },
}
