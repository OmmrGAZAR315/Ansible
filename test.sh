# shellcheck disable=SC2095
while read -r line; do
  # Extract the host and ansible_user from each line in the inventory
  host=$(echo "$line" | grep -Eo '^[^#;]+(\.[^#;]+)(com|net)')
  ansible_user=$(echo "$line" | grep -Eo 'ansible_user=[^ ]+' | cut -d'=' -f2)
  # shellcheck disable=SC2034
 ssh -i ~/.ssh/id_ed25519 "$ansible_user@$host" "
    echo $ansible_user@$host
    cd /Ansible &&
    currentBranchName=\$(git rev-parse --abbrev-ref HEAD) &&
    echo \"Current branch is \$currentBranchName\" &&
    git fetch --all &&
    git checkout master &&
    git reset --hard origin/master &&
    git checkout \$currentBranchName
    printf \"\n\"
  " &
done < <(grep -E '^[^\[#;]' inventory)
wait

