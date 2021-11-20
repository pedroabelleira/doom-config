;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Pedro Abelleira Seco"
      user-mail-address "pedroabelleira@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Noto Mono" :size 12 :weight 'regular))
(setq-default line-spacing 0.3)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-opera-light)
;; (setq doom-theme 'doom-ephemeral)
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Make the ',' work as in Spacemacs (act as a "major mode leader").
;; It saves having to press SPC + m, replacing these two keystrokes by one
;;(setq evil-snipe-override-evil-repeat-keys nil)
;;(setq doom-localleader-key ",")

(map! :leader
      :desc "M-x" "SPC" #'counsel-M-x)

(map! :leader
      :desc "Expand selection" "v" #'er/expand-region)

;; Make the ',' work as in Spacemacs (act as a "major mode leader").
;; It saves having to press SPC + m, replacing these two keystrokes by one
(setq evil-snipe-override-evil-repeat-keys nil)
(setq doom-localleader-key ",")
(setq doom-localleader-alt-key "C-,")
(setq doom-leader-alt-key "C-SPC")

;; Function to change window split orientation from vertical to horizontal
;; and viceversa
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer)))
       (next-win-buffer (window-buffer (next-window)))
       (this-win-edges (window-edges (selected-window)))
       (next-win-edges (window-edges (next-window)))
       (this-win-2nd (not (and (<= (car this-win-edges))))
           (car next-win-edges
             (<= (cadr this-win-edges)))
           (cadr next-win-edges))
       (splitter
        (if (= (car this-win-edges))
         (car (window-edges (next-window))))))
      'split-window-horizontally
    'split-window-vertically)
  (delete-other-windows)
  (let ((first-win (selected-window)))
    (funcall splitter)
    (if this-win-2nd (other-window 1))
    (set-window-buffer (selected-window) this-win-buffer)
    (set-window-buffer (next-window) next-win-buffer)
    (select-window first-win)
    (if this-win-2nd (other-window 1))))

(define-key ctl-x-4-map "t" 'toggle-window-split)

;; Avy configuration
(setq avy-all-windows t)

;; Local bindings
(map! :leader
      :desc "Goto word" "j w" #'avy-goto-word-1)

(map! :leader
      :desc "Toggle window split" "j s" #'toggle-window-split)

(map! :leader
      :desc "Change window" "w w" #'ace-window)

(map! :leader
      :desc "Next workspace" "TAB j" #'+workspace/switch-right)

(map! :leader
      :desc "Previous workspace" "TAB k" #'+workspace/switch-left)

(map! :leader
      :desc "Window resize/nav" "w e" #'+hydra/window-nav/body)

;; FIXME: this is needed because of an eeror with the default Doom binding
(map!
 :nv "gc"    #'comment-or-uncomment-region)

;; Add keybinding to debugger
(map! :map rustic-mode-map
      :localleader
      (:desc "cargo audit"    "bg" #'projectile-run-gdb))

;; Set parinfer to be on indent mode by default
(setq parinfer-auto-switch-indent-mode t)
;;(add-to-list 'parinfer-extensions 'smart-yank)
;;(add-to-list 'parinfer-extensions 'paredit)

;; Function and keybinding to open the current buffer in treemacs
(defun pas/open-current-in-treemacs ()
  (interactive)
  (treemacs-find-file)
  (treemacs-select-window))

(map! :leader
      :desc "Find file in project sidebar and focus" "o o" #'pas/open-current-in-treemacs)

;; Function and keybinding to open the current selected file
;; as a buffer and close treemeacs
(defun pas/goto-file-and-close-treemacs()
  (interactive)
  (treemacs-RET-action)
  (+treemacs/toggle))

(map! :leader
      :desc "Open file and close treemacsin project sidebar and focus"
      "o c"
      #'pas/goto-file-and-close-treemacs)

(map! :map (evil-treemacs-state-map treemacs-mode-map)
      "L"
      :desc "Open file and close treemacsin project sidebar and focus"
      #'pas/goto-file-and-close-treemacs)

(map! :leader
      :desc "Other frame"
      "w f"
      #'other-frame)

;; Extra packages
(use-package! lsp-tailwindcss
  :init (setq lsp-tailwindcss-add-on-mode t))

;; Load a local configuration file if it exists
(let ((file "~/.doom.d/local.el"))
  (when (f-exists? file)
    (load-file "~/.doom.d/local.el")))
