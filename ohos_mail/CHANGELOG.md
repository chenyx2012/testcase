## v2.0.1

- Add English README
- Add base on the copyright header of the source file
- ArkTs Indicates syntax adaptation
- Interface usage change: GlobalContext replaces globalThis

## v2.0.1-rc.1

- Add base on the copyright header of the source file

## v2.0.1-rc.0

- ArkTs Indicates syntax adaptation
- Interface usage change: GlobalContext replaces globalThis

## v2.0.0

- Adaptation DevEco Studio: 4.0 Release(4.0.3.415), SDK: API10 Release(4.0.10.6)
- The package management tool is changed from npm to ohpm
- Fix xts tests
- Modify the smtp mail forwarding demo page
- Modify the email sending logic
- Modify the file name error
- Modify the problem that some IMAP emails cannot resolve attachments or inline pictures
- Modify the misalignment of the attached body of some IMAP emails
- Modify some IMAP mail structure parsing failure
- Modify the garbled text caused by some IMAP mail parsing errors
- Modify the socket closing operation in the logout command of the IMAP
- Modify the problem that the attachment name of some POP3 emails cannot be obtained, resulting in the failure to obtain the entire email
- Modify POP3 email deletion failure
- Fixed the issue that some emails flash back and cannot be displayed
- Modify Message message parsing problems
- Add "\r\n" in the attachment
- Modify the mimeType display problem
- Fixed an issue where the results of the build message were not displayed correctly
- Fixed attachment resolution issues
- Fixed some email subject resolution issues
- Dead attachment when modifying parseAttachment
- Modify garbled characters in the email subject and mail loading failure
- Fixed an issue where sending emails with attachments failed in TaskPool
- Added exception handling for the send method of the socket in SMTP

## v1.1.6
- If the send method of the socket is modified, no callback is processed.
- Fixed an issue where pop3 could not download 20 attachments
- Modify the join method
- Modify the problem that POP3 parses attachment content with an extra line of labels

## v1.1.5
- Modify the timeout mechanism for imap to receive attachments
- Handles line breaks in attachments
- Modify failure to obtain large pop3 attachments
- Modified Some mailboxes of the A15 and A16 commands do not recognize the problem

## v1.1.4

- Fixed an issue where the topic could not be obtained
- Fixed the problem that pop3 cannot obtain html and text garbled characters
- Added whether the pop3 protocol contains attachment interfaces
- Modify the imap method for obtaining attachments
- Change the pop3 mail subject resolution mode
- Modify the pop3 protocol failed to obtain large attachments
- Modified whether the attachment interface failed to return
- Modify copy mail problem
- Modify the pop3 attachment size problem
- Fixed whether the attachment interface contains embedded images returned as attachments
- Modification of pop3 attachment content does not remove \r\n issue
- Modify pop3 garbled characters

## v1.1.3

- Modify the failure to send mails from the wo mailbox
- Fixed an issue where attachment files contain newlines
- Added interface to get calendar in mail
- Modify mail resolution issues
- Change the pop3 currentCmd setting time of Store

## v1.1.2

- The copyMessages method returns the uid of the message that copies the copy
- Fixed html garbled characters
- Added pop3 timeout mechanism
- Added the syncExpunge interface and modified the expunge interface
- Fixed a flash back issue when getting forwarded messages
- Modify Util's decode64 method
- Added the interface for obtaining inline accessories
- Modify the internal logic of obtaining attachments
- Modified the secondary callback problem
- Added a timeout mechanism for smtp
- Modified the getUnreadMessageCount method
- Fixed the error of adding an image to the html of 126 mail as an attachment
- Fixed some utf-8 format message decoding error
- Fixed the issue that mailbox 126 could not send emails with pictures or attachments larger than 1MB

## v1.1.1

- Modify the number of unReadMessageCount obtained. -1 Question
- Add the getTextSize method for MimeMultipart
- modifying folder. SyncGetMessageByUID interface to get less than the message
- Modify the error that the text cannot be obtained
- Change the socket to a local variable
- Added interface to get html size
- Compatible with encoding error reporting
- Modify how many bytes before the syncGetPartText and syncGetPartHtml methods get Text and Html
- Fixed parsing issues when syncGetPartText gets part of the text
- Solve the problem of deleting emails and immediately getting the next email details error
- Modified the problem of quickly obtaining full email content for multiple times
- Delete some redundant email content
- Modify some mail garbled characters, compatible with 7-bit encoding
- Added an imap timeout mechanism

## v1.1.0

- Modify text garbled characters
- Modify summary garbled characters
- Modify topic garbled characters

## v1.0.9

- Modified Some mail bodies cannot be obtained
- Fixed the problem that the getAllHeaders card died
- Modify the email subject garbled characters
- Fixed an error in obtaining the specified mailbox folder
- ohos_mail The multi-license license is used
- Modified README.md profile
- Modify the Copyright of files in the /mail/src/main/ets/mail/ directory

## v1.0.8

- Add IMAP to get the first few bytes of the text
- Add IMAP to get the first few bytes of Html
- Modify the sender and recipient email garbled characters
- README.md Adds project information

## v1.0.7

- Modify the failure to obtain folders from some mailboxes
- Modify the getMessageByUID logical problem
- Modified the flag parameter passing mode

## v1.0.6

- Modify the failure to move mails on mailbox 126
- Modified some mail imap protocols to obtain summary crash problems
- Supports the imap protocol to obtain the attachment summary and text interface separately

## v1.0.5

- Modified the problem of connecting pop3 and then connecting smtp to connect twice
- Solve the problem that some platforms send emails without prompting
  N/A Modify Mailbox 189 Failed to obtain mailbox information occasionally
- Solve the problem of sending emails to some mailboxes, setting multiple CC and BCC failures

## v1.0.4

- ADAPTS socket.TLSSecureOptions to the newly named attribute password, excluding the passwd field

## v1.0.3

- adaptation DevEco Studio 3.1 Beta1 version (3.1.0.200).
- Compatible with OpenHarmony SDK API version 9(3.2.10.6).
- Supports the ssl encryption protocol
- Solved some message body and html display garbled characters
- Solved the problem that some mail body and html could not be obtained
- Resolve the problem of incomplete email subject content parsing
- Fixed QQ mailbox reading qq security center mail flash back issue
- Resolves the problem that the tlssocket secondary connection does not respond

## v1.0.2

- Function implemented
- Support pop3 protocol

## v1.0.1

- Function implemented
1. Parse emails in RFC822 format
2. Build the presentation of the email message
3. Check the MIME type of the file
4. Send mail (add HTML embedded images, attachments)
5. Receive emails
6. Set the CC
7. Set BCC
8. The forwarding mail
9. Respond to emails
10. Delete the email
11. Obtain unread emails
12. Obtain the read email
13. Get all emails
14. Obtain the deleted information
15. Create an email address
16. Rename the mailbox
17. Delete email
18. Get the size of the message
19. Obtain the email Flag
20. Obtain the mail UID based on the mail index
21. Support smtp and imap protocols

