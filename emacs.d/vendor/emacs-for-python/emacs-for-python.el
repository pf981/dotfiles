;; The following enables all features of emacs-for-python
(load-file "~/.emacs.d/vendor/emacs-for-python/epy-init.el") ;; FIXME: Don't use absolute path

;; Alternatively, use the following to selectively enable some features
;; (add-to-list 'load-path "~/.emacs.d/vendor/emacs-for-python/") ;; tell where to load the various files FIXME: Don't use absolute path
;; (require 'epy-setup)      ;; It will setup other loads, it is required!
;; (require 'epy-python)     ;; If you want the python facilities [optional]
;; (require 'epy-completion) ;; If you want the autocompletion settings [optional]
;; (require 'epy-editing)    ;; For configurations related to editing [optional]
;; (require 'epy-bindings)   ;; For my suggested keybindings [optional]
;; (require 'epy-nose)       ;; For nose integration

;; Highlight indentation
(require 'highlight-indentation)
(add-hook 'python-mode-hook 'highlight-indentation)

;; Disable auto-pairing of parenthesis
(setq skeleton-pair nil)

;; Configure flymake checker
(epy-setup-checker "python3.4 -m pyflakes %f")

(provide 'emacs-for-python)
