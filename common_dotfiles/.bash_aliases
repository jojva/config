ddog () {
	if [ $# -ne 1 ]
	then
		echo "Missing a cluster name"
		return 1
	fi
	cluster_name="$1"
	/Applications/Firefox.app/Contents/MacOS/firefox -P "pro" --no-remote "https://alg-classic-search.datadoghq.com/dashboard/j8u-r3y-u4w/cluster-analysis?tpl_var_cluster-name%5B0%5D=${cluster_name}&tpl_var_cluster-regex%5B0%5D=${cluster_name}-*&live=true" &
}

algoliasaas_setup () {
	# Detect OS
	if [[ "$OSTYPE" == "darwin"* ]]; then
		os_prefix="osx"
	else
		os_prefix="ubuntu-noble"
	fi

	if [ "$1" = "debug" ]; then
		build_profile="${os_prefix}_debug"
		build_path="build/Debug"
		build_preset="conan-debug"
	elif [ "$1" = "release" ]; then
		build_profile="${os_prefix}_release"
		build_path="build/Release"
		build_preset="conan-release"
	else
		echo "Usage: algoliasaas_setup <debug|release>"
		return 1
	fi
	source .venv/bin/activate
	conan install . --profile="$build_profile" --profile:build="$build_profile" --build=missing
	source "$build_path/generators/conanbuild.sh"
	cmake --preset "$build_preset"
	cmake --build -j 6 --preset "$build_preset"
	deactivate
}

alias ls='ls -GhF --color=auto'
alias ll='ls -al'
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
alias ninja='~/dev/mold/build/mold -run ninja -j 6'
alias nd='ninja -C build/Debug'
alias nr='ninja -C build/Release'
alias afull='adebug ; arelease ; asanitize'
alias arelease='cmake -H. -Bbuild/release -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && nr'
alias adebug='cmake -H. -Bbuild/debug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && nd'
alias asanitize='cmake -H. -Bbuild/sanitize -DCMAKE_BUILD_TYPE=Sanitize -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -GNinja && ns'
alias ee='sudo killall BuildServer ; sudo killall -9 nginx ; ./tools/launch_builder.sh & ./test/e2e/launch_nginx.sh &'
alias cpj='cp -r ~/workspace/config/tests_jojo/ ~/workspace/AlgoliaSaaS/test/e2e/'

# AlgoliaSaaS with Conan
alias asd='algoliasaas_setup debug'
alias asr='algoliasaas_setup release'
alias abd='cmake --build -j 6 --preset conan-debug'
alias abr='cmake --build -j 6 --preset conan-release'
