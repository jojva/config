# Algolia repos, cloned in ~/workspace. After dotfiles, for .gitconfig's git-lfs filter.

source ${0:A:h}/../lib.sh

repos=(
    AlgoliaSaaS
    metis
)

for repo in $repos; do
    ensure_clone git@github.com:algolia/$repo.git $WORKSPACE_DIR/$repo
done
