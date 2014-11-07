;; http://www.emacswiki.org/emacs/GnuScreen#toc7
;; Enable 256 colors when using GNU Screen
(defun terminal-init-screen ()
      "Terminal initialization function for screen-256color."
      (load "term/xterm")
      (xterm-register-default-colors)
      (tty-set-up-initial-frame-faces))
