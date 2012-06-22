(require 'org-publish)

(setq org-publish-project-alist
      '(

        ;; These are the main web files
        ("norgs"
         :base-directory "~/.org/norgs/"
         :base-extension "org"
         :publishing-directory "~/public_html"
         :recursive t
         :publishing-function org-publish-org-to-html
         :headline-levels 5
         :auto-preamble t
         :section-numbers nil
         :headline-levels 3
         :table-of-contents nil
         :style "<link rel='stylesheet' type='text/css' href='static/css/style.css' />"
         :style-include-default nil
         )

        ;; These are static files (images, pdf, etc)
        ("org-static"
         :base-directory "~/.org/norgs/static" ;; Change this to your local dir
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|txt\\|asc"
         :publishing-directory "output"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("org" :components ("norgs" "org-static"))
        )
      )

(defun myweb-publish nil
  "Publish myweb."
  (interactive)
  (org-publish-all))
