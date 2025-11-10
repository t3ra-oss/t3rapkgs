export module "."

# Re-export env var from submodules
export-env {
    use cc.nu []
}

use "."

export alias cdg = git cd
export alias ga = git add
export alias gaa = git add --all
export alias gC = git cc commit
export alias gcb = git checkout -B
export alias gck = git cc checkout
export alias gcl = git cc logs
export alias gco = git checkout
export alias gl = git pull
export alias gp = git push
export alias gp! = git push --force-with-lease
export alias grbc = git rebase --continue 
export alias grbmain = git rebase origin/main
export alias gro = git reset origin/main
export alias gst = git st
