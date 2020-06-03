# assign a prompt color by hashing the letters of the hostname
# idea copied from the irssi script 'nickcolor.pl'
# Daniel Kertesz <daniel@spatof.org>

autoload -U colors
colors

setopt prompt_subst

colnames=(
	red
	green
	yellow
	blue
	magenta
	cyan
)

# Create color variables for foreground and background colors
for color in $colnames; do
	eval f$color='%{${fg[$color]}%}'
	eval b$color='%{${bg[$color]}%}'
done

# Hash the hostname and return a fixed "random" color
function _hostname_color() {
	local chash=0
	foreach letter ( ${(ws::)HOST[(ws:.:)1]} )
		(( chash += #letter ))
	end
	local crand=$(( $chash % $#colnames ))
  let i=$crand+1
	local crandname=$colnames[$i]
	echo "%{${fg[$crandname]}%}"
}
hostname_color=$(_hostname_color)
