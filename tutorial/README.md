## Overview

I have done an initial run of PopGLen at this path: `/cfs/klemming/projects/supr/snic2020-6-170/Sofie_N/FluctSel-Ischnura/tutorial`
I named this run **popglen-test-slurm** and the snakemake is set up and ready to rock. No need for you to run the `snakedeploy` command at this path.
However, to practice running the pipeline and using Git, I want you to create a new personalized profile and config.

## What YOU need to do
### 1. Get access to the GitHub repo
Either take over the access of the GitHub repo or become a collaborator (I have invited you to both options). You must have this set before you can `push` and `pull` to and from the repository.
### 2. Set up SSH authentication with GitHub
When you connect to a GitHub repository from Git, you need to authenticate using either HTTPS or SSH. For sanity, ease of use, and feeling like a *professional master computer scientist 1337_elite hacker,* you should set up the **SSH key**.

You will need to set up SSH keys for both Dardel and your local computer.

You should already have an SSH key since you are connecting to Dardel. This same key can be used for GitHub. Check your existing keys by typing this into the terminal on your local PC and on Dardel:

```bash
# List existing keys
ls ~/.ssh/*.pub

# See the key
cat ~/.ssh/id_ed25519.pub 
```

If both machines have keys or even the same key, go ahead and add it/them to your GitHub account.

Or, if you want to keep it simple, just follow the instructions here and do it for your local PC and Dardel. But remember to rename them like `id_ed25519-local` or `id_ed25519-pdc` so you don't overwrite your existing key.

- https://www.youtube.com/watch?v=X40b9x9BFGo (1min 51sec video how-to)
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

### 3. Verify your Git access
When SSH is set up, navigate to the project directory and check that everything works:

```bash
# Move to the project directory
cd /cfs/klemming/projects/supr/snic2020-6-170/Sofie_N/FluctSel-Ischnura/tutorial

# Test your SSH connection to GitHub
ssh -T git@github.com
# If successful, you should see: "Hi [username]! You've successfully authenticated..."

# Verify you can access the repo by checking the remote
git remote -v

# Check the repo status
git status
```

**Note:** Since we're working on the same shared HPC directory, the repository is already here. You don't need to `clone` or `pull`. We're both working directly in the same local copy. Just make sure your SSH key is set up so you can `push` your changes later.

### 4. Create your own Git branch

Before making any changes, create your own branch so we don't interfere with each other's work:

```bash
# Create and switch to your new branch
git branch sofie-test
git switch sofie-test

# Verify you're on your new branch
git branch
```

### 5. Create your personalized config file
Copy the existing config and give it your own name:

```bash
cp config/config-full.yaml config/config-sofie.yaml
```

Now edit `config/config-sofie.yaml` and change the **dataset** name so your results don't overwrite mine:

```yaml
#=====================Dataset Configuration============================#

samples: config/samples.tsv

units: config/units.tsv

dataset: "popglen-sofie"        # <-- Change this to your own name

#===================== Reference Configuration ========================#
```

### 6. Create your personalized profile

Copy the existing profile directory:

```bash
cp -r profiles/dardel-andbou profiles/dardel-sofie
```

Now edit `profiles/dardel-sofie/config.v8+.yaml` and update the `tmpdir` to use your username:

```yaml
restart-times: 3
local-cores: 2
printshellcmds: true
use-conda: true
use-singularity: true
jobs: 999
keep-going: true
max-threads: 128
executor: slurm
singularity-args: '-B /cfs/klemming'
default-resources:
  - "mem_mb=(threads*1700)"
  - "runtime=60"
  - "slurm_account=naiss2025-22-1413"           
  - "slurm_partition=shared"
  - "nodes=1"
  - "tmpdir='/cfs/klemming/scratch/s/sofie'"   # <-- Change 'a/andbou' to your username path
```

### 7. Commit your changes
Before running the pipeline, commit your new files to Git:

```bash
# See what files you've changed/added
git status

# Add your new files
git add <file names>

# Commit with a message
git commit -m "Short descreptive message of what you have done"

# Push your branch to GitHub
git push -u origin sofie-test
```

### 8. Set up the snakemake environment
Create the mamba environment with all required packages:

```bash
# Create mamba environment (-n names the environment, -c channels to use, -y auto selects yes to all prompts)
mamba create -n popglen -c conda-forge -c bioconda snakemake snakedeploy singularity snakemake-executor-plugin-slurm -y
```

### 9. Run PopGLen
Now you're ready to run the pipeline. This takes about 30 minutes (or up to 1 hour if you need to download container images).
I had issues with `screen` so i recommend you use `tmux` instead.

```bash
# Load the module
module load tmux/3.4

# Start a new session with a name
tmux new -s snakemake

# Activate popglen
mamba activate popglen

# Run your command
snakemake --profile profiles/dardel-sofie --configfile config/config-sofie.yaml
```
You can now detach from screen and have snakemake running in the background:

- Detach from screen: Press `Ctrl+B`, then press `D`
- Check if it's still running: `tmux ls`
- Reattach to check progress: `tmux attach -t snakemake`
- Kill the session: `kill-session -t snakemake`

