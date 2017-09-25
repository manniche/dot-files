for i in /etc/novoenv.d/*.sh; do
    if [ -r "$i" ]; then
        . $i
    fi
done        