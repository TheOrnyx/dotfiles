;;;; volume.asd

(asdf:defsystem #:volume
  :description "Add volume info to the modeline"
  :author "Zaki Si-Lounis, github.com/TheOrnyx"
  :license  "GPLv3"
  :version "1.0.0"
  :serial t
  :depends-on (#:stumpwm)
  :components ((:file "package")
               (:file "volume")))
