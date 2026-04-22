;;; 1337macs.el --- my leet ai package -*- lexical-binding: t; -*-
;;; Commentary:

(add-to-list 'load-path "~/_Projects/1337macs/")

;;; Code:

(require '1337macs-core)
(require '1337macs-ui)

(require 'projectile)

(defun 1337macs/heartbeat ()
  "Just messages \"Heartbeat\"."
  (interactive)
  (message "Heartbeat"))

(defun 1337macs/check-deps ()
  "Check if the required dependencies are installed. Just prints an error if not found."
  (interactive)
  (unless (executable-find "codex")
    (message "Codex was not found in PATH")))

(defun 1337macs/prompt (prompt)
  "The main entry point of the plugin."
  (interactive "sPrompt: ")
  (let ((prompt_id (make-temp-name "*1337macs-")))
    (1337macs/process-spawn
     "codex"
     (list "codex" "e" "--cd" (projectile-project-root) "--model" "gpt-5.2" "--skip-git-repo-check" "--json" prompt)
     (lambda (_proc line)
       (1337macs/print prompt_id line))
     (lambda (_proc event)
       (print event)))
    ))

(defun 1337macs/reload ()
    "Reload 1337macs during development."
    (interactive)
    (unload-feature '1337macs t)
    (unload-feature '1337macs-core t)
    (unload-feature '1337macs-ui t)
    (load-file "~/_Projects/1337macs/1337macs.el"))

(provide '1337macs)
;;; 1337macs.el ends here
