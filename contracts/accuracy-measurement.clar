;; Accuracy Measurement Contract
;; Measures and tracks forecasting accuracy

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_MEASUREMENT_NOT_FOUND (err u401))
(define-constant ERR_INVALID_ACCURACY (err u402))

;; Data structures
(define-map accuracy-measurements
  { measurement-id: uint }
  {
    planner-id: uint,
    algorithm-id: uint,
    forecast-result-id: uint,
    actual-demand: uint,
    predicted-demand: uint,
    accuracy-percentage: uint,
    measurement-date: uint,
    measurement-period: (string-ascii 20)
  }
)

(define-map planner-accuracy-stats
  { planner-id: uint }
  {
    total-measurements: uint,
    average-accuracy: uint,
    best-accuracy: uint,
    worst-accuracy: uint,
    last-updated: uint
  }
)

(define-map algorithm-accuracy-stats
  { algorithm-id: uint }
  {
    total-measurements: uint,
    average-accuracy: uint,
    best-accuracy: uint,
    worst-accuracy: uint,
    last-updated: uint
  }
)

(define-data-var next-measurement-id uint u1)

;; Record accuracy measurement
(define-public (record-accuracy-measurement
  (planner-id uint)
  (algorithm-id uint)
  (forecast-result-id uint)
  (actual-demand uint)
  (predicted-demand uint)
  (measurement-period (string-ascii 20)))
  (let
    (
      (measurement-id (var-get next-measurement-id))
      (accuracy-percentage (calculate-accuracy-percentage actual-demand predicted-demand))
    )
    (asserts! (> actual-demand u0) ERR_INVALID_ACCURACY)
    (asserts! (> predicted-demand u0) ERR_INVALID_ACCURACY)

    ;; Store measurement
    (map-set accuracy-measurements
      { measurement-id: measurement-id }
      {
        planner-id: planner-id,
        algorithm-id: algorithm-id,
        forecast-result-id: forecast-result-id,
        actual-demand: actual-demand,
        predicted-demand: predicted-demand,
        accuracy-percentage: accuracy-percentage,
        measurement-date: block-height,
        measurement-period: measurement-period
      }
    )

    ;; Update planner stats
    (update-planner-accuracy-stats planner-id accuracy-percentage)

    ;; Update algorithm stats
    (update-algorithm-accuracy-stats algorithm-id accuracy-percentage)

    (var-set next-measurement-id (+ measurement-id u1))
    (ok measurement-id)
  )
)

;; Calculate accuracy percentage
(define-private (calculate-accuracy-percentage (actual uint) (predicted uint))
  (let
    (
      (difference (if (>= actual predicted) (- actual predicted) (- predicted actual)))
      (accuracy-decimal (if (> actual u0) (/ (* (- actual difference) u100) actual) u0))
    )
    (if (<= accuracy-decimal u100) accuracy-decimal u0)
  )
)

;; Update planner accuracy statistics
(define-private (update-planner-accuracy-stats (planner-id uint) (new-accuracy uint))
  (match (map-get? planner-accuracy-stats { planner-id: planner-id })
    existing-stats
    (let
      (
        (total-measurements (+ (get total-measurements existing-stats) u1))
        (current-total (* (get average-accuracy existing-stats) (get total-measurements existing-stats)))
        (new-average (/ (+ current-total new-accuracy) total-measurements))
        (new-best (if (> new-accuracy (get best-accuracy existing-stats)) new-accuracy (get best-accuracy existing-stats)))
        (new-worst (if (< new-accuracy (get worst-accuracy existing-stats)) new-accuracy (get worst-accuracy existing-stats)))
      )
      (map-set planner-accuracy-stats
        { planner-id: planner-id }
        {
          total-measurements: total-measurements,
          average-accuracy: new-average,
          best-accuracy: new-best,
          worst-accuracy: new-worst,
          last-updated: block-height
        }
      )
    )
    ;; First measurement for this planner
    (map-set planner-accuracy-stats
      { planner-id: planner-id }
      {
        total-measurements: u1,
        average-accuracy: new-accuracy,
        best-accuracy: new-accuracy,
        worst-accuracy: new-accuracy,
        last-updated: block-height
      }
    )
  )
)

;; Update algorithm accuracy statistics
(define-private (update-algorithm-accuracy-stats (algorithm-id uint) (new-accuracy uint))
  (match (map-get? algorithm-accuracy-stats { algorithm-id: algorithm-id })
    existing-stats
    (let
      (
        (total-measurements (+ (get total-measurements existing-stats) u1))
        (current-total (* (get average-accuracy existing-stats) (get total-measurements existing-stats)))
        (new-average (/ (+ current-total new-accuracy) total-measurements))
        (new-best (if (> new-accuracy (get best-accuracy existing-stats)) new-accuracy (get best-accuracy existing-stats)))
        (new-worst (if (< new-accuracy (get worst-accuracy existing-stats)) new-accuracy (get worst-accuracy existing-stats)))
      )
      (map-set algorithm-accuracy-stats
        { algorithm-id: algorithm-id }
        {
          total-measurements: total-measurements,
          average-accuracy: new-average,
          best-accuracy: new-best,
          worst-accuracy: new-worst,
          last-updated: block-height
        }
      )
    )
    ;; First measurement for this algorithm
    (map-set algorithm-accuracy-stats
      { algorithm-id: algorithm-id }
      {
        total-measurements: u1,
        average-accuracy: new-accuracy,
        best-accuracy: new-accuracy,
        worst-accuracy: new-accuracy,
        last-updated: block-height
      }
    )
  )
)

;; Get accuracy measurement
(define-read-only (get-accuracy-measurement (measurement-id uint))
  (map-get? accuracy-measurements { measurement-id: measurement-id })
)

;; Get planner accuracy stats
(define-read-only (get-planner-accuracy-stats (planner-id uint))
  (map-get? planner-accuracy-stats { planner-id: planner-id })
)

;; Get algorithm accuracy stats
(define-read-only (get-algorithm-accuracy-stats (algorithm-id uint))
  (map-get? algorithm-accuracy-stats { algorithm-id: algorithm-id })
)
