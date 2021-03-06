function prep()
{
	# systemd executes jenkins in a separate sched cgroup.
	echo 950000 > /sys/fs/cgroup/cpu,cpuacct/system/cpu.rt_runtime_us || true
	echo 950000 > /sys/fs/cgroup/cpu,cpuacct/system/jenkins.service/cpu.rt_runtime_us || true

	ulimit -c unlimited &&
	git clean -dfx &&
	make -j 4 &&
	make -j 4 -C test/zdtm/live &&
	true
}

function fail()
{
	uname -a
	ps axf > ps.log
	cat /sys/kernel/debug/tracing/trace > trace.log
	tar -czf /home/`basename $0`-${GIT_COMMIT}-$(date +%m%d%H%M).tar.gz .
	exit 1
}
