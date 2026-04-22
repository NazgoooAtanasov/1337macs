;;; 1337macs-ui.el --- my leet ai package -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(defun 1337macs/write-end-buffer (&rest args)
  "Wrapper function for writing at the end of a buffer using ARGS."
  (save-excursion
    (goto-char (point-max))
    (insert (apply 'format args))))

(defun 1337macs/thread.started (event)
  (let ((thread_id (gethash "thread_id" event)))
    (1337macs/write-end-buffer "Agent started. Thread id = %s\n" thread_id)))

(defun 1337macs/turn.started (_event)
    (1337macs/write-end-buffer "Agent has started working\n"))

(defun 1337macs/item.started (event)
  (let* ((item (gethash "item" event))
         (item_id (gethash "id" item))
         (item_type (gethash "type" item))
         (item_command (gethash "command" item))
         (item_status (gethash "status" item)))
    (1337macs/write-end-buffer "Item started. Id %s, type %s, command %s, status %s\n" item_id item_type item_command item_status)))

(defun 1337macs/item.completed (event)
  (let* ((item (gethash "item" event))
        (item_id (gethash "id" item))
        (item_type (gethash "type" item))
        (item_text (gethash "text" item)))
    (1337macs/write-end-buffer "Item completed. Id %s, type %s, text %s\n" item_id item_type item_text)))

(defun 1337macs/turn.completed (event)
  (let* ((usage (gethash "usage" event))
         (input_tokens (gethash "input_tokens" usage))
         (cached_input_tokens (gethash "cached_input_tokens" usage))
         (output_tokens (gethash "output_tokens" usage)))
    (1337macs/write-end-buffer
     "A turn has been completed. Input tokens %s, cached input tokens %s and output tokens %s\n"
             input_tokens cached_input_tokens output_tokens)))

(defun 1337macs/print (prompt_id content)
  (with-current-buffer (get-buffer-create prompt_id)
    (let* ((json-content (json-parse-string content))
           (type (gethash "type" json-content)))
      (pcase type
        ("thread.started" (1337macs/thread.started json-content))
        ("turn.started" (1337macs/turn.started json-content))
        ("item.started" (1337macs/item.started json-content))
        ("item.completed" (1337macs/item.completed json-content))
        ("turn.completed" (1337macs/turn.completed json-content))
        (_ (1337macs/write-end-buffer "Unknown type caught - %s\n" type)
           (print json-content))))))

(provide '1337macs-ui)
;;; 1337macs-ui.el ends here
