# ArchLinux-alchemy
A personal vault of (*Arch*) *Linux* scripts and ricing procedures, exploring the hidden, magic potential behind your *OS* and transmuting it into a refined digital experience.



---


## 🧪 Easy and powerful Scripts

See the [dedicated README (manifest) for 'scripts' subfolder](./scripts/SCRIPTS_README.md) for more informations.

---


## 🏺 Essence & Configurations (Dotfiles)
A collection of primordial configurations and dotfiles that define the behavior, aesthetics, and interaction logic of the digital environment.

See the [dedicated README (manifest) for 'dotfiles' subfolder](./dotfiles/DOTFILES_README.md) for more informations.

---


## 🛠️ Arch fixes
A collection of specific remedies and configurations to address common (*Arch*) *Linux* issues and system behaviors.

> [!NOTE]
> While these fixes are essential for an optimized *Arch Linux* experience on mobile hardware (like the *HP Victus* series), the logic is **distro-agnostic**. They will function on any *Linux* distribution that utilizes the standard `/sys/class/` kernel interface.

---

### *[.brightness-controls](./dotfiles/shell/custom/.brightness-controls)*
A low-level interface for precise display backlight manipulation without the need for heavy desktop environment plugins.

- **Features:**
    - **Raw Kernel Access:** Directly interacts with `/sys/class/backlight/` for near-instant response;
    - **Percentage-based Logic:** Transmutes raw hardware values into a human-readable 0-100% scale;
    - **Smart Inspection:** Aliases for quick monitoring of current, maximum, and percentage brightness levels.
- **Logic:** It bypasses high-level display managers to provide a "pure" CLI method for brightness control, especially useful for minimalist window managers (WMs) or troubleshooting ACPI issues.

#### Dependencies (Ingredients)
To manipulate the screen's luminosity, the following tools are required:
- [bc](https://www.gnu.org/software/bc/) - For high-precision mathematical calculations;
- [coreutils](https://www.gnu.org/software/coreutils/) - Provides `cat` and `tee` for system file interaction;
- [sed](https://www.gnu.org/software/sed/) - For stream editing and output formatting.

#### Shell Integration
To bridge your shell with the display hardware, add this line to your `.bashrc` or `.zshrc`:

```bash
[[ -f "$HOME/dotfiles/shell/custom/.brightness-controls" ]]  &&  source "$HOME/dotfiles/shell/custom/.brightness-controls"
```



---


## 📜 Ricing & Procedures
*Section under construction.*

This area will soon host detailed Markdown guides and image galleries documenting my specific Arch Linux setup, including terminal aesthetics and window manager configurations.


---


## 🛠️ Installation & Setup

### 1. Clone the Vault
To get all scripts, dotfiles, and procedures, clone the repository:

```bash
git clone https://github.com/IlNick03/ArchLinux-alchemy.git
cd ArchLinux-alchemy
```

### 2. Grant Execution Permissions
To ensure all current and future scripts are executable across all subdirectories,
run this command targeting all `.sh` files recursively and grants execution rights

```bash
find . -type f -name "*.sh" -exec chmod +x {} +
```

### 3. Integration
Each tool may have its own integration steps.
- For the core `fzf` experience, follow the instructions inside `shell-integration-appendix` to update your shell configuration.


---


## ⚖️ License

This project is licensed under the GPL v3.0 License - protecting the freedom of the code for all users.

See the [LICENSE](./LICENSE) file for details.
