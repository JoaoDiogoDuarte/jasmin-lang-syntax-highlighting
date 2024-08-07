;;; jasmin-mode.el --- Major mode for editing Jasmin. -*- coding: utf-8; lexical-binding: t; -*-

(defvar jasmin-keywords
  '("inline" "export" "require" "param" "from" "fn" "return" "for" "to" "returnaddress" "if" "else" "while" "exec")
  "Jasmin keywords.")

(defvar jasmin-jazzline-in-red
  '("abstract" "smt" "cas")
  "Jasmin jazzline-in-red keywords.")

(defvar jazzline-keywords
  '("requires" "predicate" "ensures" "prover" "signed" "tran" "kind")
  "Jazzline keywords.")

(defvar jazzline-misc
  '("\\sum" "\\all" "\\in" "bool" "word_list" "tuple" "bit" "1u" "2u" "4u" "8u" "16u" "32u" "64u" "128u" "256u" "1s" "2s" "4s" "8s" "16s" "32s" "64s" "128s" "256s")
  "Jazzline miscellaneous symbols.")

(defvar jasmin-types
  '("stack" "reg" "ptr" "int")
  "Jasmin types.")

(defvar jasmin-size
  '("u1" "u2" "u4" "u8" "u16" "u32" "u64" "u128" "u256")
  "Jasmin size.")

(defvar jasmin-operators
  '("&&" "||" "+" "-" "*" "/" "%" "&" "|" "^" ">>" "<<" ">>r" "<<r" "==" "!=" "<" "<=" ">" "=>" ">=" "^=" "=>>"
    "<<=" "&=" "/=" "+=" "-=" "=" "->" ">>s" "<<s")
  "Jasmin operators.")

(defvar jasmin-registers
  '("#mmx" "#rax" "#msf" "#rbx" "#rcx" "#rdx" "#rsp" "#rsi" "#rdi")
  "Jasmin registers.")

;; Define syntax table for Jasmin mode
(defun jasmin-syntax-table ()
  "Set local syntax table and re-color buffer."
  (interactive)
  (let ((synTable (make-syntax-table)))
    ;; Add support for single-line comments
    (modify-syntax-entry ?\/ ". 124b" synTable)
    (modify-syntax-entry ?\n "> b" synTable)
    ;; Add support for multi-line comments
    (modify-syntax-entry ?* ". 23" synTable)
    (set-syntax-table synTable)
    (font-lock-fontify-buffer)))

;; Define custom faces
(defcustom jasmin-operators-face 'font-lock-operator-face
  "Face for operators in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-keywords-face 'font-lock-keyword-face
  "Face for keywords in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-function-call-face 'font-lock-function-call-face
  "Face for function calls in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-function-name-face 'font-lock-function-name-face
  "Face for function names in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-special-function-face 'font-lock-preprocessor-face
  "Face for special functions (e.g., #something) in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-constant-face 'font-lock-constant-face
  "Face for constants in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-hex-number-face 'font-lock-string-face
  "Face for hex numbers in Jasmin mode."
  :type 'face
  :group 'jasmin-mode)

(defcustom jazzline-keywords-face 'font-lock-string-face
  "Face for Jazzline keywords."
  :type 'face
  :group 'jasmin-mode)

(defcustom jazzline-misc-face 'font-lock-builtin-face
  "Face for Jazzline miscellaneous symbols."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-jazzline-in-red-face 'font-lock-escape-face
  "Face for Jasmin jazzline-in-red keywords."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-variable-use-face 'font-lock-variable-use-face
  "Face for variables being referenced."
  :type 'face
  :group 'jasmin-mode)

(defcustom jasmin-variable-name-face 'font-lock-variable-name-face
  "Face for variable declarations."
  :type 'face
  :group 'jasmin-mode)

(defvar jasmin-fontlock
  (let ((xkeywords-regex (regexp-opt jasmin-keywords 'words))
        (xjazzline-keywords-regex (regexp-opt jazzline-keywords 'words))
        (xjazzline-misc-regex (regexp-opt jazzline-misc 'words))
        (xjazzline-in-red-regex (regexp-opt jasmin-jazzline-in-red 'words))
        (xtypes-regex (regexp-opt jasmin-types 'words))
        (xsize-regex (regexp-opt jasmin-size 'words))
        (xoperators-regex (regexp-opt jasmin-operators 'words))
        (xregisters-regex (regexp-opt jasmin-registers 'words))
        (xfunction-call-regex "\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*(")
        (xfunction-name-regex "\\bfn\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*(")
        (xspecial-function-regex "#\\([a-zA-Z_][a-zA-Z0-9_]*\\)")
        (xconstant-regex "\\b[A-Z][A-Z0-9_]*\\b")
        (xhex-number-regex "\\b0[xX][0-9a-fA-F]+\\b")
        (xvariable-use-regex "\\b\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\b\\s-*=")
        (xvariable-declaration-regex "\\b\\(int\\|ptr\\|reg\\|stack\\|u[0-9]+\\|bool\\|word_list\\|tuple\\|bit\\)\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\b"))
    (list (cons xhex-number-regex 'jasmin-hex-number-face)
          (cons xconstant-regex 'jasmin-constant-face)
          (cons xkeywords-regex 'jasmin-keywords-face)
          (cons xspecial-function-regex 'jasmin-special-function-face)
          (cons xfunction-name-regex '(1 'jasmin-function-name-face))
          (cons xfunction-call-regex '(1 'jasmin-function-call-face))
          (cons xjazzline-keywords-regex 'jazzline-keywords-face)
          (cons xjazzline-misc-regex 'jazzline-misc-face)
          (cons xjazzline-in-red-regex 'jasmin-jazzline-in-red-face)
          (cons xtypes-regex 'font-lock-type-face)
          (cons xsize-regex 'jazzline-misc-face)
          (cons xoperators-regex 'jasmin-operators-face)
          (cons xregisters-regex 'jasmin-constant-face)
          (cons xvariable-use-regex '(1 'jasmin-variable-use-face))
          (cons xvariable-declaration-regex '(2 'jasmin-variable-name-face))))
  "List for font-lock-defaults.")

(defun jasmin-font-lock-keywords ()
  "Update font-lock keywords based on the current line."
  (let ((line (thing-at-point 'line t)))
    (if (string-match-p "^\\s-*abstract\\s-+predicate" line)
        (list (cons (regexp-opt jasmin-size 'words) 'jazzline-misc-face))
      jasmin-fontlock)))

;;;###autoload
(define-derived-mode jasmin-mode c-mode
  "Jasmin"
  "Major mode for editing Jasmin."
  (setq font-lock-defaults '((jasmin-font-lock-keywords)))
  (jasmin-syntax-table)
  (add-hook 'font-lock-mode-hook #'jasmin-font-lock-keywords nil 'local))

(provide 'jasmin-mode)
;;; jasmin-mode.el ends here
