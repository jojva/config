# Algolia repos, cloned in ~/workspace. After dotfiles, for .gitconfig's git-lfs filter.

source ${0:A:h}/../lib.sh

repos=(
    AlgoliaSaaS
    AlgoliaWeb
    alcli
    atlas-project
    chef
    dictionaries
    engineering-duty
    metis
    metis-release-manager
    salt-states
)

for repo in $repos; do
    ensure_clone git@github.com:algolia/$repo.git $WORKSPACE_DIR/$repo
done
