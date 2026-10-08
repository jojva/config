# Algolia repos, cloned in ~/workspace. After dotfiles, for .gitconfig's git-lfs filter.

source ${0:A:h}/../lib.sh

repos=(
    AlgoliaSaaS
    AlgoliaWeb
    alcli
    dictionaries
    engineering-duty
    metis
    metis-release-manager
)

for repo in $repos; do
    ensure_clone git@github.com:algolia/$repo.git $WORKSPACE_DIR/$repo
done
