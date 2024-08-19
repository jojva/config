wf () {
	cluster_name="$1"
	firefox -p pro "https:\//metrics.wavefront.com/dashboards/cluster-analysis\#_v01\(g:(d:172800,ls:!t,s:1695729037,w:'2d'),p:(cluster:(l:'Cluster%20regex',v:'${cluster_name}-*'),cluster-name:${cluster_name}))" &
}

alias lx='exa --long --all -@ --time-style long-iso --color-scale'
alias code='GTK_IM_MODULE="xim" code'
alias c='code .'
alias g='git'
alias k='kubectl'
alias k9s='k9s --kubeconfig ~/.kube/config'
# To add silversearcher's colors to ripgrep
alias rg='rg --colors line:fg:yellow --colors line:style:bold --colors path:fg:green --colors path:style:bold --colors match:fg:black --colors match:bg:yellow --colors match:style:nobold'
alias update='sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade && sudo apt autoremove && sudo apt autoclean '
alias watch='watch --color -n 0.1'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Algolia
alias ninja='/home/joris/dev/mold/build/mold -run ninja -j 6'
alias nd='ninja -C build/debug'
alias nr='ninja -C build/release'
alias ns='ninja -C build/sanitize'
alias afull='adebug ; arelease ; asanitize'
alias arelease='cmake -H. -Bbuild/release -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && nr'
alias adebug='cmake -H. -Bbuild/debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && nd'
alias asanitize='cmake -H. -Bbuild/sanitize -DCMAKE_BUILD_TYPE=Sanitize -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ns'
# alias aiwyu='cmake -H. -Bbuild/debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_CXX_INCLUDE_WHAT_YOU_USE="include-what-you-use;-w;-Xiwyu;--error_always;-Xiwyu;--mapping_file=/usr/lib/llvm-16/include/c++/v1/libcxx.imp;-Xiwyu;--transitive_includes_only" -GNinja && nd'
alias aiwyu='cmake -H. -Bbuild/debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_CXX_INCLUDE_WHAT_YOU_USE="include-what-you-use;-w;-Xiwyu;--error_always;-Xiwyu;--mapping_file=/home/joris/workspace/libcxx.imp;-Xiwyu;--transitive_includes_only" -GNinja && nd'
alias ee='sudo killall BuildServer ; sudo killall -9 nginx ; ./tools/builder.sh & ./e2e/test_nginx.sh &'
