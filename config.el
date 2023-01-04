;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.

;; (setq-hook! 'js-mode-hook +format-with-lsp nil)
;; (setq-hook! 'rjsx-mode-hook +format-with-lsp nil)
;; (setq-hook! 'js2-mode-hook +format-with-lsp nil)
;; (setq-hook! 'web-mode-hook +format-with-lsp nil)

;; (unless (package-installed-p 'prettier)
;;   (package-refresh-contents)
;;   (package-install 'prettier))

;; (require 'prettier)
;;

(setq web-mode-enable-css-colorization t)
(setq-default
 ;; js2-mode
 js2-basic-offset 2
 js-indent-level 2
 ;; ts & tsx
 typescript-indent-level 2
 ;; web-mode
 css-indent-offset 2
 rjsx-mode-indent-level 2
 web-mode-enable-auto-closing t
 web-mode-auto-quote-style nil
 web-mode-markup-indent-offset 2
 web-mode-css-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-attr-indent-offset 2)

;; for .ts, i use prettier
(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
;; for .tsx, i use lsp for formatting, so this is not needed
(setq-hook! 'typescript-tsx-mode-hook +format-with-lsp nil)

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))
(setq auto-save-default nil)
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-c p ,") 'projectile-ripgrep)
(global-set-key (kbd "C-c =") #'+format/buffer)
(global-set-key (kbd "C-c l") 'avy-copy-line)
(global-set-key (kbd "C-c r") 'avy-copy-region)


(use-package prettier
  :hook ((typescript-mode . prettier-mode)
         (js-mode . prettier-mode)
         (typescript-tsx-mode . prettier-mode)
         (rjsx-mode . prettier-mode)
         (json-mode . prettier-mode)
         (yaml-mode . prettier-mode)
         (ruby-mode . prettier-mode)))

;;(add-hook 'before-save-hook #'+format/buffer nil t)
(add-hook 'after-save-hook #'+format/buffer)

;;(add-hook 'after-init-hook #'global-prettier-mode)

;;(global-set-key (kbd "C-x j") 'avy-goto-char)
(use-package! lsp-tailwindcss :init
              (setq lsp-tailwindcss-add-on-mode t))
;;(use-package! lsp-tailwindcss)
;;(add-to-list 'lsp-language-id-configuration '(".*\\.erb$" . "html" . "jsx" . "tsx")

(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)


(setq gc-cons-threshold 1000000000)
(run-with-idle-timer 5 t #'garbage-collect)
(setq read-process-output-max (* 8 1024 1024)) ;; 1mb
;;
(add-hook 'prog-mode-hook 'subword-mode)
(add-hook 'web-mode-hook 'auto-rename-tag-mode)
(add-hook 'rjsx-mode-hook 'auto-rename-tag-mode)
;;(add-hook 'window-setup-hook #'+treemacs/toggle 'append)

;; treemacs  config
(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (treemacs-indent-guide-mode t)
    (treemacs-follow-mode nil)
    (treemacs-filewatch-mode t)
    )
  ) ;; treemacs config end


(setq user-full-name "Zer0xTJ"
      user-mail-address "zer0xtj.code@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "MonacoBSemi" :size 12 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "MonacoBSemi" :size 12))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; Best themes:
;; - doom-badger
;; - doom-nord
;; - doom-opera
;; - doom-gruvbox
;; - doom-material-dark
;; - doom-monokai-spectrum
;; - doom-tomorrow-night
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

(when window-system (set-fontset-font "fontset-default" '(#x600 . #x6ff) "Tahoma"))
