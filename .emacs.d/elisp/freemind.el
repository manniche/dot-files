<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: freemind.el</title><link rel="alternate" type="application/wiki" title="Edit this page" href="http://www.emacswiki.org/emacs?action=edit;id=freemind.el" /><link type="text/css" rel="stylesheet" href="/emacs/wiki.css" /><meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="http://www.emacswiki.org/emacs?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: freemind.el" href="http://www.emacswiki.org/emacs?action=rss;rcidonly=freemind.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="http://www.emacswiki.org/emacs/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="http://www.emacswiki.org/emacs/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="http://www.emacswiki.org/emacs/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for freemind.el only"
      href="http://www.emacswiki.org/emacs?action=rss;rcidonly=freemind.el" /><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/></head><body class="http://www.emacswiki.org/emacs"><div class="header"><a class="logo" href="http://www.emacswiki.org/emacs/SiteMap"><img class="logo" src="/emacs_logo.png" alt="[Home]" /></a><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span>
<!-- Google CSE Search Box Begins  -->
<form class="tiny" action="http://www.google.com/cse" id="searchbox_004774160799092323420:6-ff2s0o6yi"><p>
<input type="hidden" name="cx" value="004774160799092323420:6-ff2s0o6yi" />
<input type="text" name="q" size="25" />
<input type="submit" name="sa" value="Search" />
</p></form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_004774160799092323420%3A6-ff2s0o6yi"></script>
<!-- Google CSE Search Box Ends -->
<h1><a href="http://www.google.com/cse?cx=004774160799092323420:6-ff2s0o6yi&q=freemind.el">freemind.el</a></h1></div><div class="wrapper"><div class="content browse"><p><a href="http://www.emacswiki.org/cgi-bin/wiki/download/freemind.el">Download</a></p><pre class="code"><span class="linecomment">;;; freemind.el --- Export to FreeMind</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Author: Lennart Borgman (lennart O borgman A gmail O com)</span>
<span class="linecomment">;; Created: 2008-02-19T17:52:56+0100 Tue</span>
<span class="linecomment">;; Version: 0.57</span>
<span class="linecomment">;; Last-Updated: 2008-08-27 Wed</span>
<span class="linecomment">;; URL:</span>
<span class="linecomment">;; Keywords:</span>
<span class="linecomment">;; Compatibility:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Features that might be required by this library:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;   `cl', `easymenu', `font-lock', `noutline', `org', `outline',</span>
<span class="linecomment">;;   `syntax', `time-date', `xml'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Commentary:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This file tries to implement some functions useful for</span>
<span class="linecomment">;; transformation between org-mode and FreeMind files.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; To use this library you can add to your .emacs</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;   (require 'freemind)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Here are the commands you can use:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;    M-x `freemind-from-org-mode'</span>
<span class="linecomment">;;    M-x `freemind-from-org-mode-node'</span>
<span class="linecomment">;;    M-x `freemind-from-org-sparse-tree'</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;    M-x `freemind-to-org-mode'</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;    M-x `freemind-show'</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Change log:</span>
<span class="linecomment">;; 2008-08-27: Sacha Chua patched this to remove linebreaks and make sure </span>
<span class="linecomment">;; multiple nodes are closed correctly</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This program is free software; you can redistribute it and/or</span>
<span class="linecomment">;; modify it under the terms of the GNU General Public License as</span>
<span class="linecomment">;; published by the Free Software Foundation; either version 2, or</span>
<span class="linecomment">;; (at your option) any later version.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This program is distributed in the hope that it will be useful,</span>
<span class="linecomment">;; but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU</span>
<span class="linecomment">;; General Public License for more details.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with this program; see the file COPYING.  If not, write to</span>
<span class="linecomment">;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth</span>
<span class="linecomment">;; Floor, Boston, MA 02110-1301, USA.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Code:</span>

(require 'xml)
(require 'org)
(eval-when-compile (require 'cl))

<span class="linecomment">;; Fix-me: I am not sure these are useful:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; (defcustom freemind-main-fgcolor "black"</span>
<span class="linecomment">;;   "Color of main node's text."</span>
<span class="linecomment">;;   :type 'color</span>
<span class="linecomment">;;   :group 'freemind)</span>

<span class="linecomment">;; (defcustom freemind-main-color "black"</span>
<span class="linecomment">;;   "Background color of main node."</span>
<span class="linecomment">;;   :type 'color</span>
<span class="linecomment">;;   :group 'freemind)</span>

<span class="linecomment">;; (defcustom freemind-child-fgcolor "black"</span>
<span class="linecomment">;;   "Color of child nodes' text."</span>
<span class="linecomment">;;   :type 'color</span>
<span class="linecomment">;;   :group 'freemind)</span>

<span class="linecomment">;; (defcustom freemind-child-color "black"</span>
<span class="linecomment">;;   "Background color of child nodes."</span>
<span class="linecomment">;;   :type 'color</span>
<span class="linecomment">;;   :group 'freemind)</span>


(defun freemind-show (mm-file)
  "<span class="quote">Show file MM-FILE in Freemind.</span>"
  (interactive
   (list
    (save-match-data
      (let ((name (read-file-name "<span class="quote">FreeMind file: </span>"
                                  nil nil nil
                                  (if (buffer-file-name)
                                      (file-name-nondirectory (buffer-file-name))
                                    "<span class="quote"></span>")
                                  <span class="linecomment">;; Fix-me: Is this an Emacs bug?</span>
                                  <span class="linecomment">;; This predicate function is never</span>
                                  <span class="linecomment">;; called.</span>
                                  (lambda (fn)
                                    (string-match "<span class="quote">^mm$</span>" (file-name-extension fn))))))
        (setq name (expand-file-name name))
        name))))
  (cond
   ((fboundp 'w32-shell-execute) (w32-shell-execute "<span class="quote">open</span>" mm-file))
   (t (message "<span class="quote">Don't know how to show %s</span>" mm-file))))

(defconst freemind-org-nfix "<span class="quote">--org-mode: </span>")

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;; Format converters</span>

(defun freemind-escape-str-from-org (org-str)
  (let ((chars (append org-str nil))
        (fm-str "<span class="quote"></span>"))
    (dolist (cc chars)
      (setq fm-str
            (concat fm-str
                    (if (&lt; cc 256)
                        (cond
                         ((= cc ?\"<span class="quote">) </span>"&quot<span class="linecomment">;")</span>
                         ((= cc ?\&) "<span class="quote">&amp;</span>")
                         ((= cc ?\&lt;) "<span class="quote">&lt;</span>")
                         ((= cc ?\&gt;) "<span class="quote">&gt;</span>")			 
                         (t (char-to-string cc)))
                      <span class="linecomment">;; Formatting as &#number; is maybe needed</span>
                      <span class="linecomment">;; according to a bug report from kazuo</span>
                      <span class="linecomment">;; fujimoto, but I have now instead added a xml</span>
                      <span class="linecomment">;; processing instruction saying that the mm</span>
                      <span class="linecomment">;; file is utf-8:</span>
                      <span class="linecomment">;;</span>
                      <span class="linecomment">;; (format "&#x%x;" (- cc ;; ?\x800))</span>
                      (char-to-string cc)
                      ))))
    fm-str))

(defun freemind-unescape-str-to-org (fm-str)
  (let ((org-str fm-str))
    (setq org-str (replace-regexp-in-string "<span class="quote">&quot;</span>" "<span class="quote">\"</span>" org-str))
    (setq org-str (replace-regexp-in-string "<span class="quote">&amp;</span>" "<span class="quote">&</span>" org-str))
    (setq org-str (replace-regexp-in-string "<span class="quote">&lt;</span>" "<span class="quote">&lt;</span>" org-str))
    (setq org-str (replace-regexp-in-string "<span class="quote">&gt;</span>" "<span class="quote">&gt;</span>" org-str))    
    (setq org-str (replace-regexp-in-string
               "<span class="quote">&#x\\([a-f0-9]\\{2\\}\\);</span>"
               (lambda (m)
                 (char-to-string (+ (string-to-number (match-string 1 str) 16)
                                    ?\x800)))
               org-str))))

<span class="linecomment">;; (freemind-test-escape)</span>
<span class="linecomment">;; (defun freemind-test-escape ()</span>
<span class="linecomment">;;   (let* ((str1 "a quote: \", an amp: &, lt: &lt;; over 256: öåäÖÅÄ")</span>
<span class="linecomment">;;          (str2 (freemind-escape-str-from-org str1))</span>
<span class="linecomment">;;          (str3 (freemind-unescape-str-to-org str2))</span>
<span class="linecomment">;;         )</span>
<span class="linecomment">;;     (unless (string= str1 str3)</span>
<span class="linecomment">;;       (error "str3=%s" str3))</span>
<span class="linecomment">;;     ))</span>

(defun freemind-convert-links-from-org (org-str)
  (let ((fm-str (replace-regexp-in-string
                 (rx (not (any "<span class="quote">[\"</span>"))
                     (submatch
                      "<span class="quote">http</span>"
                      (opt ?\s)
                      "<span class="quote">://</span>"
                      (1+
                       (any "<span class="quote">-%.?@a-zA-Z0-9()_/:~=&#</span>"))))
                 "<span class="quote">[[\\1][\\1]]</span>"
                 org-str)))
    (replace-regexp-in-string (rx "<span class="quote">[[</span>"
                                  (submatch (*? nonl))
                                  "<span class="quote">][</span>"
                                  (submatch (*? nonl))
                                  "<span class="quote">]]</span>")
                              "<span class="quote">&lt;a href=\"\\1\"&gt;\\2&lt;/a&gt;</span>"
                              fm-str)))

<span class="linecomment">;;(freemind-convert-links-to-org "&lt;a href=\"http://www.somewhere/\"&gt;link-text&lt;/a&gt;")</span>
(defun freemind-convert-links-to-org (fm-str)
  (let ((org-str (replace-regexp-in-string
                  (rx "<span class="quote">&lt;a</span>"
                      space
                      (0+
                       (0+ (not (any "<span class="quote">&gt;</span>")))
                       space)
                      "<span class="quote">href=\"</span>"
                      (submatch (0+ (not (any "<span class="quote">\"</span>"))))
                      "<span class="quote">\"</span>"
                      (0+ (not (any "<span class="quote">&gt;</span>")))
                       "<span class="quote">&gt;</span>"
                       (submatch (0+ (not (any "<span class="quote">&lt;</span>"))))
                       "<span class="quote">&lt;/a&gt;</span>")
                  "<span class="quote">[[\\1][\\2]]</span>"
                  fm-str)))
    org-str))

(defun freemind-convert-drawers-from-org (text)
  )

<span class="linecomment">;; (freemind-test-links)</span>
<span class="linecomment">;; (defun freemind-test-links ()</span>
<span class="linecomment">;;   (let* ((str1 "[[http://www.somewhere/][link-text]")</span>
<span class="linecomment">;;          (str2 (freemind-convert-links-from-org str1))</span>
<span class="linecomment">;;          (str3 (freemind-convert-links-to-org str2))</span>
<span class="linecomment">;;         )</span>
<span class="linecomment">;;     (unless (string= str1 str3)</span>
<span class="linecomment">;;       (error "str3=%s" str3))</span>
<span class="linecomment">;;     ))</span>

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;; Org =&gt; FreeMind</span>

(defun freemind-org-text-to-freemind-subnode/note (node-name start end)
  <span class="linecomment">;; fix-me: doc</span>
  (let ((text (buffer-substring-no-properties start end))
        (node-res "<span class="quote"></span>")
        (note-res "<span class="quote"></span>"))
    (save-match-data
      (setq text (freemind-escape-str-from-org text))
      <span class="linecomment">;; First see if there is something that should be moved to the</span>
      <span class="linecomment">;; note part:</span>
      (let (drawers)
        (while (string-match drawers-regexp text)
          (setq drawers (cons (match-string 0 text) drawers))
          (setq text
                (concat (substring text 0 (match-beginning 0))
                        (substring text (match-end 0))))
          )
        (when drawers
          (dolist (drawer drawers)
            (let ((lines (split-string drawer "<span class="quote">\n</span>")))
              (dolist (line lines)
                (setq note-res (concat
                                note-res
                                freemind-org-nfix line "<span class="quote">&lt;br /&gt;\n</span>")))
              ))))

      (when (&gt; (length note-res) 0)
        (setq note-res (concat
                        "<span class="quote">&lt;richcontent TYPE=\"NOTE\"&gt;&lt;html&gt;\n</span>"
                        "<span class="quote">&lt;head&gt;\n</span>"
                        "<span class="quote">&lt;/head&gt;\n</span>"
                        "<span class="quote">&lt;body&gt;\n</span>"
                        note-res
                        "<span class="quote">&lt;/body&gt;\n</span>"
                        "<span class="quote">&lt;/html&gt;\n</span>"
                        "<span class="quote">&lt;/richcontent&gt;\n</span>"))
        )

      <span class="linecomment">;; There is always an LF char:</span>
      (when (&gt; (length text) 1)
        (setq node-res (concat
                        "<span class="quote">&lt;node style=\"bubble\" background_color=\"#eeee00\"&gt;\n</span>"
                        "<span class="quote">&lt;richcontent TYPE=\"NODE\"&gt;&lt;html&gt;\n</span>"
                        "<span class="quote">&lt;head&gt;\n</span>"
                        "<span class="quote">&lt;style type=\"text/css\"&gt;\n</span>"
                        "<span class="quote">&lt;!--\n</span>"
                        "<span class="quote">p { margin-top: 0 }\n</span>"
                        "<span class="quote">--&gt;\n</span>"
                        "<span class="quote">&lt;/style&gt;\n</span>"
                        "<span class="quote">&lt;/head&gt;\n</span>"
                        "<span class="quote">&lt;body&gt;\n</span>"))
        (setq node-res (concat node-res "<span class="quote">&lt;p&gt;</span>"))
        (setq text (replace-regexp-in-string (rx "<span class="quote">\n</span>" (0+ blank) "<span class="quote">\n</span>") "<span class="quote">&lt;/p&gt;&lt;p&gt;\n</span>" text))
        <span class="linecomment">;;(setq text (replace-regexp-in-string (rx bol (1+ blank) eol) "" text))</span>
        <span class="linecomment">;;(setq text (replace-regexp-in-string (rx bol (1+ blank)) "&lt;br /&gt;" text))</span>
        (setq text (replace-regexp-in-string "<span class="quote">\n</span>" "<span class="quote">&lt;br /&gt;</span>" text))
        (freemind-convert-links-from-org text)
        (setq node-res (concat node-res text))
        (setq node-res (concat node-res "<span class="quote">&lt;/p&gt;\n</span>"))
        (setq node-res (concat
                        node-res
                        "<span class="quote">&lt;/body&gt;\n</span>"
                        "<span class="quote">&lt;/html&gt;\n</span>"
                        "<span class="quote">&lt;/richcontent&gt;\n</span>"
                        <span class="linecomment">;; Put a note that this is for the parent node</span>
                        "<span class="quote">&lt;richcontent TYPE=\"NOTE\"&gt;&lt;html&gt;</span>"
                        "<span class="quote">&lt;head&gt;</span>"
                        "<span class="quote">&lt;/head&gt;</span>"
                        "<span class="quote">&lt;body&gt;</span>"
                        "<span class="quote">&lt;p&gt;</span>"
                        "<span class="quote">-- This is more about \"</span>" node-name "<span class="quote">\" --</span>"
                        "<span class="quote">&lt;/p&gt;</span>"
                        "<span class="quote">&lt;/body&gt;</span>"
                        "<span class="quote">&lt;/html&gt;</span>"
                        "<span class="quote">&lt;/richcontent&gt;\n</span>"
                        "<span class="quote">&lt;/node&gt;\n</span>"
                        )))
      (list node-res note-res))))

(defun freemind-write-node ()
  (let* (this-icons
         this-bg-color
         this-m2-escaped
         this-rich-node
         this-rich-note
         )
    (when (string-match "<span class="quote">TODO</span>" this-m2)
      (setq this-m2 (replace-match "<span class="quote"></span>" nil nil this-m2))
      (add-to-list 'this-icons "<span class="quote">button_cancel</span>")
      (setq this-bg-color "<span class="quote">#ffff88</span>")
      (when (string-match "<span class="quote">\\[#\\(.\\)\\]</span>" this-m2)
        (let ((prior (string-to-char (match-string 1 this-m2))))
          (setq this-m2 (replace-match "<span class="quote"></span>" nil nil this-m2))
          (cond
           ((= prior ?A)
            (add-to-list 'this-icons "<span class="quote">full-1</span>")
            (setq this-bg-color "<span class="quote">#ff0000</span>"))
           ((= prior ?B)
            (add-to-list 'this-icons "<span class="quote">full-2</span>")
            (setq this-bg-color "<span class="quote">#ffaa00</span>"))
           ((= prior ?C)
            (add-to-list 'this-icons "<span class="quote">full-3</span>")
            (setq this-bg-color "<span class="quote">#ffdd00</span>"))
           ((= prior ?D)
            (add-to-list 'this-icons "<span class="quote">full-4</span>")
            (setq this-bg-color "<span class="quote">#ffff00</span>"))
           ((= prior ?E)
            (add-to-list 'this-icons "<span class="quote">full-5</span>"))
           ((= prior ?F)
            (add-to-list 'this-icons "<span class="quote">full-6</span>"))
           ((= prior ?G)
            (add-to-list 'this-icons "<span class="quote">full-7</span>"))
           ))))
    (setq this-m2 (org-trim this-m2))
    (setq this-m2-escaped (freemind-escape-str-from-org this-m2))
    (let ((node-notes (freemind-org-text-to-freemind-subnode/note
                       this-m2-escaped
                       this-node-end (1- next-node-start))))
      (setq this-rich-node (nth 0 node-notes))
      (setq this-rich-note (nth 1 node-notes)))
    (with-current-buffer mm-buffer
      (insert "<span class="quote">&lt;node text=\"</span>" this-m2-escaped "<span class="quote">\"</span>")
      <span class="linecomment">;;(when (and (&gt; current-level base-level) (&gt; next-level current-level))</span>
      (when (&gt; next-level current-level)
        (unless (or this-children-visible
                    next-has-some-visible-child)
          (insert "<span class="quote"> folded=\"true\"</span>")))
      (when (and (= current-level (1+ base-level))
                 (&gt; num-left-nodes 0))
        (setq num-left-nodes (1- num-left-nodes))
        (insert "<span class="quote"> position=\"left\"</span>"))
      (when this-bg-color
        (insert "<span class="quote"> background_color=\"</span>" this-bg-color "<span class="quote">\"</span>"))
      (insert "<span class="quote">&gt;\n</span>")
      (when this-icons
        (dolist (icon this-icons)
          (insert "<span class="quote">&lt;icon builtin=\"</span>" icon "<span class="quote">\"/&gt;\n</span>")))
      )
    (with-current-buffer mm-buffer
      (when this-rich-note (insert this-rich-note))
      (when this-rich-node (insert this-rich-node))
      )
  ))

(defun freemind-check-overwrite (file interactively)
  (if (file-exists-p file)
      (if interactively
          (y-or-n-p (format "<span class="quote">File %s exists, replace it? </span>" file))
        (error "<span class="quote">File %s already exists</span>" mm-file))
    t))

(defun freemind-look-for-visible-child (node-level)
  (save-excursion
    (save-match-data
      (let ((found-visible-child nil))
        (while (and (not found-visible-child)
                    (re-search-forward node-pattern nil t))
          (let* ((m1 (match-string-no-properties 1))
                 (level (length m1)))
            (if (&gt;= node-level level)
                (setq found-visible-child 'none)
              (unless (get-char-property (line-beginning-position) 'invisible)
                (setq found-visible-child 'found)))))
        (eq found-visible-child 'found)
        ))))

(defun freemind-write-mm-buffer (org-buffer mm-buffer node-at-line)
  (with-current-buffer org-buffer
    (save-match-data
      (let* ((drawers (copy-sequence org-drawers))
             drawers-regexp
             (node-pattern (rx bol
                               (submatch (1+ "<span class="quote">*</span>"))
                               (1+ space)
                               (submatch (*? nonl))
                               eol))
             (num-top1-nodes 0)
             (num-top2-nodes 0)
	     use-wrapper
             num-left-nodes
             (unclosed-nodes 0)
             (first-time t)
             (current-level 1)
             base-level
             prev-node-end
             rich-text
             unfinished-tag
             node-at-line-level
             node-at-line-last)
        (with-current-buffer mm-buffer
          (erase-buffer)
          (insert "<span class="quote">&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;\n</span>")
          (insert "<span class="quote">&lt;map version=\"0.9.Beta_15\"&gt;\n</span>")
          (insert "<span class="quote">&lt;!-- FreeMind file, see http://freemind.sourceforge.net --&gt;\n</span>"))
        (save-excursion
          <span class="linecomment">;; Get special buffer vars:</span>
          (goto-char (point-min))
          (while (re-search-forward (rx bol "<span class="quote">#+DRAWERS:</span>") nil t)
            (let ((dr-txt (buffer-substring-no-properties (match-end 0) (line-end-position))))
              (setq drawers (append drawers (split-string dr-txt) nil))))
          (setq drawers-regexp
                (concat (rx bol (0+ blank) "<span class="quote">:</span>")
                        (regexp-opt drawers)
                        (rx "<span class="quote">:</span>" (0+ blank)
                            "<span class="quote">\n</span>"
                            (*? anything)
                            "<span class="quote">\n</span>"
                            (0+ blank)
                            "<span class="quote">:END:</span>"
                            (0+ blank)
                            eol)
                        ))

          (if node-at-line
              <span class="linecomment">;; Get number of top nodes and last line for this node</span>
              (progn
                (goto-line node-at-line)
                (unless (looking-at node-pattern)
                  (error "<span class="quote">No node at line %s</span>" node-at-line))
                (setq node-at-line-level (length (match-string-no-properties 1)))
                (forward-line)
                (setq node-at-line-last
                      (catch 'last-line
                        (while (re-search-forward node-pattern nil t)
                          (let* ((m1 (match-string-no-properties 1))
                                 (level (length m1)))
                            (if (&lt;= level node-at-line-level)
                                (progn
                                  (beginning-of-line)
                                  (throw 'last-line (1- (point))))
                              (if (= level (1+ node-at-line-level))
                                  (setq num-top2-nodes (1+ num-top2-nodes))))))))
                (setq current-level node-at-line-level)
                (setq num-top1-nodes 1)
                (goto-line node-at-line))

            <span class="linecomment">;; First get number of top nodes</span>
            (goto-char (point-min))
            (while (re-search-forward node-pattern nil t)
              (let* ((m1 (match-string-no-properties 1))
                     (level (length m1)))
                (if (= level 1)
                    (setq num-top1-nodes (1+ num-top1-nodes))
                  (if (= level 2)
                      (setq num-top2-nodes (1+ num-top2-nodes))))))
            <span class="linecomment">;; If there is more than one top node we need to insert a node</span>
            <span class="linecomment">;; to keep them together.</span>
            (goto-char (point-min))
            (when (&gt; num-top1-nodes 1)
	      (setq use-wrapper 1)
	      (setq num-top2-nodes num-top1-nodes)
	      (setq current-level 0)
              (let ((orig-name (if buffer-file-name
                                   (file-name-nondirectory (buffer-file-name))
                                 (buffer-name))))
                (with-current-buffer mm-buffer
                  (insert "<span class="quote">&lt;node text=\"</span>" orig-name "<span class="quote">\" background_color=\"#00bfff\"&gt;\n</span>"
                          <span class="linecomment">;; Put a note that this is for the parent node</span>
                          "<span class="quote">&lt;richcontent TYPE=\"NOTE\"&gt;&lt;html&gt;</span>"
                          "<span class="quote">&lt;head&gt;</span>"
                          "<span class="quote">&lt;/head&gt;</span>"
                          "<span class="quote">&lt;body&gt;</span>"
                          "<span class="quote">&lt;p&gt;</span>"
                          freemind-org-nfix "<span class="quote">WHOLE FILE</span>"
                          "<span class="quote">&lt;/p&gt;</span>"
                          "<span class="quote">&lt;/body&gt;</span>"
                          "<span class="quote">&lt;/html&gt;</span>"
                          "<span class="quote">&lt;/richcontent&gt;\n</span>")))))

          (setq num-left-nodes (floor num-top2-nodes 2))
          (setq base-level current-level)
          (let (this-m2
                this-node-end
                this-children-visible
                next-m2
                next-level
                next-has-some-visible-child
                next-children-visible)
            (while (and
                    (re-search-forward node-pattern nil t)
                    (if node-at-line-last (&lt;= (point) node-at-line-last) t)
                    )
              (let* ((next-m1 (match-string-no-properties 1))
                     (next-node-start (match-beginning 0))
                     (next-node-end (match-end 0))
                     )
                (setq next-m2 (match-string-no-properties 2))
                (setq next-level (length next-m1))
                (setq next-children-visible
                      (not (eq 'outline
                               (get-char-property (line-end-position) 'invisible))))
                (setq next-has-some-visible-child
                      (if next-children-visible t
                        (freemind-look-for-visible-child next-level)))
                (when this-m2
                  (freemind-write-node))
                (when (if (= num-top1-nodes 1) (&gt; current-level base-level) t)
                  (while (&gt;= current-level next-level)
                    (with-current-buffer mm-buffer
                      (insert "<span class="quote">&lt;/node&gt;\n</span>")
                      (setq current-level (1- current-level)))))
                (setq this-node-end (1+ next-node-end))
                (setq this-m2 next-m2)
                (setq current-level next-level)
                (setq this-children-visible next-children-visible)
                (forward-char)
                ))
<span class="linecomment">;;;             (unless (if node-at-line-last</span>
<span class="linecomment">;;;                         (&gt;= (point) node-at-line-last)</span>
<span class="linecomment">;;;                       nil)</span>
              <span class="linecomment">;; Write last node:</span>
              (setq this-m2 next-m2)
              (setq current-level next-level)
              (setq next-node-start (if node-at-line-last
                                        (1+ node-at-line-last)
                                      (point-max)))
              (freemind-write-node)
	      (with-current-buffer mm-buffer (insert "<span class="quote">&lt;/node&gt;\n</span>"))
              <span class="linecomment">;)</span>
            )
          (with-current-buffer mm-buffer
            (while (&gt; current-level (1+ base-level))
              (insert "<span class="quote">&lt;/node&gt;\n</span>")
              (setq current-level (1- current-level))))
          (with-current-buffer mm-buffer
	    (if use-wrapper
		(insert "<span class="quote">&lt;/node&gt;\n</span>"))
            (insert "<span class="quote">&lt;/map&gt;</span>")
            (delete-trailing-whitespace)
            (goto-char (point-min))
            ))))))

(defun freemind-from-org-mode-node (node-line mm-file)
  "<span class="quote">Convert node at line NODE-LINE to the FreeMind file MM-FILE.</span>"
  (interactive
   (progn
     (unless (org-back-to-heading nil)
       (error "<span class="quote">Can't find org-mode node start</span>"))
     (let* ((line (line-number-at-pos))
            (default-mm-file (concat (if buffer-file-name
                                         (file-name-nondirectory buffer-file-name)
                                       "<span class="quote">nofile</span>")
                                     "<span class="quote">-line-</span>" (number-to-string line)
                                     "<span class="quote">.mm</span>"))
            (mm-file (read-file-name "<span class="quote">Output FreeMind file: </span>" nil nil nil default-mm-file)))
       (list line mm-file))))
  (when (freemind-check-overwrite mm-file (called-interactively-p))
    (let ((org-buffer (current-buffer))
          (mm-buffer (find-file-noselect mm-file)))
      (freemind-write-mm-buffer org-buffer mm-buffer node-line)
      (with-current-buffer mm-buffer
        (basic-save-buffer)
        (when (called-interactively-p)
          (switch-to-buffer-other-window mm-buffer)
          (freemind-show buffer-file-name))))))

(defun freemind-from-org-mode (org-file mm-file)
  "<span class="quote">Convert the `org-mode' file ORG-FILE to the FreeMind file MM-FILE.</span>"
  <span class="linecomment">;; Fix-me: better doc, include recommendations etc.</span>
  (interactive
   (let* ((org-file buffer-file-name)
          (default-mm-file (concat
                            (if org-file
                                (file-name-nondirectory org-file)
                              "<span class="quote">nofile</span>")
                            "<span class="quote">.mm</span>"))
          (mm-file (read-file-name "<span class="quote">Output FreeMind file: </span>" nil nil nil default-mm-file)))
     (list org-file mm-file)))
  (when (freemind-check-overwrite mm-file (called-interactively-p))
    (let ((org-buffer (if org-file (find-file-noselect org-file) (current-buffer)))
          (mm-buffer (find-file-noselect mm-file)))
      (freemind-write-mm-buffer org-buffer mm-buffer nil)
      (with-current-buffer mm-buffer
        (basic-save-buffer)
        (when (called-interactively-p)
          (switch-to-buffer-other-window mm-buffer)
          (freemind-show buffer-file-name))))))

