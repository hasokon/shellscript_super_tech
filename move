#!/bin/bash

ECHO() {
	echo -e "$@"
}

cls() {
	ECHO '\033[H\033[2J\c'
}

getchar() {
	dd bs=1 count=1 2> /dev/null
}

cursol(){
	ECHO '\033['$2';'$1'H\c'
}

beep() {
	ECHO '\07\c'
}

new_screen() {
	ECHO '\033\067\033[?47h\c'
}

exit_screen() {
	ECHO '\033[?47l\033\070\c'
}

init_tty() {
	stty -icanon -echo min 1 -ixon
	cls
	new_screen
}

quit_tty() {
	cls
	exit_screen
	stty icanon echo eof '^d' ixon
}

# trap

if (trap '' INT) 2> /dev/null
then
	SIGINT=INT SIGQUIT=QUIT SIGTERM=TERM SIGSTP=TSTP
else
	SIGINT=2 SIGQUIT=3 SIGTERM=15 SIGSTP=18
fi

# program

init_map() {
	cursol 1 1
	ECHO '+-----------------------------------------------------------------------------+ \c'

	i=2
	while [ $i -le 23 ]; do
		cursol 1 $i
		ECHO '|                                                                             | \c'

		i=$((i + 1))
	done

	cursol 1 24
	ECHO '+-----------------------------------------------------------------------------+ \c'
}

# main

trap '' $SIGINT $SIGQUIT $SIGTSTP

init_tty
init_map

x=40
y=12

while :
do
	cursol $x $y
	key=`getchar`
	case "$key" in
		q)
			break
			;;
		h|D|4)
			if [ $x -gt 2 ]; then
				x=$((x - 1))
			else
				beep
			fi
			;;
		j|B|2)
			if [ $y -lt 23 ]; then
				y=$((y + 1))
			else
				beep
			fi
			;;
		k|A|8)
			if [ $y -gt 2 ]; then
				y=$((y - 1))
			else
				beep
			fi
			;;
		l|C|6)
			if [ $x -lt 78 ]; then
				x=$((x + 1))
			else
				beep
			fi
			;;
	esac
done

quit_tty
exit

