;;; extra-packages/pas-win.el -*- lexical-binding: t; -*-

;;; Commentary:
;; Utilities to manipulate windows

;;; Code:

(require 'ivy)
(require 'ht)

(defvar pas-win--window-configs (ht-create)
  "Saved window configs")

(defsubst pas-win--create-winconf (name conf pt)
  (ht<-plist (list :name name :conf conf :point pt)))

;;;###autoload
(defun pas-win/save-window-state ()
  "Save the window state with a name"
  (interactive)
  (let ((name (read-string "Enter config name: "))
        (conf (current-window-configuration))
        (pt (point-marker)))
    (ht-set! pas-win--window-configs name (pas-win--create-winconf name conf pt))))

(defun pas-win--do-restore (name)
  (when-let ((m (ht-get pas-win--window-configs name)))
    (let ((conf (ht-get m :conf))
          (pt (ht-get m :pt)))
      (set-window-configuration conf)
      (goto-char pt))))

(defun pas-win/restore-window-state ()
  "Restore the window state to a previously saved one.

The window state will be restored to a previous state saved
with a call to [pas-win/save-window-state]"
  (interactive)
  (ivy-read "Select the window configuration: "
            (ht-map (lambda (k v) (format "%s" k)) pas-win--window-configs)
            :action #'pas-win--do-restore))

(provide 'pas-win)

;;; pas-win.el ends here

