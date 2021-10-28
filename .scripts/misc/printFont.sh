for range in $(fc-match --format='%{charset}\n' "$1"); do
    for n in $(seq "0x${range%-*}" "0x${range#*-}"); do
        n_hex=$(printf "%04x" "$n")
        # using \U for 5-hex-digits
        printf "%-5s\U$n_hex\t" "$n_hex"
        count=$((count + 1))
        if [ $((count % 10)) = 0 ]; then
            printf "\n"
        fi
    done
done
printf "\n"
