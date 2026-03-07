# Installing Software Forge for OpenCode

## Steps

1. Clone the repository:
```bash
git clone https://github.com/AhmedHamadto/software-forge.git
```

2. Symlink the skills into your OpenCode skills directory:
```bash
ln -s "$(pwd)/software-forge/skills" ~/.opencode/skills/software-forge
```

3. Verify:
```bash
ls ~/.opencode/skills/software-forge/
```

## Usage

Start any project with:
```
/software-forge
```
