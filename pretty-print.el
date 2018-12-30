;;; pretty-print.el --- Creating named buffer -*- coding: utf-8; lexical-binding: t -*-

;; Author: DKrivets
;; Created: 30 Dec 2018
;; Version: 0.0.1
;; Keywords: pretty print, languages, programming, xml, json, html
;; Homepage: https://github.com/dkrivets/text-buffer
;; Package-Require: ((emacs "24"))

;;; Commentary:
;;  Pretty print using external tools.

;;  Package has an one key-binding to create a buffer: C-x p

;;; Code:
(defgroup pretty-print nil "Pretty print using external tools." :group 'applications)


(defcustom pretty-print-xml "xmllint --format -"
  "Pretty print command for XML."
  :type 'string
  :group 'pretty-print)


(defcustom pretty-print-json "json_pp -f json -json_opt pretty"
  "Pretty print command for JSON."
  :type 'string
  :group 'pretty-print)


(defcustom pretty-print-html "xmllint --format --html --pretty 2 -"
  "Pretty print command for HTML."
  :type 'string
  :group 'pretty-print)


(defvar pretty-print--map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-x p") 'text-buffer-create-buffer))
  "Keymap for using pretty print.")


;;;###autoload
(define-minor-mode pretty-print
  "PRETTY-PRINT mode."
  :group 'pretty-print
  :require 'pretty-print
  :lighter " pp"
  :keymap pretty-print-map
  :global t
  (make-local-variable 'pretty-print-map)
  )

(provide 'pretty-print)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; pretty-print.el ends here
