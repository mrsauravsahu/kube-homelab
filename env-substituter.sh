#!/bin/bash
# env-substituter.sh - Render YAML files by substituting {env:VARIABLE} placeholders
# Usage: ./env-substituter.sh [yaml_files...]
# If no files provided, processes all *.yaml, *.yml files in current directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0
CURRENT_DIR="$(pwd)"

# Process YAML file and substitute env vars
process_yaml() {
    local input_file="$1"
    local filename=$(basename "$input_file")
    local ext="${filename##*.}"
    local output_file="${filename%.*}.local.${ext}"
    local output_path="$(cd "$(dirname "$input_file")" && pwd)/${output_file}"
    
    echo "Rendering: $filename"
    
    # Check for {env:VAR} placeholders
    local has_placeholder=$(grep -c "{env:" "$input_file" 2>/dev/null)
    if [[ "$has_placeholder" -eq "0" ]]; then
        return 0
    fi
    
    # Read file and output line by line with substitutions
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Keep track of what we still need to process on this line
        local line_copy="$line"
        local replaced=false
        
        # Keep replacing until no more {env:VAR} patterns are found
        while [[ "$line_copy" == *\{env:*\}* ]]; do
            # Extract all variable names on this line
            local var_names=$(echo "$line_copy" | grep -oE '\{env:[A-Za-z0-9_]+\}' | sed 's/{env://;s/}//' | tr '\n' ' ')
            
            if [[ -z "$var_names" ]]; then
                break
            fi
            
            for var_name in $var_names; do
                # Check if environment variable is set
                if [[ -z "${!var_name+x}" ]]; then
                    echo "Error: Environment variable missing: $var_name"
                    echo "  File: $filename"
                    echo "  Line: $(grep -n "\{env:$var_name\}" "$input_file" | head -1 | cut -d: -f1)"
                    ERRORS=$((ERRORS + 1))
                    break
                fi
                
                local var_value="${!var_name}"
                # Replace using parameter expansion
                line_copy="${line_copy//\{env:$var_name\}/$var_value}"
                replaced=true
            done
            
            [[ "$replaced" == true ]] || break
        done
        
        printf '%s\n' "$line_copy"
    done < "$input_file" > "$output_path"
    
    echo "  -> Created: $output_path"
}

# Process single file argument (if provided) or all yaml files in directory
args="$@"
if [[ -z "$args" ]]; then
    # Find all .yaml and .yml files in current directory and subdirectories
    yaml_files=($(find "$SCRIPT_DIR" -maxdepth 1 \( -name "*.yaml" -o -name "*.yml" \) -type f 2>/dev/null || true))
    
    # Sort for consistent order
    IFS=$'\n' yaml_files=($(sort <<< "${yaml_files[*]}"))
    unset IFS
    
    if [[ ${#yaml_files[@]} -eq 0 ]]; then
        echo "No YAML files found in $SCRIPT_DIR/"
        exit 0
    fi
else
    yaml_files=("$@")
fi

# Process each file
for file in "${yaml_files[@]}"; do
    if [[ -f "$file" ]]; then
        process_yaml "$file"
    fi
done

if [[ $ERRORS -gt 0 ]]; then
    echo ""
    echo "Render completed with $ERRORS error(s)"
    exit 1
fi

exit 0
