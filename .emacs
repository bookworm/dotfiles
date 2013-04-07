;; Add themes to load path
(add-to-list 'load-path "~/.emacs.d/themes")

;; Load Packages
(require 'package)
(add-to-list 'package-archives
  '("marmalade" .
    "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;;;
;; Left Padding
;;;

;; Windows
(add-hook 'window-configuration-change-hook
  (lambda ()
    (set-window-margins (car (get-buffer-window-list (current-buffer) nil t)) 2 2)))

;; TODO and some margin to minibuffer

;; Make sure to include packages we want
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings starter-kit-js starter-kit-ruby)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Load Textmate Mode
(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

;; Require midnight to cleanup unused buffers.
(require 'midnight)

;; Load yasnippet
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;; Settings
(setq frame-title-format '("Emacs @ " system-name ": %b %+%+ %f"))

;; use setq-default to set it for /all/ modes
(setq-default mode-line-format
  (list
    ;; the buffer name; the file name as a tool tip
    '(:eval (propertize "%b " 'face 'font-lock-keyword-face
        'help-echo (buffer-file-name)))

    ;; line and column
    "(" ;; '%02' to set to 2 chars at least; prevents flickering
      (propertize "%02l" 'face 'font-lock-type-face) ","
      (propertize "%02c" 'face 'font-lock-type-face)
    ") "

    ;; relative position, size of file
    "["
    (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
    "/"
    (propertize "%I" 'face 'font-lock-constant-face) ;; size
    "] "

    ;; the current major mode for the buffer.
    "["

    '(:eval (propertize "%m" 'face 'font-lock-string-face
              'help-echo buffer-file-coding-system))
    "] "


    "[" ;; insert vs overwrite mode, input-method in a tooltip
    '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
              'face 'font-lock-preprocessor-face
              'help-echo (concat "Buffer is in "
                           (if overwrite-mode "overwrite" "insert") " mode")))

    ;; was this buffer modified since the last save?
    '(:eval (when (buffer-modified-p)
              (concat ","  (propertize "Mod"
                             'face 'font-lock-warning-face
                             'help-echo "Buffer has been modified"))))

    ;; is this buffer read-only?
    '(:eval (when buffer-read-only
              (concat ","  (propertize "RO"
                             'face 'font-lock-type-face
                             'help-echo "Buffer is read-only"))))
    "] "

    ;; add the time, with the date and the emacs uptime in the tooltip
    '(:eval (propertize (format-time-string "%H:%M")
              'help-echo
              (concat (format-time-string "%c; ")
                      (emacs-uptime "Uptime:%hh"))))
    " --"
    ;; i don't want to see minor-modes; but if you want, uncomment this:
    ;; minor-mode-alist  ;; list of minor modes
    "%-" ;; fill with '-'
    ))

;; Configure Indentation and tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(delete-selection-mode 1)
(setq shift-select-mode t)

;; Turn off Crazy Cua Bindings
(setq cua-enable-cua-keys nil)

;; Insert mode
(require 'inline-string-rectangle)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)

;; Multiple Cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)

;; From active region to multiple cursors:
(global-set-key(kbd "C-S-c C-e")  'mc/edit-ends-of-lines)
(global-set-key(kbd "C-S-c C-a")  'mc/edit-beginnings-of-lines)

;; Rectangular region mode
(global-set-key (kbd "C-SPC") 'set-rectangular-region-anchor)

;; Load Autocomplete
(require 'auto-complete-config)
(ac-config-default)

;; Resense
(setq rsense-home "/usr/local/bin/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)

;; Set backup directory
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

;; Color theme
(require 'color-theme)
(color-theme-initialize)
(require 'color-theme-ava)
(color-theme-ava)
(set-default-font "Monaco-12")

;; Remove Fringes
(set-fringe-mode 0)

;; Set Helm
(helm-mode 1)

;; Control backups location. Puts them in ~/.emacs_autosaves and ~/.emacs_backups
(defvar backup-dir (expand-file-name "~/.emacs_backups/"))
(defvar autosave-dir (expand-file-name "~/.emacs_autosaves/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs_backups/" t)
(make-directory "~/.emacs_autosaves/" t)

;; Load Markdown Mode
(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode.el")
(require 'markdown-mode)

;; Autoload modes
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
  (setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; Buffer Mover
(require 'buffer-move)

;; Indentation
(setq timeclock-ask-before-exiting t)

;; I hate tabs!
(setq-default indent-tabs-mode nil)

;; Jquery Tmpl using html-mode
(add-to-list 'auto-mode-alist '("\\.tmpl$" . html-mode))

;; Load Ack
(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)

;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;; Ack Shortcut
(define-key osx-key-mode-map `[(,osxkeys-command-key shift f)] 'ack-and-a-half)

;; nREPL
(when (not (package-installed-p 'nrepl))
  (package-install 'nrepl))
(add-hook 'nrepl-interaction-mode-hook
  'nrepl-turn-on-eldoc-mode)
  
(setq nrepl-popup-stacktraces nil)

;; Load Speedbar in same frame plugin
(require 'sr-speedbar)

;; Disable compilation of scss on save
(setq scss-compile-at-save nil)

;; I hate tabs!
(setq c-basic-indent 2)
(setq-default tab-width 2)
(setq indent-tabs-mode nil)

;; Pomodoro
(require 'tomatinho)
(global-set-key (kbd "<f6>") 'tomatinho)