(defun freemind-from-org-sparse-tree (org-buffer mm-file)
  "<span class="quote">Convert visible part of buffer ORG-BUFFER to FreeMind file MM-FILE.</span>"
  (interactive
   (let* ((org-file buffer-file-name)
          (default-mm-file (concat
                            (if org-file
                                (file-name-nondirectory org-file)
                              "<span class="quote">nofile</span>")
                            "<span class="quote">-sparse.mm</span>"))
          (mm-file (read-file-name "<span class="quote">Output FreeMind file: </span>" nil nil nil default-mm-file)))
     (list (current-buffer) mm-file)))
  (when (freemind-check-overwrite mm-file (called-interactively-p))
    (let (org-buffer
          (mm-buffer (find-file-noselect mm-file)))
      (save-window-excursion
        (org-export-visible ?\  nil)
        (setq org-buffer (current-buffer)))
      (freemind-write-mm-buffer org-buffer mm-buffer nil)
      (with-current-buffer mm-buffer
        (basic-save-buffer)
        (when (called-interactively-p)
          (switch-to-buffer-other-window mm-buffer)
          (freemind-show buffer-file-name))))))


<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;; FreeMind =&gt; Org</span>

<span class="linecomment">;; (sort '(b a c) 'freemind-lt-symbols)</span>
(defun freemind-lt-symbols (sym-a sym-b)
  (string&lt; (symbol-name sym-a) (symbol-name sym-b)))
