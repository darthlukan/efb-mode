;;; efb.el --- An Electronic Flight Bag major mode in Emacs
;; Copyright (C) 2025 Brian Tomlinson

;; Author: Brian Tomlinson <briantomlinson at duck dot com>
;; Version: 0.0.1
;; Package-Requires: ((nil "ver"))
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

(define-derived-mode efb-mode
  custom-mode "efb"
  "Major mode implementing a basic Electronic Flight Bag."
  (setq-local efb-departure-icao nil)
  (setq-local efb-arrival-icao nil))

(provide 'efb-mode)
;;; efb.el ends here
