;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq doom-theme 'doom-gruvbox)

(setq display-line-numbers-type t)

;; --- ORG-MODE ---
(setq org-directory "~/org/")

(setq org-agenda-files
      (list "inbox.org" "projects.org" "todo.org"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJ(p)" "LOOP(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")
        (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
        (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

(setq org-ellipsis " ▾")

(setq org-capture-templates
      '(("t" "todo" entry (file+headline "inbox.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("n" "note" entry (file+headline "inbox.org" "Notes")
         "* %?\n  %i\n  %a")
        ("u" "uni" entry (file+headline "todo.org" "University")
         "* TODO %? :uni:\n  DEADLINE: %t")))

;; --- ORG-ROAM ---
(use-package! org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode))

(setq org-roam-dailies-directory "~/org/roam/daily/")

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("u" "university" plain
         "* Source: %^{Source}\n* Professor: %^{Professor}\n* Context: %?\n"
         :target (file+head "uni/${slug}.org"
                            "#+title: ${title}\n#+filetags: :uni:\n")
         :unnarrowed t)

        ("c" "code" plain
         "* Language: %^{Language}\n* Difficulty: %^{Difficulty}\n\n* Problem:\n%?\n\n* Solution:\n#+begin_src %\\1\n\n#+end_src"
         :target (file+head "code/${slug}.org"
                            "#+title: ${title}\n#+filetags: :code:\n")
         :unnarrowed t)

        ("s" "study" plain
         "* Author: %^{Author}\n* Type: %^{Type|Book|Essay|Video|Podcast|Course}\n* Source: %^{Source}\n\n* Thesis / Core Idea:\n%?\n\n* Key Concepts:\n- \n\n* Actionable Insight / Reflection:\n"
         :target (file+head "study/${slug}.org"
                            "#+title: ${title}\n#+filetags: :study:\n")
         :unnarrowed t)

        ("p" "people" plain
         "* Met at: %^{Met where?}\n* Role: %^{Role}\n\n* Notes:\n%?"
         :target (file+head "people/${slug}.org"
                            "#+title: ${title}\n#+filetags: :people:\n")
         :unnarrowed t)))

(use-package! citar
  :custom
  (citar-bibliography '("~/org/references.bib"))
  (citar-library-paths '("~/Zotero/storage"))
  (citar-notes-paths '("~/org/roam/"))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))


;; --- TABLET INTEGRATION ---
(defun my/open-handwritten-journal ()
  "Open today's handwritten journal PDF if it exists."
  (interactive)
  (let* ((date (format-time-string "%Y-%m-%d"))
         (file-path (concat "~/org/journal_handwritten/" date ".pdf")))
    (if (file-exists-p file-path)
        (find-file file-path)
      (message "No handwritten journal found for today (%s)" date))))

(map! :leader
      (:prefix ("j" . "journal")
       :desc "Open handwritten journal" "h" #'my/open-handwritten-journal))


;; --- AGENDA ---
(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((agenda "" ((org-agenda-span 1)
                      (org-agenda-start-day "+0d")))
          (tags-todo "+DEADLINE<=\"<+3d>\""
                     ((org-agenda-overriding-header "CRITICAL DEADLINES (Next 3 Days)")))
          (tags-todo "+uni+TODO=\"TODO\""
                     ((org-agenda-overriding-header "UNIVERSITY")))
          (tags-todo "+code+TODO=\"PROJ\""
                     ((org-agenda-overriding-header "ACTIVE PROJECTS")))
          (todo "TODO"
                ((org-agenda-overriding-header "INBOX / MISC")
                 (org-agenda-files '("~/org/inbox.org" "~/org/todo.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled 'tags "uni" "code")))))
         ((org-agenda-compact-blocks t)))))
