;; -*- lexical-binding: t; -*-
;;; efb.el --- An Electronic Flight Bag major mode
;; Copyright (C) 2025 Brian Tomlinson

;; Author: Brian Tomlinson <darthlukan at gmail dot com>
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))
;; Keywords: efb, flight-bag, flight-planner, aviation
;; URL: https://github.com/darthlukan/efb-mode

;;; Commentary:
;; This package provides a major mode to assist pilots in planning
;; VFR flights. To activate it, just type M-x efb-mode RET.

;;;###autoload
(defun efb-load ()
  "Switch to *efb* buffer and start VFR flight planning."
  (interactive)
  (switch-to-buffer "*efb*")
  (efb-mode))

(define-derived-mode efb-mode text-mode "efb"
  "Major mode implementing a basic Electronic Flight Bag."
  (setq-local efb-departure-icao "KHMT"
              efb-arrival-icao "KSEZ")

  (insert efb-departure-icao ?\n efb-arrival-icao ?\n)
  (buffer-string))

(provide 'efb)
;;; efb.el ends here
