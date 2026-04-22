;;; 1337macs-core.el --- my leet ai package -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(defun 1337macs/process-spawn (name command on-output on-exit)
  (let ((buffr ""))
    (make-process
     :name     name
     :command  command
     :filter   (lambda (proc output)
                 (setq buffr (concat buffr output))
                 (while (string-match "\n" buffr)
                   (let ((line (substring buffr 0 (match-beginning 0))))
                     (setq buffr (substring buffr (match-end 0)))
                     (funcall on-output proc line))))
     :sentinel (lambda (proc event)
                 (funcall on-exit proc event)))))

(provide '1337macs-core)
;;; 1337macs-core.el ends here
