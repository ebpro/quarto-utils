#!/bin/bash

# Set strict error handling
set -euo pipefail

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Error handling function
error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# Create output directories if they don't exist
mkdir -p _output/_slides || error "Failed to create output directories"

# Move speaker notes to slides directory with error handling
find . -name "*-speaker.html" -not -path "./_output/*" -print0 | while IFS= read -r -d '' file; do
    if ! mv "$file" _output/_slides/; then
        error "Failed to move speaker notes: $file"
    fi
done

# Create .htaccess for speaker notes protection
cat > _output/_slides/.htaccess << 'EOF'
AuthType Basic
AuthName "Speaker Notes - Restricted Access"
AuthUserFile .htpasswd
Require valid-user

# Prevent directory listing
Options -Indexes

# Deny access to .htaccess and .htpasswd
<FilesMatch "^\.ht">
    Require all denied
</FilesMatch>
EOF

# Create .htpasswd file if it doesn't exist
# if [ ! -f "_output/_slides/.htpasswd" ]; then
#    htpasswd -c _output/_slides/.htpasswd admin
#fi

# Set proper permissions
chmod 644 _output/_slides/.htaccess
#chmod 644 _output/_slides/.htpasswd

echo -e "${GREEN}[SUCCESS]${NC} Post-render processing completed"