<?php

// Define some constants
define( "RECIPIENT_NAME", "John Smith" );
define( "RECIPIENT_EMAIL", "smithremi70@yahoo.com" );
define( "EMAIL_SUBJECT", "website form Message" );

// Read the form values
$success = false;
$senderName = isset( $_POST['senderName'] ) ? preg_replace( "/[^\.\-\' a-zA-Z0-9]/", "", $_POST['senderName'] ) : "";
$senderEmail = isset( $_POST['senderEmail'] ) ? preg_replace( "/[^\.\-\_\@a-zA-Z0-9]/", "", $_POST['senderEmail'] ) : "";
$message = isset( $_POST['message'] ) ? preg_replace( "/(From:|To:|BCC:|CC:|Subject:|Content-Type:)/", "", $_POST['message'] ) : "";

// If all values exist, send the email
if ( $senderName && $senderEmail && $message ) {
  $recipient = RECIPIENT_NAME . " <" . RECIPIENT_EMAIL . ">";
  $headers = "From: " . $senderName . " <" . $senderEmail . ">";
  $success = mail( $recipient, EMAIL_SUBJECT, $message, $headers );
}

// Return an appropriate response to the browser
if ( isset($_GET["ajax"]) ) {
  echo $success ? "success" : "error";
} else {
?>

<html>
  <head>
    <title>Thanks!</title>
  </head>
  <body>
  <?php if ( $success ) echo "<div style='text-align:center'><h1>Thanks for sending your message! We will get back to you shortly.</div></h1>" 
  ?>
  <?php if ( !$success ) echo "<div style='text-align:center'><h1 style='color: #ff0000'>There was a problem sending your message. Please fill out all form fields.</div></h1>" ?> 
    <!--<p>Click your browser's Back button to return to the page.</p>-->
    <script type="text/javascript"> 
    setTimeout('window.location="http://www.xavier-marketing.com/contact.html"',5000); 
</script>
  </body>
</html>
<?php
}
?>


