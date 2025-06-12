;; Collaboration Platform Contract
;; Facilitates demand planning collaboration between planners

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_PROJECT_NOT_FOUND (err u301))
(define-constant ERR_NOT_PARTICIPANT (err u302))
(define-constant ERR_INVALID_STATUS (err u303))

;; Data structures
(define-map collaboration-projects
  { project-id: uint }
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    creator: principal,
    status: (string-ascii 20),
    created-at: uint,
    deadline: uint,
    participant-count: uint
  }
)

(define-map project-participants
  { project-id: uint, participant: principal }
  {
    planner-id: uint,
    role: (string-ascii 20),
    joined-at: uint,
    contribution-score: uint
  }
)

(define-map project-updates
  { update-id: uint }
  {
    project-id: uint,
    author: principal,
    content: (string-ascii 300),
    update-type: (string-ascii 20),
    created-at: uint
  }
)

(define-data-var next-project-id uint u1)
(define-data-var next-update-id uint u1)

;; Create a new collaboration project
(define-public (create-project
  (name (string-ascii 50))
  (description (string-ascii 200))
  (deadline uint))
  (let ((project-id (var-get next-project-id)))
    (map-set collaboration-projects
      { project-id: project-id }
      {
        name: name,
        description: description,
        creator: tx-sender,
        status: "active",
        created-at: block-height,
        deadline: deadline,
        participant-count: u1
      }
    )

    ;; Add creator as participant
    (map-set project-participants
      { project-id: project-id, participant: tx-sender }
      {
        planner-id: u0,
        role: "lead",
        joined-at: block-height,
        contribution-score: u0
      }
    )

    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

;; Join a collaboration project
(define-public (join-project (project-id uint) (planner-id uint) (role (string-ascii 20)))
  (begin
    (asserts! (is-some (map-get? collaboration-projects { project-id: project-id })) ERR_PROJECT_NOT_FOUND)
    (asserts! (is-none (map-get? project-participants { project-id: project-id, participant: tx-sender })) ERR_NOT_PARTICIPANT)

    (map-set project-participants
      { project-id: project-id, participant: tx-sender }
      {
        planner-id: planner-id,
        role: role,
        joined-at: block-height,
        contribution-score: u0
      }
    )

    ;; Update participant count
    (match (map-get? collaboration-projects { project-id: project-id })
      project-data
      (map-set collaboration-projects
        { project-id: project-id }
        (merge project-data { participant-count: (+ (get participant-count project-data) u1) })
      )
      false
    )

    (ok true)
  )
)

;; Add project update
(define-public (add-project-update
  (project-id uint)
  (content (string-ascii 300))
  (update-type (string-ascii 20)))
  (let ((update-id (var-get next-update-id)))
    (asserts! (is-some (map-get? collaboration-projects { project-id: project-id })) ERR_PROJECT_NOT_FOUND)
    (asserts! (is-some (map-get? project-participants { project-id: project-id, participant: tx-sender })) ERR_NOT_PARTICIPANT)

    (map-set project-updates
      { update-id: update-id }
      {
        project-id: project-id,
        author: tx-sender,
        content: content,
        update-type: update-type,
        created-at: block-height
      }
    )

    (var-set next-update-id (+ update-id u1))
    (ok update-id)
  )
)

;; Get project details
(define-read-only (get-project (project-id uint))
  (map-get? collaboration-projects { project-id: project-id })
)

;; Get participant info
(define-read-only (get-participant (project-id uint) (participant principal))
  (map-get? project-participants { project-id: project-id, participant: participant })
)

;; Get project update
(define-read-only (get-project-update (update-id uint))
  (map-get? project-updates { update-id: update-id })
)
