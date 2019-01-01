;;; pretty-print.el --- Creating named buffer -*- coding: utf-8; lexical-binding: t -*-

;; Author: DKrivets
;; Created: 30 Dec 2018
;; Version: 0.0.1
;; Keywords: pretty print, languages, programming, xml, json, html
;; Homepage: https://github.com/dkrivets/text-buffer
;; Package-Require: ((emacs "24"))

;;; Commentary:
;;  Pretty print using external tools.
;;  Example of xml:
;;  <note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>
;;  Result:
;;  <note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>
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


(defun pretty-print--cmd (cmd)
  "Run CMD by shell in Emacs."
  (if (< 0 (length cmd))
      (let ((b (if mark-active (min (point) (mark)) (point-min)))
            (e (if mark-active (max (point) (mark)) (point-max))))
        (shell-command-on-region b e cmd (current-buffer) t))
    (error "No CMD to run in shell!")))


(defun pretty-print--standard-completion (prompt alist)
  "Standart completion which use PROMPT as question for user action.
ALIST as list of completion.
Example, for debug:
\\(pretty-print--standard-completion \"asd: \" (list \"asd\" \"qwe\"))\."
  (interactive)
  ;; Prepare list for completion.
  ;; It must be looks like (("test" 1) ("test2" 2))
  (let ((num    (length alist))
        (c-list '())
        (a-list alist))
    (dolist (element a-list)
      (progn
        (push `(,element ,num) c-list)
        (setq num (1- num))))
    (completing-read prompt c-list nil t "")))


(defun pretty-print--ido-completion (prompt alist)
  "IDO completion which use PROMPT as question for user action.
ALIST as list of completion.
Uses only if IDO works."
  (ido-completing-read prompt alist))


(defun pretty-print--completion ()
  "Completion.  Main function."
  (interactive)
  (let ((prompt "Type: ")
        (alist  '("xml" "html" "json_pp")))
    (if (bound-and-true-p ido-mode)
        (pretty-print--ido-completion prompt alist)
      (pretty-print--standard-completion prompt alist))))


(defun pretty-print--get-var (cmd)
  "Get value of variables by text - CMD."
  ;; pretty-print-xml
  ;; We can use also "(progn pretty-print-%s)"
  (eval (car (read-from-string (format "pretty-print-%s" cmd)))) )


;;;###autoload
(defun pretty-print()
  "Run process."
  (interactive)
  (let ((cmd (pretty-print--completion)))
    (pretty-print--cmd (pretty-print--get-var cmd))))

  
;;;###autoload
(define-minor-mode pretty-print-mode
  "PRETTY-PRINT mode."
  :group 'pretty-print
  :require 'pretty-print
  :lighter " pp"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c p") 'pretty-print)
            map)
  :global t
  )


(provide 'pretty-print)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; pretty-print.el ends here
