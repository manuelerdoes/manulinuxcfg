speedyscan() {
  for PORT in {1..10000}
  do 
    echo $PORT 1>&2
    (nc -w 1 -vnz $1 $PORT 2>&1 | grep -v "timed out" &)
  done
  echo "finito" 1>&2
}
