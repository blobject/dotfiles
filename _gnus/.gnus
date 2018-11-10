(setq user-mail-address "agaric@protonmail.com"
      user-full-name    "b")
(setq gnus-select-method '(nnnil "")
      gnus-secondary-select-methods
      '((nnmaildir "alocybe"
                   (directory "/data/mail/alocybe/"))
        (nnmaildir "binzter"
                   (directory "/data/mail/binzter/"))
        ))
(setq send-mail-function         'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-smtp-server       "smtp.gmail.com"
      smtpmail-smtp-service      587)
;(setq gnus-topic-topology '(("Gnus" visible)
;                            (("alocybe" visible))
;                            (("binzter" visible))))
;(setq gnus-topic-alist '(("Gnus"
;                          "nnfolder+archive:sent.2018-10"
;                          "nndraft:drafts")
;                         ("alocybe"
;                          "nnmaildir+alocybe:drafts"
;                          "nnmaildir+alocybe:inbox"
;                          "nnmaildir+alocybe:sent"
;                          "nnmaildir+alocybe:spam"
;                          "nnmaildir+alocybe:trash")
;                         ("binzter"
;                          "nnmaildir+binzter:drafts"
;                          "nnmaildir+binzter:inbox"
;                          "nnmaildir+binzter:sent"
;                          "nnmaildir+binzter:spam"
;                          "nnmaildir+binzter:trash")))
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
