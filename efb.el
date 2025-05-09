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

;;; Code:
(require 'widget)

(eval-when-compile
  (require 'wid-edit))

;;;###autoload
(defun efb-load ()
  "Switch to *efb* buffer and start VFR flight planning."
  (interactive)
  (switch-to-buffer "*efb*")
  (kill-all-local-variables)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (widget-insert "EFB Mode: Plan your VFR Flight.\n\n")
  (efb-mode))

(defun efb-action (depart-widget arrival-widget)
  "Display the value of DEPART-WIDGET and ARRIVAL-WIDGET."
  (progn
    (message "Departing: %s" (widget-value depart-widget))
    (message "Arriving: %s" (widget-value arrival-widget))))

(define-derived-mode efb-mode text-mode "efb"
  "Major mode implementing a basic Electronic Flight Bag."
  (setq-local efb-default-departure-icao "KHMT"
              efb-default-arrival-icao "KSEZ")

  (setq-local efb-departure-widget (widget-create 'string
                                                  :size 12
                                                  :value efb-default-departure-icao
                                                  :format "Departure ICAO: %v"
                                                  :help-echo "Origin Airport"))
  (widget-insert "\n\n")
  (setq-local efb-arrival-widget (widget-create 'string
                                                :size 12
                                                :value efb-default-arrival-icao
                                                :format "Arrival ICAO: %v"
                                                :help-echo "Destination Airport"))
  (widget-insert "\n\n\n\n")
  (setq-local efb-submit-button (widget-create 'push-button
                                               :action (lambda (&rest ignore)
                                                         (efb-action efb-departure-widget efb-arrival-widget))
                                               "Submit"))
  (use-local-map widget-keymap)
  (widget-setup))

(provide 'efb)
;;; efb.el ends here
