# chezmoi source layout

This source is organized around three layers:

- `.chezmoidata/`: shared declarative data used by templates and scripts.
- top-level `dot_*` / `private_*` / `empty_*`: managed files mapped to `$HOME`.
- `run_*`: lifecycle scripts run by chezmoi during `apply`.

## Key entry points

- `.chezmoidata/packages.yaml`: package catalog plus Homebrew install behavior.
- `.chezmoidata/externals.yaml`: external archives and git repos managed by chezmoi.
- `.chezmoidata/git.yaml`: Git identity and platform-specific helper paths.
- `dot_gitconfig.tmpl`: renders Git config from shared data.
- `run_onchange_after_10-install-managed-software.sh.tmpl`: installs managed software on macOS.

## Maintenance notes

- Prefer editing `.chezmoidata/*` when changing reusable values.
- Keep `run_*` scripts thin; push constants into data files when possible.
- Validate changes with `chezmoi execute-template` and `chezmoi diff` before applying broadly.

