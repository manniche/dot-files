;; clojure-mode
(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/.emacs.d/elpa/clojure-mode")
(add-to-list 'load-path "~/.emacs.d/elpa/slime")
(add-to-list 'load-path "~/.emacs.d/elpa/swank-clojure")
(add-to-list 'load-path "~/.emacs.d/elpa/slime-repl")


(require 'clojure-mode)

;; swank-clojure

(setq swank-clojure-jar-path "~/.clojure/clojure.jar"
      swank-clojure-extra-classpaths (list
				      "~/.emacs.d/elisp/swank-clojure/src/main/clojure"
				      "~/.clojure/clojure-contrib.jar"))

(require 'swank-clojure-autoloads)

;; slime
(eval-after-load "slime"
  '(progn (slime-setup '(slime-repl))))

(require 'slime)
(slime-setup)