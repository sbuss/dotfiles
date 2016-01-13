/usr/bin/xmodmap /home/sbuss/.Xmodmap
redshift &

# That \K in the grep is a zero-width look-behind assertion which basically
# means "only match if these digits are preceeded by id=, but don't include
# that in the match!"
TOUCHPAD_ID=$(xinput list | grep TouchPad | grep --only-matching -P 'id=\K([0-9]+)')
xinput set-prop ${TOUCHPAD_ID} "Synaptics Palm Detection" 1
xinput set-prop ${TOUCHPAD_ID} "Synaptics Palm Dimensions" 10, 30
