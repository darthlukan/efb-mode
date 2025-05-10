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
(require 'request)

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

(defvar-local efb-weather-base-url "https://aviationweather.gov/api/data/")
(defvar-local efb-weather-type-metar "metar")
(defvar-local efb-weather-icao-key "ids")

(defun efb-get-metar (icao)
  "Retrieve and return the METAR string for ICAO."
  (request
    (format "%s/%s?%s=%s" efb-weather-base-url efb-weather-type-metar efb-weather-icao-key icao)
    :type "GET"
    :parser 'buffer-string
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (progn
                  (message "Got: %s" data)
                  data)))
    :error (cl-function
            (lambda (&rest args &key error-thrown &allow-other-keys)
              (progn
                (message "Error: %s" error-thrown)
                error-thrown)))))

(defun efb-get-taf (icao)
  "Retrieve and return the TAF string for ICAO."
  icao)

(defun efb-get-notams (icao)
  "Retrieve and return the NOTAMS for ICAO."
  icao)

(defun efb-get-tfrs (icao)
  "Retrieve and return the TFRS for ICAO."
  icao)

(defun efb-action (depart-widget arrival-widget)
  "Display the value of DEPART-WIDGET and ARRIVAL-WIDGET."
  (setq-local dep-icao (widget-value depart-widget))
  (setq-local arr-icao (widget-value arrival-widget))
  (setq-local dep-metar (efb-get-metar dep-icao))
  (setq-local arr-metar (efb-get-metar arr-icao))
  (progn
    (message "Departing: %s, Arriving: %s" dep-icao arr-icao)
    (message "Dep METAR: %s" dep-metar)
    (message "Arr METAR: %s" arr-metar)))

(define-derived-mode efb-mode text-mode "efb"
  "Major mode implementing a basic Electronic Flight Bag."
  (setq-local efb-default-departure-icao "KRIV"
              efb-default-arrival-icao "KSEZ")

  (setq-local efb-departure-widget (widget-create 'string
                                                  :size 12
                                                  :value efb-default-departure-icao
                                                  :format "Departure ICAO: %v"
                                                  :help-echo "Origin Airport"))
  (widget-insert "\s\s")
  (setq-local efb-arrival-widget (widget-create 'string
                                                :size 12
                                                :value efb-default-arrival-icao
                                                :format "Arrival ICAO: %v"
                                                :help-echo "Destination Airport"))
  (widget-insert "\n\n")
  (setq-local efb-submit-button (widget-create 'push-button
                                               :action (lambda (&rest _)
                                                         (efb-action efb-departure-widget efb-arrival-widget))
                                               "Submit"))
  (use-local-map widget-keymap)
  (widget-setup))

(provide 'efb)
;;; efb.el ends here
