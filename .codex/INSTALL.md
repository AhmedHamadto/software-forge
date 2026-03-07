# Installing Software Forge for Codex

Codex uses native skill discovery via symlinks.

## Steps

1. Clone the repository:
```bash
git clone https://github.com/AhmedHamadto/software-forge.git
```

2. Create the skills directory if it doesn't exist:
```bash
mkdir -p ~/.agents/skills
```

3. Symlink the skills:
```bash
ln -s "$(pwd)/software-forge/skills" ~/.agents/skills/software-forge
```

4. Verify:
```bash
ls ~/.agents/skills/software-forge/
```

You should see all 28 skill directories.

## Usage

Start any project with:
```
/software-forge
```
