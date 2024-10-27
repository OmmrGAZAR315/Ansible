          # shellcheck disable=SC2095
branchName=$(echo "$GITHUB_REF" | awk -F/ '{print $3}')
          while read -r line; do
            # Extract the host and ansible_user from each line in the inventory
            host=$(echo "$line" | grep -Eo '^[^#;]+(\.[^#;]+)(com|net)')
            ansible_user=$(echo "$line" | grep -Eo 'ansible_user=[^ ]+' | cut -d'=' -f2)
            echo host="$host" ansible_user="$ansible_user"
           ssh -i ~/.ssh/id_ed25519 "$ansible_user@$host" "
            cd /Ansible &&
            git fetch --all &&
            git checkout $branchName &&
            git reset --hard origin/$branchName
          " &
done < <(grep -E '^[^\[#;]' inventory)
wait

