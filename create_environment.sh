#!/bin/bash

mkdir -p submission_reminder_app

mkdir -p submission_reminder_app/assets
mkdir -p submission_reminder_app/config
mkdir -p submission_reminder_app/modules
mkdir -p submission_reminder_app/app

cat <<EOL > submission_reminder_app/assets/submissions.txt
student, assignment, submission status
here, Shell Navigation, submitted
Noel, Shell Navigation, not submitted
Alice, Shell Navigation, submitted
Bob, Shell Navigation, not submitted
Charlie, Shell Navigation, submitted
Diana, Shell Navigation, not submitted
Eve, Shell Navigation, submitted
EOL

cat <<EOL > submission_reminder_app/config/config.env
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

cat <<EOL > submission_reminder_app/modules/functions.sh
#!/bin/bash

function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL

cat <<EOL > submission_reminder_app/app/reminder.sh
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"


echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOL

cat <<EOL > submission_reminder_app/startup.sh
#!/bin/bash

echo "Starting the submission reminder application..."

./app/reminder.sh
EOL

chmod +x submission_reminder_app/app/reminder.sh
chmod +x submission_reminder_app/startup.sh
chmod +x submission_reminder_app/modules/functions.sh

echo "Environment setup complete!"
