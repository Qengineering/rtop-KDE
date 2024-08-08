#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Get the current non-root user
CURRENT_USER=$(logname)

# Determine the directory of the setup script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Check if rtop is in the same directory as the script
RTOP_PATH="$SCRIPT_DIR/rtop"
if [ -f "$RTOP_PATH" ]; then
  echo "rtop found at $RTOP_PATH"
else
  echo "Error: rtop not found in the current directory ($SCRIPT_DIR). Please ensure rtop is present."
  exit 1
fi

# Copy rtop to /usr/local/bin if not already there
if [ ! -f /usr/local/bin/rtop ]; then
  cp "$RTOP_PATH" /usr/local/bin/
  chmod +x /usr/local/bin/rtop
  echo "rtop has been copied to /usr/local/bin."
else
  echo "rtop is already present in /usr/local/bin."
fi

# Define the sudoers entry
SUDOERS_ENTRY="$CURRENT_USER ALL=(ALL) NOPASSWD: /usr/local/bin/rtop"

# Create a new file in /etc/sudoers.d/
SUDOERS_FILE="/etc/sudoers.d/rtop_nopasswd"

# Check if the file already exists
if [ -f "$SUDOERS_FILE" ]; then
  echo "The sudoers file for rtop already exists. Updating it..."
  echo "$SUDOERS_ENTRY" > "$SUDOERS_FILE"
else
  echo "$SUDOERS_ENTRY" > "$SUDOERS_FILE"
fi

# Set correct permissions for the file
chmod 0440 "$SUDOERS_FILE"

# Create a launcher script
LAUNCHER_SCRIPT="/usr/local/bin/rtop-launcher"
cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
konsole --noclose -e bash -c "sudo /usr/local/bin/rtop; exec bash"
EOF

# Make the launcher script executable
chmod +x "$LAUNCHER_SCRIPT"

# Add the alias to the user's .bashrc
BASHRC_FILE="/home/$CURRENT_USER/.bashrc"
ALIAS_CMD="alias rtop='sudo /usr/local/bin/rtop'"

# Check if the alias already exists in .bashrc
if grep -Fxq "$ALIAS_CMD" "$BASHRC_FILE"; then
  echo "The alias for rtop already exists in $BASHRC_FILE."
else
  echo "$ALIAS_CMD" >> "$BASHRC_FILE"
  echo "The alias for rtop has been added to $BASHRC_FILE."
fi

# Define source and destination paths
ICON_SOURCE="$SCRIPT_DIR/rtop_icon.png"
ICON_DEST_DIR="/usr/share/icons/hicolor/128x128/apps"
ICON_DEST="$ICON_DEST_DIR/rtop_icon.png"

# Check if the source icon file exists
if [ -f "$ICON_SOURCE" ]; then
  # Check if the destination directory exists
  if [ ! -d "$ICON_DEST_DIR" ]; then
    # Create the destination directory
    mkdir -p "$ICON_DEST_DIR"
    echo "Created directory $ICON_DEST_DIR."
  fi
  # Copy the icon to the destination directory
  cp "$ICON_SOURCE" "$ICON_DEST"
  echo "Icon has been copied to $ICON_DEST."
else
  echo "Warning: Icon not found at $ICON_SOURCE. The .desktop file will be created without an icon."
fi

# Create .desktop file for rtop
DESKTOP_FILE="/usr/share/applications/rtop.desktop"
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Rtop
Comment=Remote system monitoring tool
Exec=/usr/local/bin/rtop-launcher
Icon=rtop_icon
Terminal=false
Type=Application
Categories=System;Monitor;
EOF

# Ensure the .desktop file is executable
chmod +x "$DESKTOP_FILE"

echo "Setup complete. A .desktop file has been created for rtop."
echo "Please log out and log back in, or start a new shell session for changes to take effect."
echo "You can now find rtop in your applications menu and pin it to the dock if desired."
