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
  (interactive)
  (ivy-read "Select the window configuration: "
            (ht-map (lambda (k v) (format "%s" k)) pas-win--window-configs)
            :action #'pas-win--do-restore))

(provide 'pas-win)

;;; pas-win.el ends here

