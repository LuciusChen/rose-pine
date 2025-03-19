;;; rose-pine.el --- Rosé Pine for Emacs  -*- lexical-binding: t -*-

;; Copyright (C) 2012-2017 Steve Purcell

;; Author: Steve Purcell <steve@sanityinc.com>
;; Adapted by: Lucius <chenyh572@gmail.com>
;; Keywords: faces themes
;; Homepage: https://github.com/LuciusChen/rose-pine
;; Package-Requires: ((emacs "24.1"))
;; Version: 0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This theme, "Rosé Pine for Emacs", is designed for use with Emacs'
;; built-in theme support in Emacs 24. It provides a colour palette
;; inspired by the Rosé Pine theme (https://rosepinetheme.com/palette/ingredients/).

;; Usage:

;; Use the load-theme' command, to activate this theme programmatically,
;; or use customize-themes' to select a theme interactively.

;; Alternatively, use the provided command to activate the theme:

;;     M-x load-theme RET rose-pine RET
;;
;;; Credit:

;; Original colour selection inspired by the Rosé Pine palette:
;; https://rosepinetheme.com/palette/ingredients/

;;; Code:

(require 'color)

(eval-when-compile (require 'ansi-color))

(defun rose-pine--interpolate (hex1 hex2 gradations which)
  (let ((c1 (color-name-to-rgb hex1))
        (c2 (color-name-to-rgb hex2)))
    (apply 'color-rgb-to-hex (nth which (color-gradient c1 c2 gradations)))))

(defun rose-pine--alt-background (background highlight)
  "Calculate the alt-background color by blending BACKGROUND and HIGHLIGHT.
This cannot be done at runtime because its output is dependent
upon the display characteristics of the frame in which it is
executed."
  (rose-pine--interpolate background highlight 7 3))

(defconst rose-pine-colors
  '((night . ((background     . "#1e2021")
              (alt-background . "#323740")
              (current-line   . "#26282e")
              (selection      . "#3D4252")
              (foreground     . "#e3dfcb")
              (comment        . "#868087")
              (rose           . "#ebbcba")
              (gold           . "#f6c177")
              (love           . "#eb6f92")
              (amber          . "#f6d06e")
              (leaf           . "#95b1ac")
              (foam           . "#9ccfd8")
              (pine           . "#81a2be")
              (iris           . "#b294bb")

              (bg-added           . "#003a2f")
              (bg-added-faint     . "#002922")
              (bg-added-refine    . "#035542")
              (fg-added           . "#a0e0a0")
              (fg-added-intense   . "#80e080")

              (bg-changed         . "#363300")
              (bg-changed-faint   . "#2a1f00")
              (bg-changed-refine  . "#4a4a00")
              (fg-changed         . "#efef80")
              (fg-changed-intense . "#c0b05f")

              (bg-removed         . "#4f1127")
              (bg-removed-faint   . "#380a19")
              (bg-removed-refine  . "#781a3a")
              (fg-removed         . "#ffbfbf")
              (fg-removed-intense . "#ff9095")))
    (day . ((background     . "#faf4ed")
            (alt-background . "#e7e3e0")
            (current-line   . "#f4ede8")
            (selection      . "#dfdad9")
            (foreground     . "#34494a")
            (comment        . "#8e908c")
            (rose           . "#d7827e")
            (gold           . "#ea9d34")
            (love           . "#b4637a")
            (amber          . "#e9c987")
            (leaf           . "#568D68")
            (foam           . "#56949f")
            (pine           . "#286983")
            (iris           . "#907aa9")

            (bg-added           . "#c3ebc1")
            (bg-added-faint     . "#dcf8d1")
            (bg-added-refine    . "#acd6a5")
            (fg-added           . "#005000")
            (fg-added-intense   . "#006700")

            (bg-changed         . "#ffdfa9")
            (bg-changed-faint   . "#ffefbf")
            (bg-changed-refine  . "#fac090")
            (fg-changed         . "#553d00")
            (fg-changed-intense . "#655000")

            (bg-removed         . "#f4d0cf")
            (bg-removed-faint   . "#ffe9e5")
            (bg-removed-refine  . "#f3b5a7")
            (fg-removed         . "#8f1313")
            (fg-removed-intense . "#aa2222")))))

(defmacro rose-pine--with-colors (mode &rest body)
  "Execute `BODY' in a scope with variables bound to the various tomorrow colors.

Also sets background-mode to either `light' or `dark', for use in
setting `frame-background-mode'.

`MODE' should be set to either `day', `night'."
  `(let* ((colors (or (cdr (assoc ,mode rose-pine-colors))
                      (error "no such theme flavor")))
          (background      (cdr (assoc 'background colors)))
          (contrast-bg     (cdr (assoc 'selection colors)))
          (highlight       (cdr (assoc 'current-line colors)))
          (low-contrast-bg (cdr (assoc 'alt-background colors)))
          (foreground      (cdr (assoc 'foreground colors)))
          (comment         (cdr (assoc 'comment colors)))
          (rose            (cdr (assoc 'rose colors)))
          (gold            (cdr (assoc 'gold colors)))
          (love            (cdr (assoc 'love colors)))
          (amber           (cdr (assoc 'amber colors)))
          (leaf            (cdr (assoc 'leaf colors)))
          (foam            (cdr (assoc 'foam colors)))
          (pine            (cdr (assoc 'pine colors)))
          (iris            (cdr (assoc 'iris colors)))

          (bg-added           (cdr (assoc 'bg-added colors)))
          (bg-added-faint     (cdr (assoc 'bg-added-faint colors)))
          (bg-added-refine    (cdr (assoc 'bg-added-refine colors)))
          (fg-added           (cdr (assoc 'fg-added colors)))
          (fg-added-intense   (cdr (assoc 'fg-added-intense colors)))

          (bg-changed         (cdr (assoc 'bg-changed colors)))
          (bg-changed-faint   (cdr (assoc 'bg-changed-faint colors)))
          (bg-changed-refine  (cdr (assoc 'bg-changed-refine colors)))
          (fg-changed         (cdr (assoc 'fg-changed colors)))
          (fg-changed-intense (cdr (assoc 'fg-changed-intense colors)))

          (bg-removed         (cdr (assoc 'bg-removed colors)))
          (bg-removed-faint   (cdr (assoc 'bg-removed-faint colors)))
          (bg-removed-refine  (cdr (assoc 'bg-removed-refine colors)))
          (fg-removed         (cdr (assoc 'fg-removed colors)))
          (fg-removed-intense (cdr (assoc 'fg-removed-intense colors)))

          (term-white      (if (eq ,mode 'day) contrast-bg comment))
          (term-black      (if (eq ,mode 'day) comment contrast-bg))
          (class '((class color) (min-colors 89)))
          (background-mode (if (eq ,mode 'day) 'light 'dark)))
     ,@body))

(defmacro rose-pine--face-specs ()
  "Return a backquote which defines a list of face specs.

It expects to be evaluated in a scope in which the various color
names to which it refers are bound."
  (quote
   (mapcar
    (lambda (entry)
      (list (car entry) `((,class ,@(cdr entry)))))
    `(;; Standard font lock faces
      (default (:foreground ,foreground :background ,background))
      (bold (:weight bold))
      (bold-italic (:slant italic :weight bold))
      (underline (:underline t))
      (italic (:slant italic))
      (font-lock-bracket-face (:foreground ,pine))
      (font-lock-builtin-face (:foreground ,iris))
      (font-lock-comment-delimiter-face (:foreground ,comment))
      (font-lock-comment-face (:foreground ,comment))
      (font-lock-constant-face (:foreground ,pine))
      (font-lock-doc-face (:foreground ,iris))
      (font-lock-doc-string-face (:foreground ,love))
      (font-lock-escape-face (:foreground ,love))
      (font-lock-function-call-face (:foreground ,gold))
      (font-lock-function-name-face (:foreground ,gold))
      (font-lock-keyword-face (:foreground ,leaf))
      (font-lock-misc-punctuation-face (:inherit font-lock-punctuation-face))
      (font-lock-negation-char-face (:foreground ,gold))
      (font-lock-number-face (:foreground ,pine))
      (font-lock-operator-face (:foreground ,gold))
      (font-lock-preprocessor-face (:foreground ,iris))
      (font-lock-property-name-face (:inherit font-lock-variable-name-face))
      (font-lock-property-use-face (:inherit font-lock-variable-name-face))
      (font-lock-punctuation-face (:inherit default))
      (font-lock-regexp-face (:inherit font-lock-string-face))
      (font-lock-regexp-grouping-backslash (:foreground ,love))
      (font-lock-regexp-grouping-construct (:foreground ,iris))
      (font-lock-string-face (:foreground ,foam))
      (font-lock-type-face (:foreground ,pine))
      (font-lock-bracket-face (:foreground ,leaf))
      (font-lock-delimiter-face (:foreground ,iris))
      (font-lock-type-face (:foreground ,pine))
      (font-lock-variable-name-face (:foreground ,love))
      (font-lock-variable-use-face (:inherit font-lock-variable-name-face))
      (font-lock-warning-face (:weight bold :foreground ,rose))
      (shadow (:foreground ,comment))
      (fill-column-indicator (:foreground ,contrast-bg))
      (success (:foreground ,leaf))
      (error (:foreground ,rose))
      (warning (:foreground ,gold))
      (tooltip (:foreground ,love :background ,background :inverse-video t))

      ;; Emacs interface
      (cursor (:background ,rose))
      (fringe (:background ,low-contrast-bg :foreground ,comment))
      (linum (:background ,low-contrast-bg :foreground ,comment :italic nil :underline nil))
      (line-number (:inherit default :background ,background :foreground ,comment))
      (line-number-current-line (:inherit line-number :background ,low-contrast-bg :foreground ,foreground :weight bold))
      (line-number-major-tick (:inherit line-number :foreground ,rose))
      (line-number-minor-tick (:inherit line-number :foreground ,comment))
      (fill-column-indicator (:foreground ,contrast-bg :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :stipple nil))
      (vertical-border (:foreground ,contrast-bg))
      (border (:background ,contrast-bg :foreground ,highlight))
      (help-argument-name (:inherit italic :foreground ,love))
      (help-key-binding (:inherit bold :foreground ,love))
      (highlight (:inverse-video nil :background ,highlight))
      (mode-line (:foreground ,foreground :background ,background :weight normal :box (:line-width 1 :color ,foreground)))
      (mode-line-buffer-id (:foreground ,iris :background unspecified))
      (mode-line-inactive (:inherit mode-line :foreground ,comment :background ,highlight :box (:line-width 1 :color ,comment)))
      (mode-line-emphasis (:foreground ,foreground :slant italic))
      (mode-line-highlight (:foreground ,iris :box nil :weight bold))
      (minibuffer-prompt (:foreground ,pine))
      (region (:background ,low-contrast-bg :inverse-video nil :extend t))
      (secondary-selection (:background ,contrast-bg :extend t))
      (rectangle-preview (:inherit secondary-selection))

      (header-line (:foreground ,foam :background unspecified))
      (header-line-highlight (:inherit highlight))

      ;; search
      (match (:foreground ,foam :background ,contrast-bg))
      (isearch (:foreground ,love :background ,background :inverse-video t))
      (lazy-highlight (:foreground ,foam :background ,background :inverse-video t))
      (isearch-fail (:background ,contrast-bg :inherit font-lock-warning-face))

      (link (:foreground unspecified :underline t))
      (link-visited (:background unspecified :foreground ,iris :underline ,iris))
      (button (:underline t :foreground ,foam))
      (widget-button (:underline t))
      (widget-field (:background ,contrast-bg :box (:line-width 1 :color ,foreground)))

      ;; ansi-color (built-in, face scheme below from Emacs 28.1 onwards)
      (ansi-color-black (:foreground ,term-black :background ,term-black))
      (ansi-color-red (:foreground ,rose :background ,rose))
      (ansi-color-green (:foreground ,leaf :background ,leaf))
      (ansi-color-yellow (:foreground ,love :background ,love))
      (ansi-color-blue (:foreground ,pine :background ,pine))
      (ansi-color-magenta (:foreground ,iris :background ,iris))
      (ansi-color-cyan (:foreground ,foam :background ,foam))
      (ansi-color-white (:foreground ,term-white :background ,term-white))
      (ansi-color-bright-black (:inherit ansi-color-black :weight bold))
      (ansi-color-bright-red (:inherit ansi-color-red :weight bold))
      (ansi-color-bright-green (:inherit ansi-color-green :weight bold))
      (ansi-color-bright-yellow (:inherit ansi-color-yellow :weight bold))
      (ansi-color-bright-blue (:inherit ansi-color-blue :weight bold))
      (ansi-color-bright-magenta (:inherit ansi-color-magenta :weight bold))
      (ansi-color-bright-cyan (:inherit ansi-color-cyan :weight bold))
      (ansi-color-bright-white (:inherit ansi-color-white :weight bold))

      ;; ansi-term (built-in)
      (term (:foreground unspecified :background unspecified :inherit default))
      (term-color-black (:foreground ,term-black :background ,term-black))
      (term-color-red (:foreground ,rose :background ,rose))
      (term-color-green (:foreground ,leaf :background ,leaf))
      (term-color-yellow (:foreground ,love :background ,love))
      (term-color-blue (:foreground ,pine :background ,pine))
      (term-color-magenta (:foreground ,iris :background ,iris))
      (term-color-cyan (:foreground ,foam :background ,foam))
      (term-color-white (:foreground ,term-white :background ,term-white))

      ;; antlr-mode (built-in)
      (antlr-keyword (:inherit font-lock-keyword-face))
      (antlr-syntax (:inherit font-lock-constant-face))
      (antlr-ruledef (:inherit font-lock-function-name-face))
      (antlr-ruleref (:inherit font-lock-type-face))
      (antlr-tokendef (:inherit font-lock-function-name-face))
      (antlr-tokenref (:inherit font-lock-type-face))
      (antlr-literal (:inherit font-lock-constant-face))

      ;; calendar (built-in)
      (diary (:foreground ,love))
      (holiday (:foreground ,background :background ,gold))

      ;; Compilation (built-in)
      (compilation-column-number (:foreground ,love))
      (compilation-line-number (:foreground ,love))
      (compilation-message-face (:foreground ,pine))
      (compilation-mode-line-exit (:foreground ,leaf))
      (compilation-mode-line-fail (:foreground ,rose))
      (compilation-mode-line-run (:foreground ,pine))

      ;; completion display (built-in)
      (completions-annotations (:foreground ,comment :slant italic))
      (completions-common-part (:foreground ,pine))
      (completions-first-difference (:foreground ,gold :weight bold))

      ;; custom (built-in)
      (custom-variable-tag (:foreground ,pine))
      (custom-group-tag (:foreground ,pine))
      (custom-state (:foreground ,leaf))

      ;; diff-mode (built-in)
      (diff-added (:background ,bg-added :foreground ,fg-added))
      (diff-changed (:background ,bg-changed :foreground ,fg-changed :extend t))
      (diff-removed (:background ,bg-removed :foreground ,fg-removed))
      (diff-header ())
      (diff-file-header (:foreground ,pine :background unspecified :extend t))
      (diff-hunk-header (:foreground ,iris))
      (diff-indicator-added (:inherit diff-added :foreground ,fg-added-intense))
      (diff-indicator-changed (:inherit diff-changed :foreground ,fg-changed-intense))
      (diff-indicator-removed (:inherit diff-removed :foreground ,fg-removed-intense))
      (diff-refine-added (:background ,bg-added-refine :foreground ,fg-added))
      (diff-refine-changed (:background ,bg-changed-refine :foreground ,fg-changed))
      (diff-refine-removed (:background ,bg-removed-refine :foreground ,fg-removed))

      ;; ediff (built-in)
      (ediff-current-diff-A (:foreground ,comment :background ,highlight :extend t))
      (ediff-current-diff-Ancestor (:foreground ,foam :background ,highlight))
      (ediff-current-diff-B (:foreground ,comment :background ,highlight :extend t))
      (ediff-current-diff-C (:foreground ,comment :background ,highlight :extend t))
      (ediff-even-diff-A (:foreground ,pine :background ,contrast-bg :extend t))
      (ediff-even-diff-Ancestor (:foreground ,iris :background ,highlight))
      (ediff-even-diff-B (:foreground ,pine :background ,contrast-bg :extend t))
      (ediff-even-diff-C (:foreground ,pine :background ,contrast-bg :extend t))
      (ediff-fine-diff-A (:foreground ,leaf :background ,contrast-bg))
      (ediff-fine-diff-Ancestor (:foreground ,love :background ,highlight))
      (ediff-fine-diff-B (:foreground ,leaf :background ,contrast-bg))
      (ediff-fine-diff-C (:foreground ,leaf :background ,contrast-bg))
      (ediff-odd-diff-A (:foreground ,gold :background ,contrast-bg :extend t))
      (ediff-odd-diff-Ancestor (:foreground ,rose :background ,highlight))
      (ediff-odd-diff-B (:foreground ,gold :background ,contrast-bg :extend t))
      (ediff-odd-diff-C (:foreground ,gold :background ,contrast-bg :extend t))

      ;; Eglot
      (eglot-inlay-hint-face (:height 0.8 :inherit shadow :slant italic))
      ;; ElDoc (built-in)
      (eldoc-highlight-function-argument (:foreground ,leaf :weight bold))

      ;; ERC (built-in)
      (erc-direct-msg-face (:foreground ,gold))
      (erc-error-face (:foreground ,rose))
      (erc-header-face (:foreground ,foreground :background ,highlight))
      (erc-input-face (:foreground ,leaf))
      (erc-keyword-face (:foreground ,love))
      (erc-current-nick-face (:foreground ,leaf))
      (erc-my-nick-face (:foreground ,leaf))
      (erc-nick-default-face (:weight normal :foreground ,iris))
      (erc-nick-msg-face (:weight normal :foreground ,love))
      (erc-notice-face (:foreground ,comment))
      (erc-pal-face (:foreground ,gold))
      (erc-prompt-face (:foreground ,pine))
      (erc-timestamp-face (:foreground ,foam))
      (erc-keyword-face (:foreground ,leaf))

      ;; ERT (built-in)
      (ert-test-result-unexpected (:inherit error))
      (ert-test-result-expected (:inherit success))

      ;; eshell (built-in)
      (eshell-prompt (:foreground ,love :weight bold))
      (eshell-ls-archive (:foreground ,pine))
      (eshell-ls-backup (:foreground ,comment))
      (eshell-ls-clutter (:foreground ,gold :weight bold))
      (eshell-ls-directory :foreground ,pine :weight bold)
      (eshell-ls-executable (:foreground ,love :weight bold))
      (eshell-ls-missing (:foreground ,rose :weight bold))
      (eshell-ls-product (:foreground ,leaf))
      (eshell-ls-readonly (:foreground ,rose))
      (eshell-ls-special (:foreground ,iris :weight bold))
      (eshell-ls-symlink (:foreground ,foam :weight bold))
      (eshell-ls-unreadable (:foreground ,comment))

      ;; Flycheck (built-in)
      (flycheck-error (:underline (:style wave :color ,rose)))
      (flycheck-info (:underline (:style wave :color ,foam)))
      (flycheck-warning (:underline (:style wave :color ,gold)))
      (flycheck-fringe-error (:foreground ,rose))
      (flycheck-fringe-info (:foreground ,foam))
      (flycheck-fringe-warning (:foreground ,gold))
      (flycheck-color-mode-line-error-face (:foreground ,rose))
      (flycheck-color-mode-line-warning-face (:foreground ,gold))
      (flycheck-color-mode-line-info-face (:foreground ,foam))
      (flycheck-color-mode-line-running-face (:foreground ,comment))
      (flycheck-color-mode-line-success-face (:foreground ,leaf))

      ;; Flymake (built-in)
      (flymake-end-of-line-diagnostics-face (:inherit italic :height 0.85 :box (:line-width 1)))
      (flymake-error (:underline (:style wave :color ,rose)))
      (flymake-error-echo (:inherit error))
      (flymake-error-echo-at-eol (:inherit flymake-end-of-line-diagnostics-face :foreground ,rose))
      (flymake-note (:underline (:style wave :color ,foam)))
      (flymake-note-echo (:foreground ,foam))
      (flymake-note-echo-at-eol (:inherit flymake-end-of-line-diagnostics-face :foreground ,foam))
      (flymake-warning (:underline (:style wave :color ,gold)))
      (flymake-warning-echo (:foreground ,gold))
      (flymake-warning-echo-at-eol (:inherit flymake-end-of-line-diagnostics-face :foreground ,gold))

      ;; Flyspell (built-in)
      (flyspell-incorrect (:underline (:style wave :color ,rose)))

      ;; Gnus (built-in)
      (gnus-button (:inherit link :foreground unspecified))
      (gnus-emphasis-highlight-words (:foreground ,love :background ,highlight))
      (gnus-header-content (:inherit message-header-other))
      (gnus-header-from (:inherit message-header-other-face :weight bold :foreground ,gold))
      (gnus-header-name (:inherit message-header-name))
      (gnus-header-newsgroups (:foreground ,love :slant italic))
      (gnus-header-subject (:inherit message-header-subject))
      (gnus-x-face (:foreground ,background :background ,foreground))
      (gnus-signature (:inherit font-lock-comment-face))

      (mm-uu-extract (:foreground ,leaf :background ,highlight))

      (gnus-cite-1 (:foreground ,pine))
      (gnus-cite-2 (:foreground ,iris))
      (gnus-cite-3 (:foreground ,foam))
      (gnus-cite-4 (:foreground ,love))
      (gnus-cite-5 (:foreground ,gold))
      (gnus-cite-6 (:foreground ,pine))
      (gnus-cite-7 (:foreground ,iris))
      (gnus-cite-8 (:foreground ,foam))
      (gnus-cite-9 (:foreground ,rose))
      (gnus-cite-10 (:foreground ,comment))
      (gnus-cite-11 (:foreground ,contrast-bg))

      (gnus-group-mail-1 (:foreground ,pine :weight normal))
      (gnus-group-mail-1-empty (:inherit gnus-group-mail-1 :foreground ,comment))
      (gnus-group-mail-2 (:foreground ,iris :weight normal))
      (gnus-group-mail-2-empty (:inherit gnus-group-mail-2 :foreground ,comment))
      (gnus-group-mail-3 (:foreground ,foam :weight normal))
      (gnus-group-mail-3-empty (:inherit gnus-group-mail-3 :foreground ,comment))
      (gnus-group-mail-4 (:foreground ,love :weight normal))
      (gnus-group-mail-4-empty (:inherit gnus-group-mail-4 :foreground ,comment))
      (gnus-group-mail-5 (:foreground ,gold :weight normal))
      (gnus-group-mail-5-empty (:inherit gnus-group-mail-5 :foreground ,comment))
      (gnus-group-mail-6 (:foreground ,pine :weight normal))
      (gnus-group-mail-6-empty (:inherit gnus-group-mail-6 :foreground ,comment))
      (gnus-group-mail-low (:foreground ,comment))
      (gnus-group-mail-low-empty (:foreground ,comment))

      (gnus-group-news-1 (:foreground ,pine :weight normal))
      (gnus-group-news-1-empty (:inherit gnus-group-news-1 :foreground ,comment))
      (gnus-group-news-2 (:foreground ,iris :weight normal))
      (gnus-group-news-2-empty (:inherit gnus-group-news-2 :foreground ,comment))
      (gnus-group-news-3 (:foreground ,foam :weight normal))
      (gnus-group-news-3-empty (:inherit gnus-group-news-3 :foreground ,comment))
      (gnus-group-news-4 (:foreground ,love :weight normal))
      (gnus-group-news-4-empty (:inherit gnus-group-news-4 :foreground ,comment))
      (gnus-group-news-5 (:foreground ,gold :weight normal))
      (gnus-group-news-5-empty (:inherit gnus-group-news-5 :foreground ,comment))
      (gnus-group-news-6 (:foreground ,pine :weight normal))
      (gnus-group-news-6-empty (:inherit gnus-group-news-6 :foreground ,comment))

      (gnus-server-agent (:foreground ,foam :weight bold))
      (gnus-server-closed (:foreground ,comment :slant italic))
      (gnus-server-cloud (:foreground ,gold :weight bold))
      (gnus-server-denied (:foreground ,rose :weight bold))
      (gnus-server-offline (:foreground ,pine :weight bold))
      (gnus-server-opened (:foreground ,leaf :weight bold))

      (gnus-splash (:foreground ,foam))

      (gnus-summary-cancelled (:foreground ,rose :background unspecified :weight normal))
      (gnus-summary-high-ancient (:foreground ,leaf :weight normal))
      (gnus-summary-high-read (:foreground ,leaf :weight normal))
      (gnus-summary-high-ticked (:foreground ,gold :weight normal))
      (gnus-summary-high-undownloaded (:foreground ,foreground :weight bold))
      (gnus-summary-high-unread (:foreground ,love :weight normal))

      (gnus-summary-low-ancient (:foreground ,comment :weight normal))
      (gnus-summary-low-read (:foreground ,comment :weight normal))
      (gnus-summary-low-ticked (:foreground ,comment :slant italic))
      (gnus-summary-low-undownloaded (:foreground ,foreground :slant italic))
      (gnus-summary-low-unread (:foreground ,comment :weight normal))

      (gnus-summary-normal-ancient (:foreground ,foam :weight normal))
      (gnus-summary-normal-read (:foreground ,foreground :weight normal))
      (gnus-summary-normal-ticked (:foreground ,gold :weight normal))
      (gnus-summary-normal-undownloaded (:foreground ,foreground))
      (gnus-summary-normal-unread (:foreground ,pine :weight normal))

      ;; grep (built-in)
      (grep-context-face (:foreground ,comment))
      (grep-error-face (:foreground ,rose :weight bold :underline t))
      (grep-hit-face (:foreground ,pine))
      (grep-match-face (:foreground unspecified :background unspecified :inherit match))

      ;; hi-lock (built-in)
      (hi-black-hb (:weight bold))
      (hi-blue (:foreground ,background :background ,pine))
      (hi-blue-b (:foreground ,pine :weight bold))
      (hi-green (:foreground ,background :background ,leaf))
      (hi-green-b (:foreground ,leaf :weight bold))
      (hi-pink (:foreground ,background :background ,foam))
      (hi-red-b (:foreground ,rose :weight bold))
      (hi-yellow (:foreground ,background :background ,love))

      ;; icomplete (built-in)
      (icomplete-first-match (:foreground ,leaf :weight bold))

      ;; IDO (built-in)
      (ido-subdir (:foreground ,iris))
      (ido-first-match (:foreground ,gold))
      (ido-only-match (:foreground ,leaf))
      (ido-indicator (:foreground ,rose :background ,background))
      (ido-virtual (:foreground ,comment))

      ;; info (built-in)
      (Info-quoted (:inherit font-lock-constant-face))
      (info-index-match (:inherit isearch))
      (info-menu-header (:foreground ,leaf :weight bold :height 1.4))
      (info-menu-star (:foreground ,love))
      (info-node (:foreground ,leaf :weight bold :slant italic))
      (info-title-1 (:weight bold :height 1.4))
      (info-title-2 (:weight bold :height 1.2))
      (info-title-3 (:weight bold :foreground ,gold))
      (info-title-4 (:weight bold :foreground ,iris))
      (info-xref-visited (:foreground ,comment :underline t))

      ;; j-mode
      (j-verb-face (:inherit font-lock-constant-face))
      (j-adverb-face (:inherit font-lock-function-name-face))
      (j-conjunction-face (:inherit font-lock-keyword-face))
      (j-other-face (:inherit font-lock-preprocessor-face))

      ;; kaocha-runner
      (kaocha-runner-error-face (:foreground ,rose))
      (kaocha-runner-success-face (:foreground ,leaf))
      (kaocha-runner-warning-face (:foreground ,love))

      ;; Message-mode (built-in)
      (message-header-other (:foreground unspecified :background unspecified :weight normal))
      (message-header-subject (:inherit message-header-other :weight bold :foreground ,love))
      (message-header-to (:inherit message-header-other :weight bold :foreground ,gold))
      (message-header-cc (:inherit message-header-to :foreground unspecified))
      (message-header-name (:foreground ,pine :background unspecified))
      (message-header-newsgroups (:foreground ,foam :background unspecified :slant normal))
      (message-separator (:foreground ,iris))

      ;; Meow
      (meow-beacon-fake-cursor (:foreground ,gold :inverse-video t))
      (meow-search-highlight (:inherit lazy-highlight))

      ;; nim-mode
      (nim-font-lock-export-face (:inherit font-lock-function-name-face))
      (nim-font-lock-number-face (:inherit default))
      (nim-font-lock-pragma-face (:inherit font-lock-preprocessor-face))
      (nim-non-overloadable-face (:inherit font-lock-builtin-face))

      ;; nxml (built-in)
      (nxml-name-face (:foreground unspecified :inherit font-lock-constant-face))
      (nxml-attribute-local-name-face (:foreground unspecified :inherit font-lock-variable-name-face))
      (nxml-ref-face (:foreground unspecified :inherit font-lock-preprocessor-face))
      (nxml-delimiter-face (:foreground unspecified :inherit font-lock-keyword-face))
      (nxml-delimited-data-face (:foreground unspecified :inherit font-lock-string-face))
      (rng-error-face (:underline ,rose))

      ;; orderless
      (orderless-match-face-0 (:foreground ,foam))
      (orderless-match-face-1 (:foreground ,love))
      (orderless-match-face-2 (:foreground ,gold))
      (orderless-match-face-3 (:foreground ,pine))

      ;; org-mode (built-in)
      (org-agenda-structure (:foreground ,iris))
      (org-agenda-current-time (:foreground ,love))
      (org-agenda-date (:foreground ,pine :underline nil))
      (org-agenda-done (:foreground ,leaf))
      (org-agenda-dimmed-todo-face (:foreground ,comment))
      (org-block (:background ,highlight))
      (org-block-begin-line (:background ,background :foreground ,comment :slant italic))
      (org-block-end-line (:background ,background :foreground ,comment :slant italic))
      (org-code (:foreground ,love))
      (org-column (:background ,contrast-bg))
      (org-column-title (:inherit org-column :weight bold :underline t))
      (org-date (:foreground ,pine :underline t))
      (org-date-selected (:foreground ,foam :inverse-video t))
      (org-document-info (:foreground ,foam))
      (org-document-info-keyword (:foreground ,leaf))
      (org-document-title (:weight bold :foreground ,gold))
      (org-done (:foreground ,leaf))
      (org-drawer (:foreground ,comment))
      (org-ellipsis (:foreground ,comment))
      (org-footnote (:foreground ,foam))
      (org-formula (:foreground ,rose))
      (org-hide (:foreground ,background :background ,background))
      (org-habit-alert-face (:foreground ,background :background ,love))
      (org-habit-alert-future-face (:foreground ,background :background ,gold))
      (org-habit-clear-face (:foreground ,background :background ,comment))
      (org-habit-clear-future-face (:foreground ,background :background ,iris))
      (org-habit-overdue-face (:foreground ,background :background ,rose))
      (org-habit-overdue-future-face (:foreground ,background :background ,love))
      (org-habit-ready-face (:foreground ,background :background ,foam))
      (org-habit-ready-future-face (:foreground ,background :background ,leaf))
      (org-headline-done (:foreground unspecified :strike-through t))
      (org-headline-todo (:foreground ,gold))
      (org-link (:foreground ,pine :underline t))
      (org-mode-line-clock-overrun (:inherit mode-line :background ,rose))
      (org-scheduled (:foreground ,leaf))
      (org-scheduled-previously (:foreground ,foam))
      (org-scheduled-today (:foreground ,leaf))
      (org-special-keyword (:inherit org-drawer))
      (org-table (:foreground ,iris))
      (org-time-grid (:foreground ,love))
      (org-todo (:foreground ,rose))
      (org-upcoming-deadline (:foreground ,gold))
      (org-warning (:weight bold :foreground ,rose))

      ;; org-modern
      (org-modern-date-active (:background ,highlight))
      (org-modern-date-inactive (:inherit org-modern-label :background ,highlight :foreground ,comment))
      (org-modern-done (:inherit org-modern-label :background ,leaf :foreground ,foreground))
      (org-modern-priority (:inherit (org-modern-label org-priority) :background ,highlight))
      (org-modern-statistics (:inherit org-modern-label :background ,highlight))
      (org-modern-tag (:inherit (org-modern-label org-tag) :background ,highlight))
      (org-modern-time-active (:inherit org-modern-label :background ,foam :foreground ,foreground))
      (org-modern-time-inactive (:inherit (org-modern-label org-modern-date-inactive)))
      (org-modern-todo (:inherit org-modern-label :background ,rose :foreground ,foreground))

      ;; doom-modeline
      (doom-modeline-bar (:background ,iris))
      (doom-modeline-bar-inactive (:background ,comment))
      (doom-modeline-battery-charging (:foreground ,leaf))
      (doom-modeline-battery-critical (:underline t :foreground ,love))
      (doom-modeline-battery-error (:underline t :foreground ,love))
      (doom-modeline-battery-full (( )))
      (doom-modeline-battery-warning (:inherit warning))
      (doom-modeline-buffer-file (:inherit bold))
      (doom-modeline-buffer-major-mode (( )))
      (doom-modeline-buffer-minor-mode (( )))
      (doom-modeline-buffer-modified (:foreground ,love))
      (doom-modeline-buffer-path (( )))
      (doom-modeline-evil-emacs-state (:inherit italic))
      (doom-modeline-evil-insert-state (:foreground ,love))
      (doom-modeline-evil-motion-state (:foreground ,iris))
      (doom-modeline-evil-normal-state (:foreground ,leaf ))
      (doom-modeline-evil-operator-state (:foreground ,gold))
      (doom-modeline-evil-replace-state (:inherit error))
      (doom-modeline-evil-visual-state (:foreground ,rose))
      (doom-modeline-info (:inherit success))
      (doom-modeline-input-method (( )))
      (doom-modeline-lsp-error (:inherit bold))
      (doom-modeline-lsp-running (( )))
      (doom-modeline-lsp-success (:inherit success))
      (doom-modeline-lsp-warning (:inherit warning))
      (doom-modeline-notification (:inherit error))
      (doom-modeline-project-dir (( )))
      (doom-modeline-project-parent-dir (( )))
      (doom-modeline-project-root-dir (( )))
      (doom-modeline-repl-success (:inherit success))
      (doom-modeline-repl-warning (:inherit warning))
      (doom-modeline-time (( )))
      (doom-modeline-urgent (:inherit bold :foreground ,love))
      (doom-modeline-warning (:inherit warning))

      ;; Outline (built-in)
      (outline-1 (:inherit nil :foreground ,pine))
      (outline-2 (:inherit nil :foreground ,iris))
      (outline-3 (:inherit nil :foreground ,foam))
      (outline-4 (:inherit nil :foreground ,love))
      (outline-5 (:inherit nil :foreground ,gold))
      (outline-6 (:inherit nil :foreground ,pine))
      (outline-7 (:inherit nil :foreground ,iris))
      (outline-8 (:inherit nil :foreground ,foam))
      (outline-9 (:inherit nil :foreground ,love))

      ;; outline-minor-faces
      (outline-minor-0 (:weight bold :background ,low-contrast-bg))
      (outline-minor-1 (:inherit (outline-minor-0 outline-1)))

      ;; Parenthesis matching (built-in)
      (show-paren-match (:background ,iris :foreground ,background))
      (show-paren-mismatch (:background ,rose :foreground ,background))

      ;; rcirc (built-in)
      (rcirc-bright-nick (:foreground ,love))
      (rcirc-dim-nick (:foreground ,comment))
      (rcirc-keyword (:foreground ,leaf))
      (rcirc-my-nick (:foreground ,leaf))
      (rcirc-nick-in-message (:foreground ,love))
      (rcirc-nick-in-message-full-line (:foreground ,gold))
      (rcirc-other-nick (:foreground ,iris))
      (rcirc-prompt (:foreground ,pine))
      (rcirc-server (:foreground ,leaf))
      (rcirc-timestamp (:foreground ,foam))

      ;; re-builder (built-in)
      (reb-match-0 (:foreground ,background :background ,foam))
      (reb-match-1 (:foreground ,background :background ,love))
      (reb-match-2 (:foreground ,background :background ,gold))
      (reb-match-3 (:foreground ,background :background ,pine))

      ;; ruler-mode (built-in)
      (ruler-mode-column-number (:foreground ,foreground :background ,highlight))
      (ruler-mode-comment-column (:foreground ,comment :background ,contrast-bg))
      (ruler-mode-current-column (:foreground ,love :background ,contrast-bg :weight bold))
      (ruler-mode-default (:foreground ,comment :background ,highlight))
      (ruler-mode-fill-column (:foreground ,rose :background ,contrast-bg))
      (ruler-mode-fringes (:foreground ,leaf :background ,contrast-bg))
      (ruler-mode-goal-column (:foreground ,rose :background ,contrast-bg))
      (ruler-mode-margins (:foreground ,gold :background ,contrast-bg))
      (ruler-mode-pad (:foreground ,background :background ,comment))
      (ruler-mode-tab-stop (:foreground ,pine :background ,contrast-bg))

      ;; sh-script (built-in)
      (sh-heredoc (:foreground unspecified :inherit font-lock-string-face :weight normal))
      (sh-quoted-exec (:foreground unspecified :inherit font-lock-preprocessor-face))

      ;; Speedbar (built-in)
      (speedbar-button-face (:foreground ,leaf))
      (speedbar-directory-face (:foreground ,gold))
      (speedbar-file-face (:foreground ,foam))
      (speedbar-highlight-face (:inherit highlight))
      (speedbar-selected-face (:foreground ,rose :underline t))
      (speedbar-separator-face (:foreground ,background :background ,pine :overline ,background))
      (speedbar-tag-face (:foreground ,love))
      (vhdl-speedbar-architecture-face (:foreground ,pine))
      (vhdl-speedbar-architecture-selected-face (:foreground ,pine :underline t))
      (vhdl-speedbar-configuration-face (:foreground ,leaf))
      (vhdl-speedbar-configuration-selected-face (:foreground ,leaf :underline t))
      (vhdl-speedbar-entity-face (:foreground ,gold))
      (vhdl-speedbar-entity-selected-face (:foreground ,gold :underline t))
      (vhdl-speedbar-instantiation-face (:foreground ,love))
      (vhdl-speedbar-instantiation-selected-face (:foreground ,love :underline t))
      (vhdl-speedbar-library-face (:foreground ,iris))
      (vhdl-speedbar-package-face (:foreground ,foam))
      (vhdl-speedbar-package-selected-face (:foreground ,foam :underline t))
      (vhdl-speedbar-subprogram-face (:foreground ,leaf))

      ;; tab-bar (built-in)
      (tab-bar (:foreground ,comment :background ,background))
      (tab-bar-tab-group-current (:inherit bold :background ,background :foreground ,highlight :box (:line-width -2 :color ,background)))
      (tab-bar-tab-group-inactive (:background ,background :foreground ,highlight :box (:line-width -2 :color ,background)))
      (tab-bar-tab (:inherit bold :background ,background :foreground ,foreground :box (:line-width -2 :color ,background) :underline (:style line :color ,foreground)))
      (tab-bar-tab-inactive (:foreground ,comment :background ,background :box (:line-width -2 :color ,background)))
      (tab-bar-tab-ungrouped (:inherit tab-bar-tab-inactive))

      ;; tab-line (built-in)
      (tab-line (:foreground ,comment :background ,highlight))
      (tab-line-close-highlight (:foreground ,rose))
      (tab-line-highlight (:inherit highlight))
      (tab-line-tab ())
      (tab-line-tab-current (:inherit bold :background ,background :foreground ,foreground :box (:line-width -2 :color ,background) :underline (:style line :color ,foreground)))
      (tab-line-tab-inactive (:background ,highlight :foreground ,comment :box (:line-width -2 :color ,background) ))
      (tab-line-tab-modifie (:foreground ,gold))

      ;; which-function (built-in)
      (which-func (:foreground ,pine :background unspecified :weight bold))

      ;; whitespace (built-in)
      (whitespace-big-indent (:background ,rose :foreground ,contrast-bg))
      (whitespace-empty (:background ,love :foreground ,gold))
      (whitespace-hspace (:background ,contrast-bg :foreground ,comment))
      (whitespace-indentation (:background ,contrast-bg :foreground ,comment))
      (whitespace-line (:background ,contrast-bg :foreground ,gold))
      (whitespace-newline (:background ,contrast-bg :foreground ,comment))
      (whitespace-space (:background ,contrast-bg :foreground ,comment))
      (whitespace-space-after-tab (:background ,contrast-bg :foreground ,love))
      (whitespace-space-before-tab (:background ,contrast-bg :foreground ,gold))
      (whitespace-tab (:background ,contrast-bg :foreground ,comment))
      (whitespace-trailing (:background ,gold :foreground ,contrast-bg))
      (trailing-whitespace (:inherit whitespace-trailing))

      ;; window-divider (built-in)
      (window-divider (:foreground ,comment))
      (window-divider-first-pixel (:foreground ,contrast-bg))
      (window-divider-last-pixel (:foreground ,contrast-bg))

      ;; window-tool-bar (built-in)
      (window-tool-bar-button (:background ,contrast-bg :foreground ,iris :inverse-video nil :box (:line-width 1 :style released-button)))
      (window-tool-bar-button-disabled (:inherit tab-line :foreground ,comment :inverse-video nil :box (:line-width 1 :style released-button)))
      (window-tool-bar-button-hover (:background ,low-contrast-bg :foreground ,pine :inverse-video nil :box (:line-width 1 :style released-button)))

      ;; ace-window
      (aw-background-face (:foreground ,contrast-bg))
      (aw-leading-char-face (:foreground ,love))

      ;; Anzu
      (anzu-mode-line (:foreground ,gold))
      (anzu-mode-line-no-match (:foreground ,rose))
      (anzu-replace-highlight (:inherit lazy-highlight))
      (anzu-replace-to (:inherit isearch))
      (anzu-match-1 (:foreground ,love ))
      (anzu-match-2 (:foreground ,gold))
      (anzu-match-3 (:foreground ,pine))

      ;; auctex
      (font-latex-bold-face (:foreground ,leaf :weight bold))
      (font-latex-doctex-documentation-face (:inherit highlight))
      (font-latex-italic-face (:foreground ,leaf :slant italic))
      (font-latex-math-face (:foreground ,iris))
      (font-latex-script-char-face (:foreground ,rose))
      (font-latex-sectioning-0-face (:foreground ,love :weight bold :height 1.2))
      (font-latex-sectioning-1-face (:foreground ,love :weight bold :height 1.2))
      (font-latex-sectioning-2-face (:foreground ,love :weight bold :height 1.2))
      (font-latex-sectioning-3-face (:foreground ,love :weight bold :height 1.2))
      (font-latex-sectioning-4-face (:foreground ,love :weight bold :height 1.2))
      (font-latex-sectioning-5-face (:foreground ,love :weight bold))
      (font-latex-sedate-face (:foreground ,gold))
      (font-latex-slide-title-face (:foreground ,pine :weight bold :height 1.2))
      (font-latex-string-face (:inherit font-lock-string-face))
      (font-latex-verbatim-face (:inherit font-lock-string-face))
      (font-latex-warning-face (:inherit warning))
      ;; TeX-fold
      (TeX-fold-folded-face (:foreground ,iris))
      (TeX-fold-unfolded-face (:inherit highlight))

      ;; avy
      (avy-background-face (:foreground ,contrast-bg))
      (avy-lead-face (:foreground ,background :background ,love))
      (avy-lead-face-0 (:foreground ,background :background ,pine))
      (avy-lead-face-1 (:foreground ,background :background ,foam))
      (avy-lead-face-2 (:foreground ,background :background ,gold))

      ;; bm
      (bm-face (:background ,contrast-bg :foreground ,foreground :extend t))
      (bm-persistent-face (:background ,pine :foreground ,background :extend t))

      ;; bookmark
      (bookmark-face (:foreground ,background :background ,love))

      ;; bookmark+
      (bmkp-*-mark (:foreground ,background :background ,love))
      (bmkp->-mark (:foreground ,love))
      (bmkp-D-mark (:foreground ,background :background ,rose))
      (bmkp-X-mark (:foreground ,rose))
      (bmkp-a-mark (:background ,rose))
      (bmkp-bad-bookmark (:foreground ,background :background ,love))
      (bmkp-bookmark-file (:foreground ,iris :background ,contrast-bg))
      (bmkp-bookmark-list (:background ,contrast-bg))
      (bmkp-buffer (:foreground ,pine))
      (bmkp-desktop (:foreground ,background :background ,iris))
      (bmkp-file-handler (:background ,rose))
      (bmkp-function (:foreground ,leaf))
      (bmkp-gnus (:foreground ,gold))
      (bmkp-heading (:foreground ,love))
      (bmkp-info (:foreground ,foam))
      (bmkp-light-autonamed (:foreground ,foam :background ,highlight))
      (bmkp-light-autonamed-region (:foreground ,rose :background ,highlight))
      (bmkp-light-fringe-autonamed (:foreground ,contrast-bg :background ,iris))
      (bmkp-light-fringe-non-autonamed (:foreground ,contrast-bg :background ,leaf))
      (bmkp-light-mark (:foreground ,background :background ,foam))
      (bmkp-light-non-autonamed (:foreground ,iris :background ,highlight))
      (bmkp-light-non-autonamed-region (:foreground ,gold :background ,highlight))
      (bmkp-local-directory (:foreground ,background :background ,iris))
      (bmkp-local-file-with-region (:foreground ,love))
      (bmkp-local-file-without-region (:foreground ,comment))
      (bmkp-man (:foreground ,iris))
      (bmkp-no-jump (:foreground ,comment))
      (bmkp-no-local (:foreground ,love))
      (bmkp-non-file (:foreground ,leaf))
      (bmkp-remote-file (:foreground ,gold))
      (bmkp-sequence (:foreground ,pine))
      (bmkp-su-or-sudo (:foreground ,rose))
      (bmkp-t-mark (:foreground ,iris))
      (bmkp-url (:foreground ,pine :underline t))
      (bmkp-variable-list (:foreground ,leaf))

      ;; Caml
      (caml-types-def-face (:inherit highlight :box (:color ,pine :line-width -1)))
      (caml-types-occ-face (:inherit highlight :box (:color ,love :line-width -1)))
      (caml-types-expr-face (:inherit highlight :box (:color ,foam :line-width -1)))
      (caml-types-scope-face (:inherit highlight :box (:color ,leaf :line-width -1)))
      (caml-types-typed-face (:inherit highlight :box (:color ,iris :line-width -1)))

      ;; CIDER
      (cider-debug-code-overlay-face (:background ,contrast-bg))
      (cider-deprecated-face (:foreground ,contrast-bg :background ,love))
      (cider-enlightened-face (:inherit cider-result-overlay-face :box (:color ,gold :line-width -1)))
      (cider-enlightened-local-face (:weight bold :foreground ,gold))
      (cider-error-highlight-face (:underline (:style wave :color ,rose) :inherit unspecified))
      (cider-fringe-good-face (:foreground ,leaf))
      (cider-instrumented-face (:box (:color ,rose :line-width -1)))
      (cider-result-overlay-face (:background ,contrast-bg :box (:line-width -1 :color ,love)))
      (cider-test-error-face (:foreground ,contrast-bg :background ,gold))
      (cider-test-failure-face (:foreground ,contrast-bg :background ,rose))
      (cider-test-success-face (:foreground ,contrast-bg :background ,leaf))
      (cider-traced-face (:box ,foam :line-width -1))
      (cider-warning-highlight-face (:underline (:style wave :color ,love) :inherit unspecified))

      ;; Circe
      (circe-fool-face (:foreground ,comment))
      (circe-highlight-nick-face (:foreground ,gold))
      (circe-my-message-face (:foreground ,leaf))
      (circe-prompt-face (:foreground ,pine))
      (circe-server-face (:foreground ,leaf))
      (circe-topic-diff-new-face (:foreground ,pine))
      (circe-topic-diff-removed-face (:foreground ,rose))

      ;; For Brian Carper's extended clojure syntax table
      (clojure-keyword (:foreground ,love))
      (clojure-parens (:foreground ,foreground))
      (clojure-braces (:foreground ,leaf))
      (clojure-brackets (:foreground ,love))
      (clojure-double-quote (:foreground ,foam :background unspecified))
      (clojure-special (:foreground ,pine))
      (clojure-java-call (:foreground ,iris))

      ;; Clojure errors
      (clojure-test-failure-face (:background unspecified :inherit flymake-warnline))
      (clojure-test-error-face (:background unspecified :inherit flymake-errline))
      (clojure-test-success-face (:background unspecified :foreground unspecified :underline ,leaf))

      ;; coffee-mode
      (coffee-mode-class-name (:foreground ,gold :weight bold))
      (coffee-mode-function-param (:foreground ,iris))

      ;; company
      (company-preview (:foreground ,comment :background ,contrast-bg))
      (company-preview-common (:inherit company-preview :foreground ,rose))
      (company-preview-search (:inherit company-preview :foreground ,pine))
      (company-tooltip (:background ,contrast-bg))
      (company-tooltip-selection (:foreground ,comment :inverse-video t))
      (company-tooltip-common (:inherit company-tooltip :foreground ,rose))
      (company-tooltip-common-selection (:inherit company-tooltip-selection :foreground ,rose))
      (company-tooltip-search (:inherit company-tooltip :foreground ,pine))
      (company-tooltip-annotation (:inherit company-tooltip :foreground ,leaf))
      (company-tooltip-annotation-selection (:inherit company-tooltip-selection :foreground ,leaf))
      (company-scrollbar-bg (:inherit 'company-tooltip :background ,highlight))
      (company-scrollbar-fg (:background ,contrast-bg))
      (company-echo-common (:inherit company-echo :foreground ,rose))

      ;; counsel-css
      (counsel-css-selector-depth-face-1 (:foreground ,love))
      (counsel-css-selector-depth-face-2 (:foreground ,gold))
      (counsel-css-selector-depth-face-3 (:foreground ,leaf))
      (counsel-css-selector-depth-face-4 (:foreground ,foam))
      (counsel-css-selector-depth-face-5 (:foreground ,pine))
      (counsel-css-selector-depth-face-6 (:foreground ,iris))

      ;; csv-mode
      (csv-separator-face (:foreground ,gold))

      ;; debbugs
      (debbugs-gnu-done (:foreground ,comment))
      (debbugs-gnu-forwarded (:foreground ,love))
      (debbugs-gnu-handled (:foreground ,leaf))
      (debbugs-gnu-new (:foreground ,rose))
      (debbugs-gnu-pending (:foreground ,pine))
      (debbugs-gnu-stale-1 (:foreground ,gold))
      (debbugs-gnu-stale-2 (:foreground ,leaf))
      (debbugs-gnu-stale-3 (:foreground ,iris))
      (debbugs-gnu-stale-4 (:foreground ,foam))
      (debbugs-gnu-stale-5 (:foreground ,foreground))
      (debbugs-gnu-tagged (:foreground ,rose))

      ;; define-it
      (define-it-headline-face (:foreground ,pine :bold t))
      (define-it-pop-tip-color (:foreground ,comment :background ,contrast-bg))
      (define-it-sense-number-face (:foreground ,iris :bold t))
      (define-it-type-face (:foreground ,foam))
      (define-it-var-face (:foreground ,gold :bold t))

      ;; diff-hl
      (diff-hl-insert (:foreground ,background :background ,leaf))
      (diff-hl-change (:foreground ,background :background ,gold))
      (diff-hl-delete (:foreground ,background :background ,rose))

      ;; dired
      (dired-marked (:foreground ,leaf))
      (dired-mark (:foreground ,leaf :inverse-video t))

      ;; dired-async
      (dired-async-failures (:inherit error))
      (dired-async-message (:inherit success))
      (dired-async-mode-message (:inherit warning))

      ;; diredfl
      (diredfl-compressed-file-suffix (:foreground ,pine))
      (diredfl-compressed-file-name (:foreground ,pine))
      (diredfl-deletion (:inherit error :inverse-video t))
      (diredfl-deletion-file-name (:inherit error))
      (diredfl-date-time (:foreground ,pine))
      (diredfl-dir-heading (:foreground ,leaf :weight bold))
      (diredfl-dir-name (:foreground ,foam))
      (diredfl-dir-priv (:foreground ,foam :background unspecified))
      (diredfl-exec-priv (:foreground ,gold :background unspecified))
      (diredfl-executable-tag (:foreground ,rose :background unspecified))
      (diredfl-file-name (:foreground ,foreground))
      (diredfl-file-suffix (:foreground ,leaf))
      (diredfl-flag-mark (:foreground ,leaf :inverse-video t))
      (diredfl-flag-mark-line (:background unspecified :inherit highlight))
      (diredfl-ignored-file-name (:foreground ,comment))
      (diredfl-link-priv (:background unspecified :foreground ,iris))
      (diredfl-mode-line-flagged (:foreground ,rose))
      (diredfl-mode-line-marked (:foreground ,leaf))
      (diredfl-no-priv (:background unspecified))
      (diredfl-number (:foreground ,love))
      (diredfl-other-priv (:background unspecified :foreground ,iris))
      (diredfl-rare-priv (:foreground ,rose :background unspecified))
      (diredfl-read-priv (:foreground ,leaf :background unspecified))
      (diredfl-symlink (:foreground ,iris))
      (diredfl-write-priv (:foreground ,love :background unspecified))

      ;; dired+
      (diredp-compressed-file-suffix (:inherit diredfl-compressed-file-suffix))
      (diredp-compressed-file-name (:inherit diredfl-compressed-file-name))
      (diredp-deletion (:inherit diredfl-deletion))
      (diredp-deletion-file-name (:inherit diredfl-deletion-file-name))
      (diredp-date-time (:inherit diredfl-date-time))
      (diredp-dir-heading (:inherit diredfl-dir-heading))
      (diredp-dir-name (:inherit diredfl-dir-name))
      (diredp-dir-priv (:inherit diredfl-dir-priv))
      (diredp-exec-priv (:inherit diredfl-exec-priv))
      (diredp-executable-tag (:inherit diredfl-executable-tag))
      (diredp-file-name (:inherit diredfl-file-name))
      (diredp-file-suffix (:inherit diredfl-file-suffix))
      (diredp-flag-mark (:inherit diredfl-flag-mark))
      (diredp-flag-mark-line (:inherit diredfl-flag-mark-line))
      (diredp-ignored-file-name (:inherit diredfl-ignored-file-name))
      (diredp-link-priv (:inherit diredfl-link-priv))
      (diredp-mode-line-flagged (:inherit diredfl-mode-line-flagged))
      (diredp-mode-line-marked (:inherit diredfl-mode-line-marked))
      (diredp-no-priv (:inherit diredfl-no-priv))
      (diredp-number (:inherit diredfl-number))
      (diredp-other-priv (:inherit diredfl-other-priv))
      (diredp-rare-priv (:inherit diredfl-rare-priv))
      (diredp-read-priv (:inherit diredfl-read-priv))
      (diredp-symlink (:inherit diredfl-symlink))
      (diredp-write-priv (:inherit diredfl-write-priv))

      ;; dired-narrow
      (dired-narrow-blink (:foreground ,background :background ,love))

      ;; e2wm
      (e2wm:face-history-list-normal (:foreground ,foreground :background ,background))
      (e2wm:face-history-list-select1 (:foreground ,foam :background ,background))
      (e2wm:face-history-list-select2 (:foreground ,love :background ,background))

      ;; EDTS errors
      (edts-face-warning-line (:background unspecified :inherit flymake-warnline))
      (edts-face-warning-mode-line (:background unspecified :foreground ,gold :weight bold))
      (edts-face-error-line (:background unspecified :inherit flymake-errline))
      (edts-face-error-mode-line (:background unspecified :foreground ,rose :weight bold))

      ;; Elfeed
      (elfeed-log-debug-level-face (:foreground ,comment))
      (elfeed-log-error-level-face (:inherit error))
      (elfeed-log-info-level-face (:inherit success))
      (elfeed-log-warn-level-face (:inherit warning))
      (elfeed-search-date-face (:foreground ,pine))
      (elfeed-search-feed-face (:foreground ,love))
      (elfeed-search-tag-face (:foreground ,comment))
      (elfeed-search-title-face (:foreground ,comment))
      (elfeed-search-unread-count-face (:foreground ,love))
      (elfeed-search-unread-title-face (:foreground ,foreground :weight bold))

      ;; EMMS
      (emms-browser-artist-face (:foreground ,iris))
      (emms-browser-album-face (:foreground ,foam))
      (emms-browser-track-face (:foreground ,love))
      (emms-browser-year/genre-face (:foreground ,pine))
      (emms-playlist-selected-face (:inverse-video t))
      (emms-playlist-track-face (:foreground ,love))

      ;; eyebrowse
      (eyebrowse-mode-line-active (:foreground ,gold :weight bold))
      (eyebrowse-mode-line-delimiters (:foreground ,iris))
      (eyebrowse-mode-line-inactive (:foreground ,comment))
      (eyebrowse-mode-line-separator (:foreground ,iris))

      ;; flx-ido
      (flx-highlight-face (:inherit nil :foreground ,love :weight bold :underline nil))

      ;; fold-this
      (fold-this-overlay (:foreground ,leaf))

      ;; forge
      (forge-pullreq-open (:foreground ,foam))
      (forge-pullreq-merged (:foreground ,leaf :strike-through t))
      (forge-pullreq-rejected (:foreground ,rose :strike-through t))

      ;; git-gutter (git-gutter-fringe inherits from git-gutter)
      (git-gutter:separator (:foreground ,foam :weight bold))
      (git-gutter:modified (:foreground ,iris :weight bold))
      (git-gutter:added (:foreground ,leaf :weight bold))
      (git-gutter:deleted (:foreground ,rose :weight bold))
      (git-gutter:unchanged (:background ,love))

      ;; git-gutter+ (git-gutter-fringe+ inherits from git-gutter+)
      (git-gutter+-separator (:foreground ,foam :weight bold))
      (git-gutter+-modified (:foreground ,iris :weight bold))
      (git-gutter+-added (:foreground ,leaf :weight bold))
      (git-gutter+-deleted (:foreground ,rose :weight bold))
      (git-gutter+-unchanged (:background ,love))

      ;; git-timemachine
      (git-timemachine-minibuffer-author-face (:foreground ,iris))
      (git-timemachine-minibuffer-detail-face (:foreground ,leaf))

      ;; guide-key
      (guide-key/prefix-command-face (:foreground ,pine))
      (guide-key/highlight-command-face (:foreground ,leaf))
      (guide-key/key-face (:foreground ,comment))

      ;; helm
      (helm-M-x-key (:foreground ,gold :underline t))
      (helm-bookmark-addressbook (:foreground ,rose))
      (helm-bookmark-file (:foreground ,foam))
      (helm-bookmark-file-not-found (:foreground ,background))
      (helm-bookmark-gnus (:foreground ,iris))
      (helm-bookmark-info (:foreground ,leaf))
      (helm-bookmark-man (:foreground ,gold))
      (helm-bookmark-w3m (:foreground ,love))
      (helm-buffer-archive (:foreground ,love))
      (helm-buffer-directory (:foreground ,pine))
      (helm-buffer-not-saved (:foreground ,gold))
      (helm-buffer-process (:foreground ,foam))
      (helm-buffer-saved-out (:inherit warning))
      (helm-buffer-size (:foreground ,love))
      (helm-candidate-number (:foreground ,leaf))
      (helm-comint-prompts-buffer-name (:foreground ,leaf))
      (helm-comint-prompts-promptidx (:foreground ,foam))
      (helm-delete-async-message (:foreground ,love))
      (helm-eshell-prompts-buffer-name (:foreground ,leaf))
      (helm-eshell-prompts-promptidx (:foreground ,foam))
      (helm-etags-file (:foreground ,love :underline t))
      (helm-ff-denied (:foreground ,background :background ,rose))
      (helm-ff-directory (:foreground ,foam))
      (helm-ff-dotted-directory (:foreground ,comment))
      (helm-ff-dotted-symlink-directory (:foreground ,comment))
      (helm-ff-executable (:foreground ,leaf))
      (helm-ff-invalid-symlink (:foreground ,background :background ,rose))
      (helm-ff-pipe (:foreground ,love :background ,background))
      (helm-ff-prefix (:foreground ,background :background ,love))
      (helm-ff-socket (:foreground ,iris))
      (helm-ff-suid (:foreground ,background :background ,rose))
      (helm-grep-file (:foreground ,iris :underline t))
      (helm-grep-finish (:foreground ,leaf))
      (helm-grep-lineno (:foreground ,gold))
      (helm-grep-match (:inherit match))
      (helm-header-line-left-margin (:foreground ,background :background ,love))
      (helm-lisp-completion-info (:foreground ,rose))
      (helm-lisp-show-completion (:background ,contrast-bg))
      (helm-locate-finish (:foreground ,leaf))
      (helm-match (:inherit match))
      (helm-moccur-buffer (:foreground ,foam :underline t))
      (helm-mode-prefix (:foreground ,background :background ,rose))
      (helm-prefarg (:foreground ,rose))
      (helm-resume-need-update (:background ,rose))
      (helm-selection (:inherit highlight :extend t))
      (helm-selection-line (:inherit highlight :extend t))
      (helm-separator (:foreground ,iris))
      (helm-source-header (:weight bold :foreground ,gold))
      (helm-time-zone-current (:foreground ,leaf))
      (helm-time-zone-home (:foreground ,rose))
      (helm-ucs-char (:foreground ,love))
      (helm-visible-mark (:foreground ,pine))

      ;;;;; marginalia
      (marginalia-archive (:foreground ,foam))
      (marginalia-char (:foreground ,amber))
      (marginalia-date (:foreground ,pine))

      (marginalia-documentation (:foreground ,iris))
      (marginalia-file-name ( ))
      (marginalia-file-owner (:inherit shadow))
      (marginalia-file-priv-dir (:foreground ,foam))
      (marginalia-file-priv-exec (:foreground ,love))
      (marginalia-file-priv-link (:foreground unspecified))

      (marginalia-file-priv-no (:inherit shadow))
      (marginalia-file-priv-other (:foreground ,pine))
      (marginalia-file-priv-rare (:foreground ,amber))
      (marginalia-file-priv-read (:foreground ,foreground))
      (marginalia-file-priv-write (:foreground ,foam))
      (marginalia-function (:foreground ,gold))
      (marginalia-key (:inherit bold :foreground ,iris))

      (marginalia-lighter (:inherit shadow))
      (marginalia-liqst (:inherit shadow))
      (marginalia-mode (:foreground ,foam))
      (marginalia-modified (:inherit warning))
      (marginalia-null (:inherit shadow))
      (marginalia-number (:foreground ,foam))
      (marginalia-size (:foreground ,love))
      (marginalia-string (:foreground ,foam))
      (marginalia-symbol (:foreground ,pine))
      (marginalia-true ( ))
      (marginalia-type (:foreground ,pine))
      (marginalia-value (:inherit shadow))
      (marginalia-version (:foreground ,pine))

      ;; helm-ls-git
      (helm-ls-git-added-copied-face (:foreground ,leaf))
      (helm-ls-git-added-modified-face (:foreground ,love))
      (helm-ls-git-conflict-face (:foreground ,rose))
      (helm-ls-git-deleted-and-staged-face (:foreground ,iris))
      (helm-ls-git-deleted-not-staged-face (:foreground ,comment))
      (helm-ls-git-modified-and-staged-face (:foreground ,leaf))
      (helm-ls-git-modified-not-staged-face (:foreground ,love))
      (helm-ls-git-renamed-modified-face (:foreground ,pine))
      (helm-ls-git-untracked-face (:foreground ,foam))

      ;; helm-rg
      (helm-rg-active-arg-face (:foreground ,leaf))
      (helm-rg-base-rg-cmd-face (:foreground ,foreground))
      (helm-rg-colon-separator-ripgrep-output-face (:foreground ,foreground))
      (helm-rg-directory-cmd-face (:foreground ,gold))
      (helm-rg-directory-header-face (:foreground ,foreground :extend t))
      (helm-rg-error-message (:foreground ,rose))
      (helm-rg-extra-arg-face (:foreground ,love))
      (helm-rg-file-match-face (:foreground ,foam :underline t))
      (helm-rg-inactive-arg-face (:foreground ,comment))
      (helm-rg-line-number-match-face (:foreground ,gold :underline t))
      (helm-rg-match-text-face (:foreground ,background :background ,pine))
      (helm-rg-preview-line-highlight (:foreground ,leaf))
      (helm-rg-title-face (:foreground ,iris))

      ;; helm-switch-shell
      (helm-switch-shell-new-shell-face (:foreground ,background :background ,iris))

      ;; hl-sexp
      (hl-sexp-face (:background ,contrast-bg))

      ;; highlight-80+
      (highlight-80+ (:background ,contrast-bg))

      ;; highlight-symbol
      (highlight-symbol-face (:inherit highlight))

      ;; Hydra
      (hydra-face-blue (:foreground ,pine))
      (hydra-face-teal (:foreground ,foam))
      (hydra-face-pink (:foreground ,iris))
      (hydra-face-red (:foreground ,rose))
      ;; this is unfortunate, but we have no color close to amaranth in
      ;; our palette
      (hydra-face-amaranth (:foreground ,gold))

      ;; info+
      (info-command-ref-item (:foreground ,leaf :background ,highlight))
      (info-constant-ref-item (:foreground ,iris :background ,highlight))
      (info-double-quoted-name (:inherit font-lock-comment-face))
      (info-file (:foreground ,love :background ,highlight))
      (info-function-ref-item (:inherit font-lock-function-name-face :background ,highlight))
      (info-macro-ref-item (:foreground ,gold :background ,highlight))
      (info-menu (:foreground ,leaf))
      (info-quoted-name (:inherit font-lock-constant-face))
      (info-reference-item (:background ,highlight))
      (info-single-quote (:inherit font-lock-keyword-face))
      (info-special-form-ref-item (:foreground ,gold :background ,highlight))
      (info-string (:inherit font-lock-string-face))
      (info-syntax-class-item (:foreground ,pine :background ,highlight))
      (info-user-option-ref-item (:foreground ,rose :background ,highlight))
      (info-variable-ref-item (:inherit font-lock-variable-name-face :background ,highlight))
      (info-xref-bookmarked (:foreground ,iris))

      ;; Ivy
      (ivy-action (:foreground ,iris))
      (ivy-confirm-face (:foreground ,leaf))
      (ivy-current-match (:background ,contrast-bg))
      (ivy-cursor (:background ,contrast-bg))
      (ivy-match-required-face (:foreground ,rose :background ,background))
      (ivy-remote (:foreground ,gold))
      (ivy-subdir (:foreground ,iris))
      (ivy-virtual (:foreground ,comment))
      (ivy-minibuffer-match-face-1 (:foreground ,foam))
      (ivy-minibuffer-match-face-2 (:foreground ,love))
      (ivy-minibuffer-match-face-3 (:foreground ,pine))
      (ivy-minibuffer-match-face-4 (:foreground ,gold))

      ;; Jabber
      (jabber-chat-prompt-local (:foreground ,love))
      (jabber-chat-prompt-foreign (:foreground ,gold))
      (jabber-chat-prompt-system (:foreground ,love :weight bold))
      (jabber-chat-text-local (:foreground ,love))
      (jabber-chat-text-foreign (:foreground ,gold))
      (jabber-chat-text-error (:foreground ,rose))

      (jabber-roster-user-online (:foreground ,leaf))
      (jabber-roster-user-xa :foreground ,comment)
      (jabber-roster-user-dnd :foreground ,love)
      (jabber-roster-user-away (:foreground ,gold))
      (jabber-roster-user-chatty (:foreground ,iris))
      (jabber-roster-user-error (:foreground ,rose))
      (jabber-roster-user-offline (:foreground ,comment))

      (jabber-rare-time-face (:foreground ,comment))
      (jabber-activity-face (:foreground ,iris))
      (jabber-activity-personal-face (:foreground ,foam))

      ;; Cperl
      (cperl-array-face (:foreground ,pine :weight bold))
      (cperl-hash-face (:foreground ,rose :slant italic))
      (cperl-nonoverridable-face (:foreground ,iris))

      ;; js2-mode
      (js2-warning (:underline ,gold))
      (js2-error (:foreground unspecified :underline ,rose))
      (js2-external-variable (:foreground ,iris))
      (js2-function-param (:foreground ,pine))
      (js2-instance-member (:foreground ,pine))
      (js2-private-function-call (:foreground ,rose))
      ;; js2-mode additional attributes for better syntax highlight in javascript
      (js2-jsdoc-tag (:foreground ,foam))
      (js2-jsdoc-type (:foreground ,gold))
      (js2-jsdoc-value (:foreground ,gold))
      (js2-function-call (:foreground ,leaf))
      (js2-object-property (:foreground ,gold))
      (js2-private-member (:foreground ,iris))
      (js2-jsdoc-html-tag-name (:foreground ,gold))
      (js2-jsdoc-html-tag-delimiter (:foreground ,gold))

      ;; js3-mode
      (js3-warning-face (:underline ,gold))
      (js3-error-face (:foreground unspecified :underline ,rose))
      (js3-external-variable-face (:foreground ,iris))
      (js3-function-param-face (:foreground ,pine))
      (js3-jsdoc-tag-face (:foreground ,gold))
      (js3-jsdoc-type-face (:foreground ,foam))
      (js3-jsdoc-value-face (:foreground ,love))
      (js3-jsdoc-html-tag-name-face (:foreground ,pine))
      (js3-jsdoc-html-tag-delimiter-face (:foreground ,leaf))
      (js3-instance-member-face (:foreground ,pine))
      (js3-private-function-call-face (:foreground ,rose))

      ;; Ledger-mode
      (ledger-font-comment-face (:inherit font-lock-comment-face))
      (ledger-font-occur-narrowed-face (:inherit font-lock-comment-face :invisible t))
      (ledger-font-occur-xact-face (:inherit highlight))
      (ledger-font-payee-cleared-face (:foreground ,leaf))
      (ledger-font-payee-uncleared-face (:foreground ,foam))
      (ledger-font-posting-date-face (:foreground ,gold))
      (ledger-font-posting-amount-face (:foreground ,foreground))
      (ledger-font-posting-account-cleared-face (:foreground ,pine))
      (ledger-font-posting-account-face (:foreground ,iris))
      (ledger-font-posting-account-pending-face (:foreground ,love))
      (ledger-font-xact-highlight-face (:inherit highlight))
      (ledger-occur-narrowed-face (:inherit font-lock-comment-face :invisible t))
      (ledger-occur-xact-face (:inherit highlight))

      ;; Lispy
      (lispy-command-name-face (:inherit font-lock-function-name-face :background ,highlight))
      (lispy-cursor-face (:foreground ,background :background ,foreground))
      (lispy-face-hint (:foreground ,leaf :background ,contrast-bg))

      ;; macrostep
      (macrostep-expansion-highlight-face (:inherit highlight :foreground unspecified))

      ;; Magit
      (magit-bisect-bad (:foreground ,rose))
      (magit-bisect-good (:foreground ,leaf))
      (magit-bisect-skip (:foreground ,gold))
      (magit-blame-date (:foreground ,rose))
      (magit-blame-heading (:foreground ,gold :background ,highlight :extend t))
      (magit-branch-current (:foreground ,pine))
      (magit-branch-local (:foreground ,foam))
      (magit-branch-remote (:foreground ,leaf))
      (magit-cherry-equivalent (:foreground ,iris))
      (magit-cherry-unmatched (:foreground ,foam))
      (magit-diff-added (:foreground ,fg-added :background ,bg-added-faint))
      (magit-diff-added-highlight (:foreground ,fg-added :background ,bg-added))
      (magit-diff-base (background ,bg-changed-faint :foreground ,fg-changed))
      (magit-diff-base-highlight (:background ,bg-changed :foreground ,fg-changed))
      (magit-diff-context (:foreground ,comment :extend t))
      (magit-diff-context-highlight (:foreground ,comment :background ,highlight :extend t))
      (magit-diff-file-heading (:foreground ,foreground :extend t))
      (magit-diff-file-heading-highlight (:background ,highlight :weight bold :extend t))
      (magit-diff-file-heading-selection (:foreground ,gold :background ,highlight :extend t))
      (magit-diff-hunk-heading (:foreground ,foreground :background ,contrast-bg :extend t))
      (magit-diff-hunk-heading-highlight (:background ,contrast-bg :extend t))
      (magit-diff-lines-heading (:foreground ,love :background ,rose :extend t))
      (magit-diff-removed (:foreground ,fg-removed :background ,bg-removed-faint))
      (magit-diff-removed-highlight (:foreground ,fg-removed :background ,bg-removed))
      (magit-diffstat-added (:foreground ,fg-added-intense))
      (magit-diffstat-removed (:foreground ,fg-removed-intense))
      (magit-dimmed (:foreground ,comment))
      (magit-filename (:foreground ,iris))
      (magit-hash (:foreground ,comment))
      (magit-header-line (:inherit nil :weight bold))
      (magit-log-author (:foreground ,gold))
      (magit-log-date (:foreground ,pine))
      (magit-log-graph (:foreground ,comment))
      (magit-mode-line-process (:foreground ,gold))
      (magit-mode-line-process-error (:foreground ,rose))
      (magit-process-ng (:inherit error))
      (magit-process-ok (:inherit success))
      (magit-reflog-amend (:foreground ,iris))
      (magit-reflog-checkout (:foreground ,pine))
      (magit-reflog-cherry-pick (:foreground ,leaf))
      (magit-reflog-commit (:foreground ,leaf))
      (magit-reflog-merge (:foreground ,leaf))
      (magit-reflog-other (:foreground ,foam))
      (magit-reflog-rebase (:foreground ,iris))
      (magit-reflog-remote (:foreground ,foam))
      (magit-reflog-reset (:inherit error))
      (magit-refname (:foreground ,comment))
      (magit-section-heading (:foreground ,love :weight bold :extend t))
      (magit-section-heading-selection (:foreground ,gold :weight bold :extend t))
      (magit-section-highlight (:background ,highlight :weight bold :extend t))
      (magit-sequence-drop (:foreground ,rose))
      (magit-sequence-head (:foreground ,pine))
      (magit-sequence-part (:foreground ,gold))
      (magit-sequence-stop (:foreground ,leaf))
      (magit-signature-bad (:inherit error))
      (magit-signature-error (:inherit error))
      (magit-signature-expired (:foreground ,gold))
      (magit-signature-good (:inherit success))
      (magit-signature-revoked (:foreground ,iris))
      (magit-signature-untrusted (:foreground ,foam))
      (magit-tag (:foreground ,love))

      ;; mark-multiple
      (mm/master-face (:inherit region :foreground unspecified :background unspecified))
      (mm/mirror-face (:inherit region :foreground unspecified :background unspecified))

      ;; markdown
      (markdown-url-face (:inherit link))
      (markdown-link-face (:foreground ,pine :underline t))
      (markdown-code-face (:inherit fixed-pitch :background ,background :foreground ,iris))
      (markdown-inline-code-face (:inherit markdown-code-face))

      ;; markup
      (markup-code-face (:inherit fixed-pitch :background ,background :foreground ,iris))
      (markup-complex-replacement-face (:background ,background))
      (markup-error-face (:foreground ,rose :background ,background :weight bold))
      (markup-gen-face (:foreground ,pine))
      (markup-list-face (:foreground unspecified :background unspecified))
      (markup-meta-face (:foreground ,comment))
      (markup-meta-hide-face (:foreground ,comment))
      (markup-reference-face (:inherit link))
      (markup-secondary-text-face (:foreground ,comment))
      (markup-title-0-face (:foreground ,pine :weight bold :height 1.4))
      (markup-title-1-face (:foreground ,iris :weight bold :height 1.2))
      (markup-title-2-face (:foreground ,gold :weight bold))
      (markup-title-3-face (:foreground ,leaf :weight bold))
      (markup-title-4-face (:foreground ,pine :weight bold))
      (markup-title-5-face (:foreground ,iris :weight bold))
      (markup-typewriter-face (:inherit shadow))
      (markup-verbatim-face (:inherit shadow :background ,background))

      ;; Merlin (ocaml)
      (merlin-compilation-error-face (:inherit flycheck-error))
      (merlin-compilation-warning-face (:inherit flycheck-warning))

      ;; mu4e
      (mu4e-header-highlight-face (:underline nil :inherit region))
      (mu4e-header-marks-face (:underline nil :foreground ,love))
      (mu4e-flagged-face (:foreground ,gold :inherit nil))
      (mu4e-replied-face (:foreground ,pine :inherit nil))
      (mu4e-unread-face (:foreground ,love :inherit nil))
      (mu4e-cited-1-face (:foreground ,pine :slant normal))
      (mu4e-cited-2-face (:foreground ,iris :slant normal))
      (mu4e-cited-3-face (:foreground ,foam :slant normal))
      (mu4e-cited-4-face (:foreground ,love :slant normal))
      (mu4e-cited-5-face (:foreground ,gold :slant normal))
      (mu4e-cited-6-face (:foreground ,pine :slant normal))
      (mu4e-cited-7-face (:foreground ,iris :slant normal))
      (mu4e-ok-face (:foreground ,leaf))
      (mu4e-view-contact-face (:inherit nil :foreground ,love))
      (mu4e-view-link-face (:inherit link :foreground ,pine))
      (mu4e-view-url-number-face (:inherit nil :foreground ,foam))
      (mu4e-view-attach-number-face (:inherit nil :foreground ,gold))
      (mu4e-highlight-face (:inherit highlight))
      (mu4e-title-face (:inherit nil :foreground ,leaf))

      ;; MMM-mode
      (mmm-code-submode-face (:background ,contrast-bg))
      (mmm-comment-submode-face (:inherit font-lock-comment-face))
      (mmm-output-submode-face (:background ,contrast-bg))

      ;; neotree
      (neo-banner-face (:foreground ,pine :weight bold))
      (neo-button-face (:underline t))
      (neo-dir-link-face (:foreground ,gold))
      (neo-expand-btn-face (:foreground ,comment))
      (neo-file-link-face (:foreground ,foreground))
      (neo-header-face (:foreground ,foreground :background ,highlight))
      (neo-root-dir-face (:foreground ,pine :weight bold))
      (neo-vc-added-face (:foreground ,leaf))
      (neo-vc-conflict-face (:foreground ,rose))
      (neo-vc-default-face (:foreground ,foreground))
      (neo-vc-edited-face (:foreground ,iris))
      (neo-vc-ignored-face (:foreground ,contrast-bg))
      (neo-vc-missing-face (:foreground ,rose))
      (neo-vc-needs-merge-face (:foreground ,rose))
      (neo-vc-unlocked-changes-face (:foreground ,pine :slant italic))
      (neo-vc-user-face (:foreground ,rose :slant italic))

      ;; nswbuff
      (nswbuff-current-buffer-face (:foreground ,pine :weight bold :underline nil))
      (nswbuff-default-face (:foreground ,foreground :background ,background))
      (nswbuff-separator-face (:foreground ,comment))
      (nswbuff-special-buffers-face (:foreground ,iris :bold nil :underline nil))

      (package-name (:foreground ,love))
      (package-status-available (:foreground ,pine))
      (package-status-installed (:foreground ,leaf))
      (package-status-dependency (:foreground ,foam))

      ;; Parenthesis matching (mic-paren)
      (paren-face-match (:foreground unspecified :background unspecified :inherit show-paren-match))
      (paren-face-mismatch (:foreground unspecified :background unspecified :inherit show-paren-mismatch))
      (paren-face-no-match (:foreground unspecified :background unspecified :inherit show-paren-mismatch))

      ;; Parenthesis dimming (parenface)
      (paren-face (:foreground ,comment :background unspecified))

      ;; Perspective
      (persp-selected-face (:foreground ,love :weight bold))

      ;; Powerline
      (powerline-active1 (:foreground ,foreground :background ,highlight))
      (powerline-active2 (:foreground ,foreground :background ,contrast-bg))

      ;; Powerline-evil
      (powerline-evil-base-face (:inherit mode-line :foreground ,background))
      (powerline-evil-emacs-face (:inherit powerline-evil-base-face :background ,iris))
      (powerline-evil-insert-face (:inherit powerline-evil-base-face :background ,pine))
      (powerline-evil-motion-face (:inherit powerline-evil-base-face :background ,gold))
      (powerline-evil-normal-face (:inherit powerline-evil-base-face :background ,leaf))
      (powerline-evil-operator-face (:inherit powerline-evil-base-face :background ,foam))
      (powerline-evil-replace-face (:inherit powerline-evil-base-face :background ,rose))
      (powerline-evil-visual-face (:inherit powerline-evil-base-face :background ,love))

      (pulse-highlight-start-face (:background ,rose))

      ;; Python-specific overrides
      (py-builtins-face (:foreground ,gold :weight normal))

      ;; Rainbow-delimiters
      (rainbow-delimiters-depth-1-face (:foreground ,foreground))
      (rainbow-delimiters-depth-2-face (:foreground ,foam))
      (rainbow-delimiters-depth-3-face (:foreground ,love))
      (rainbow-delimiters-depth-4-face (:foreground ,leaf))
      (rainbow-delimiters-depth-5-face (:foreground ,pine))
      (rainbow-delimiters-depth-6-face (:foreground ,foreground))
      (rainbow-delimiters-depth-7-face (:foreground ,foam))
      (rainbow-delimiters-depth-8-face (:foreground ,love))
      (rainbow-delimiters-depth-9-face (:foreground ,leaf))
      (rainbow-delimiters-unmatched-face (:foreground ,rose))

      ;; regex-tool
      (regex-tool-matched-face (:foreground unspecified :background unspecified :inherit match))

      ;; RHTML
      (erb-delim-face (:background ,contrast-bg))
      (erb-exec-face (:background ,contrast-bg :weight bold))
      (erb-exec-delim-face (:background ,contrast-bg))
      (erb-out-face (:background ,contrast-bg :weight bold))
      (erb-out-delim-face (:background ,contrast-bg))
      (erb-comment-face (:background ,contrast-bg :weight bold))
      (erb-comment-delim-face (:background ,contrast-bg))

      ;; rpm-spec-mode
      (rpm-spec-dir-face (:foreground ,leaf))
      (rpm-spec-doc-face (:foreground ,leaf))
      (rpm-spec-ghost-face (:foreground ,rose))
      (rpm-spec-macro-face (:foreground ,love))
      (rpm-spec-obsolete-tag-face (:foreground ,rose))
      (rpm-spec-package-face (:foreground ,rose))
      (rpm-spec-section-face (:foreground ,love))
      (rpm-spec-tag-face (:foreground ,pine))
      (rpm-spec-var-face (:foreground ,rose))

      ;; Selectrum
      (selectrum-current-candidate (:background ,contrast-bg))
      (selectrum-primary-highlight (:foreground ,foam))
      (selectrum-secondary-highlight (:foreground ,love))
      (selectrum-completion-docsig (:inherit completions-annotation :underline t))

      ;; SLIME
      (slime-highlight-edits-face (:weight bold))
      (slime-repl-input-face (:weight normal :underline nil))
      (slime-repl-prompt-face (:underline nil :weight bold :foreground ,iris))
      (slime-repl-result-face (:foreground ,leaf))
      (slime-repl-output-face (:foreground ,pine :background ,background))
      (slime-repl-inputed-output-face (:foreground ,comment))

      ;; SLY
      (sly-error-face (:underline (:style wave :color ,rose)))
      (sly-mrepl-output-face (:foreground ,iris :background ,background))
      (sly-note-face (:underline (:style wave :color ,leaf)))
      (sly-style-warning-face (:underline (:style wave :color ,love)))
      (sly-warning-face (:underline (:style wave :color ,gold)))
      (sly-stickers-armed-face (:foreground ,background :background ,pine))
      (sly-stickers-empty-face (:foreground ,background :background ,comment))
      (sly-stickers-placed-face (:foreground ,background :background ,foreground))
      (sly-stickers-recordings-face (:foreground ,background :background ,leaf))

      ;; Smartparens paren matching
      (sp-show-pair-match-face (:foreground unspecified :background unspecified :inherit show-paren-match))
      (sp-show-pair-mismatch-face (:foreground unspecified :background unspecified :inherit show-paren-mismatch))

      ;; stripe-buffer
      (stripe-highlight (:inherit highlight))

      ;; swiper
      (swiper-line-face (:underline t))

      ;; sx
      (sx-question-mode-content-face (:background ,highlight))
      (sx-question-list-answers (:inherit sx-question-list-parent :foreground ,leaf))
      (sx-question-mode-accepted (:inherit sx-question-mode-title :foreground ,leaf))
      (sx-question-mode-kbd-tag (:weight semi-bold :box (:line-width 3 :style released-button :color ,contrast-bg)))

      ;; symbol-overlay
      (symbol-overlay-default-face (:inherit highlight :underline t))

      ;; syslog-mode
      (syslog-debug (:weight bold :foreground ,leaf))
      (syslog-error (:weight bold :foreground ,rose))
      (syslog-hide (:foregound ,comment))
      (syslog-info (:weight bold :foreground ,pine))
      (syslog-su (:weight bold :foreground ,iris))
      (syslog-warn (:weight bold :foreground ,gold))

      ;; transient
      (transient-enabled-suffix (:foreground ,low-contrast-bg :background ,leaf :weight bold))
      (transient-disabled-suffix (:foreground ,foreground :background ,rose :weight bold))

      ;; tuareg-mode (ocaml)
      (tuareg-font-lock-constructor-face (:inherit default :weight bold))
      (tuareg-font-lock-governing-face (:inherit font-lock-keyword-face :weight bold))
      (tuareg-font-lock-multistage-face (:inherit font-lock-preprocessor-face))
      (tuareg-font-lock-line-number-face (:foreground ,comment))
      (tuareg-font-lock-operator-face (:inherit font-lock-preprocessor-face))
      (tuareg-font-lock-interactive-error-face (:inherit error))
      (tuareg-font-double-semicolon-face (:inherit warning :slant italic))
      (tuareg-font-lock-error-face (:inherit error :slant italic))
      (tuareg-font-lock-interactive-output-face)
      (tuareg-font-lock-interactive-directive-face)

      ;; twittering-mode
      (twittering-username-face (:inherit erc-pal-face))
      (twittering-uri-face (:foreground ,pine :inherit link))
      (twittering-timeline-header-face (:foreground ,leaf :weight bold))
      (twittering-timeline-footer-face (:inherit twittering-timeline-header-face))

      ;; undo-tree
      (undo-tree-visualizer-default-face (:foreground ,foreground))
      (undo-tree-visualizer-current-face (:foreground ,leaf :weight bold))
      (undo-tree-visualizer-active-branch-face (:foreground ,rose))
      (undo-tree-visualizer-register-face (:foreground ,love))

      ;; vertico
      (vertico-current (:background ,contrast-bg :extend t))

      ;; visual-regexp
      (vr/match-0 (:foreground ,love :background ,background :inverse-video t))
      (vr/match-1 (:foreground ,foam :background ,background :inverse-video t))
      (vr/group-0 (:foreground ,iris :background ,background :inverse-video t))
      (vr/group-1 (:foreground ,leaf :background ,background :inverse-video t))
      (vr/group-2 (:foreground ,gold :background ,background :inverse-video t))

      ;; vterm
      (vterm-color-black (:background ,term-black :foreground ,term-black))
      (vterm-color-blue (:background ,pine :foreground ,pine))
      (vterm-color-cyan (:background ,foam :foreground ,foam))
      (vterm-color-default (:foreground unspecified :background unspecified :inherit default))
      (vterm-color-green (:background ,leaf :foreground ,leaf))
      (vterm-color-magenta (:background ,iris :foreground ,iris))
      (vterm-color-red (:background ,rose :foreground ,rose))
      (vterm-color-white (:background ,term-white :foreground ,term-white))
      (vterm-color-yellow (:background ,love :foreground ,love))
      (vterm-color-underline (:underline t))
      (vterm-color-inverse-video (:background ,background :inverse-video t))

      ;; web-mode
      (web-mode-doctype-face (:inherit font-lock-string-face))
      (web-mode-html-attr-equal-face (:foreground unspecified :background unspecified :inherit default))
      (web-mode-html-attr-name-face (:inherit font-lock-variable-name-face))
      (web-mode-html-tag-face (:inherit font-lock-function-name-face))
      (web-mode-html-tag-bracket-face (:inherit font-lock-function-name-face))
      (web-mode-symbol-face (:inherit font-lock-constant-face))

      ;; weechat
      (weechat-highlight-face (:foreground ,gold))
      (weechat-nick-self-face (:foreground ,leaf))
      (weechat-time-face (:foreground ,foam))

      ;; wgrep
      (wgrep-delete-face (:foreground ,rose))
      (wgrep-done-face (:foreground ,pine))
      (wgrep-face (:foreground ,leaf :background ,contrast-bg))
      (wgrep-file-face (:foreground ,comment :background ,contrast-bg))
      (wgrep-reject-face (:foreground ,gold :weight bold))

      ;; xcscope
      (cscope-file-face (:foreground ,leaf))
      (cscope-function-face (:foreground ,pine))
      (cscope-line-number-face (:foreground ,rose))
      (cscope-separator-face (:bold t :overline t :underline t :foreground ,iris))

      ;; uiua
      (uiua-number (:foreground ,gold))
      (uiua-noadic-or-constant (:foreground ,rose))
      (uiua-monadic-function (:foreground ,leaf))
      (uiua-dyadic-function (:foreground ,pine))
      (uiua-monadic-modifier (:foreground ,love))
      (uiua-dyadic-modifier (:foreground ,iris))

      ;; ztree
      (ztreep-arrow-face (:foreground ,highlight))
      (ztreep-diff-header-face (:foreground ,love :weight bold))
      (ztreep-diff-header-small-face (:foregorund ,love))
      (ztreep-diff-model-add-face (:foreground ,leaf))
      (ztreep-diff-model-diff-face (:foreground ,rose))
      (ztreep-diff-model-ignored-face (:foreground ,gold))
      (ztreep-diff-model-normal-face (:foreground ,foreground))
      (ztreep-expand-sign-face (:foreground ,foreground))
      (ztreep-header-face (:forground ,love :weight bold))
      (ztreep-leaf-face (:foreground ,foam))
      (ztreep-node-face (:foreground ,foreground))

      ;; telega
      (telega-button-highlight (:background ,contrast-bg))
      (telega-msg-heading (:background ,background))
      (telega-msg-self-title (:foreground ,gold :weight bold))
      (telega-root-heading (:foreground ,iris :background ,highlight :inherit bold))
      (telega-mention-count (:inherit bold :foreground ,amber))

      ;; corfu
      (corfu-current (:background ,contrast-bg))
      (corfu-bar (:background ,low-contrast-bg))
      (corfu-border (:background ,contrast-bg))
      (corfu-default (:background ,highlight))

      ;; goggles
      (goggles-changed (:background ,amber))
      (goggles-removed (:background ,love))
      (goggles-added (:background ,foam))))))

(eval-and-compile
  (defun rose-pine--theme-name (mode)
    (intern (format "rose-pine-%s" (symbol-name mode)))))

(defmacro rose-pine--define-theme (mode)
  "Define a theme for the tomorrow variant `MODE'."
  (let ((name (rose-pine--theme-name mode))
        (doc (format "A version of Chris Kempson's 'Tomorrow' theme (%s version)" mode)))
    `(progn
       (deftheme ,name ,doc)
       (put ',name 'theme-immediate t)
       (rose-pine--with-colors
        ',mode
        (apply 'custom-theme-set-faces ',name
               (rose-pine--face-specs))
        (custom-theme-set-variables
         ',name
         `(frame-background-mode ',background-mode)
         `(beacon-color ,rose)
         `(fci-rule-color ,contrast-bg)
         `(vc-annotate-color-map
           '((20  . ,rose)
             (40  . ,gold)
             (60  . ,love)
             (80  . ,leaf)
             (100 . ,foam)
             (120 . ,pine)
             (140 . ,iris)
             (160 . ,rose)
             (180 . ,gold)
             (200 . ,love)
             (220 . ,leaf)
             (240 . ,foam)
             (260 . ,pine)
             (280 . ,iris)
             (300 . ,rose)
             (320 . ,gold)
             (340 . ,love)
             (360 . ,leaf)))
         `(vc-annotate-very-old-color nil)
         `(vc-annotate-background nil)
         `(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
         `(ansi-color-names-vector (vector ,background ,rose ,leaf ,love ,pine ,iris ,foam ,foreground))
         `(window-divider-mode nil)
         ))
       (provide-theme ',name))))

(defun rose-pine (variant)
  "Apply the given tomorrow theme VARIANT, e.g. `night'."
  (let ((name (rose-pine--theme-name variant)))
    (custom-set-variables `(custom-enabled-themes '(,name)))))

;;;###autoload
(when (boundp 'custom-theme-load-path)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

;;;###autoload
(defun rose-pine-night ()
  "Apply the tomorrow night theme."
  (interactive)
  (rose-pine 'night))

;;;###autoload
(defun rose-pine-day ()
  "Apply the tomorrow day theme."
  (interactive)
  (rose-pine 'day))

(provide 'rose-pine)

;; Local Variables:
;; byte-compile-warnings: (not cl-functions)
;; End:

;;; rose-pine.el ends here