<span class="linecomment">;; (sort '((b . 1) (a . 2) (c . 3)) 'freemind-lt-xml-attrs)</span>
(defun freemind-lt-xml-attrs (attr-a attr-b)
  (string&lt; (symbol-name (car attr-a)) (symbol-name (car attr-b))))

<span class="linecomment">;; xml-parse-region gives things like</span>
<span class="linecomment">;; ((p nil "\n"</span>
<span class="linecomment">;;     (a</span>
<span class="linecomment">;;      ((href . "link"))</span>
<span class="linecomment">;;      "text")</span>
<span class="linecomment">;;     "\n"</span>
<span class="linecomment">;;     (b nil "hej")</span>
<span class="linecomment">;;     "\n"))</span>

<span class="linecomment">;; '(a . nil)</span>

<span class="linecomment">;; (freemind-symbols= 'a (car '(A B)))</span>
(defsubst freemind-symbols= (sym-a sym-b)
  (or (eq sym-a sym-b)
      (string= (downcase (symbol-name sym-a))
               (downcase (symbol-name sym-b)))))

(defun freemind-get-children (parent path)
  "<span class="quote">Find children node to PARENT from PATH.
PATH should be a list of steps, where each step has the form

  '(NODE-NAME (ATTR-NAME . ATTR-VALUE))
</span>"
  <span class="linecomment">;; Fix-me: maybe implement op? step: Name, number, attr, attr op val</span>
  <span class="linecomment">;; Fix-me: case insensitive version for children?</span>
  (let* ((children (if (not (listp (car parent)))
                       (cddr parent)
                     (let (cs)
                       (dolist (p parent)
                         (dolist (c (cddr p))
                           (add-to-list 'cs c)))
                       cs)
                     ))
         (step (car path))
         (step-node (if (listp step) (car step) step))
         (step-attr-list (when (listp step) (sort (cdr step) 'freemind-lt-xml-attrs)))
         (path-tail (cdr path))
         path-children)
    (dolist (child children)
      <span class="linecomment">;; skip xml.el formatting nodes</span>
      (unless (stringp child)
        <span class="linecomment">;; compare node name</span>
        (when (if (not step-node)
                  t <span class="linecomment">;; any node name</span>
                (freemind-symbols= step-node (car child)))
          (if (not step-attr-list)
              <span class="linecomment">;;(throw 'path-child child) ;; no attr to care about</span>
              (add-to-list 'path-children child)
            (let* ((child-attr-list (cadr child))
                   (step-attr-copy (copy-sequence step-attr-list)))
              (dolist (child-attr child-attr-list)
                                   <span class="linecomment">;; Compare attr names:</span>
                (when (freemind-symbols= (caar step-attr-copy) (car child-attr))
                  <span class="linecomment">;; Compare values:</span>
                  (let ((step-val (cdar step-attr-copy))
                        (child-val (cdr child-attr)))
                    (when (if (not step-val)
                              t <span class="linecomment">;; any value</span>
                            (string= step-val child-val))
                      (setq step-attr-copy (cdr step-attr-copy))))))
              <span class="linecomment">;; Did we find all?</span>
              (unless step-attr-copy
                <span class="linecomment">;;(throw 'path-child child)</span>
                (add-to-list 'path-children child)
                ))))))
    (if path-tail
        (freemind-get-children path-children path-tail)
      path-children)))

(defun freemind-get-richcontent-node (node)
  (let ((rc-nodes
         (freemind-get-children node '((richcontent (type . "<span class="quote">NODE</span>")) html body))))
    (when (&gt; (length rc-nodes) 1)
      (lwarn t :warning "<span class="quote">Unexpected structure: several &lt;richcontent type=\"NODE\" ...&gt;</span>"))
    (car rc-nodes)))

(defun freemind-get-richcontent-note (node)
  (let ((rc-notes
         (freemind-get-children node '((richcontent (type . "<span class="quote">NOTE</span>")) html body))))
    (when (&gt; (length rc-notes) 1)
      (lwarn t :warning "<span class="quote">Unexpected structure: several &lt;richcontent type=\"NOTE\" ...&gt;</span>"))
    (car rc-notes)))

(defun freemind-test-get-tree-text ()
  (let ((node '(p nil "<span class="quote">\n</span>"
                 (a
                  ((href . "<span class="quote">link</span>"))
                  "<span class="quote">text</span>")
                 "<span class="quote">\n</span>"
                 (b nil "<span class="quote">hej</span>")
                 "<span class="quote">\n</span>")))
    (freemind-get-tree-text node)))
<span class="linecomment">;; (freemind-test-get-tree-text)</span>

(defun freemind-get-tree-text (node)
  (when node
    (let ((ntxt "<span class="quote"></span>")
          (link nil)
          (lf-after nil))
      (dolist (n node)
        (case n
          <span class="linecomment">;;(a (setq is-link t) )</span>
          ((h1 h2 h3 h4 h5 h6 p)
           <span class="linecomment">;;(setq ntxt (concat "\n" ntxt))</span>
           (setq lf-after 2)
           )
          (br
           (setq lf-after 1)
           )
          (t
           (cond
            ((stringp n)
             (when (string= n "<span class="quote">\n</span>") (setq n "<span class="quote"></span>"))
             (if link
                 (setq ntxt (concat ntxt
                                    "<span class="quote">[[</span>" link "<span class="quote">][</span>" n "<span class="quote">]]</span>"))
               (setq ntxt (concat ntxt n))))
            ((and n (listp n))
             (if (symbolp (car n))
                 (setq ntxt (concat ntxt (freemind-get-tree-text n)))
               <span class="linecomment">;; This should be the attributes:</span>
               (dolist (att-val n)
                 (let ((att (car att-val))
                       (val (cdr att-val)))
                   (when (eq att 'href)
                     (setq link val)))))
             )))))
      (if lf-after
          (setq ntxt (concat ntxt (make-string lf-after ?\n)))
        (setq ntxt (concat ntxt "<span class="quote"> </span>")))
      <span class="linecomment">;;(setq ntxt (concat ntxt (format "{%s}" n)))</span>
      ntxt)))

(defun freemind-get-richcontent-node-text (node)
  "<span class="quote">Get the node text as from the richcontent node.</span>"
  (save-match-data
    (let* ((rc (freemind-get-richcontent-node node))
           (txt (freemind-get-tree-text rc)))
      <span class="linecomment">;;(when txt (setq txt (replace-regexp-in-string (rx (1+ whitespace)) " " txt)))</span>
      txt
      )))

(defun freemind-get-richcontent-note-text (node)
  "<span class="quote">Get the node text as from the richcontent node.</span>"
  (save-match-data
    (let* ((rc (freemind-get-richcontent-note node))
           (txt (when rc (freemind-get-tree-text rc))))
      <span class="linecomment">;;(when txt (setq txt (replace-regexp-in-string (rx (1+ whitespace)) " " txt)))</span>
      txt
      )))

(defun freemind-get-icon-names (node)
  (let* ((icon-nodes (freemind-get-children node '((icon ))))
         names)
    (dolist (icn icon-nodes)
      (setq names (cons (cdr (assq 'builtin (cadr icn))) names)))
    <span class="linecomment">;; (icon (builtin . "full-1"))</span>
    names))

(defun freemind-node-to-org (node level skip-levels)
  (let ((qname (car node))
        (attributes (cadr node))
        text
        (note (freemind-get-richcontent-note-text node))
        (mark "<span class="quote">-- This is more about </span>")
        (icons (freemind-get-icon-names node))
        (children (cddr node)))
    (when (&lt; 0 (- level skip-levels))
      (dolist (attrib attributes)
        (case (car attrib)
          ('TEXT (setq text (cdr attrib)))
          ('text (setq text (cdr attrib)))))
      (unless text
        <span class="linecomment">;; There should be a richcontent node holding the text:</span>
        (setq text (freemind-get-richcontent-node-text node)))
      (when icons
        (when (member "<span class="quote">full-1</span>" icons) (setq text (concat "<span class="quote">[#A] </span>" text)))
        (when (member "<span class="quote">full-2</span>" icons) (setq text (concat "<span class="quote">[#B] </span>" text)))
        (when (member "<span class="quote">full-3</span>" icons) (setq text (concat "<span class="quote">[#C] </span>" text)))
        (when (member "<span class="quote">full-4</span>" icons) (setq text (concat "<span class="quote">[#D] </span>" text)))
        (when (member "<span class="quote">full-5</span>" icons) (setq text (concat "<span class="quote">[#E] </span>" text)))
        (when (member "<span class="quote">full-6</span>" icons) (setq text (concat "<span class="quote">[#F] </span>" text)))
        (when (member "<span class="quote">full-7</span>" icons) (setq text (concat "<span class="quote">[#G] </span>" text)))
        (when (member "<span class="quote">button_cancel</span>" icons) (setq text (concat "<span class="quote">TODO </span>" text)))
        )
      (if (and note
               (string= mark (substring note 0 (length mark))))
          (progn
            (setq text (replace-regexp-in-string "<span class="quote">\n $</span>" "<span class="quote"></span>" text))
            (insert text))
        (case qname
          ('node
           (insert (make-string (- level skip-levels) ?*) "<span class="quote"> </span>" text "<span class="quote">\n</span>")
           ))))
    (dolist (child children)
      (unless (stringp child)
        (freemind-node-to-org child (1+ level) skip-levels)))))

<span class="linecomment">;; Fix-me: put back special things, like drawers that are stored in</span>
<span class="linecomment">;; the notes. Should maybe all notes contents be put in drawers?</span>
(defun freemind-to-org-mode (mm-file org-file)
  "<span class="quote">Convert FreeMind file MM-FILE to `org-mode' file ORG-FILE.</span>"
  (interactive
   (save-match-data
     (let* ((mm-file (buffer-file-name))
            (default-org-file (concat (file-name-nondirectory mm-file) "<span class="quote">.org</span>"))
            (org-file (read-file-name "<span class="quote">Output org-mode file: </span>" nil nil nil default-org-file)))
       (list mm-file org-file))))
  (when (freemind-check-overwrite org-file (called-interactively-p))
    (let ((mm-buffer (find-file-noselect mm-file))
          (org-buffer (find-file-noselect org-file)))
      (with-current-buffer mm-buffer
        (let* ((xml-list (xml-parse-file mm-file))
               (top-node (cadr (cddar xml-list)))
               (note (freemind-get-richcontent-note-text top-node))
               (skip-levels
                (if (string-match (rx bol "<span class="quote">--org-mode: WHOLE FILE</span>" eol) note)
                    1
                  0)))
          (with-current-buffer org-buffer
            (erase-buffer)
            (freemind-node-to-org top-node 1 skip-levels))
          (org-set-tags t t) <span class="linecomment">;; Align all tags</span>
          (switch-to-buffer-other-window org-buffer)
          )))))

(provide 'freemind)
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;; freemind.el ends here</span></span></pre></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span><span class="translation bar"><br />  <a class="translation new" rel="nofollow" href="http://www.emacswiki.org/emacs?action=translate;id=freemind.el;missing=de_es_fr_it_ja_ko_pt_ru_se_zh">Add Translation</a></span><span class="edit bar"><br /> <a class="edit" accesskey="e" title="Click to edit this page" rel="nofollow" href="http://www.emacswiki.org/emacs?action=edit;id=freemind.el">Edit this page</a> <a class="history" rel="nofollow" href="http://www.emacswiki.org/emacs?action=history;id=freemind.el">View other revisions</a> <a class="admin" rel="nofollow" href="http://www.emacswiki.org/emacs?action=admin;id=freemind.el">Administration</a></span><span class="time"><br /> Last edited 2008-08-27 17:44 UTC by <a class="author" title="from bi01p1.co.us.ibm.com" href="http://www.emacswiki.org/emacs/Sacha_Chua">Sacha Chua</a> <a class="diff" rel="nofollow" href="http://www.emacswiki.org/emacs?action=browse;diff=2;id=freemind.el">(diff)</a></span><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div>
</body>
</html>
