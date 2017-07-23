<?php
    if(count($argv) < 2){
        echo "monitor_mail.php called without an error to report\n";
    }
    else {
        $error_body = $argv[1];
        $subject    = "Monzo Integration Failure";
        mail("ijtabahussain@live.com", $subject, $error_body,"FROM: Monzo Integration Alerts <alert@ijtaba.me.uk>\r\nImportance: High\r\n");
        echo "Email sent\n";
    }
?>
