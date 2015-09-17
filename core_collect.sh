!/bin/bash

# Intended to be used as core_pattern filter:
# echo "| /path_to/core_collect.sh %p %s %e " > /proc/sys/kernel/core_pattern

usage() {
	exit_msg "Usage: $0 %p %s %e (see man 5 core for parameters meaning)"
}

exit_msg() {
	echo $1
	exit 1
}

report_to=email@adress.xx
report_from=coredump@`hostname`
coredump_dir=/tmp

[ $# -eq 3 ] || usage $0

pid=$1
signal=$2
exe_name=$3

filename=$coredump_dir/`hostname`.$exe_name.core.$pid.gz
tmpfile=`mktemp`
gzip > $tmpfile
mv $tmpfile $filename

mail -r $report_from -s "Process $exe_name have crashed" $report_to <<-__EOF
	Hello!
	Process $exe_name (PID=$pid) have crashed due to signal $signal.
	Coredump is available at $filename.

	Have a nice day.
__EOF
